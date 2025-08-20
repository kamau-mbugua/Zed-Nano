import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zed_nano/services/app_update_extensions.dart';
import 'package:zed_nano/services/app_update_service.dart';

/// Temporary test page for app update functionality
/// Remove this file after testing is complete
class UpdateTestPage extends StatefulWidget {
  const UpdateTestPage({Key? key}) : super(key: key);

  @override
  State<UpdateTestPage> createState() => _UpdateTestPageState();
}

class _UpdateTestPageState extends State<UpdateTestPage> {
  String _lastTestResult = 'No tests run yet';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Update Testing'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Results:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _lastTestResult,
                      style: TextStyle(
                        color: _lastTestResult.contains('✅') ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Test Buttons
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              ElevatedButton.icon(
                onPressed: _testServiceInitialization,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Test Service Initialization'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: _testForceUpdateCheck,
                icon: const Icon(Icons.system_update),
                label: const Text('Force Update Check'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: _testNormalUpdateCheck,
                icon: const Icon(Icons.update),
                label: const Text('Normal Update Check'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: _clearPreferences,
                icon: const Icon(Icons.clear),
                label: const Text('Clear Preferences'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: _checkPreferences,
                icon: const Icon(Icons.info),
                label: const Text('Check Stored Preferences'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Instructions Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Testing Instructions:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Test Service Initialization - Checks if service works\n'
                      '2. Force Update Check - Ignores timing, checks immediately\n'
                      '3. Normal Update Check - Respects 24-hour timing\n'
                      '4. Clear Preferences - Resets timing and dismissals\n'
                      '5. Check logs in debug console for "AppUpdate:" messages',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testServiceInitialization() async {
    setState(() {
      _isLoading = true;
      _lastTestResult = 'Testing service initialization...';
    });

    try {
      final service = AppUpdateService();
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate test
      
      setState(() {
        _lastTestResult = '✅ Service initialized successfully! Check logs for details.';
      });
      
      print('🧪 UPDATE TEST: Service initialization test completed');
    } catch (e) {
      setState(() {
        _lastTestResult = '❌ Service initialization failed: $e';
      });
      print('🧪 UPDATE TEST ERROR: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testForceUpdateCheck() async {
    setState(() {
      _isLoading = true;
      _lastTestResult = 'Testing force update check...';
    });

    try {
      print('🧪 UPDATE TEST: Starting force update check...');
      await context.forceAppUpdateCheck();
      
      setState(() {
        _lastTestResult = '✅ Force update check completed! Check logs for "AppUpdate:" messages.';
      });
      
      print('🧪 UPDATE TEST: Force update check completed');
    } catch (e) {
      setState(() {
        _lastTestResult = '❌ Force update check failed: $e';
      });
      print('🧪 UPDATE TEST ERROR: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testNormalUpdateCheck() async {
    setState(() {
      _isLoading = true;
      _lastTestResult = 'Testing normal update check...';
    });

    try {
      print('🧪 UPDATE TEST: Starting normal update check...');
      await context.checkForAppUpdates();
      
      setState(() {
        _lastTestResult = '✅ Normal update check completed! May skip if too recent.';
      });
      
      print('🧪 UPDATE TEST: Normal update check completed');
    } catch (e) {
      setState(() {
        _lastTestResult = '❌ Normal update check failed: $e';
      });
      print('🧪 UPDATE TEST ERROR: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _clearPreferences() async {
    setState(() {
      _isLoading = true;
      _lastTestResult = 'Clearing preferences...';
    });

    try {
      await AppUpdateService().clearUpdatePreferences();
      
      setState(() {
        _lastTestResult = '✅ Preferences cleared! Next update check will run immediately.';
      });
      
      print('🧪 UPDATE TEST: Preferences cleared');
    } catch (e) {
      setState(() {
        _lastTestResult = '❌ Failed to clear preferences: $e';
      });
      print('🧪 UPDATE TEST ERROR: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkPreferences() async {
    setState(() {
      _isLoading = true;
      _lastTestResult = 'Checking stored preferences...';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final lastCheck = prefs.getInt('last_update_check');
      final dismissedVersion = prefs.getInt('update_dismissed_version');
      
      final lastCheckTime = lastCheck != null 
          ? DateTime.fromMillisecondsSinceEpoch(lastCheck).toString()
          : 'Never';
      
      setState(() {
        _lastTestResult = '✅ Preferences:\n'
            'Last check: $lastCheckTime\n'
            'Dismissed version: ${dismissedVersion ?? 'None'}';
      });
      
      print('🧪 UPDATE TEST: Last check: $lastCheckTime');
      print('🧪 UPDATE TEST: Dismissed version: $dismissedVersion');
    } catch (e) {
      setState(() {
        _lastTestResult = '❌ Failed to check preferences: $e';
      });
      print('🧪 UPDATE TEST ERROR: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
