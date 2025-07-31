import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/main/pages/admin/admin_dashboard_page.dart';
import 'package:zed_nano/screens/main/pages/common/p_o_s_pages.dart';
import 'package:zed_nano/screens/main/welcome_setup_screen.dart';
import 'package:zed_nano/screens/orders/orders_list_main_page.dart';
import 'package:zed_nano/screens/reports/reports_list_page.dart';
import 'package:zed_nano/screens/widget/common/custom_app_bar.dart';
import 'package:zed_nano/screens/widgets/custom_drawer.dart';
import 'package:zed_nano/screens/widgets/nav_bar_item.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/viewmodels/RefreshViewModel.dart';
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
  void initState() {
    super.initState();
    // Run API calls after first frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkflowViewModel>(context, listen: false)
      .skipSetup(context);
    });
  }

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
    final refreshViewModel = Provider.of<RefreshViewModel>(context, listen: false);
    final workflowViewModel = Provider.of<WorkflowViewModel>(context, listen: false);
    
    // Start the refresh process
    refreshViewModel.startRefresh();
    
    try {
      // Refresh workflow state
      await workflowViewModel.skipSetup(context);
      // Mark specific pages as refreshed
      refreshViewModel.refreshPage('dashboard');
      refreshViewModel.refreshPage('pos');
      refreshViewModel.refreshPage('reports');
      refreshViewModel.refreshPage('admin_dashboard');  // Make sure this matches


    } catch (e) {
      // Handle any errors
    } finally {
      // Complete the refresh process
      refreshViewModel.completeRefresh();
    }
  }

  /// Trigger refresh programmatically
  void triggerRefresh() {
    _refreshIndicatorKey.currentState?.show();
  }

  List<Widget> _buildScreens() {
    // Wrap each screen in a ScrollView to make RefreshIndicator work
    return [
      _buildScrollableScreen(const AdminDashboardPage()),
      _buildScrollableScreen(const POSPages()),
      _buildScrollableScreen( OrdersListMainPage(showAppBar: false,)),
      _buildScrollableScreen(const ReportsListPage()),
    ];
  }

  Widget _buildScrollableScreen(Widget screen) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        // Prevent nested scroll conflicts
        return false;
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        child: SizedBox(
          // Make sure the content is at least as tall as the viewport
          // to allow pulling even when content is small
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
    return Consumer2<WorkflowViewModel, RefreshViewModel>(
      builder: (context, workflowViewModel, refreshViewModel, _) {
        if (workflowViewModel.showBusinessSetup) {
          return const WelcomeSetupScreen();
        }

        return Scaffold(
          backgroundColor: getScaffoldColor(),
          drawer: CustomDrawer(
            onClose: () => Navigator.pop(context),
          ),
          appBar: CustomDashboardAppBar(title: getBusinessDetails(context)?.businessName ?? '',),
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
          bottomNavigationBar: _buildBottomNavigationBar(),
        );
      },
    );
  }
}
