import 'package:flutter/material.dart';
import 'package:zed_nano/screens/widget/common/base_bottom_sheet.dart';

/// A confirmation bottom sheet that can be used for confirming actions
/// with options to confirm or cancel.
class ConfirmationBottomSheet extends StatelessWidget {

  const ConfirmationBottomSheet({
    required this.title, required this.message, required this.onConfirm, super.key,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.confirmColor = const Color(0xffe86339),
    this.cancelColor = const Color(0xff71727a),
    this.icon,
  });
  /// The title of the confirmation dialog
  final String title;
  
  /// The message to display in the confirmation dialog
  final String message;
  
  /// The text for the confirm button
  final String confirmText;
  
  /// The text for the cancel button
  final String cancelText;
  
  /// The color for the confirm button
  final Color confirmColor;
  
  /// The color for the cancel button
  final Color cancelColor;
  
  /// Callback when confirm button is pressed
  final VoidCallback onConfirm;
  
  /// Optional icon to display above the message
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      title: title,
      initialChildSize: 0.5,
      minChildSize: 0.4,
      bodyContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            const SizedBox(height: 20),
            Center(child: icon),
            const SizedBox(height: 20),
          ],
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              color: Color(0xff1f2024),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: cancelColor,
                    side: BorderSide(color: cancelColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    cancelText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: cancelColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    confirmText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
