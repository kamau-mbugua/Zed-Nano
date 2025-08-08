import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/get_all_activeStock/GetAllActiveStockResponse.dart';
import 'package:zed_nano/models/listCategories/ListCategoriesResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/sell/select_category_page.dart';
import 'package:zed_nano/screens/stock/itemBuilder/build_stock_item.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/filter_row_widget.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class ViewOutOfStockPage extends StatefulWidget {
  const ViewOutOfStockPage({super.key});

  @override
  _ViewOutOfStockPageState createState() => _ViewOutOfStockPageState();
}

class _ViewOutOfStockPageState extends State<ViewOutOfStockPage> {
  late PaginationController<ActiveStockProduct> _paginationController;
  final int _activeStatusFilter = -1; // -1: All, 0: Low Stock, 1: Out of Stock

  String _searchTerm = '';
  String? selectedCategoryId;
  String selectedCategory = 'All Categories';
  String sortOrder = 'List: A-Z';
  bool isAscending = true;

  List<ProductCategoryData> categories = [];
  int totalStockCount = 0;
  int lowStockCount = 0;
  int outOfStockCount = 0;

  final String _selectedCategory = 'All';
  final String _sortOrder = 'A-Z';
  final TextEditingController _searchController = TextEditingController();

  List<ActiveStockProduct> products = [];
  TextEditingController searchController = TextEditingController();

  Timer? _debounceTimer;

  final bool _isLoading = true;
  StockStatusSummary? _summary;

  ProductCategoryData? categoryData;
  GetAllActiveStockResponse? getAllActiveStockResponse;


  @override
  void initState() {
    super.initState();

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
        _paginationController.fetchFirstPage();
      }
    });
  }

  Future<List<ActiveStockProduct>> getAllActiveStock(
      {required int page, required int limit,}) async {
    try {
      final response = await getBusinessProvider(context).getAllActiveStock(
          page: page,
          limit: limit,
          searchValue: _searchTerm,
          context: context,
          categoryId: selectedCategoryId ?? '',
          showStockDashboard:true,
      );

      setState(() {
        totalStockCount = response.data?.count ?? 0;
        lowStockCount = response.data?.lowStockProductsCount ?? 0;
        outOfStockCount = response.data?.outOfStockProductsCount ?? 0;
      });

      return response.data?.outOfStockProducts ?? [];
    } catch (e) {
      showCustomToast(e.toString());
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

  Future<void> _openCategorySelection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectCategoryPage()),
    );

    if (result != null && result is ProductCategoryData) {
      setState(() {
        categoryData = result;
        selectedCategoryId = result.id;
        selectedCategory = result.categoryName ?? 'All Categories';
      });
      _paginationController.refresh();
    }
  }


  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  const AuthAppBar(title: 'Out of Stock'),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilters(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _paginationController.refresh();
                // await _fetchStockSummary();
              },
              child: _buildStockList(),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //   },
      //   label: const Text('Add', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
      //   icon: const Icon(Icons.add, color: Colors.white),
      //   backgroundColor: appThemePrimary,
      // ),
    );
  }


  Widget _buildSearchBar() {
    return buildSearchBar(controller: _searchController, onChanged: _onSearchChanged);
  }

  Widget _buildFilters() {
    return FilterRowWidget(
      leftButtonText: selectedCategory,
      leftButtonIsActive: selectedCategory != 'All Categories',
      leftButtonOnTap: _openCategorySelection,
      leftButtonIcon: Icons.tune,
      rightButtonText: sortOrder,
      rightButtonIsActive: sortOrder != 'List: A-Z',
      rightButtonOnTap: () {
        setState(() {
          sortOrder = sortOrder == 'List: A-Z' ? 'List: Z-A' : 'List: A-Z';
        });
      },
      showRightButtonArrow: false,
      showRightButton: false,
    ).paddingSymmetric(horizontal: 16);
  }
  Widget _buildStockList() {
    return PagedListView<int, ActiveStockProduct>(
      pagingController: _paginationController.pagingController,
      builderDelegate: PagedChildBuilderDelegate<ActiveStockProduct>(
        itemBuilder: (context, item, index) {
          return buildStockItem(item);
        },
        firstPageProgressIndicatorBuilder: (_) => const SizedBox(),
        newPageProgressIndicatorBuilder: (_) => const SizedBox(),
        noItemsFoundIndicatorBuilder: (context) => const Center(
          child: CompactGifDisplayWidget(
            gifPath: emptyListGif,
            title: "It's empty over here.",
            subtitle:
            'No products in this category yet! Add to view them here.',
          ),
        ),
        firstPageErrorIndicatorBuilder: (context) => const Center(
          child: CompactGifDisplayWidget(
            gifPath: emptyListGif,
            title: "It's empty over here.",
            subtitle:
            'No products in this category yet! Add to view them here.',
          ),
        ),
      ),
    );
  }

}
