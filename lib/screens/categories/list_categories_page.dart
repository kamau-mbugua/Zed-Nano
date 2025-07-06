import 'package:flutter/material.dart';

class ListCategoriesPage extends StatefulWidget {
  const ListCategoriesPage({super.key});

  @override
  State<ListCategoriesPage> createState() => _ListCategoriesPageState();
}

class _ListCategoriesPageState extends State<ListCategoriesPage> {
  int selectedTab = 1; // 0 = Product, 1 = Service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: BackButton(color: const Color(0xFF1F2024)),
        title: const Text(
          'Categories',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2024),
            fontFamily: 'Poppins',
          ),
        ),
      ),
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
                  _buildTab("Product Categories", 0),
                  _buildTab("Service Categories", 1),
                ],
              ),
            ),
          ),
          const SizedBox(height: 80),
          // Empty State
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/empty_categories.png', // replace with your actual asset
                  width: 135,
                  height: 135,
                ),
                const SizedBox(height: 16),
                const Text(
                  "It’s empty, over here.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Color(0xFF1F2024),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    "No service categories in your business, yet! Add to view them here.",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      color: Color(0xFF71727A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Handle add
        },
        backgroundColor: const Color(0xFF032541),
        icon: const Icon(Icons.add, size: 20),
        label: const Text(
          "Add",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
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
