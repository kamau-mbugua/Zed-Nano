/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/customers_created.svg
  SvgGenImage get customersCreated =>
      const SvgGenImage('assets/images/customers_created.svg');

  /// File path: assets/images/email_icon.svg
  SvgGenImage get emailIcon =>
      const SvgGenImage('assets/images/email_icon.svg');

  /// File path: assets/images/facebook_icon.svg
  SvgGenImage get facebookIcon =>
      const SvgGenImage('assets/images/facebook_icon.svg');

  /// File path: assets/images/google_icon.svg
  SvgGenImage get googleIcon =>
      const SvgGenImage('assets/images/google_icon.svg');

  /// File path: assets/images/home_icon.svg
  SvgGenImage get homeIcon => const SvgGenImage('assets/images/home_icon.svg');

  /// File path: assets/images/logo.svg
  SvgGenImage get logo => const SvgGenImage('assets/images/logo.svg');

  /// File path: assets/images/menu_icon.svg
  SvgGenImage get menuIcon => const SvgGenImage('assets/images/menu_icon.svg');

  /// File path: assets/images/onboarding_image.png
  AssetGenImage get onboardingImage =>
      const AssetGenImage('assets/images/onboarding_image.png');

  /// File path: assets/images/pending_payments.svg
  SvgGenImage get pendingPayments =>
      const SvgGenImage('assets/images/pending_payments.svg');

  /// File path: assets/images/phone_icon.svg
  SvgGenImage get phoneIcon =>
      const SvgGenImage('assets/images/phone_icon.svg');

  /// File path: assets/images/products.svg
  SvgGenImage get products => const SvgGenImage('assets/images/products.svg');

  /// File path: assets/images/reports_icon.svg
  SvgGenImage get reportsIcon =>
      const SvgGenImage('assets/images/reports_icon.svg');

  /// File path: assets/images/sales_icon.svg
  SvgGenImage get salesIcon =>
      const SvgGenImage('assets/images/sales_icon.svg');

  /// File path: assets/images/total_sales_icon.svg
  SvgGenImage get totalSalesIcon =>
      const SvgGenImage('assets/images/total_sales_icon.svg');

  /// File path: assets/images/twitter_icon.svg
  SvgGenImage get twitterIcon =>
      const SvgGenImage('assets/images/twitter_icon.svg');

  /// File path: assets/images/user_icon.svg
  SvgGenImage get userIcon => const SvgGenImage('assets/images/user_icon.svg');

  /// List of all assets
  List<dynamic> get values => [
    customersCreated,
    emailIcon,
    facebookIcon,
    googleIcon,
    homeIcon,
    logo,
    menuIcon,
    onboardingImage,
    pendingPayments,
    phoneIcon,
    products,
    reportsIcon,
    salesIcon,
    totalSalesIcon,
    twitterIcon,
    userIcon,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
