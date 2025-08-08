import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/utils/Colors.dart';

/// A reusable rectangular social login button with icon and label
class SocialButton extends StatelessWidget {

  const SocialButton({
    required this.icon, required this.label, required this.onTap, required this.backgroundColor, super.key,
  });
  final String icon;
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              height: 18,
              width: 18,
              color: colorWhite,
            ),
            8.width,
            Text(
              label,
              style: boldTextStyle(
                size: 14,
                color: colorWhite,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A reusable circular social media button with icon
class CircularSocialButton extends StatelessWidget {

  const CircularSocialButton({
    required this.icon, required this.onTap, required this.backgroundColor, super.key,
  });
  final String icon;
  final VoidCallback onTap;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SvgPicture.asset(
          icon,
          height: 24,
          width: 24,
          color: colorWhite,
        ),
      ),
    );
  }
}

/// A horizontal row of social login buttons that scrolls if needed
class SocialButtonsRow extends StatelessWidget {

  const SocialButtonsRow({
    required this.buttons, super.key,
  });
  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: buttons.map((button) => 
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: button,
            ),
          ).toList(),
        ),
      ),
    );
  }
}
