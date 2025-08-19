import 'package:zed_nano/app/app_config.dart';
import 'package:zed_nano/app/app_initializer.dart';

void main() async {
  // Default to development flavor when running from Xcode
  await initializeApp(Flavor.development);
}
