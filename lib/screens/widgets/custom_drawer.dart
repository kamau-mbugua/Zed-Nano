import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/providers/auth/authenticated_app_providers.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/stock/view_stock_page.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomDrawer extends StatefulWidget {
  final Function()? onClose;
  
  const CustomDrawer({Key? key, this.onClose}) : super(key: key);

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
    final user = authProvider?.userDetails;
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
                  const Text("Menu",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: darkGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.08,

                      )
                  ),
                  IconButton(
                    icon: SvgPicture.asset(closeIcon, width: 20, height: 20),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),
            
            // User profile section
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  // Profile image
                commonCachedNetworkImage(
                  defaultAvatarIcon,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                usePlaceholderIfUrlEmpty: true,
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


                            )
                        ),
                        Text(phoneNumber,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.12,

                            )
                        ),
                      ],
                    ),
                  ),
                  // View Profile button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                        )
                    ),
                  ),
                ],
              ),
            ),
            
            // const Divider(height: 1),
            
            // Menu items in a scrollable list
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Businesses - expandable
                  _buildExpandableMenuItem(
                    title: 'Businesses',
                    iconPath: businessesIcon,
                    children: [
                      _buildSubMenuItem(
                        title: 'My Businesses',
                        onTap: () => _navigateTo(context, AppRoutes.getBusinessProfileScreenRoute()),
                      ),
                    ],
                  ),
                  
                  // Inventory - expandable
                  _buildExpandableMenuItem(
                    title: 'Inventory',
                    iconPath: inventoryIcon,
                    children: [
                      _buildSubMenuItem(
                        title: 'Categories',
                        onTap: () => _navigateTo(context, AppRoutes.getListCategoriesRoute()),
                      ),
                      _buildSubMenuItem(
                        title: 'Products and Services',
                        onTap: () => _navigateTo(context, AppRoutes.getListProductsAndServicesRoute()),
                      ),

                    ],
                  ),
                  
                  // Stock Management - expandable
                  _buildExpandableMenuItem(
                    title: 'Stock Management',
                    iconPath: stockManagementIcon,
                    children: [
                      _buildSubMenuItem(
                        title: 'View Stock',
                        // onTap: () => /*_navigateTo(context, '/stock-levels')*/ViewStockPage.launch(context)
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ViewStockPage()),
                          );
                        }
                      ),
                      _buildSubMenuItem(
                        title: 'Add Stock',
                        onTap: () => _navigateTo(context, '/stock-adjustments'),
                      ),
                      _buildSubMenuItem(
                        title: 'Stock Take',
                        onTap: () => _navigateTo(context, '/stock-adjustments'),
                      ),
                    ],
                  ),
                  
                  // Sales - expandable
                  _buildExpandableMenuItem(
                    title: 'Sales',
                    iconPath: salesSideMenuIcon,
                    children: [
                      _buildSubMenuItem(
                        title: 'Customers',
                        onTap: () => _navigateTo(context, '/transactions'),
                      ),
                      _buildSubMenuItem(
                        title: 'Invoices',
                        onTap: () => _navigateTo(context, '/pos'),
                      ),
                      _buildSubMenuItem(
                        title: 'Orders',
                        onTap: () => _navigateTo(context, '/pos'),
                      ),
                      _buildSubMenuItem(
                        title: 'Receipts',
                        onTap: () => _navigateTo(context, '/pos'),
                      ),
                      _buildSubMenuItem(
                        title: 'Transactions',
                        onTap: () => _navigateTo(context, '/pos'),
                      ),
                    ],
                  ),
                  
                  // Users
                  _buildMenuItem(
                    title: 'Users',
                    iconPath: usersIcon,
                    onTap: () => _navigateTo(context, '/users'),
                  ),
                  
                  // Approvals
                  _buildMenuItem(
                    title: 'Approvals',
                    iconPath: approvalsIcon,
                    onTap: () => _navigateTo(context, '/approvals'),
                  ),
                  
                  // Reports
                  _buildMenuItem(
                    title: 'Reports',
                    iconPath: reportsSideMenuIcon,
                    onTap: () => _navigateTo(context, '/reports'),
                  ),
                  
                  // Settings
                  _buildMenuItem(
                    title: 'Settings',
                    iconPath: settingsIcon,
                    onTap: () => _navigateTo(context, '/settings'),
                  ),
                ],
              ),
            ),
            
            // const Divider(height: 1),
            
            // Logout button
            ListTile(
              leading: SvgPicture.asset(logoutIcon, color: Colors.red),
              title:const Text("Logout",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: accentRed,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  )
              ),
              onTap: () {
                // Show confirmation dialog
                // showDialog(
                //   context: context,
                //   builder: (context) => AlertDialog(
                //     title: const Text('Logout Confirmation'),
                //     content: const Text('Are you sure you want to logout?'),
                //     actions: [
                //       TextButton(
                //         onPressed: () => Navigator.pop(context),
                //         child: const Text('CANCEL'),
                //       ),
                //       TextButton(
                //         onPressed: () {
                //           Navigator.pop(context); // Close dialog
                          Provider.of<AuthenticatedAppProviders>(context, listen: false).logout(context);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.getSplashPageRoute(),
                            (route) => false,
                          );
                //         },
                //         child: const Text('LOGOUT', style: TextStyle(color: Colors.red)),
                //       ),
                //     ],
                //   ),
                // );
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
          title: Text(
              title,
              style: const TextStyle(
                  color:  const Color(0xff000000),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontStyle:  FontStyle.normal,
                  fontSize: 12.0
              ),
              textAlign: TextAlign.left
          ),
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
        if (_isExpanded[title] == true)
          Column(children: children),
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
            )
        ),
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

          )
      ),
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
