import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zed_nano/screens/main/pages/admin/admin_dashboard_page.dart';
import 'package:zed_nano/screens/main/pages/common/p_o_s_pages.dart';
import 'package:zed_nano/screens/main/pages/common/report_page.dart';
import 'package:zed_nano/screens/widgets/nav_bar_item.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({Key? key}) : super(key: key);

  @override
  _HomeMainPageState createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> adminNavItems = [
      NavBarItem.create(
        label: 'Home',
        iconPath: homeIcon,
      ),
      NavBarItem.create(
        label: 'Sales',
        iconPath: salesIcon,
      ),
      NavBarItem.create(
        label: 'Report',
        iconPath: reportsIcon,
      ),
    ];

    List<Widget> pages;
    List<BottomNavigationBarItem> navItems;

    pages = [
      const AdminDashboardPage(),
      const POSPages(),
      const ReportPage(),
    ];
    navItems = adminNavItems;


    return Scaffold(
      backgroundColor: getScaffoldColor(),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 4,
        backgroundColor: colorBackground,
        selectedItemColor: const Color(0xFF1F2024),
        unselectedItemColor: const Color(0xFF71727A),
        currentIndex: selectedIndex,
        selectedFontSize: 12,
        unselectedFontSize: 13,
        onTap: onItemTapped,
        items: navItems,
      ),
    );
  }
}
