import 'package:flutter/material.dart';
import 'package:zed_nano/screens/orders/tabs/orders_list_cancelled_page.dart';
import 'package:zed_nano/screens/orders/tabs/orders_list_paid_page.dart';
import 'package:zed_nano/screens/orders/tabs/orders_list_partial_page.dart';
import 'package:zed_nano/screens/orders/tabs/orders_list_unpaid_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_tab_switcher.dart';
import 'package:zed_nano/utils/Colors.dart';

class OrdersListMainPage extends StatefulWidget {
  const OrdersListMainPage({Key? key}) : super(key: key);

  @override
  _OrdersListMainPageState createState() => _OrdersListMainPageState();
}

class _OrdersListMainPageState extends State<OrdersListMainPage> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(
          title: 'Orders'
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          // Tabs
          CustomTabSwitcher(
            tabs: const ['Unpaid', 'Partial', 'Paid', 'Cancelled'],
            selectedIndex: selectedTab,
            onTabSelected: (index) => setState(() => selectedTab = index),
            selectedTabColors: const [
              googleRed,      // Unpaid tab color
              primaryOrangeTextColor,     // Partial tab color
              successTextColor,        // Paid tab color
              colorBackground,        // Cancelled tab color
            ],
            selectedTextColors: const [
              Colors.white,      // Unpaid text color
              Colors.white,      // Partial text color
              Colors.white,      // Paid text color
              textPrimary,      // Cancelled text color
            ],
            selectedBorderColors: const [
              googleRed,      // Unpaid border color
              primaryOrangeTextColor,     // Partial border color
              successTextColor,        // Paid border color
              colorBackground,        // Cancelled border color
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: selectedTab == 0
                ? const OrdersListUnpaidPage()
                : selectedTab == 1
                ? const OrdersListPartialPage()
                : selectedTab == 2
                ? const OrdersListPaidPage()
                : const OrdersListCancelledPage(),
          ),
        ],
      ),
    );
  }
}
