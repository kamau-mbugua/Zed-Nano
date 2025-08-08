import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/listCategories/ListCategoriesResponse.dart';
import 'package:zed_nano/models/listStockTake/GetActiveStockTakeResponse.dart';
import 'package:zed_nano/models/product_model.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/sell/select_category_page.dart';
import 'package:zed_nano/screens/stock/itemBuilder/add_stock_build_product_item.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/bottom_sheet_helper.dart';
import 'package:zed_nano/screens/widget/common/filter_row_widget.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/pagination_controller.dart';
import 'package:zed_nano/viewmodels/add_stock_take_viewmodel.dart';

class AddStockTakeProductsPage extends StatefulWidget {
  const AddStockTakeProductsPage({required this.onNext, required this.onPrevious, super.key});
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  State<AddStockTakeProductsPage> createState() => _AddStockTakeProductsPageState();
}

class _AddStockTakeProductsPageState extends State<AddStockTakeProductsPage> {
  String selectedCategory = 'All Categories';
  String sortOrder = 'List: A-Z';
  List<Product> products = []; // This would come from your API
  TextEditingController searchController = TextEditingController();

  late PaginationController<StockTakeProduct> _paginationController;
  String _searchTerm = '';
  ProductCategoryData? categoryData;
  Timer? _debounceTimer;
  String? selectedCategoryId = '';

  @override
  void initState() {
    super.initState();

    // Initialize pagination controller without adding listeners yet
    _paginationController = PaginationController<StockTakeProduct>(
      fetchItems: (page, pageSize) async {
        return getListStockTake(page: page, limit: pageSize);
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

  Future<List<StockTakeProduct>> getListStockTake(
      {required int page, required int limit,}) async {
    try {
      final response = await getBusinessProvider(context).getListStockTake(
          page: page,
          limit: limit,
          searchValue: _searchTerm,
          context: context,
          categoryId: selectedCategoryId ?? '',
      );

      return response.data?.data ?? [];
    } catch (e) {
      return [];
    }
  }

  @override
  void dispose() {
    _paginationController.dispose();
    searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _debounceSearch(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchTerm = value;
      });
      _paginationController.refresh();
    });
  }

  // Method to open category selection page
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
  Widget build(BuildContext context) {
    final addStockViewModel = Provider.of<AddStockTakeViewModel>(context);
    final selectedItems = addStockViewModel.itemCount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AuthAppBar(title: 'Stock Take', onBackPressed: widget.onPrevious,),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter row
          headings(
            label: 'Update Stock',
            subLabel: 'Tap on a product to edit stock.',
          ).paddingSymmetric(horizontal: 16),
          FilterRowWidget(
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
          ),
          16.height,
          // Product list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _paginationController.refresh();
              },
              child: PagedListView<int, StockTakeProduct>(
                pagingController: _paginationController.pagingController,
                builderDelegate: PagedChildBuilderDelegate<StockTakeProduct>(
                  itemBuilder: (context, item, index) {
                    final product = item;
                    final cartItem = addStockViewModel.findItem(product.id ?? '');
                    final quantity = cartItem?.quantity ?? 0;
                    final variance = cartItem?.variation ?? 0;

                    return addStockTakeBuildProductItem(
                      product: product,
                      quantity: quantity.toInt(),
                      variance: variance.toInt(),
                      onTap: () {
                        BottomSheetHelper.showAddStockTakeBottomSheet(
                          context,
                          activeStockProduct: product,
                        );
                      },
                    );
                  },
                  firstPageProgressIndicatorBuilder: (_) => const SizedBox(),
                  newPageProgressIndicatorBuilder: (_) => const SizedBox(),
                  noItemsFoundIndicatorBuilder: (context) => const Center(
                    child: CompactGifDisplayWidget(
                      gifPath: emptyListGif,
                      title: "It's empty, over here.",
                      subtitle:
                      'No products in this category yet! Add to view them here.',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Search bar takes 60% of the width
              Expanded(
                flex: 6,
                child: buildSearchBar(
                  controller: searchController,
                  onChanged: _debounceSearch,
                  hint: 'Search product',
                ),
              ),
              const SizedBox(width: 12),
              // Button takes 40% of the width
              Expanded(
                flex: 4,
                child: appButton(
                  text: 'Preview: $selectedItems',
                  onTap: () {
                    widget.onNext();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const CartPreviewPage()),
                    // );
                  },
                  context: context,
                  width: 120, // Fixed width instead of full width
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
