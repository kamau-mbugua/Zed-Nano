import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/utils/Colors.dart';

class FilterRowWidget extends StatelessWidget {
  final String leftButtonText;
  final bool leftButtonIsActive;
  final VoidCallback leftButtonOnTap;
  final String rightButtonText;
  final bool rightButtonIsActive;
  final VoidCallback rightButtonOnTap;
  final IconData? leftButtonIcon;
  final bool showLeftButtonArrow;
  final bool showRightButtonArrow;
  final EdgeInsets? padding;

  const FilterRowWidget({
    Key? key,
    required this.leftButtonText,
    required this.leftButtonIsActive,
    required this.leftButtonOnTap,
    required this.rightButtonText,
    required this.rightButtonIsActive,
    required this.rightButtonOnTap,
    this.leftButtonIcon,
    this.showLeftButtonArrow = true,
    this.showRightButtonArrow = true,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildFilterButton(
            text: leftButtonText,
            isActive: leftButtonIsActive,
            onTap: leftButtonOnTap,
            icon: leftButtonIcon,
            showArrow: showLeftButtonArrow,
          ),
          buildFilterButton(
            text: rightButtonText,
            isActive: rightButtonIsActive,
            onTap: rightButtonOnTap,
            showArrow: showRightButtonArrow,
          ),
        ],
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
      height: 40,
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
            )
        ],
      ),
    ),
  );
}