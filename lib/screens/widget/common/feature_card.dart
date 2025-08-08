import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

class FeatureCard extends StatelessWidget {

  const FeatureCard({
    required this.iconColor, required this.assetPath, required this.title, required this.subtitle, super.key,
  });
  final Color iconColor;
  final String assetPath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    // Remove Expanded so the card takes only its intrinsic width when placed
    // inside a horizontal scroll view.
    return SizedBox(
      height: 200,
      width: 160,
      child: Card(
        color: Colors.white,        // <<< background colour
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: iconColor, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              20.height,
              CircleAvatar(
                backgroundColor: iconColor,
                radius: 24,
                child: SvgPicture.asset(
                  assetPath,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff71727a),
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ).paddingSymmetric(horizontal: 10),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff333333),
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
