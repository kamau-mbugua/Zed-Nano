import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUpdateService {
  static final AppUpdateService _instance = AppUpdateService._internal();
  factory AppUpdateService() => _instance;
  AppUpdateService._internal();

  final Logger _logger = Logger();
  static const String _lastUpdateCheckKey = 'last_update_check';
  static const String _updateDismissedVersionKey = 'update_dismissed_version';
  
  // Check for updates every 24 hours
  static const Duration _updateCheckInterval = Duration(hours: 24);

  /// Check if app update is available and handle accordingly
  Future<void> checkForUpdate(BuildContext context, {bool forceCheck = false}) async {
    try {
      // Only check on Android (iOS uses App Store automatic updates)
      if (!Platform.isAndroid) {
        _logger.i('AppUpdate: iOS detected, skipping in-app update check');
        return;
      }

      // Check if we should skip this check based on timing
      if (!forceCheck && !await _shouldCheckForUpdate()) {
        _logger.i('AppUpdate: Skipping update check (too recent)');
        return;
      }

      _logger.i('AppUpdate: Checking for app updates...');

      // Check for available updates
      final AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      
      await _recordUpdateCheck();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        _logger.i('AppUpdate: Update available - Priority: ${updateInfo.immediateUpdateAllowed ? "High" : "Normal"}');
        
        // Check if user previously dismissed this version
        if (await _wasUpdateDismissed(updateInfo.availableVersionCode)) {
          _logger.i('AppUpdate: User previously dismissed this version');
          return;
        }

        await _handleUpdateAvailable(context, updateInfo);
      } else {
        _logger.i('AppUpdate: No updates available');
      }
    } catch (e) {
      _logger.e('AppUpdate: Error checking for updates: $e');
    }
  }

  /// Handle when update is available
  Future<void> _handleUpdateAvailable(BuildContext context, AppUpdateInfo updateInfo) async {
    try {
      // Force immediate update for critical updates
      if (updateInfo.immediateUpdateAllowed && updateInfo.updatePriority >= 4) {
        _logger.w('AppUpdate: Starting immediate update (critical)');
        await _startImmediateUpdate();
        return;
      }

      // Show update dialog for flexible updates
      if (updateInfo.flexibleUpdateAllowed) {
        _logger.i('AppUpdate: Showing flexible update dialog');
        await _showUpdateDialog(context, updateInfo);
      }
    } catch (e) {
      _logger.e('AppUpdate: Error handling available update: $e');
    }
  }

  /// Show update dialog to user
  Future<void> _showUpdateDialog(BuildContext context, AppUpdateInfo updateInfo) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            children: [
              Icon(Icons.system_update, color: Colors.blue, size: 28),
              SizedBox(width: 12),
              Text('App Update Available'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A new version of ${packageInfo.appName} is available with improvements and bug fixes.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Version: ${packageInfo.version}'),
                    Text('Available Version: ${updateInfo.availableVersionCode}'),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Update now to get the latest features and improvements.',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _dismissUpdate(updateInfo.availableVersionCode);
                Navigator.of(context).pop();
              },
              child: Text('Later', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _startFlexibleUpdate(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Update Now'),
            ),
          ],
        );
      },
    );
  }

  /// Start flexible update process
  Future<void> _startFlexibleUpdate(BuildContext context) async {
    try {
      _logger.i('AppUpdate: Starting flexible update...');
      
      // Show progress dialog
      _showUpdateProgressDialog(context);
      
      final AppUpdateResult result = await InAppUpdate.startFlexibleUpdate();
      
      // Close progress dialog
      Navigator.of(context).pop();
      
      if (result == AppUpdateResult.success) {
        _logger.i('AppUpdate: Flexible update downloaded successfully');
        await _showUpdateDownloadedDialog(context);
      } else {
        _logger.w('AppUpdate: Flexible update failed: $result');
        _showUpdateFailedDialog(context);
      }
    } catch (e) {
      _logger.e('AppUpdate: Error during flexible update: $e');
      Navigator.of(context).pop(); // Close progress dialog
      _showUpdateFailedDialog(context);
    }
  }

  /// Start immediate update process
  Future<void> _startImmediateUpdate() async {
    try {
      _logger.i('AppUpdate: Starting immediate update...');
      
      final AppUpdateResult result = await InAppUpdate.performImmediateUpdate();
      
      if (result == AppUpdateResult.success) {
        _logger.i('AppUpdate: Immediate update completed successfully');
      } else {
        _logger.w('AppUpdate: Immediate update failed: $result');
      }
    } catch (e) {
      _logger.e('AppUpdate: Error during immediate update: $e');
    }
  }

  /// Show update progress dialog
  void _showUpdateProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Downloading update...'),
            ],
          ),
        );
      },
    );
  }

  /// Show dialog when flexible update is downloaded
  Future<void> _showUpdateDownloadedDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            children: [
              Icon(Icons.download_done, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text('Update Downloaded'),
            ],
          ),
          content: Text(
            'The update has been downloaded successfully. Restart the app to install the update.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Later'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await InAppUpdate.completeFlexibleUpdate();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Restart Now'),
            ),
          ],
        );
      },
    );
  }

  /// Show update failed dialog
  void _showUpdateFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 28),
              SizedBox(width: 12),
              Text('Update Failed'),
            ],
          ),
          content: Text(
            'Failed to download the update. Please check your internet connection and try again.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Check if we should perform an update check
  Future<bool> _shouldCheckForUpdate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastCheck = prefs.getInt(_lastUpdateCheckKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      
      return (now - lastCheck) >= _updateCheckInterval.inMilliseconds;
    } catch (e) {
      _logger.e('AppUpdate: Error checking update timing: $e');
      return true; // Default to allowing check
    }
  }

  /// Record when we last checked for updates
  Future<void> _recordUpdateCheck() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastUpdateCheckKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      _logger.e('AppUpdate: Error recording update check: $e');
    }
  }

  /// Check if user dismissed this version
  Future<bool> _wasUpdateDismissed(int? versionCode) async {
    if (versionCode == null) return false;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final dismissedVersion = prefs.getInt(_updateDismissedVersionKey) ?? 0;
      return dismissedVersion == versionCode;
    } catch (e) {
      _logger.e('AppUpdate: Error checking dismissed version: $e');
      return false;
    }
  }

  /// Record that user dismissed this version
  Future<void> _dismissUpdate(int? versionCode) async {
    if (versionCode == null) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_updateDismissedVersionKey, versionCode);
      _logger.i('AppUpdate: User dismissed version $versionCode');
    } catch (e) {
      _logger.e('AppUpdate: Error recording dismissed version: $e');
    }
  }

  /// Force check for updates (ignoring timing restrictions)
  Future<void> forceUpdateCheck(BuildContext context) async {
    await checkForUpdate(context, forceCheck: true);
  }

  /// Clear update preferences (for testing)
  Future<void> clearUpdatePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastUpdateCheckKey);
      await prefs.remove(_updateDismissedVersionKey);
      _logger.i('AppUpdate: Cleared update preferences');
    } catch (e) {
      _logger.e('AppUpdate: Error clearing preferences: $e');
    }
  }
}
