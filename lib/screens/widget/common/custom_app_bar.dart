import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';

/// A reusable app bar with menu and user icons that matches the
/// design used across dashboard-style screens.
class CustomDashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomDashboardAppBar({
    super.key,
    this.title = 'Business Dashboard',
    this.onMenuTap,
    this.onProfileTap,
  });

  final String title;
  final VoidCallback? onMenuTap;
  final VoidCallback? onProfileTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: colorBackground,
      leading: IconButton(
        onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
        icon: SvgPicture.asset(
          menuIcon,
          width: 25,
          height: 25,
          colorFilter: const ColorFilter.mode(darkGreyColor, BlendMode.srcIn),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: darkGreyColor,
        ),
      ),
      actions: [
        IconButton(
          onPressed: onProfileTap,
          icon: SvgPicture.asset(
            userIcon,
            width: 30,
            height: 30,
          ),
        ),
      ],
    );
  }
}
