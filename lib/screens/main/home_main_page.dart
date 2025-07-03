import 'package:flutter/material.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/business/subscription/activating_trial_screen.dart';
import 'package:zed_nano/screens/main/pages/admin/admin_dashboard_page.dart';
import 'package:zed_nano/screens/main/pages/common/p_o_s_pages.dart';
import 'package:zed_nano/screens/main/welcome_setup_screen.dart';
import 'package:zed_nano/screens/reports/reports_list_page.dart';
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
  bool _showBusinessSetup = false; // flag to decide which UI to display

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Run API calls after first frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTokenAfterInvite();
    });
  }

  Future<void> getTokenAfterInvite() async {
    final authProvider = getAuthProvider(context);
    if (authProvider.isLoggedIn) {
      final businessProvider = getBusinessProvider(context);
      final requestData = <String, dynamic>{};
      await authProvider.getTokenAfterInvite(requestData: requestData, context: context);

      await businessProvider.getSetupStatus(context: context).then((value) {
        if (value.isSuccess) {
          final response = value.data!;

          setState(() {
            _showBusinessSetup = response.data?.workflowState == null;
          });
        }
      });
    }



  }

  @override
  Widget build(BuildContext context) {
    // If business setup is required show the setup page directly
    if (_showBusinessSetup) {
      return const WelcomeSetupScreen();
    }

    final adminNavItems = <BottomNavigationBarItem>[
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
      const ReportsListPage(),
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
