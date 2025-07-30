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
import 'package:zed_nano/screens/sell/cart_preview_page.dart';
import 'package:zed_nano/screens/sell/itemBuilders/order_taking_item_builder.dart';
import 'package:zed_nano/screens/sell/select_category_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/bottom_sheet_helper.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/screens/widget/common/filter_row_widget.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/logger.dart';
import 'package:zed_nano/utils/pagination_controller.dart';
import 'package:zed_nano/viewmodels/CustomerInvoicingViewModel.dart';

class SellPage extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  SellPage({Key? key, required this.onNext, required this.onPrevious})
      : super(key: key);

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
  Timer? _longPressTimer;
  String? selectedCategoryId = '';

  @override
  void initState() {
    super.initState();
    // Initialize pagination controller without adding listeners yet
    _paginationController = PaginationController<ProductData>(
      fetchItems: (page, pageSize) async {
        return getListByProducts(page: page, limit: pageSize);
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
    _longPressTimer?.cancel();
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

  void onDecrease(
      int quantity, CartViewModel cartViewModel, ProductData product) {
    if (quantity > 0) {
      if (quantity == 1) {
        cartViewModel.removeItem(product.id ?? '');
      } else {
        cartViewModel.updateQuantity(product.id ?? '', quantity - 1);
      }
    }
  }

  void onIncrease(
      int quantity, CartViewModel cartViewModel, ProductData product) {
    if (quantity == 0) {
      cartViewModel.addItem(
        product.id ?? '',
        product.productName ?? '',
        product.productPrice?.toDouble() ?? 0.0,
        product.imagePath ?? '',
        product.currency ?? '',
        product.productCategory ?? '',
        0.0,
      );
    } else {
      cartViewModel.updateQuantity(product.id ?? '', quantity + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);
    var customerInvoicingViewModel = Provider.of<CustomerInvoicingViewModel>(context);


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(title:
      customerInvoicingViewModel.customerData != null
          ? 'Create Invoice'
          : 'Sell', onBackPressed: widget.onPrevious),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createInvoiceHeader(customerInvoicingViewModel),
          _createFilterRow(),
          16.height,
          _createListView(cartViewModel),
          // Product list
        ],
      ).paddingSymmetric(horizontal: 16),
      bottomNavigationBar: _createBottomNavBar(cartViewModel),
    );
  }

  Widget _createInvoiceHeader(CustomerInvoicingViewModel customerInvoicingViewModel) {
    return Visibility(
      visible: customerInvoicingViewModel.customerData != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headings(
            label: 'Invoice Items',
            subLabel: 'Fill in the details to create your invoice.',
          ),
        ],
      ),
    );
  }

  Widget _createBottomNavBar(CartViewModel cartViewModel) {
    final selectedItems = cartViewModel.itemCount;
    return Container(
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
                },
                context: context,
                width: 120, // Fixed width instead of full width
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createFilterRow() {
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
    );
  }

  Widget _createListView(CartViewModel cartViewModel) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await _paginationController.refresh();
        },
        child: PagedListView<int, ProductData>(
          pagingController: _paginationController.pagingController,
          builderDelegate: PagedChildBuilderDelegate<ProductData>(
            itemBuilder: (context, item, index) {
              final product = item;
              final cartItem = cartViewModel.findItem(product.id ?? '');
              final quantity = cartItem?.quantity ?? 0;
              final discount = cartItem?.discount ?? 0;

              return buildProductItem(
                product: product,
                quantity: quantity,
                discount: discount,
                cartViewModel: cartViewModel,
                onAddDiscount: () {
                  logger.d('onAddDiscount');
                  if (quantity == 0) {
                    cartViewModel.addItem(
                      product.id ?? '',
                      product.productName ?? '',
                      product.productPrice?.toDouble() ?? 0.0,
                      product.imagePath ?? '',
                      product.currency ?? '',
                      product.productCategory ?? '',
                      0.0,
                    );
                  }
                  BottomSheetHelper.showAddDiscountBottomSheet(
                    context,
                    productData: product,
                  );
                },
                onDecrease: () => onDecrease(quantity, cartViewModel, product),
                onIncrease: () => onIncrease(quantity, cartViewModel, product),
                onIncreaseLongPress: () => onIncrease(quantity, cartViewModel, product),
                onDecreaseLongPress: () {
                  cartViewModel.removeItem(product.id ?? '');
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
    );
  }
}
