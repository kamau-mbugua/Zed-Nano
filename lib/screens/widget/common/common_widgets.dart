import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Constants.dart';
import 'package:zed_nano/utils/Images.dart';

Future<void> launchWhatsApp(String phoneNumber) async {
  var cleanedPhone = phoneNumber.replaceAll(RegExp('[^0-9]'), '');
  if (!cleanedPhone.startsWith('254')) {
    cleanedPhone = '254${cleanedPhone.substring(1)}';
  }

  final whatsappAppUrl = 'whatsapp://send?phone=$cleanedPhone';
  final whatsappWebUrl = 'https://wa.me/$cleanedPhone';

  if (await canLaunchUrl(Uri.parse(whatsappAppUrl))) {
    await launchUrl(Uri.parse(whatsappAppUrl), mode: LaunchMode.externalApplication);
  } else if (await canLaunchUrl(Uri.parse(whatsappWebUrl))) {
    await launchUrl(Uri.parse(whatsappWebUrl), mode: LaunchMode.externalApplication);
  } else {
    showCustomSnackBar('Unable to open WhatsApp');
  }
}



Decoration shadowWidget(BuildContext context) {
  return boxDecorationWithRoundedCorners(
    backgroundColor: context.cardColor,
    boxShadow: [
      BoxShadow(spreadRadius: 0.4, blurRadius: 3, color: gray.withOpacity(0.1), offset: const Offset(1, 6)),
    ],
  );
}


InputDecoration rfInputDecoration({Widget? suffixIcon, String? hintText, Widget? prefixIcon, bool? showPreFixIcon, String? lableText, bool showLableText = false}) {
  return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: gray.withOpacity(0.4)),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      hintText: hintText,
      hintStyle: secondaryTextStyle(),
      labelStyle: secondaryTextStyle(),
      labelText: showLableText.validate() ? lableText! : null,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: appThemePrimary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: gray.withOpacity(0.4)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: redColor.withOpacity(0.4)),
      ),
      filled: true,
      fillColor: white,
      suffix: suffixIcon.validate(),
      prefixIcon: showPreFixIcon.validate() ? prefixIcon.validate() : null,);
}


PreferredSizeWidget commonAppBarWidget(BuildContext context, {String? title,
  double? appBarHeight,
  bool? showLeadingIcon,
  bool? bottomSheet,
  bool? roundCornerShape,
  Color? backgroundColor,
  Color? iconColor,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(appBarHeight ?? 100.0),
    child: AppBar(
      title: Text(title!, style: boldTextStyle(color: whiteColor, size: 20)),
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
      backgroundColor: backgroundColor ?? appThemePrimary,
      centerTitle: true,
      leading: showLeadingIcon.validate()
          ? const SizedBox()
          : IconButton(
        onPressed: () {
          finish(context);
        },
        icon: const Icon(Icons.arrow_back_ios_new, color: whiteColor, size: 18),
        color: iconColor ?? appThemePrimary,
      ),
      elevation: 0,
      shape: roundCornerShape.validate()
          ? const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)))
          : const RoundedRectangleBorder(
        
      ),
    ),
  );
}

