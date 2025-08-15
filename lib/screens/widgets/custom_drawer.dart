import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/providers/auth/authenticated_app_providers.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/about/about_zed_page.dart';
import 'package:zed_nano/screens/approvals/approvals_main_page.dart';
import 'package:zed_nano/screens/business/get_started_page.dart';
import 'package:zed_nano/screens/customers/customers_list_page.dart';
import 'package:zed_nano/screens/invoices/invoices_list_main_page.dart';
import 'package:zed_nano/screens/main/pages/common/report_page.dart';
import 'package:zed_nano/screens/orders/orders_list_main_page.dart';
import 'package:zed_nano/screens/payments/list_payments_page.dart';
import 'package:zed_nano/screens/profile/profile_page.dart';
import 'package:zed_nano/screens/reports/all_transactions/all_t_ranasctions_page.dart';
import 'package:zed_nano/screens/stock/view_stock/view_stock_page.dart';
import 'package:zed_nano/screens/users/users_main_list.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';

class CustomDrawer extends StatefulWidget {

  const CustomDrawer({super.key, this.onClose});
  final Function()? onClose;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // Track expanded sections
  final Map<String, bool> _isExpanded = {
    'Businesses': false,
    'Inventory': false,
    'Stock Management': false,
    'Sales': false,
  };

  @override
  Widget build(BuildContext context) {
    final authProvider = getAuthProvider(context);
    final user = authProvider.userDetails;
    final userName = user?.name ?? 'User';
    final phoneNumber = user?.phoneNumber ?? '';

    return Container(
      width: context.width() /** 0.7*/, // 85% of screen width
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header with Menu text and close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Menu',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: darkGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.08,
                      ),),
                  IconButton(
                    icon: SvgPicture.asset(closeIcon, width: 20, height: 20),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),

