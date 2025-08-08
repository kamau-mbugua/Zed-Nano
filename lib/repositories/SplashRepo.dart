import 'package:shared_preferences/shared_preferences.dart';
import 'package:zed_nano/contants/AppConstants.dart';


class SplashRepo {
  SplashRepo({required this.sharedPreferences});
  final SharedPreferences? sharedPreferences;

  Future<bool> initSharedData() {
    if(!sharedPreferences!.containsKey(AppConstants.onBoardingSkip)) {
      return sharedPreferences!.setBool(AppConstants.onBoardingSkip, true);
    }
    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences!.clear();
  }

  bool getOnBoardingSkip() {
    return sharedPreferences!.containsKey(AppConstants.onBoardingSkip);
    // return true;
  }
}
