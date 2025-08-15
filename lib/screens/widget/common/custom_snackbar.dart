import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart' hide navigatorKey;
import 'package:zed_nano/utils/styles.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void showCustomSnackBar(String? message,
    {bool isError = true, bool isToast = false}) {
  if (Get.context != null) {
    showTopSnackBar(
      Overlay.of(Get.context!),
      isError
          ? MyCustomSnackBar.error(message: message!)
          : MyCustomSnackBar.success(message: message!),
    );
  } else {
    Fluttertoast.showToast(
      msg: message!,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
    );
  }
}

void showCustomToast(String? message,
    {bool isError = true,
    String? actionText,
    VoidCallback? onPressed,
    BuildContext? context,
    VoidCallback? onDismissed}) {
  if (onPressed != null) {
    showTopSnackBar(
        Overlay.of(context!),
        isError
            ? MyCustomSnackBar.error(message: message!)
            : MyCustomSnackBar.success(message: message!),
        onTap: onPressed,
        onDismissed: onDismissed);
  } else {
    Fluttertoast.showToast(
      msg: message!,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
    );
  }
}

Widget showCustomSnackBarWidget(String? message,
    {bool isError = true, bool isToast = false}) {
  final width = MediaQuery.of(Get.context!).size.width;
  return SnackBar(
    content: Text(
      message!,
      style: rubikRegular.copyWith(
        color: Colors.white,
      ),
    ),
    margin: EdgeInsets.zero,
    behavior: SnackBarBehavior.floating,
    backgroundColor: isError ? Colors.red : Colors.green,
  );
}


/// Popup widget that you can use by default to show some information
class MyCustomSnackBar extends StatefulWidget {
  const MyCustomSnackBar.success({
    Key? key,
    required this.message,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.maxLines = 2,
    this.iconRotationAngle = 32,
    this.iconPositionTop = -10,
    this.iconPositionLeft = -8,
    this.backgroundColor = Colors.green,
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaleFactor = 1.0,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  const MyCustomSnackBar.info({
    Key? key,
    required this.message,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.maxLines = 2,
    this.iconRotationAngle = 32,
    this.iconPositionTop = -10,
    this.iconPositionLeft = -8,
    this.backgroundColor = const Color(0xff2196F3),
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaleFactor = 1.0,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  const MyCustomSnackBar.error({
    Key? key,
    required this.message,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.maxLines = 2,
    this.iconRotationAngle = 32,
    this.iconPositionTop = -10,
    this.iconPositionLeft = -8,
    this.backgroundColor = const Color(0xffff5252),
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaleFactor = 1.0,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  final String message;
  final Color backgroundColor;
  final TextStyle textStyle;
  final int maxLines;
  final int iconRotationAngle;
  final List<BoxShadow> boxShadow;
  final BorderRadius borderRadius;
  final double iconPositionTop;
  final double iconPositionLeft;
  final EdgeInsetsGeometry messagePadding;
  final double textScaleFactor;
  final TextAlign textAlign;

  @override
  MyCustomSnackBarState createState() => MyCustomSnackBarState();
}

class MyCustomSnackBarState extends State<MyCustomSnackBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      height: 80,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
        boxShadow: widget.boxShadow,
      ),
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: widget.iconPositionTop,
            left: widget.iconPositionLeft,
            child: SizedBox(
              height: 95,
              child: Transform.rotate(
                angle: widget.iconRotationAngle * pi / 180,
              ),
            ),
          ),
          Padding(
            padding: widget.messagePadding,
            child: Text(
              widget.message,
              style: theme.textTheme.bodyMedium?.merge(widget.textStyle),
              textAlign: widget.textAlign,
              overflow: TextOverflow.ellipsis,
              maxLines: widget.maxLines,
              textScaler: TextScaler.linear(widget.textScaleFactor),
            ),
          ),
        ],
      ),
    );
  }
}

const kDefaultBoxShadow = [
  BoxShadow(
    color: Colors.black26,
    offset: Offset(0, 8),
    spreadRadius: 1,
    blurRadius: 30,
  ),
];

const kDefaultBorderRadius = BorderRadius.all(Radius.circular(12));
