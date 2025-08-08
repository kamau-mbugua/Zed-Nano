import 'package:flutter/material.dart';
import 'package:zed_nano/screens/stock/stock_take/tabs/stock_take_approved_batch_page.dart';
import 'package:zed_nano/screens/stock/stock_take/tabs/stock_take_pending_batch_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_tab_switcher.dart';

class StockTakeBatchTabsPage extends StatefulWidget {
  const StockTakeBatchTabsPage({super.key});

  @override
  State<StockTakeBatchTabsPage> createState() => _StockTakeBatchTabsPageState();
}

class _StockTakeBatchTabsPageState extends State<StockTakeBatchTabsPage> {
  int selectedTab = 0; // 0 = Product, 1 = Service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const AuthAppBar(title: 'Stock Take'),
        body: Column(
          children: [
            const SizedBox(height: 4),
            // Tabs
            // Example 1: Original 2-tab version (still works as before)
            // CustomTabSwitcher(
            //   tabs: const ["Approved", "Pending"],
            //   selectedIndex: selectedTab,
            //   onTabSelected: (index) => setState(() => selectedTab = index),
            // ),
            
            // Example 2: 3 tabs with individual colors
            // CustomTabSwitcher(
            //   tabs: const ["Approved", "Pending"],
            //   selectedIndex: selectedTab,
            //   onTabSelected: (index) => setState(() => selectedTab = index),
            //   // selectedTabColors: const [
            //   //   Colors.green,      // Approved tab color
            //   //   Colors.orange,     // Pending tab color
            //   //   // Colors.red,        // Rejected tab color
            //   // ],
            //   // selectedTextColors: const [
            //   //   Colors.white,      // Approved text color
            //   //   Colors.white,      // Pending text color
            //   //   // Colors.white,      // Rejected text color
            //   // ],
            //   // selectedBorderColors: const [
            //   //   Colors.green,      // Approved border color
            //   //   Colors.orange,     // Pending border color
            //   //   // Colors.red,        // Rejected border color
            //   // ],
            // ),
            
            // Example 3: Mixed approach - some tabs with custom colors, others use default
            // CustomTabSwitcher(
            //   tabs: const ["Active", "Inactive", "Draft"],
            //   selectedIndex: selectedTab,
            //   onTabSelected: (index) => setState(() => selectedTab = index),
            //   selectedTabColors: const [
            //     Colors.blue,       // Active tab - custom color
            //     Colors.grey,       // Inactive tab - custom color
            //     // Draft tab will use default selectedTabColor (Colors.white)
            //   ],
            // ),
            const SizedBox(height: 16),
            Expanded(
              child: SwipeableTabSwitcher(
                tabs: const ['Approved', 'Pending'],
                children: const [
                  StockTakeApprovedBatchPage(),
                  StockTakePendingBatchPage(),
                ],
              ),
            ),
          ],
        ),
    );
  }
}
