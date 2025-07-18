import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/get_all_activeStock/GetAllActiveStockResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/utils/pagination_controller.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/GifsImages.dart';

class ViewStockPage extends StatefulWidget {
  const ViewStockPage({Key? key}) : super(key: key);

  @override
  _ViewStockPageState createState() => _ViewStockPageState();
}

class _ViewStockPageState extends State<ViewStockPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  String _sortOrder = 'A-Z';
  TextEditingController _searchController = TextEditingController();

  String selectedCategory = 'All Categories';
  String sortOrder = 'List: A-Z';
  List<ActiveStockProduct> products = [];
  TextEditingController searchController = TextEditingController();

  late PaginationController<ActiveStockProduct> _paginationController;
  String _searchTerm = "";
  Timer? _debounceTimer;
  String? selectedCategoryId = '';
  
  bool _isLoading = true;
  StockStatusSummary? _summary;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize pagination controller without adding listeners yet
    _paginationController = PaginationController<ActiveStockProduct>(
      fetchItems: (page, pageSize) async {
        return getAllActiveStock(page: page, limit: pageSize);
      },
    );

    // Defer API calls to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Initialize the controller and fetch first page after build is complete
        _paginationController.initialize();
        _fetchStockSummary();
      }
    });
  }

  Future<void> _fetchStockSummary() async {
    try {
      final response = await getBusinessProvider(context).getAllActiveStock(
          page: 1,
          limit: 10,
          searchValue: '',
          context: context,
          categoryId: '');
      
      if (response.isSuccess && response.data != null) {
        setState(() {
          _summary = response.data!.stockStatusSummary;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<ActiveStockProduct>> getAllActiveStock(
      {required int page, required int limit}) async {
    try {
      final response = await getBusinessProvider(context).getAllActiveStock(
          page: page,
          limit: limit,
          searchValue: _searchTerm,
          context: context,
          categoryId: selectedCategoryId ?? '');

      return response.data?.data ?? [];
    } catch (e) {
      print("Error fetching stock: $e");
      return [];
    }
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchTerm = query;
        _paginationController.refresh();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(title: "View Stock"),
      body: Column(
        children: [
          _buildStatusSummary(),
          _buildSearchBar(),
          _buildFilters(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _paginationController.refresh();
                await _fetchStockSummary();
              },
              child: _buildStockList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF032541),
        onPressed: () {
          // Navigate to add product page
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatusSummary() {
    final int lowStockCount = _summary?.totalProductsInLowStock ?? 0;
    final int outOfStockCount = _summary?.totalProductsOutOfStock ?? 0;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildStatusCard(
              Icons.warning_amber_rounded,
              Colors.orange,
              'Low Stock',
              '$lowStockCount Products',
              onTap: () {
                _tabController.animateTo(0);
              },
              isActive: _tabController.index == 0,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatusCard(
              Icons.cancel_outlined,
              Colors.red,
              'Out of Stock',
              '$outOfStockCount Products',
              onTap: () {
                _tabController.animateTo(1);
              },
              isActive: _tabController.index == 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    IconData icon,
    Color color,
    String title,
    String subtitle, {
    required Function() onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: color,
            width:  1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(fontFamily: 'Poppins'),
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        style: const TextStyle(fontFamily: 'Poppins'),
        onChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdown(
              'Categories: $_selectedCategory',
              ['All', 'Food', 'Drinks', 'Stationery', 'Cleaning'],
              (value) {
                setState(() {
                  _selectedCategory = value!;
                  // Add logic to filter by category
                  _paginationController.refresh();
                });
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildDropdown(
              'List: $_sortOrder',
              ['A-Z', 'Z-A', 'Price ↑', 'Price ↓'],
              (value) {
                setState(() {
                  _sortOrder = value!;
                  // Add logic to sort products
                  _paginationController.refresh();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
      String hint, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint, style: TextStyle(fontFamily: 'Poppins')),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontFamily: 'Poppins')),
            );
          }).toList(),
          onChanged: onChanged,
          style: TextStyle(color: Colors.black87, fontFamily: 'Poppins'),
        ),
      ),
    );
  }

  Widget _buildStockList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return PagedListView<int, ActiveStockProduct>(
      pagingController: _paginationController.pagingController,
      builderDelegate: PagedChildBuilderDelegate<ActiveStockProduct>(
        itemBuilder: (context, item, index) {
          return _buildStockItem(item);
        },
        firstPageProgressIndicatorBuilder: (_) => SizedBox(),
        newPageProgressIndicatorBuilder: (_) => SizedBox(),
        noItemsFoundIndicatorBuilder: (context) => Center(
          child: CompactGifDisplayWidget(
            gifPath: emptyListGif,
            title: "It's empty over here.",
            subtitle:
            'No products in this category yet! Add to view them here.',
          ),
        ),
        firstPageErrorIndicatorBuilder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Failed to load stock data',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _paginationController.refresh(),
                child: const Text('Try Again', style: TextStyle(fontFamily: 'Poppins')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockItem(ActiveStockProduct item) {
    Color statusColor;
    String statusText;
    
    switch (item.stockStatus) {
      case 'LOW_STOCK':
        statusColor = Colors.orange;
        statusText = 'Low stock: ${item.inStockQuantity} items left';
        break;
      case 'OUT_OF_STOCK':
        statusColor = Colors.red;
        statusText = 'Out of stock';
        break;
      case 'IN_STOCK':
      default:
        statusColor = Colors.green;
        statusText = 'In Stock: ${item.inStockQuantity} items';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Status indicator bar
          Container(
            width: 4,
            height: 80,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName ?? '',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.productCategory} · $statusText',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${item.currency ?? "KES"} ${item.sellingPrice?.toStringAsFixed(0) ?? "0"}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
