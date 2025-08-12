import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

const double AppContainerRadius = 32;
const double AppCommonRadius = 12;
const appName = 'ZED Nano';
const googlePlacesKey = 'AIzaSyCSW1KYkDjPvrFnGIbuNEJhjeUdu1IgC9A';

const RFWidgetHeight = 300;
const bottomNavigationIconSize = 16.0;

/// Utility method to get app version
/// Returns the app version from pubspec.yaml
Future<String> getAppVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

/// Utility method to get app version with build number
/// Returns version in format "1.0.0 (1)"
Future<String> getAppVersionWithBuild() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return '${packageInfo.version} (${packageInfo.buildNumber})';
}

/// Utility method to get full package info
/// Returns PackageInfo object for more detailed information
Future<PackageInfo> getPackageInfo() async {
  return await PackageInfo.fromPlatform();
}

class NotificationType {
  static String like = 'like';
  static String request = 'request';
  static String birthday = 'birthday';
  static String newPost = 'newPost';
}

class PostType {
  static String video = 'video';
  // Camera constant removed for Google Play compliance
  static String voice = 'voice';
  static String location = 'location';
  static String text = 'text';
}

String? FontRoboto = GoogleFonts.roboto().fontFamily;
