import 'package:google_fonts/google_fonts.dart';

const double AppContainerRadius = 32;
const double AppCommonRadius = 12;
const appName = 'ZED Nano';

const RFWidgetHeight = 300;
const bottomNavigationIconSize = 16.0;


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
