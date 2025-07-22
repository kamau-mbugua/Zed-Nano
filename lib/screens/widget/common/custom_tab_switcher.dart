import 'package:flutter/material.dart';

class CustomTabSwitcher extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? selectedTabColor;
  final Color? selectedBorderColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final double? borderRadius;
  final double? tabBorderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;

  const CustomTabSwitcher({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.height = 40,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.backgroundColor = const Color(0xFFF4F4F5),
    this.selectedTabColor = Colors.white,
    this.selectedBorderColor = const Color(0xFFE8E8E8),
    this.selectedTextColor = const Color(0xFF1F2024),
    this.unselectedTextColor = const Color(0xFF71727A),
    this.borderRadius = 12,
    this.tabBorderRadius = 10,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w600,
    this.fontFamily = 'Poppins',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius!),
        ),
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final title = entry.value;
            return _buildTab(title, index);
          }).toList(),
        ),
      ),
    );
  }

  Expanded _buildTab(String title, int index) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? selectedTabColor : Colors.transparent,
            borderRadius: BorderRadius.circular(tabBorderRadius!),
            border: isSelected
                ? Border.all(color: selectedBorderColor!)
                : null,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontFamily: fontFamily,
              color: isSelected ? selectedTextColor : unselectedTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
