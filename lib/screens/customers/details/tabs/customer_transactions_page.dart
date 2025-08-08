import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/customerTransactions/CustomerTransactionsResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/customers/itemBuilder/list_customers_transactions_item_builder.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class CustomerTransactionsPage extends StatefulWidget {

  CustomerTransactionsPage({required this.customerID, super.key});
  String customerID;

  @override
  _CustomerTransactionsPageState createState() =>
      _CustomerTransactionsPageState();
}

class _CustomerTransactionsPageState extends State<CustomerTransactionsPage> {
  late PaginationController<CustomerTransaction> _paginationController;
  final TextEditingController _searchController = TextEditingController();

  String _searchTerm = '';
  final bool _isInitialized = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    // Initialize the controller but don't start fetching yet
    _paginationController = PaginationController<CustomerTransaction>(
      fetchItems: (page, pageSize) async {
        return getCustomerTransactions(page: page, limit: pageSize);
      },
    );

    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _paginationController.fetchFirstPage();
    });
  }

  Future<List<CustomerTransaction>> getCustomerTransactions(
      {required int page, required int limit,}) async {
    final response = await getBusinessProvider(context).getCustomerTransactions(
        page: page,
        limit: limit,
        searchValue: _searchTerm,
        context: context,
        customerId: widget.customerID,);
    return response.data?.transaction ?? [];
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
  void dispose() {
    _paginationController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Transactions',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xff000000),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),),
            Text('View All',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: accentRed,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),),
          ],
        ),
        Expanded(
          child: PagedListView<int, CustomerTransaction>(
            pagingController: _paginationController.pagingController,
            builderDelegate: PagedChildBuilderDelegate<CustomerTransaction>(
              itemBuilder: (context, item, index) {
                return listCustomersTransactionsItemBuilder(item);
              },
              firstPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
              newPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
              noItemsFoundIndicatorBuilder: (context) => const Center(
                child: CompactGifDisplayWidget(
                  gifPath: emptyListGif,
                  title: "It's empty, over here.",
                  subtitle:
                      'No Customers in your business, yet! Add to view them here.',
                ),
              ),
            ),
          ).paddingSymmetric(vertical: 16),
        ),
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}
