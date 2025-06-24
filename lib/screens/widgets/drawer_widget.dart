import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: colorWhite,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: appThemePrimary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  userIcon,
                  width: 60,
                  height: 60,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Admin User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'admin@example.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: SvgPicture.asset(
              homeIcon,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(appThemePrimary, BlendMode.srcIn),
            ),
            title: const Text(
              'Dashboard',
              style: TextStyle(
                color: appThemePrimary,
                fontFamily: 'Poppins',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              salesIcon,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(appThemePrimary, BlendMode.srcIn),
            ),
            title: const Text(
              'Sales',
              style: TextStyle(
                color: appThemePrimary,
                fontFamily: 'Poppins',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              reportsIcon,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(appThemePrimary, BlendMode.srcIn),
            ),
            title: const Text(
              'Reports',
              style: TextStyle(
                color: appThemePrimary,
                fontFamily: 'Poppins',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
