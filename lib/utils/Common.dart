import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/utils/Constants.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'Colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nb_utils/nb_utils.dart' as nb_utils;

InputDecoration inputDecoration(BuildContext context,
    {String? hint,
    String? label,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    Widget? prefix,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixIcon}) {
  return InputDecoration(
    contentPadding: contentPadding,
    labelText: label,
    hintText: hint,
    hintStyle: hintStyle ?? secondaryTextStyle(),
    labelStyle: labelStyle ?? secondaryTextStyle(),
    prefix: prefix,
    prefixIcon: prefixIcon,
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppBorderColor)),
    focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: appThemePrimary)),
    border: const UnderlineInputBorder(
        borderSide: BorderSide(color: appThemePrimary)),
    focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0)),
    errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0)),
    alignLabelWithHint: true,
  );
}

InputDecoration inputDecorationBorder(BuildContext context,
    {String? hint,
    String? label,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    Widget? prefix,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixIcon}) {
  OutlineInputBorder outlineInputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), // <- nice rounded corners
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  return InputDecoration(
    contentPadding: contentPadding,
    labelText: label,
    hintText: hint,
    hintStyle: hintStyle ?? secondaryTextStyle(),
    labelStyle: labelStyle ?? secondaryTextStyle(),
    prefix: prefix,
    prefixIcon: prefixIcon,
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    enabledBorder: outlineInputBorder(AppBorderColor),
    focusedBorder: outlineInputBorder(appThemePrimary),
    border: outlineInputBorder(appThemePrimary),
    focusedErrorBorder: outlineInputBorder(Colors.red),
    errorBorder: outlineInputBorder(Colors.red),
    alignLabelWithHint: true,
  );
}

Widget robotoText(
    {required String text,
    Color? color,
    FontStyle? fontStyle,
    Function? onTap,
    TextAlign? textAlign}) {
  return Text(
    text,
    style: secondaryTextStyle(
      fontFamily: FontRoboto,
      color: color ?? getBodyColor(),
      fontStyle: fontStyle ?? FontStyle.normal,
    ),
    textAlign: textAlign ?? TextAlign.center,
  ).onTap(onTap,
      splashColor: Colors.transparent, highlightColor: Colors.transparent);
}

Color getBodyColor() {
  // if (appStore.isDarkModeOn)
  //   return SVBodyDark;
  // else
  return BodyWhite;
}

Color getScaffoldColor() {
  // if (appStore.isDarkModeOn)
  //   return appBackgroundColorDark;
  // else
  return AppLayoutBackground;
}

Widget headerContainer({required Widget child, required BuildContext context}) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Container(
        width: context.width(),
        decoration: BoxDecoration(
            color: appThemePrimary,
            borderRadius: radiusOnly(
                topLeft: AppContainerRadius, topRight: AppContainerRadius)),
        padding: const EdgeInsets.all(24),
        child: child,
      ),
      Container(
        height: 20,
        decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: radiusOnly(
                topLeft: AppContainerRadius, topRight: AppContainerRadius)),
      )
    ],
  );
}

Widget appButton(
    {required String text,
    required Function onTap,
    double? width,
    bool isEnable = true,
    Color? buttonColor = appThemePrimary,
    required BuildContext context}) {
  return AppButton(
    shapeBorder: RoundedRectangleBorder(borderRadius: radius(AppCommonRadius)),
    text: text,
    textStyle: boldTextStyle(
        color: Colors.white,
        fontFamily: "Poppins",
        size: 14,
        weight: FontWeight.w500),
    onTap: onTap,
    elevation: 0,
    color: isEnable ? buttonColor : textSecondary,
    width: width ?? context.width() - 32,
    height: 50,
  );
}

Widget appButtonWithIcon({
  required String text,
  required Function onTap,
  String? iconPath, // SVG path
  IconData? icon, // Regular Flutter icon
  double? width,
  bool isEnable = true,
  bool iconOnRight = false, // Position icon on right side
  double iconSize = 16,
  Color? iconColor,
  Color? backgroundColor,
  Color? textColor,
  required BuildContext context,
}) {
  Widget iconWidget = const SizedBox.shrink();

  if (iconPath != null) {
    // SVG icon
    iconWidget = SvgPicture.asset(
      iconPath,
      width: iconSize,
      height: iconSize,
      colorFilter: const ColorFilter.mode(
        Colors.black,
        BlendMode.srcIn,
      ),
    );
  } else if (icon != null) {
    // Regular Flutter icon
    iconWidget = Icon(
      icon,
      size: iconSize,
      color: iconColor ?? Colors.white,
    );
  }

  return Container(
    width: width ?? context.width() - 32,
    height: 50,
    child: ElevatedButton(
      onPressed: isEnable ? () => onTap() : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: inactiveButton,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppCommonRadius),
        ),
      ),
      child: Center(child: iconWidget),
    ),
  );
}

