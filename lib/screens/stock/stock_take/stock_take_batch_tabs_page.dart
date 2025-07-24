import 'package:flutter/material.dart';
import 'package:zed_nano/screens/products/tab/products_list_page.dart';
import 'package:zed_nano/screens/products/tab/service_list_page.dart';
import 'package:zed_nano/screens/stock/add_stock/tabs/add_stock_approved_batch_page.dart';
import 'package:zed_nano/screens/stock/add_stock/tabs/add_stock_pending_batch_page.dart';
import 'package:zed_nano/screens/stock/stock_take/tabs/stock_take_approved_batch_page.dart';
import 'package:zed_nano/screens/stock/stock_take/tabs/stock_take_pending_batch_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_tab_switcher.dart';

class StockTakeBatchTabsPage extends StatefulWidget {
  const StockTakeBatchTabsPage({Key? key}) : super(key: key);

  @override
  State<StockTakeBatchTabsPage> createState() => _StockTakeBatchTabsPageState();
}

class _StockTakeBatchTabsPageState extends State<StockTakeBatchTabsPage> {
  int selectedTab = 0; // 0 = Product, 1 = Service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AuthAppBar(title: "Stock Take"),
        body: Column(
          children: [
            const SizedBox(height: 4),
            // Tabs
            CustomTabSwitcher(
              tabs: const ["Approved", "Pending"],
              selectedIndex: selectedTab,
              onTabSelected: (index) => setState(() => selectedTab = index),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: selectedTab == 0
                  ? const StockTakeApprovedBatchPage()
                  : const StockTakePendingBatchPage(),
            ),
          ],
        )
    );
  }
}
