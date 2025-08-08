import 'package:flutter/material.dart';
import 'package:zed_nano/repositories/SplashRepo.dart';



class SplashProvider extends ChangeNotifier {
  SplashProvider({required this.splashRepo});
  final SplashRepo? splashRepo;


  Future<bool> initSharedData() {
    return splashRepo!.initSharedData();
  }
  Future<bool> removeSharedData() {
    return splashRepo!.removeSharedData();
  }

  bool getOnBoardingSkip() {
    return splashRepo!.getOnBoardingSkip();
  }
}