Widget outlineButton(
    {required String text,
    required Function onTap,
    double? width,
    required BuildContext context,
    Color? borderColor,
    Color? textColor}) {
  return AppButton(
    shapeBorder: RoundedRectangleBorder(
      borderRadius: radius(AppCommonRadius),
      side: BorderSide(color: borderColor ?? appThemePrimary, width: 1.5),
    ),
    text: text,
    textStyle: boldTextStyle(
        color: textColor ?? appThemePrimary,
        fontFamily: "Poppins",
        size: 14,
        weight: FontWeight.w500),
    onTap: onTap,
    elevation: 0,
    color: Colors.transparent,
    width: width ?? context.width() - 32,
    height: 50,
  );
}

Future<File> getImageSource() async {
  final picker = ImagePicker();
  final pickedImage = await picker.pickImage(source: ImageSource.camera);
  return File(pickedImage!.path);
}

// void svShowShareBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     enableDrag: true,
//     isDismissible: true,
//     backgroundColor: context.cardColor,
//     shape: RoundedRectangleBorder(borderRadius: radiusOnly(topLeft: 30, topRight: 30)),
//     builder: (context) {
//       return SVSharePostBottomSheetComponent();
//     },
//   );
// }

Widget commonCachedNetworkImage(
  String? url, {
  double? height,
  double? width,
  BoxFit? fit,
  AlignmentGeometry? alignment,
  bool usePlaceholderIfUrlEmpty = true,
  double? radius,
  Color? color,
}) {
  if (url!.validate().isEmpty) {
    return placeHolderWidget(
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return const SizedBox();
        return placeHolderWidget(
            height: height,
            width: width,
            fit: fit,
            alignment: alignment,
            radius: radius);
      },
    );
  } else {
    return Image.asset(url,
            height: height,
            width: width,
            fit: fit,
            color: color,
            alignment: alignment ?? Alignment.center)
        .cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget(
    {double? height,
    double? width,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    double? radius}) {
  return Image.asset('images/app/placeholder.jpg',
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          alignment: alignment ?? Alignment.center)
      .cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

Widget buildEmptyCard(String title, String subtitle) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xfff9f9fc),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Text(title,
            style: const TextStyle(
                color: Color(0xff032541),
                fontWeight: FontWeight.w600,
                fontSize: 12)),
        const SizedBox(height: 6),
        Text(subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xff71727a), fontSize: 12)),
      ],
    ),
  );
}

Widget buildOverviewCard(
  String title,
  String value,
  String userIcon,
  Color iconColor, {
  double? width,
}) {
  return Container(
    width: width ?? 160,
    height: 122,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: iconColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          userIcon,
          width: 30,
          height: 30,
        ),
        const SizedBox(height: 14),
        Text(title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            )),
        Text(value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            )),
      ],
    ),
  );
}

/// Returns a BoxDecoration that matches the styling of StyledTextField
BoxDecoration getStyledDropdownDecoration({bool disabled = false}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(13),
    // Matching StyledTextField border radius
    color: disabled ? Colors.grey.shade100 : Colors.white,
    border: Border.all(
      color: BodyWhite, // Matching StyledTextField border color
      width: 1,
    ),
  );
}

Widget buildSalesSummaryRow({
  required String name,
  required String currency,
  required num amount,
  required String transactionsCount,
  required double percentage,
  required Color backgroundColor,
  Color color = Colors.green,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    )),
                5.height,
                Text("${transactionsCount} Transaction(s)",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,
                    ))
              ],
            ),
            Text("$currency ${amount.formatCurrency()}",
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0.12,
                ))
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(3.0),
          // Half of minHeight (6/2 = 3)
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 10,
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ).paddingSymmetric(vertical: 10),
      ],
    ),
  );
}
