import 'package:flutter/material.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';

/// A reusable dialog component with customizable title, subtitle, and action buttons.
///
/// Example usage:
/// ```dart
/// showCustomDialog(
///   context: context,
///   title: 'Cancel Subscription',
///   subtitle: 'Are you sure you want to cancel your current subscription?',
///   negativeButtonText: 'No, Keep it',
///   positiveButtonText: 'Yes, Cancel',
///   onNegativePressed: () => Navigator.of(context).pop(),
///   onPositivePressed: () {
///     // Handle cancellation logic
///     Navigator.of(context).pop(true);
///   },
/// );
/// ```
Future<T?> showCustomDialog<T>({
  required BuildContext context,
  required String title,
  required String subtitle,
  String? negativeButtonText,
  String? positiveButtonText,
  VoidCallback? onNegativePressed,
  VoidCallback? onPositivePressed,
  bool barrierDismissible = true,
  Color? titleColor,
  Color? subtitleColor,
  Color? positiveButtonColor,
  Color? negativeButtonColor,
  Widget? icon,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) => CustomDialog(
      title: title,
      subtitle: subtitle,
      negativeButtonText: negativeButtonText,
      positiveButtonText: positiveButtonText,
      onNegativePressed: onNegativePressed,
      onPositivePressed: onPositivePressed,
      titleColor: titleColor,
      subtitleColor: subtitleColor,
      positiveButtonColor: positiveButtonColor,
      negativeButtonColor: negativeButtonColor,
      icon: icon,
    ),
  );
}

class CustomDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? negativeButtonText;
  final String? positiveButtonText;
  final VoidCallback? onNegativePressed;
  final VoidCallback? onPositivePressed;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? positiveButtonColor;
  final Color? negativeButtonColor;
  final Widget? icon;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.subtitle,
    this.negativeButtonText,
    this.positiveButtonText,
    this.onNegativePressed,
    this.onPositivePressed,
    this.titleColor,
    this.subtitleColor,
    this.positiveButtonColor,
    this.negativeButtonColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0,
      backgroundColor: colorBackground,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24), // Increased padding to match Zeplin (16px outer + 8px inner)
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center, // Center content
        children: [
          // Optional Icon
          if (icon != null) ...[
            icon!,
            const SizedBox(height: 16),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: darkGreyColor,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontSize: 16.0
            )
          ),

          const SizedBox(height: 16), // Match the spacing in Zeplin
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add horizontal padding for text
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              )
            ),
          ),
          const SizedBox(height: 32), // Match the spacing to buttons in Zeplin
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Negative Button (if provided)
              if (negativeButtonText != null)
                Expanded(
                  child: outlineButton(
                    text: negativeButtonText ?? 'Cancel',
                    onTap: onNegativePressed ?? () => Navigator.of(context).pop(),
                    context: context
                  ),
                ),

              // Spacing between buttons
              if (negativeButtonText != null && positiveButtonText != null)
                const SizedBox(width: 16), // Increased to match Zeplin

              // Positive Button (if provided)
              if (positiveButtonText != null)
                Expanded(
                  child: appButton(
                    text: positiveButtonText ?? 'Confirm',
                    onTap: onPositivePressed ?? () => Navigator.of(context).pop(true),
                    context: context
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
