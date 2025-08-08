import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';

/// A reusable app bar for authentication screens with consistent styling
class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  
  const AuthAppBar({
    required this.title, super.key,
    this.onBackPressed,
    this.actions,
    this.elevation = 5,
  });
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: boldTextStyle(size: 14)),
      centerTitle: false,
      backgroundColor: colorWhite,
      elevation: elevation,
      titleSpacing: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: getBodyColor()),
      leading:  title.isEmpty ? const SizedBox() : IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: getBodyColor()),
        onPressed: onBackPressed ?? () {
          Navigator.pop(context);
        },
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
