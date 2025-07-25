import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/screens/customers/add_customer/add_customers.dart';
import 'package:zed_nano/screens/customers/tabs/approved_customers_list_page.dart';
import 'package:zed_nano/screens/customers/tabs/pending_customers_list_page.dart';
import 'package:zed_nano/screens/customers/tabs/suspended_customers_list_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_tab_switcher.dart';
import 'package:zed_nano/utils/Colors.dart';

class CustomersListPage extends StatefulWidget {
  const CustomersListPage({Key? key}) : super(key: key);

  @override
  _CustomersListPageState createState() => _CustomersListPageState();
}

class _CustomersListPageState extends State<CustomersListPage> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(
        title: 'Customers'
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          // Tabs
          CustomTabSwitcher(
            tabs: const ['Active', 'Pending', 'Suspended'],
            selectedIndex: selectedTab,
            onTabSelected: (index) => setState(() => selectedTab = index),
            selectedTabColors: const [
              successTextColor,      // Approved tab color
              primaryOrangeTextColor,     // Pending tab color
              colorBackground,        // Rejected tab color
            ],
            selectedTextColors: const [
              Colors.white,      // Approved text color
              Colors.white,      // Pending text color
              textPrimary,      // Rejected text color
            ],
            selectedBorderColors: const [
              successTextColor,      // Approved border color
              primaryOrangeTextColor,     // Pending border color
              colorBackground,        // Rejected border color
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: selectedTab == 0
                ? const ApprovedCustomersListPage()
                : selectedTab == 1
                ? const PendingCustomersListPage()
                : const SuspendedCustomersListPage(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          AddCustomers().launch(context);
        },
        backgroundColor: const Color(0xFF032541),
        icon: const Icon(Icons.add, size: 20, color: Colors.white),
        label: const Text(
          'Add',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
