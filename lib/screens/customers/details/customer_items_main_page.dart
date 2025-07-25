import 'package:flutter/material.dart';
import 'package:zed_nano/screens/customers/details/tabs/customer_invoices_page.dart';
import 'package:zed_nano/screens/customers/details/tabs/customer_orders_pages.dart';
import 'package:zed_nano/screens/customers/details/tabs/customer_transactions_page.dart';
import 'package:zed_nano/screens/widget/common/custom_tab_switcher.dart';
import 'package:zed_nano/utils/Colors.dart';

class CustomerItemsMainPage extends StatefulWidget {
  String? customerID;

  CustomerItemsMainPage({Key? key, this.customerID}) : super(key: key);

  @override
  _CustomerItemsMainPageState createState() => _CustomerItemsMainPageState();
}

class _CustomerItemsMainPageState extends State<CustomerItemsMainPage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        // Tabs
        CustomTabSwitcher(
          tabs: const ['Transactions', 'Invoices', 'Orders'],
          selectedIndex: selectedTab,
          onTabSelected: (index) => setState(() => selectedTab = index),
          selectedTabColors: const [
            colorBackground,      // Approved tab color
            colorBackground,     // Pending tab color
            colorBackground,        // Rejected tab color
          ],
          selectedTextColors: const [
            textPrimary,      // Approved text color
            textPrimary,      // Pending text color
            textPrimary,      // Rejected text color
          ],
          selectedBorderColors: const [
            colorBackground,      // Approved border color
            colorBackground,     // Pending border color
            colorBackground,        // Rejected border color
          ],
        ),
        const SizedBox(height: 16),
        // Fixed height container for the tab content
        SizedBox(
          height: 400, // Fixed height to prevent infinite expansion
          child: selectedTab == 0
              ? CustomerTransactionsPage(customerID: widget?.customerID ?? '')
              : selectedTab == 1
              ? CustomerInvoicesPage(customerId: widget?.customerID ?? '')
              : CustomerOrdersPages(customerId: widget?.customerID ?? ''),
        ),
      ],
    );
  }
}
