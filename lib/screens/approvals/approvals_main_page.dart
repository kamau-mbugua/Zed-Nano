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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          widget?.showAppBar == true ? AuthAppBar(title: 'Approvals ') : null,
      body: Column(
        children: [
          SizedBox(height: widget?.showAppBar == true ? 24 : 80),
          Expanded(
            child: SwipeableTabSwitcher(
              tabs: const ['Pending', 'Approved', 'Declined'],
              children: [
                PendingApprovalsPage(getStatus: 'Pending'),
                ApprovedApprovalsPage(getStatus: 'Approved'),
                DeclinedApprovalsPage(getStatus: 'Declined'),
              ],
              selectedTabColors: const [
                primaryOrangeTextColor, // Pending tab color
                successTextColor, // Approved tab color
                googleRed, // Declined tab color
              ],
              selectedTextColors: const [
                Colors.white, // Pending text color
                Colors.white, // Approved text color
                Colors.white, // Declined text color
              ],
              selectedBorderColors: const [
                primaryOrangeTextColor, // Pending border color
                successTextColor, // Approved border color
                googleRed, // Declined border color
              ],
              onTabChanged: (index) {
                // Optional: Handle tab changes if needed
                // You can add any logic here when tabs change
              },
            ),
          ),
        ],
      ),
    );
  }
}
