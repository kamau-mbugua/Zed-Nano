import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBarItem {
  /// Creates a custom bottom navigation bar item with SVG icons and specified colors
  /// 
  /// [label] is the text shown below the icon
  /// [iconPath] is the path to the SVG asset
  /// [activeIconColor] is the color of the icon when selected (default: #032541)
  /// [activeTextColor] is the color of the text when selected (default: #1f2024)
  /// [inactiveIconColor] is the color of the icon when not selected (default: #d4d6dd)
  /// [inactiveTextColor] is the color of the text when not selected (default: #71727a)
  static BottomNavigationBarItem create({
    required String label,
    required String iconPath,
    Color activeIconColor = const Color(0xFF032541),
    Color activeTextColor = const Color(0xFF1F2024),
    Color inactiveIconColor = const Color(0xFFD4D6DD),
    Color inactiveTextColor = const Color(0xFF71727A),
  }) {
    return BottomNavigationBarItem(
      label: label,
      icon: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(inactiveIconColor, BlendMode.srcIn),
      ),
      activeIcon: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(activeIconColor, BlendMode.srcIn),
      ),
    );
  }
}
