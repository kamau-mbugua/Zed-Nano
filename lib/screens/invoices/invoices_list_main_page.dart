import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/screens/invoices/tabs/invoices_list_cancelled_page.dart';
import 'package:zed_nano/screens/invoices/tabs/invoices_list_paid_page.dart';
import 'package:zed_nano/screens/invoices/tabs/invoices_list_partial_page.dart';
import 'package:zed_nano/screens/invoices/tabs/invoices_list_unpaid_page.dart';
import 'package:zed_nano/screens/orders/tabs/orders_list_cancelled_page.dart';
import 'package:zed_nano/screens/orders/tabs/orders_list_paid_page.dart';
import 'package:zed_nano/screens/orders/tabs/orders_list_partial_page.dart';
import 'package:zed_nano/screens/orders/tabs/orders_list_unpaid_page.dart';
import 'package:zed_nano/screens/sell/sell_stepper_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_tab_switcher.dart';
import 'package:zed_nano/utils/Colors.dart';

class InvoicesListMainPage extends StatefulWidget {
  const InvoicesListMainPage({Key? key}) : super(key: key);

  @override
  _InvoicesListMainPageState createState() => _InvoicesListMainPageState();
}

class _InvoicesListMainPageState extends State<InvoicesListMainPage> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(
          title: 'Invoices'
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
                ? const InvoicesListUnpaidPage()
                : selectedTab == 1
                ? const InvoicesListPartialPage()
                : selectedTab == 2
                ? const InvoicesListPaidPage()
                : const InvoicesListCancelledPage(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // AddUserPage().launch(context);
          SellStepperPage(stepType: SellStepType.Invoice,).launch(context);

        },
        backgroundColor: const Color(0xFF032541),
        icon: const Icon(Icons.add, size: 20, color: Colors.white),
        label: const Text(
          'Create',
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
