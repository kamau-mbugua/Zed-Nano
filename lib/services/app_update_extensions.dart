import 'package:flutter/material.dart';
import 'app_update_service.dart';

/// Extension methods for easy access to AppUpdateService
extension AppUpdateExtensions on BuildContext {
  /// Check for app updates (respects 24-hour timing)
  Future<void> checkForAppUpdates({bool forceCheck = false}) async {
    await AppUpdateService().checkForUpdate(this, forceCheck: forceCheck);
  }

  /// Force check for app updates (ignoring timing restrictions)
  Future<void> forceAppUpdateCheck() async {
    await AppUpdateService().forceUpdateCheck(this);
  }
}

/// Extension methods for AppUpdateService
extension AppUpdateServiceExtensions on AppUpdateService {
  /// Initialize update checking (call this in app startup)
  Future<void> initializeUpdateChecking(BuildContext context) async {
    // Wait a bit after app startup before checking
    await Future.delayed(const Duration(seconds: 3));
    await checkForUpdate(context);
  }

  /// Check for updates with user-friendly error handling
  Future<void> checkForUpdateSafely(BuildContext context) async {
    try {
      await checkForUpdate(context);
    } catch (e) {
      // Silently handle errors - don't disrupt user experience
      debugPrint('AppUpdate: Silent error during update check: $e');
    }
  }
}
