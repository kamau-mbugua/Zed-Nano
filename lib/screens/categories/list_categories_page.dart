import 'package:flutter/material.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'tabs/product_categories_tab.dart';
import 'tabs/service_categories_tab.dart';

class ListCategoriesPage extends StatefulWidget {
  const ListCategoriesPage({super.key});

  @override
  State<ListCategoriesPage> createState() => _ListCategoriesPageState();
}

class _ListCategoriesPageState extends State<ListCategoriesPage> {
  int selectedTab = 0; // 0 = Product, 1 = Service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AuthAppBar(title: 'Categories'),
      body: Column(
        children: [
          const SizedBox(height: 24),
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildTab('Product Categories', 0),
                  _buildTab('Service Categories', 1),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Tab Content
          Expanded(
            child: selectedTab == 0 
                ? const ProductCategoriesTab()
                : const ServiceCategoriesTab(),
          ),
        ],
      )
    );
  }

  Expanded _buildTab(String title, int index) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: const Color(0xFFE8E8E8))
                : null,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: isSelected
                  ? const Color(0xFF1F2024)
                  : const Color(0xFF71727A),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
