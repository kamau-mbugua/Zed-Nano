import 'package:permission_handler/permission_handler.dart';

/// Permission service for Google Play compliant permissions
/// Camera permission removed for compliance
class PermissionService {
  Future<void> requestPermissions() async {
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
        // Camera permission removed for Google Play compliance
      }
    });
  }
}