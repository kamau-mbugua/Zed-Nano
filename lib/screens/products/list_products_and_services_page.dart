import 'package:flutter/material.dart';
import 'package:zed_nano/screens/products/tab/products_list_page.dart';
import 'package:zed_nano/screens/products/tab/service_list_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_tab_switcher.dart';

class ListProductsAndServicesPage extends StatefulWidget {
  const ListProductsAndServicesPage({Key? key}) : super(key: key);

  @override
  State<ListProductsAndServicesPage> createState() => _ListProductsAndServicesPageState();
}

class _ListProductsAndServicesPageState extends State<ListProductsAndServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(title: "Products & Services"),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Expanded(
            child: SwipeableTabSwitcher(
              tabs: const ["Product", "Service"],
              children: const [
                ProductsListPage(),
                ServiceListPage(),
              ],
              onTabChanged: (index) {
                // Optional: Handle tab changes if needed
                // print('Tab changed to: $index');
              },
            ),
          ),
        ],
      )
    );
  }
}
