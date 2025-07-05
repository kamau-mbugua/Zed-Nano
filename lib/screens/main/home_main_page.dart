import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/screens/main/pages/admin/admin_dashboard_page.dart';
import 'package:zed_nano/screens/main/pages/common/p_o_s_pages.dart';
import 'package:zed_nano/screens/main/welcome_setup_screen.dart';
import 'package:zed_nano/screens/reports/reports_list_page.dart';
import 'package:zed_nano/screens/widgets/nav_bar_item.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({super.key});

  @override
  _HomeMainPageState createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Run API calls after first frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkflowViewModel>(context, listen: false)
      .skipSetup(context);
    });
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> _buildScreens() {
    return [
      const AdminDashboardPage(),
      const POSPages(),
      const ReportsListPage(),
    ];
  }

  Widget _buildBottomNavigationBar() {
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

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 4,
      backgroundColor: colorBackground,
      selectedItemColor: const Color(0xFF1F2024),
      unselectedItemColor: const Color(0xFF71727A),
      currentIndex: selectedIndex,
      selectedFontSize: 12,
      unselectedFontSize: 13,
      onTap: onItemTapped,
      items: adminNavItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkflowViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.showBusinessSetup) {
          return const WelcomeSetupScreen();
        }

        return Scaffold(
          backgroundColor: getScaffoldColor(),
          body: IndexedStack(
            index: selectedIndex,
            children: _buildScreens(),
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
        );
      },
    );
  }
}
