import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/listCategories/ListCategoriesResponse.dart';
import 'package:zed_nano/models/listProducts/ListProductsResponse.dart';
import 'package:zed_nano/models/product_model.dart';
import 'package:zed_nano/providers/cart/CartViewModel.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/sell/select_category_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class SellPage extends StatefulWidget {
  const SellPage({Key? key}) : super(key: key);

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  String selectedCategory = 'All Categories';
  String sortOrder = 'List: A-Z';
  List<Product> products = []; // This would come from your API
  TextEditingController searchController = TextEditingController();

  late PaginationController<ProductData> _paginationController;
  String _searchTerm = "";
  ProductCategoryData? categoryData;
  Timer? _debounceTimer;
  String? selectedCategoryId = '';

  @override
  void initState() {
    // Initialize pagination controller without immediately fetching data
    _paginationController = PaginationController<ProductData>(
      fetchItems: (page, pageSize) async {
        return getListByProducts(page: page, limit: pageSize);
      },
    );

    // Defer API calls to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _paginationController.fetchFirstPage();
    });

    super.initState();
  }

  Future<List<ProductData>> getListByProducts(
      {required int page, required int limit}) async {
    final response = await getBusinessProvider(context).getListByProducts(
        page: page,
        limit: limit,
        searchValue: _searchTerm,
        context: context,
        categoryId: selectedCategoryId ?? '');

    return response.data?.data ?? [];
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
    final cartViewModel = Provider.of<CartViewModel>(context);
    final selectedItems = cartViewModel.itemCount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AuthAppBar(title: 'Sell'),
      body: Column(
        children: [
          // Filter row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFilterDynamicButton(
                  'All Categories',
                  selectedCategory == 'All Categories',
                  _openCategorySelection,
                ),
                _buildFilterButton(
                  'List: A-Z',
                  sortOrder == 'List: A-Z',
                  () {
                    setState(() {
                      sortOrder = 'List: A-Z';
                    });
                  },
                ),
              ],
            ),
          ),
          16.height,
          // Product list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _paginationController.refresh();
              },
              child: PagedListView<int, ProductData>(
                pagingController: _paginationController.pagingController,
                builderDelegate: PagedChildBuilderDelegate<ProductData>(
                  itemBuilder: (context, item, index) {
                    final product = item;
                    final cartItem = cartViewModel.findItem(product.id ?? '');
                    final quantity = cartItem?.quantity ?? 0;

                    return _buildProductItem(
                      product: product,
                      quantity: quantity,
                      onDecrease: () {
                        if (quantity > 0) {
                          if (quantity == 1) {
                            cartViewModel.removeItem(product.id ?? '');
                          } else {
                            cartViewModel.updateQuantity(
                                product.id ?? '', quantity - 1);
                          }
                        }
                      },
                      onIncrease: () {
                        if (quantity == 0) {
                          cartViewModel.addItem(
                            product.id ?? '',
                            product.productName ?? '',
                            product.productPrice?.toDouble() ?? 0.0,
                          );
                        } else {
                          cartViewModel.updateQuantity(
                              product.id ?? '', quantity + 1);
                        }
                      },
                    );
                  },
                  firstPageProgressIndicatorBuilder: (_) => SizedBox(),
                  newPageProgressIndicatorBuilder: (_) => SizedBox(),
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
                  onTap: () {},
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

  Widget _buildFilterDynamicButton(String text, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: innactiveBorder,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                  Icon(
                    Icons.tune,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                Text(
                  selectedCategory,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildFilterButton(String text, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: innactiveBorder,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (text == 'All Categories')
                  Icon(
                    Icons.tune,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                if (text == 'All Categories') const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem({
    required ProductData product,
    required int quantity,
    required VoidCallback onDecrease,
    required VoidCallback onIncrease,
  }) {
    final bool isSelected = quantity > 0;
    final int totalPrice = product.productPrice! * quantity;

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? highlightMainDark : innactiveBorder,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          rfCommonCachedNetworkImage(
            product.imagePath ?? '',
            fit: BoxFit.cover,
            height: 42,
            width: 42,
          ),
          const SizedBox(width: 16),
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: Color(0xFF323232),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      product.productCategory ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      ' · ',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      '${product.currency} ${product.productPrice}',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Quantity controls
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  // Minus button
                  InkWell(
                    onTap: onDecrease,
                    child: Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: lightGreyColor,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: 8,
                        height: 1.5,
                        color: isSelected
                            ? highlightMainDark
                            : Colors.grey.shade400,
                      ),
                    ),
                  ),

                  // Quantity
                  Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(
                      quantity.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        color: highlightMainDark,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  // Plus button
                  InkWell(
                    onTap: onIncrease,
                    child: Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: lightGreyColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 10,
                        color: highlightMainDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Total price
              Text(
                'KES ${totalPrice.round()}',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? const Color(0xFF323232)
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
