import 'package:permission_handler/permission_handler.dart';

/// A service to handle permission requests in the app
class PermissionService {
  /// Request all necessary permissions for the app to function
  Future<void> requestPermissions() async {
    // List of permissions needed by the app
    final permissions = [
      Permission.camera,
      Permission.storage,
      Permission.notification,
      Permission.manageExternalStorage,
    ];

    // Request each permission
    for (var permission in permissions) {
      final status = await permission.status;
      if (!status.isGranted) {
        await permission.request();
      }
    }
  }

  /// Check if a specific permission is granted
  Future<bool> isPermissionGranted(Permission permission) async {
    return await permission.isGranted;
  }

  /// Open app settings if permissions are permanently denied
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
