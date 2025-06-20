import 'package:flutter/material.dart';
import 'package:zed_nano/app/app_initializer.dart';
import '../../../../utils/styles.dart';
void showCustomSnackBar(String? message, {bool isError = true, bool isToast = false}) {
  final width = MediaQuery.of(Get.context!).size.width;
  ScaffoldMessenger.of(Get.context!)..hideCurrentSnackBar()..showSnackBar(SnackBar(
    content: Text(message!, style: rubikRegular.copyWith(
      color: Colors.white,
    )),
    margin: EdgeInsets.zero,
    behavior: SnackBarBehavior.floating,
    backgroundColor: isError ? Colors.red : Colors.green,
  ));

}

Widget showCustomSnackBarWidget(String? message, {bool isError = true, bool isToast = false}) {
  final width = MediaQuery.of(Get.context!).size.width;
  return SnackBar(
    content: Text(message!, style: rubikRegular.copyWith(
      color: Colors.white,
    )),
    margin: EdgeInsets.zero,
    behavior: SnackBarBehavior.floating,
    backgroundColor: isError ? Colors.red : Colors.green,
  );
}