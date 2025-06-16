import 'package:zed_nano/app/app.dart';
import 'package:zed_nano/app/app_config.dart';
import 'package:zed_nano/bootstrap.dart';

void main() {
  AppConfig.setFlavor(Flavor.staging);
  bootstrap(() => const App());
}
