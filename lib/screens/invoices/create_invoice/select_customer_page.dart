import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/customers_list/CustomerListResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/pagination_controller.dart';
import 'package:zed_nano/viewmodels/CustomerInvoicingViewModel.dart';

class SelectCustomerPage extends StatefulWidget {
  const SelectCustomerPage({required this.onNext, required this.onPrevious, super.key});
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  State<SelectCustomerPage> createState() => _SelectCustomerPageState();
}

class _SelectCustomerPageState extends State<SelectCustomerPage> {
  List<Customer> categories = [];
  bool isLoading = true;
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  late PaginationController<Customer> _paginationController;
  String _searchTerm = '';
  bool _isInitialized = false;
  Timer? _debounceTimer;
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();

    _paginationController = PaginationController<Customer>(
      fetchItems: (page, pageSize) async {
        return getListCustomers(page: page, limit: pageSize);
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

  @override
  void dispose() {
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

  Future<List<Customer>> getListCustomers({required int page, required int limit}) async {
    final response = await getBusinessProvider(context).getListCustomers(
      page: page,
      limit: limit,
      searchValue: _searchTerm,
      context: context,
      status: 'Active',
      paymentType: '',
      customerType: '',
    );
    return response.data?.data ?? [];
  }


  @override
  Widget build(BuildContext context) {
    final customerInvoicingViewModel = Provider.of<CustomerInvoicingViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(title: 'Create Invoice', onBackPressed: widget.onPrevious),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          headings(
            label: 'Select Customer',
            subLabel: 'Choose who you are invoicing.',
          ).paddingSymmetric(horizontal: 16),
          buildSearchBar(
            controller: searchController,
            onChanged: _debounceSearch,
          ).paddingSymmetric(horizontal: 16),

          // Categories list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _paginationController.refresh();
              },
              child: PagedListView<int, Customer>(
                pagingController: _paginationController.pagingController,
                padding: const EdgeInsets.all(16),
                builderDelegate: PagedChildBuilderDelegate<Customer>(
                  itemBuilder: (context, item, index) {
                    return _buildCategoryItem(item);
                  },
                  firstPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
                  newPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
                  noItemsFoundIndicatorBuilder: (context) => const Center(
                    child: CompactGifDisplayWidget(
                      gifPath: emptyListGif,
                      title: "It's empty, over here.",
                      subtitle: 'No product categories in your business, yet! Add to view them here.',
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Select button at bottom
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedCategoryId != null) {
                    // Find the selected category from pagination controller
                    final selectedCategory = _paginationController.pagingController.itemList?.firstWhere(
                          (category) => category.id == selectedCategoryId,
                    );
              
                    if (selectedCategory != null) {
                      customerInvoicingViewModel.setCustomerData(selectedCategory);
                      widget.onNext();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBlueColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Select',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(Customer category) {
    // Track if this category is selected
    final isSelected = selectedCategoryId == category.id;

    return InkWell(
      onTap: () {
        setState(() {
          selectedCategoryId = category.id;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF2F4F5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? highlightMainDark : innactiveBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Text(
              category.customerName ?? '',
              style: const TextStyle(
                color: darkGreyColor, // #1f2024
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
            const Spacer(),
            // Checkbox
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: isSelected ? darkBlueColor : Colors.white, // #032541 when selected
                border: Border.all(
                  color: isSelected ? darkBlueColor : innactiveBorder, // #c5c6cc when unselected
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? const Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
