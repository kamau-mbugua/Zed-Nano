import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/Colors.dart';
import '../../../utils/Constants.dart';
import 'custom_snackbar.dart';

Future<void> launchWhatsApp(String phoneNumber) async {
  String cleanedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
  if (!cleanedPhone.startsWith('254')) {
    cleanedPhone = '254' + cleanedPhone.substring(1);
  }

  final whatsappAppUrl = "whatsapp://send?phone=$cleanedPhone";
  final whatsappWebUrl = "https://wa.me/$cleanedPhone";

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
      BoxShadow(spreadRadius: 0.4, blurRadius: 3, color: gray.withOpacity(0.1), offset: Offset(1, 6)),
    ],
  );
}


InputDecoration rfInputDecoration({Widget? suffixIcon, String? hintText, Widget? prefixIcon, bool? showPreFixIcon, String? lableText, bool showLableText = false}) {
  return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: gray.withOpacity(0.4)),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      hintText: hintText,
      hintStyle: secondaryTextStyle(),
      labelStyle: secondaryTextStyle(),
      labelText: showLableText.validate() ? lableText! : null,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: appThemePrimary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: gray.withOpacity(0.4)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: redColor.withOpacity(0.4)),
      ),
      filled: true,
      fillColor: white,
      suffix: suffixIcon.validate(),
      prefixIcon: showPreFixIcon.validate() ? prefixIcon.validate() : null);
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
      systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
      backgroundColor: backgroundColor ?? appThemePrimary,
      centerTitle: true,
      leading: showLeadingIcon.validate()
          ? SizedBox()
          : IconButton(
        onPressed: () {
          finish(context);
        },
        icon: Icon(Icons.arrow_back_ios_new, color: whiteColor, size: 18),
        color: iconColor ?? appThemePrimary,
      ),
      elevation: 0,
      shape: roundCornerShape.validate()
          ? RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)))
          : RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero),
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
    }) {
      if(url.isEmptyOrNull){
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      }else if (url!.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
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
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
    );
  } else {
    return Image.asset(url, height: height, width: width, fit: fit, color: color, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Image.asset('assets/images/placeholder.jpg', height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

Future<void> commonLaunchUrl(String address, {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    toast('Invalid URL: $address');
  });
}
void launchMail(String? url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl('mailto:' + url!, launchMode: LaunchMode.externalApplication);
  }
}

void launchCall(String? url) {
  if (url.validate().isNotEmpty) {
    if (isIOS)
      commonLaunchUrl('tel://' + url!, launchMode: LaunchMode.externalApplication);
    else
      commonLaunchUrl('tel:' + url!, launchMode: LaunchMode.externalApplication);
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
