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
  int selectedTab = 0; // 0 = Product, 1 = Service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(title: "Products & Services"),
      body: Column(
        children: [
          const SizedBox(height: 24),
          // Tabs
          CustomTabSwitcher(
            tabs: const ["Product", "Service"],
            selectedIndex: selectedTab,
            onTabSelected: (index) => setState(() => selectedTab = index),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: selectedTab == 0
                ? const ProductsListPage()
                : const ServiceListPage(),
          ),
        ],
      )
    );
  }
}
