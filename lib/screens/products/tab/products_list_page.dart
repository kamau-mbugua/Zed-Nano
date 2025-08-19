import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/listProducts/ListProductsResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/products/add/add_product_page.dart';
import 'package:zed_nano/screens/widget/common/categories_widget.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/pagination_controller.dart';
import 'package:zed_nano/viewmodels/DataRefreshViewModel.dart';
class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {

  // Initialize with default value to avoid LateInitializationError
  late PaginationController<ProductData> _paginationController;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  bool _isInitialized = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    // Initialize the controller but don't start fetching yet
    _paginationController = PaginationController<ProductData>(
      fetchItems: (page, pageSize) async {
        return getListProducts(page: page, limit: pageSize);
      },
    );

    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isInitialized = true;
      });
      // Start the first page fetch after the UI is fully built
      _paginationController.fetchFirstPage();
    });
  }

  Future<List<ProductData>> getListProducts({required int page, required int limit}) async {
    final response = await getBusinessProvider(context).getListProducts(
        page: page,
        limit: limit,
        searchValue: _searchTerm,
        context: context,
        productService: 'Product',
    );
    return response.data?.data ?? [];
  }

  @override
  void dispose() {
    _paginationController.dispose();
    _searchController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Consumer<DataRefreshViewModel>(
        builder: (context, dataRefreshViewModel, child) {
          var shouldRefresh = false;
          // Check if data refresh is needed
          if (dataRefreshViewModel.isRefreshing(DataRefreshType.addStock) ||
              dataRefreshViewModel.isRefreshing(DataRefreshType.stockTake)) {
            shouldRefresh = true;
            Future.microtask(() {
              dataRefreshViewModel.completeRefresh(DataRefreshType.addStock);
              dataRefreshViewModel.completeRefresh(DataRefreshType.stockTake);
            });
          }

          // Only fetch data once if either condition is true
          if (shouldRefresh) {
            _paginationController.refresh();
          }
          return Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                // await Navigator.pushNamed(context, AppRoutes.getNewProductWithParamRoutes('true')).then((value) {
                //   _paginationController.refresh();
                // });

                await const AddProductScreen(
                  doNotUpdate: true,
                  selectedCategory: '',
                  productService: 'Product',
                ).launch(context).then((value) {
                  _paginationController.refresh();
                });

              },
              backgroundColor: const Color(0xFF032541),
              icon: const Icon(Icons.add, size: 20, color: Colors.white),
              label: const Text(
                'Add',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
            body: !_isInitialized
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: () async {
                await _paginationController.refresh();
              },
              child:
              Column(
                children: [
                  buildSearchBar(
                    controller: _searchController,
                    onChanged: _debounceSearch,
                    hint: 'Search Products',
                  ),
                  Expanded(
                    child: PagedListView<int, ProductData>(
                      pagingController: _paginationController.pagingController,
                      padding: const EdgeInsets.all(16),
                      builderDelegate: PagedChildBuilderDelegate<ProductData>(
                        itemBuilder: (context, item, index) {
                          return buildProductCard(item);
                        },
                        firstPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
                        newPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
                        noItemsFoundIndicatorBuilder: (context) => const Center(
                          child: CompactGifDisplayWidget(
                            gifPath: emptyListGif,
                            title: "It's empty, over here.",
                            subtitle: 'No product Products in your business, yet! Add to view them here.',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );

  }
}