            // User profile section
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  // Profile image
                  commonCachedNetworkImage(
                    defaultAvatarIcon,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    radius: 16,
                  ),
                  16.width,
                  // User info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userName,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xff000000),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                            ),),
                        Text(phoneNumber,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.12,
                            ),),
                      ],
                    ),
                  ),
                  // View Profile button
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: lightGreyColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('View Profile',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: emailBlue,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),),
                  ).onTap(() => const ProfilePage().launch(context)),
                ],
              ),
            ),

            // Progressive menu based on workflow state
            Expanded(
              child: Consumer<WorkflowViewModel>(
                builder: (context, viewModel, child) {
                  // If showBusinessSetup is true, show create business option
                  if (viewModel.showBusinessSetup) {
                    return ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildMenuItem(
                          title: 'Home',
                          iconPath: homeIcon,
                          onTap: () => widget.onClose,
                        ),
                        _buildMenuItem(
                          title: 'Create Business',
                          iconPath: createBusinessIcon,
                          onTap: () => const GetStartedPage().launch(context),
                        ),
                        _buildMenuItem(
                          title: 'About Us',
                          iconPath: aboutUsIcon,
                          onTap: () => const AboutZedPage().launch(context),
                        ),
                      ],
                    );
                  }

                  // Progressive menu based on workflow state
                  final workflowState = viewModel.workflowState?.toLowerCase();
                  final userRole = authProvider.businessDetails?.group?.toLowerCase();
                  final menuItems = <Widget>[];

                  // Role-based menu restrictions
                  final isCashierOrSupervisor = userRole == 'cashier' || userRole == 'supervisor';
                  final isMerchantOrOwner = userRole == 'merchant' || userRole == 'owner';

                  // For Cashier and Supervisor - limited menu
                  if (isCashierOrSupervisor) {
                    menuItems.add(
                      _buildExpandableMenuItem(
                        title: 'Sales',
                        iconPath: salesSideMenuIcon,
                        children: [
                          _buildSubMenuItem(
                            title: 'Invoices',
                            onTap: () => InvoicesListMainPage().launch(context),
                          ),
                          _buildSubMenuItem(
                            title: 'Orders',
                            onTap: () => OrdersListMainPage().launch(context),
                          ),
                        ],
                      ),
                    );

                  }
                  // For Merchant and Owner - full menu based on workflow state
                  else if (isMerchantOrOwner) {
                    // Show Businesses section for basic and billing states
                    if (workflowState == 'basic' || workflowState == 'billing') {
                      menuItems.add(
                        _buildExpandableMenuItem(
                          title: 'Businesses',
                          iconPath: businessesIcon,
                          children: [
                            _buildSubMenuItem(
                              title: 'My Businesses',
                              onTap: () => _navigateTo(context,
                                  AppRoutes.getBusinessProfileScreenRoute(),),
                            ),
                          ],
                        ),
                      );
                    }

                    // Show Inventory section for category and product states
                    if (workflowState == 'category' || workflowState == 'product') {
                      menuItems.addAll([
                        _buildExpandableMenuItem(
                          title: 'Businesses',
                          iconPath: businessesIcon,
                          children: [
                            _buildSubMenuItem(
                              title: 'My Businesses',
                              onTap: () => _navigateTo(context,
                                  AppRoutes.getBusinessProfileScreenRoute(),),
                            ),
                          ],
                        ),
                        _buildExpandableMenuItem(
                          title: 'Inventory',
                          iconPath: inventoryIcon,
                          children: [
                            _buildSubMenuItem(
                              title: 'Categories',
                              onTap: () => _navigateTo(
                                  context, AppRoutes.getListCategoriesRoute(),),
                            ),
                            _buildSubMenuItem(
                              title: 'Products and Services',
                              onTap: () => _navigateTo(context,
                                  AppRoutes.getListProductsAndServicesRoute(),),
                            ),
                          ],
                        ),
                      ]);
                    }

                    // Show complete menu for COMPLETE state
                    if (workflowState == 'complete') {
                      menuItems.addAll([
                        _buildExpandableMenuItem(
                          title: 'Businesses',
                          iconPath: businessesIcon,
                          children: [
                            _buildSubMenuItem(
                              title: 'My Businesses',
                              onTap: () => _navigateTo(context,
                                  AppRoutes.getBusinessProfileScreenRoute(),),
                            ),
                          ],
                        ),
                        _buildExpandableMenuItem(
                          title: 'Inventory',
                          iconPath: inventoryIcon,
                          children: [
                            _buildSubMenuItem(
                              title: 'Categories',
                              onTap: () => _navigateTo(
                                  context, AppRoutes.getListCategoriesRoute(),),
                            ),
                            _buildSubMenuItem(
                              title: 'Products and Services',
                              onTap: () => _navigateTo(context,
                                  AppRoutes.getListProductsAndServicesRoute(),),
                            ),
                          ],
                        ),
                        _buildExpandableMenuItem(
                          title: 'Stock Management',
                          iconPath: stockManagementIcon,
                          children: [
                            _buildSubMenuItem(
                                title: 'View Stock',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ViewStockPage(),),
                                  );
                                },),
                            _buildSubMenuItem(
                              title: 'Add Stock',
                              onTap: () {
                                Navigator.pushNamed(
                                    context,
                                    AppRoutes
                                        .getAddStockBatchTabsPageScreenRoute(),);
                              },
                            ),
                            _buildSubMenuItem(
                              title: 'Stock Take',
                              onTap: () {
                                Navigator.pushNamed(
                                    context,
                                    AppRoutes
                                        .getAddStockTakeBatchTabsPageScreenRoute(),);
                              },
                            ),
                          ],
                        ),
                        _buildExpandableMenuItem(
                          title: 'Sales',
                          iconPath: salesSideMenuIcon,
                          children: [
                            _buildSubMenuItem(
                              title: 'Customers',
                              onTap: () =>
                                  const CustomersListPage().launch(context),
                            ),
                            _buildSubMenuItem(
                              title: 'Invoices',
                              onTap: () =>
                                  InvoicesListMainPage().launch(context),
                            ),
                            _buildSubMenuItem(
                              title: 'Orders',
                              onTap: () => OrdersListMainPage().launch(context),
                            ),
                            _buildSubMenuItem(
                              title: 'Receipts',
                              onTap: () => const AllTRanasctionsPage().launch(context),
                            ),
                          ],
                        ),
                        _buildMenuItem(
                          title: 'Payment',
                          iconPath: paymentSetupIcon,
                          onTap: () => const AddPaymentMethodScreen(isWorkFlow: false)
                              .launch(context),
                        ),
                        _buildMenuItem(
                          title: 'Users',
                          iconPath: usersIcon,
                          onTap: () => const UsersMainList().launch(context),
                        ),
                        _buildMenuItem(
                          title: 'Approvals',
                          iconPath: approvalsIcon,
                          onTap: () => ApprovalsMainPage().launch(context),
                        ),
                        _buildMenuItem(
                          title: 'Reports',
                          iconPath: reportsSideMenuIcon,
                          onTap: () => ReportPage(isShowAppBar: true,).launch(context),
                        ),
                      ]);
                    }

                    menuItems.addAll([
                      _buildMenuItem(
                        title: 'About Us',
                        iconPath: aboutUsIcon,
                        onTap: () => const AboutZedPage().launch(context),
                      ),
                    ]);
                  }

                  return ListView(
                    padding: EdgeInsets.zero,
                    children: menuItems,
                  );
                },
              ),
            ),

            ListTile(
              leading: SvgPicture.asset(logoutIcon, color: Colors.red),
              title: const Text('Logout',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: accentRed,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),),
              onTap: () {
                Provider.of<AuthenticatedAppProviders>(context, listen: false)
                    .logout(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.getSplashPageRoute(),
                  (route) => false,
                );
              },
            ),
            16.height, // Bottom padding
          ],
        ),
      ),
    );
  }

  // Helper method to build an expandable menu item
  Widget _buildExpandableMenuItem({
    required String title,
    required String iconPath,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        ListTile(
          leading: SvgPicture.asset(iconPath, color: Colors.black54),
          title: Text(title,
              style: const TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontStyle: FontStyle.normal,
                  fontSize: 12,),
              textAlign: TextAlign.left,),
          trailing: Icon(
            _isExpanded[title] == true
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: Colors.black54,
          ),
          onTap: () {
            setState(() {
              _isExpanded[title] = !(_isExpanded[title] ?? false);
            });
          },
        ),
        if (_isExpanded[title] == true) Column(children: children),
      ],
    );
  }

  // Helper method to build a sub-menu item
  Widget _buildSubMenuItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: const BoxDecoration(
        color: lightGreyColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 72, right: 16),
        title: Text(title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xff000000),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              letterSpacing: 0.12,
            ),),
        onTap: () {
          Navigator.pop(context); // Close drawer
          onTap();
        },
      ),
    );
  }

  // Helper method to build a regular menu item
  Widget _buildMenuItem({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: SvgPicture.asset(iconPath, color: Colors.black54),
      title: Text(title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xff000000),
            fontSize: 12,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.12,
          ),),
      onTap: () {
        Navigator.pop(context); // Close drawer
        onTap();
      },
    );
  }

  // Helper method for navigation
  void _navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }
}
