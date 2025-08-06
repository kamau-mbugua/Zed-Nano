import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/screens/main/pages/admin/admin_dashboard_page.dart';
import 'package:zed_nano/screens/main/pages/common/p_o_s_pages.dart';
import 'package:zed_nano/screens/main/pages/common/report_page.dart';
import 'package:zed_nano/screens/main/welcome_setup_screen.dart';
import 'package:zed_nano/screens/orders/orders_list_main_page.dart';
import 'package:zed_nano/screens/profile/profile_page.dart';
import 'package:zed_nano/screens/sell/sell_stepper_page.dart';
import 'package:zed_nano/screens/widget/common/custom_app_bar.dart';
import 'package:zed_nano/screens/widgets/custom_drawer.dart';
import 'package:zed_nano/screens/widgets/nav_bar_item.dart';
import 'package:zed_nano/services/business_setup_extensions.dart';
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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();

  

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  /// Handle the refresh action
  Future<void> _handleRefresh() async {
    try {
      // Add any refresh logic here in the future
      await Future.delayed(const Duration(seconds: 1)); // Simulate a network call
    } catch (e) {
      // Handle any errors
    }
  }

  

  List<Widget> _buildScreens() {
    // Wrap each screen in a ScrollView to make RefreshIndicator work
    return [
      _buildScrollableScreen(const AdminDashboardPage()),
      _buildScrollableScreen(const POSPagesScreen()),
      _buildScrollableScreen( OrdersListMainPage(showAppBar: false,)),
      _buildScrollableScreen(ReportPage()),
    ];
  }

  Widget _buildScrollableScreen(Widget screen) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        return false;
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 
                 kBottomNavigationBarHeight - 
                 MediaQuery.of(context).padding.top,
          child: screen,
        ),
      ),
    );
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
        label: 'Order',
        iconPath: customerOrdersIcon,
      ),
      NavBarItem.create(
        label: 'Report',
        iconPath: reportsIcon,
      ),
    ];

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 3,
      backgroundColor: colorBackground,
      selectedItemColor: const Color(0xFF1F2024),
      unselectedItemColor: const Color(0xFF71727A),
      currentIndex: selectedIndex,
      selectedFontSize: 12,
      unselectedFontSize: 13,
      onTap: onItemTapped,
      items: adminNavItems,
      useLegacyColorScheme: false,
      landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkflowViewModel>(
      builder: (context, workflowViewModel, _) {
        // Debug logging
        logger.i(
            'HomeMainPage - WorkflowViewModel.showBusinessSetup: ${workflowViewModel.showBusinessSetup}');

        // Show business setup screen if required
        if (workflowViewModel.showBusinessSetup) {
          logger.i('HomeMainPage - Showing WelcomeSetupScreen');
          return const WelcomeSetupScreen();
        }

        // Show main app interface
        return Scaffold(
          backgroundColor: getScaffoldColor(),
          drawer: CustomDrawer(
            onClose: () => Navigator.pop(context),
          ),
          appBar: CustomDashboardAppBar(
            title: context.businessDisplayName,
            onProfileTap: () =>const ProfilePage().launch(context),
          ),
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _handleRefresh,
            color: const Color(0xffe86339),
            backgroundColor: Colors.white,
            child: IndexedStack(
              index: selectedIndex,
              children: _buildScreens(),
            ),
          ),
          bottomNavigationBar: workflowViewModel.workflowState == 'COMPLETE' ? _buildBottomNavigationBar() : null,
          floatingActionButton: (selectedIndex == 0 || selectedIndex == 2) && workflowViewModel.workflowState == 'COMPLETE'
              ? FloatingActionButton.extended(
                  heroTag: 'home_main_fab',
                  onPressed: () {
                    const SellStepperPage().launch(context);
                  },
                  label: const Text('Sell',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white)),
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  backgroundColor: appThemePrimary,
                )
              : null,
        );
      },
    );
  }
}
