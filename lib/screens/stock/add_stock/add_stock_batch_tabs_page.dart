import 'package:flutter/material.dart';
import 'package:zed_nano/screens/products/tab/products_list_page.dart';
import 'package:zed_nano/screens/products/tab/service_list_page.dart';
import 'package:zed_nano/screens/stock/add_stock/tabs/add_stock_approved_batch_page.dart';
import 'package:zed_nano/screens/stock/add_stock/tabs/add_stock_pending_batch_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_tab_switcher.dart';

class AddStockBatchTabsPage extends StatefulWidget {
  const AddStockBatchTabsPage({Key? key}) : super(key: key);

  @override
  State<AddStockBatchTabsPage> createState() => _AddStockBatchTabsPageState();
}

class _AddStockBatchTabsPageState extends State<AddStockBatchTabsPage> {
  int selectedTab = 0; // 0 = Product, 1 = Service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AuthAppBar(title: "Add Stock"),
        body: Column(
          children: [
            const SizedBox(height: 4),
            Expanded(
              child: SwipeableTabSwitcher(
                tabs: const ["Approved", "Pending"],
                children: const [
                  AddStockApprovedBatchPage(),
                  AddStockPendingBatchPage(),
                ],
              ),
            ),
          ],
        )
    );
  }
}
