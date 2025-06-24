import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/routes/routes_helper.dart';
import 'package:zed_nano/screens/widgets/drawer_widget.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: colorBackground,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: SvgPicture.asset(
              menuIcon,
              width: 32,
              height: 32,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          );
        }),
        title: Text(
          'Business Dashboard',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.pushNamed(context, AppRoutes.getNotificationsPageRoute());
            },
            icon: SvgPicture.asset(
              userIcon,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }
}
