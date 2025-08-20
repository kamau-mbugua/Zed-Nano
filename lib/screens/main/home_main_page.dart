import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/invoices/invoices_list_main_page.dart';
import 'package:zed_nano/screens/main/pages/admin/admin_dashboard_page.dart';
import 'package:zed_nano/screens/main/pages/common/p_o_s_pages.dart';
import 'package:zed_nano/screens/main/welcome_setup_screen.dart';
import 'package:zed_nano/screens/orders/orders_list_main_page.dart';
import 'package:zed_nano/screens/profile/profile_page.dart';
import 'package:zed_nano/screens/sell/sell_stepper_page.dart';
import 'package:zed_nano/screens/widget/common/custom_app_bar.dart';
import 'package:zed_nano/screens/widgets/custom_drawer.dart';
import 'package:zed_nano/screens/widgets/nav_bar_item.dart';
import 'package:zed_nano/services/business_setup_extensions.dart';
import 'package:zed_nano/services/app_update_extensions.dart';
import 'package:zed_nano/screens/test/update_test_page.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/viewmodels/CustomerInvoicingViewModel.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({super.key});

  @override
  _HomeMainPageState createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  int selectedIndex = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize app update checking after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAppUpdates();
    });
  }

  /// Initialize app update checking
  void _initializeAppUpdates() {
    // Check for app updates using the extension method
    context.checkForAppUpdates();
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
    try {
      // Add any refresh logic here in the future
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate a network call
    } catch (e) {
      // Handle any errors
    }
  }

  List<Widget> _buildScreens() {
    final authProvider = getAuthProvider(context);
    final userRole = authProvider.businessDetails?.group?.toLowerCase();

    // For Cashier and Supervisor, only show Orders screen
    if (userRole == 'cashier' || userRole == 'supervisor') {
      return [
        _buildScrollableScreen(OrdersListMainPage(showAppBar: false)),
      ];
    }

    // For Merchant and Owner, show all screens
    return [
      _buildScrollableScreen(const AdminDashboardPage()),
      _buildScrollableScreen(const POSPagesScreen()),
      _buildScrollableScreen(OrdersListMainPage(showAppBar: false)),
      _buildScrollableScreen(InvoicesListMainPage(isHideAppBar: true)),
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
    final authProvider = getAuthProvider(context);
    final userRole = authProvider.businessDetails?.group?.toLowerCase();

    // For Cashier and Supervisor, don't show bottom navigation since there's only one screen
    if (userRole == 'cashier' || userRole == 'supervisor') {
      return const SizedBox.shrink(); // Hide bottom navigation completely
    }

    // For Merchant and Owner, show all tabs
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
        label: 'Invoices',
        iconPath: invoiceIcon,
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
          'HomeMainPage - WorkflowViewModel.showBusinessSetup: ${workflowViewModel.showBusinessSetup}',
        );

        // Show business setup screen if required
        if (workflowViewModel.showBusinessSetup) {
          logger.i('HomeMainPage - Showing WelcomeSetupScreen');
          return const WelcomeSetupScreen();
        }

        var sgowFloatingAction = false;

        if ((selectedIndex == 0 || selectedIndex == 2) &&
            workflowViewModel.workflowState == 'COMPLETE') {
          // setState(() {
            sgowFloatingAction = true;
          // });
        } else if ((context.businessUserRole?.toLowerCase() == 'cashier' ||
                context.businessUserRole?.toLowerCase() == 'supervisor') &&
            workflowViewModel.workflowState == 'COMPLETE') {
          // setState(() {
            sgowFloatingAction = true;
          // });
        } else {
          // setState(() {
            sgowFloatingAction = false;
          // });
        }

        // Show main app interface
        return Scaffold(
          backgroundColor: getScaffoldColor(),
          drawer: CustomDrawer(
            onClose: () => Navigator.pop(context),
          ),
          appBar: CustomDashboardAppBar(
            title: context.businessDisplayName,
            userRole: context.businessUserRole,
            onProfileTap: () => const ProfilePage().launch(context),
            // Temporary test button - remove after testing
            // actions: [
            //   IconButton(
            //     icon: Icon(Icons.bug_report, color: Colors.orange),
            //     onPressed: () => const UpdateTestPage().launch(context),
            //     tooltip: 'Test App Updates',
            //   ),
            // ],
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
          bottomNavigationBar: workflowViewModel.workflowState == 'COMPLETE'
              ? Container(
                  decoration: BoxDecoration(
                    color: colorBackground,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Platform.isAndroid
                      ? SafeArea(
                    child: _buildBottomNavigationBar(),
                  )
                      : _buildBottomNavigationBar(),
                )
              : null,
          floatingActionButton: /*(selectedIndex == 0 || selectedIndex == 2) &&
                  workflowViewModel.workflowState == 'COMPLETE'*/
          sgowFloatingAction
              ? FloatingActionButton.extended(
                  heroTag: 'home_main_fab',
                  onPressed: () async {
                    final customerInvoicingViewModel =
                        Provider.of<CustomerInvoicingViewModel>(context,
                            listen: false,);
                    if (customerInvoicingViewModel.customerData != null) {
                      customerInvoicingViewModel.clearData();
                    }

                    const SellStepperPage().launch(context);
                  },
                  label: const Text('Sell',
                      style: TextStyle( fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600, color: Colors.white,),),
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  backgroundColor: appThemePrimary,
                )
              : selectedIndex == 3
                  ? FloatingActionButton.extended(
                      heroTag: 'invoices_main_fab',
                      onPressed: () async {
                        const SellStepperPage(
                          stepType: SellStepType.Invoice,
                        ).launch(context);
                      },
                      label: const Text('Create',
                          style: TextStyle( fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,),),
                      icon:
                          const Icon(Icons.add, size: 20, color: Colors.white),
                      backgroundColor: appThemePrimary,
                    )
                  : null,
        );
      },
    );
  }
}
