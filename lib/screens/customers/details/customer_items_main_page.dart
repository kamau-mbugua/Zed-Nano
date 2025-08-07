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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        // Fixed height container for the swipeable tab content
        SizedBox(
          height: 400, // Fixed height to prevent infinite expansion
          child: SwipeableTabSwitcher(
            tabs: const ['Transactions', 'Invoices', 'Orders'],
            children: [
              CustomerTransactionsPage(customerID: widget?.customerID ?? ''),
              CustomerInvoicesPage(customerId: widget?.customerID ?? ''),
              CustomerOrdersPages(customerId: widget?.customerID ?? ''),
            ],
            selectedTabColors: const [
              colorBackground,      // Transactions tab color
              colorBackground,     // Invoices tab color
              colorBackground,        // Orders tab color
            ],
            selectedTextColors: const [
              textPrimary,      // Transactions text color
              textPrimary,      // Invoices text color
              textPrimary,      // Orders text color
            ],
            selectedBorderColors: const [
              colorBackground,      // Transactions border color
              colorBackground,     // Invoices border color
              colorBackground,        // Orders border color
            ],
          ),
        ),
      ],
    );
  }
}