Widget rfCommonCachedNetworkImage(
    String? url, {
      double? height,
      double? width,
      BoxFit? fit,
      AlignmentGeometry? alignment,
      bool usePlaceholderIfUrlEmpty = true,
      double? radius,
      Color? color,
      double horizontalMargin = 0,
      double verticalMargin = 0,
    }) {
      if(url.isEmptyOrNull){
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      }else if (url!.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: CachedNetworkImage(
          imageUrl: url,
          height: height,
          width: width,
          fit: fit,
          color: color,
          alignment: alignment as Alignment? ?? Alignment.center,
          errorWidget: (_, s, d) {
            return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
          },
          placeholder: (_, s) {
            if (!usePlaceholderIfUrlEmpty) return const SizedBox();
            return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
          },
        ),
      ),
    );
  }else if (url.endsWith('.svg')) {
    return SvgPicture.asset(
      url,
      width: width,
      height: height,
      color: color,
      fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center,
    ).cornerRadiusWithClipRRect(radius ?? defaultRadius).paddingSymmetric(horizontal: horizontalMargin, vertical: verticalMargin);
  }   else {
    return Image.asset(url, height: height, width: width, fit: fit, color: color, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}




Widget borderWidget({
  int? activeIndex,
  int? index,
  List<String>? steps,
  Function(dynamic index)? onTab,
}) {

  String getIconAsset(int index) {
    if (index < activeIndex!) {
      return 'assets/icons/check_completed.svg'; // green
    } else if (index == activeIndex) {
      return 'assets/icons/check_current.svg'; // navy blue
    } else {
      return 'assets/icons/check_future.svg'; // grey
    }
  }

  Color getTextColor(int index) {
    if (index < activeIndex!) {
      return const Color(0xff1f2024);
    } else if (index == activeIndex) {
      return const Color(0xff1f2024);
    } else {
      return const Color(0xffc5c6cc);
    }
  }

  Color getBorderColor(int index) {
    if (index < activeIndex!) {
      return mintColors;
    } else if (index == activeIndex) {
      return darkBlueColor;
    } else {
      return innactiveBorder;
    }
  }
  Color getBackgroundColor(int index) {
    if (index < activeIndex!) {
      return lightGreenColor;
    } else if (index == activeIndex) {
      return colorWhite;
    } else {
      return whiteColor;
    }
  }

  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: GestureDetector(
      onTap: () {
        onTab!(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 12,),
        decoration: BoxDecoration(
            color: getBackgroundColor(index!),
          border: Border.all(color: getBorderColor(index)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              getIconAsset(index),
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 16),
            Text(
              steps![index],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                color: getTextColor(index),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


Widget arrowListItem({
  int? activeIndex,
  int? index,
  List<String>? steps,
  Function(dynamic index)? onTab,
}) {

  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: GestureDetector(
      onTap: () {
        onTab!(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 12,),
        decoration: BoxDecoration(
            color: whiteColor,
          border: Border.all(color: innactiveBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              steps![index!],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                color: darkGreyColor,
              ),
            ),
            SvgPicture.asset(
              arrowItem,
              width: 20,
              height: 14,
              color: darkGreyColor,
            ),
          ],
        ),
      ),
    ),
  );
}

// Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
//   return Image.asset(imagePlaceholder, height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
// }

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return      SvgPicture.asset(
    imagePlaceholder,
    width: width,
    height: height,
    fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center,
  ).cornerRadiusWithClipRRect(radius ?? defaultRadius);

    // Image.asset(imagePlaceholder, height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

Future<void> commonLaunchUrl(String address, {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    toast('Invalid URL: $address');
  });
}
void launchMail(String? url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl('mailto:${url!}', launchMode: LaunchMode.externalApplication);
  }
}

void launchCall(String? url) {
  if (url.validate().isNotEmpty) {
    if (isIOS) {
      commonLaunchUrl('tel://${url!}', launchMode: LaunchMode.externalApplication);
    } else {
      commonLaunchUrl('tel:${url!}', launchMode: LaunchMode.externalApplication);
    }
  }
}

extension strExt on String {
  Widget iconImage({Color? iconColor, double size = bottomNavigationIconSize}) {
    return Image.asset(
      this,
      width: size,
      height: size,
      color: iconColor ?? gray,
      errorBuilder: (_, __, ___) => placeHolderWidget(width: size, height: size),
    );
  }
}

RichText richText({String? text1, TextStyle? style1, String? text2, TextStyle? style2}) {
  return RichText(
    text: TextSpan(
      text: text1 ?? '',
      style: style1,
      children: [
        TextSpan(text: text2 ?? '', style: style2),
      ],
    ),
  );
}
