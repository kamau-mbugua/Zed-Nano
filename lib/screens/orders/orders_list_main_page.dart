import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/screens/orders/tabs/orders_list_cancelled_page.dart';
import 'package:zed_nano/screens/orders/tabs/orders_list_paid_page.dart';
import 'package:zed_nano/screens/orders/tabs/orders_list_partial_page.dart';
import 'package:zed_nano/screens/orders/tabs/orders_list_unpaid_page.dart';
import 'package:zed_nano/screens/sell/sell_stepper_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_tab_switcher.dart';
import 'package:zed_nano/utils/Colors.dart';

class OrdersListMainPage extends StatefulWidget {
  bool? showAppBar;
  OrdersListMainPage({Key? key, this.showAppBar = true}) : super(key: key);

  @override
  _OrdersListMainPageState createState() => _OrdersListMainPageState();
}

class _OrdersListMainPageState extends State<OrdersListMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:widget?.showAppBar == true ? AuthAppBar(
          title: 'Orders '
      ) : null,
      body: Column(
        children: [
          // SizedBox(height: 24),
          // Tabs
          Expanded(
            child: SwipeableTabSwitcher(
              tabs: const ['Unpaid', 'Partial', 'Paid', 'Cancelled'],
              children: const [
                OrdersListUnpaidPage(),
                OrdersListPartialPage(),
                OrdersListPaidPage(),
                OrdersListCancelledPage(),
              ],
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
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: (widget.showAppBar ==true),
        child: FloatingActionButton.extended(
          heroTag: "orders_list_fab",
          onPressed: () {
            const SellStepperPage().launch(context);
          },
          label: const Text('Sell', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
          icon: const Icon(Icons.lock, color: Colors.white),
          backgroundColor: appThemePrimary,
        ),
      ),
    );
  }
}
