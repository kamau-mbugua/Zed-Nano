import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/utils/Colors.dart';

class FilterRowWidget extends StatelessWidget {

  const FilterRowWidget({
    required this.leftButtonText, required this.leftButtonIsActive, required this.leftButtonOnTap, required this.rightButtonText, required this.rightButtonIsActive, required this.rightButtonOnTap, super.key,
    this.leftButtonIcon,
    this.showLeftButtonArrow = true,
    this.showRightButtonArrow = true,
    this.showLeftButton = true,
    this.showRightButton = true,
    this.padding,
  });
  final String leftButtonText;
  final bool leftButtonIsActive;
  final VoidCallback leftButtonOnTap;
  final String rightButtonText;
  final bool rightButtonIsActive;
  final VoidCallback rightButtonOnTap;
  final IconData? leftButtonIcon;
  final bool showLeftButtonArrow;
  final bool showRightButtonArrow;
  final bool showLeftButton;
  final bool showRightButton;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    // Build list of visible buttons
    final buttons = <Widget>[];
    
    if (showLeftButton) {
      var leftButton = buildFilterButton(
        text: leftButtonText,
        isActive: leftButtonIsActive,
        onTap: leftButtonOnTap,
        icon: leftButtonIcon,
        showArrow: showLeftButtonArrow,
      );
      
      // If only one button is shown, wrap it in Expanded to take full width
      if (!showRightButton) {
        leftButton = Expanded(child: leftButton);
      }
      
      buttons.add(leftButton);
    }
    
    if (showRightButton) {
      var rightButton = buildFilterButton(
        text: rightButtonText,
        isActive: rightButtonIsActive,
        onTap: rightButtonOnTap,
        showArrow: showRightButtonArrow,
      );
      // If only one button is shown, wrap it in Expanded to take full width
      if (!showLeftButton) {
        rightButton = Expanded(child: rightButton);
      }
      
      buttons.add(rightButton);
    }

    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(0, 16, 16, 0),
      child: Row(
        mainAxisAlignment: buttons.length == 1 
            ? MainAxisAlignment.start 
            : MainAxisAlignment.spaceBetween,
        children: buttons,
      ),
    );
  }
}


Widget buildFilterButton({
  required String text,
  required bool isActive,
  required VoidCallback onTap,
  IconData? icon,
  bool showArrow = true,
  bool showTrailingText = false,
  Widget trailingWidget = const SizedBox(),
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? appThemePrimary : innactiveBorder,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: isActive ? appThemePrimary : Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: isActive ? appThemePrimary : Colors.grey.shade800,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
          if (showArrow)
            Row(
              children: [
                if (showTrailingText)trailingWidget,
                16.width,
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: isActive ? appThemePrimary : Colors.grey.shade600,
                ),
              ],
            ),
        ],
      ),
    ),
  );
}