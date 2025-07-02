import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
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
void showCustomToast(String? message, {bool isError = true, bool isToast = false}) {
  Fluttertoast.showToast(
    msg: message!,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    backgroundColor: isError ? Colors.red : Colors.green,
    textColor: Colors.white,
  );

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