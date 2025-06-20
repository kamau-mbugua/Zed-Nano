import 'package:zed_nano/app/app_config.dart';
import 'package:zed_nano/app/app_initializer.dart';

void main() async {
  await initializeApp(Flavor.production);
}
