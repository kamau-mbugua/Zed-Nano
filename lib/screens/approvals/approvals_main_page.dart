import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/screens/approvals/tabs/approved_approvals_page.dart';
import 'package:zed_nano/screens/approvals/tabs/declined_approvals_page.dart';
import 'package:zed_nano/screens/approvals/tabs/pending_approvals_page.dart';
import 'package:zed_nano/screens/orders/tabs/orders_list_cancelled_page.dart';
import 'package:zed_nano/screens/orders/tabs/orders_list_paid_page.dart';
import 'package:zed_nano/screens/orders/tabs/orders_list_partial_page.dart';
import 'package:zed_nano/screens/orders/tabs/orders_list_unpaid_page.dart';
import 'package:zed_nano/screens/sell/sell_stepper_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_tab_switcher.dart';
import 'package:zed_nano/utils/Colors.dart';

class ApprovalsMainPage extends StatefulWidget {
  bool? showAppBar;

  ApprovalsMainPage({Key? key, this.showAppBar = true}) : super(key: key);

  @override
  _ApprovalsMainPageState createState() => _ApprovalsMainPageState();
}

class _ApprovalsMainPageState extends State<ApprovalsMainPage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          widget?.showAppBar == true ? AuthAppBar(title: 'Approvals ') : null,
      body: Column(
        children: [
          SizedBox(height: widget?.showAppBar == true ? 24 : 80),
          // Tabs
          CustomTabSwitcher(
            tabs: const ['Pending', 'Approved', 'Declined'],
            selectedIndex: selectedTab,
            onTabSelected: (index) => setState(() => selectedTab = index),
            selectedTabColors: const [
              primaryOrangeTextColor, // Unpaid tab color
              successTextColor, // Partial tab color
              googleRed, // Paid tab color
            ],
            selectedTextColors: const [
              Colors.white, // Unpaid text color
              Colors.white, // Partial text color
              Colors.white, // Paid text color
            ],
            selectedBorderColors: const [
              primaryOrangeTextColor, // Unpaid border color
              successTextColor, // Partial border color
              googleRed, // Paid border color
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
              child: selectedTab == 0
                  ? PendingApprovalsPage(getStatus:'Pending')
                  : selectedTab == 1
                      ? ApprovedApprovalsPage(getStatus:'Approved')
                      : DeclinedApprovalsPage(getStatus:'Declined')),
        ],
      ),
    );
  }
}
