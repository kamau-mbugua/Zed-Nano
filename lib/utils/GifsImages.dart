import 'package:flutter/material.dart';
import 'Colors.dart';
import 'styles.dart';
import 'dimensions.dart';
import 'package:gif/gif.dart';

const emptyListGif = "assets/gifs/emptylist.gif";
const successGif = "assets/gifs/success.gif";

class GifDisplayWidget extends StatelessWidget {
  final String gifPath;
  final String title;
  final String subtitle;
  final double? gifWidth;
  final double? gifHeight;
  final EdgeInsets? padding;
  final TextAlign? textAlign;

  const GifDisplayWidget({
    Key? key,
    required this.gifPath,
    required this.title,
    required this.subtitle,
    this.gifWidth,
    this.gifHeight,
    this.padding,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // GIF Image
            Image.asset(
              gifPath,
              width: gifWidth ?? 200,
              height: gifHeight ?? 200,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: gifWidth ?? 200,
                  height: gifHeight ?? 200,
                  decoration: BoxDecoration(
                    color: grey100,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: const Icon(
                    Icons.image_not_supported,
                    color: textSecondary,
                    size: 50,
                  ),
                );
              },
            ),
            
            const SizedBox(height: Dimensions.paddingSizeLarge),
            
            // Title
            Text(
              title,
              style: poppinsBold.copyWith(
                fontSize: Dimensions.fontSizeExtraLarge,
                color: textPrimary,
              ),
              textAlign: textAlign ?? TextAlign.center,
            ),
            
            const SizedBox(height: Dimensions.paddingSizeSmall),
            
            // Subtitle
            Text(
              subtitle,
              style: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: textSecondary,
              ),
              textAlign: textAlign ?? TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Alternative compact version for smaller spaces
class CompactGifDisplayWidget extends StatelessWidget {
  final String gifPath;
  final String title;
  final String subtitle;
  final double? gifSize;
  final EdgeInsets? padding;

  const CompactGifDisplayWidget({
    Key? key,
    required this.gifPath,
    required this.title,
    required this.subtitle,
    this.gifSize,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Gif(
              autostart: Autostart.loop,
              placeholder: (context) =>
              const Center(child: CircularProgressIndicator()),
              image: AssetImage(gifPath),
            ),
            
            const SizedBox(height: Dimensions.paddingSizeDefault),
            
            // Title
            Text(
              title,
              style: poppinsSemiBold.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            
            // Subtitle
            Text(
              subtitle,
              style: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}