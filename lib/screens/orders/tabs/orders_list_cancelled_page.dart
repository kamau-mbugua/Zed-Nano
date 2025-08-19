import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/fetchByStatus/OrderResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/customers/itemBuilder/list_customers_transactions_item_builder.dart';
import 'package:zed_nano/screens/orders/detail/order_detail_page.dart';
import 'package:zed_nano/screens/widget/common/date_range_filter_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/filter_row_widget.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/date_range_util.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class OrdersListCancelledPage extends StatefulWidget {
  const OrdersListCancelledPage({super.key});

  @override
  _OrdersListCancelledPageState createState() => _OrdersListCancelledPageState();
}

class _OrdersListCancelledPageState extends State<OrdersListCancelledPage> {
  late PaginationController<OrderData> _paginationController;
  final TextEditingController _searchController = TextEditingController();

  String _searchTerm = '';
  final bool _isInitialized = false;
  Timer? _debounceTimer;
  OrderResponse? orderResponse;

  String _selectedRangeLabel = 'this_month';


  @override
  void initState() {
    super.initState();

    // Initialize the controller but don't start fetching yet
    _paginationController = PaginationController<OrderData>(
      fetchItems: (page, pageSize) async {
        return fetchByStatus(page: page, limit: pageSize);
      },
    );

    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _paginationController.fetchFirstPage();
    });
  }

  Future<List<OrderData>> fetchByStatus(
      {required int page, required int limit,}) async {
    final dateRange = DateRangeUtil.getDateRange(_selectedRangeLabel);
    final startDate = dateRange.values.first.removeTimezoneOffset;
    final endDate = dateRange.values.last.removeTimezoneOffset;
    final response = await getBusinessProvider(context).fetchByStatus(
      page: page,
      limit: limit,
      searchValue: _searchTerm,
      context: context,
      customerId: '',
      status: 'cancelled',
      startDate: startDate,
      endDate: endDate,
      cashier: '',
    );
    setState(() {
      orderResponse = response.data;
    });
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

  void _showDateRangeFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DateRangeFilterBottomSheet(
        selectedRangeLabel: _selectedRangeLabel,
        onRangeSelected: (rangeLabel) {
          setState(() {
            _selectedRangeLabel = rangeLabel;
          });
          _paginationController.refresh();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchAndFilter(),
        _buildSummary(),
        _buildList(),
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  Widget _buildSummary() {
    return Row(
      children: [
        Expanded(
          child: Container(
              height: 85,
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Order Count',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.12,

                      ),
                  ),
                  Text('${orderResponse?.count ?? 0}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: highlightMainLight,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                  ),
                ],
              ),
          ),
        ),
        16.width,
        Expanded(
          child: Container(
              height: 85,
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Order Amount',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.12,

                      ),
                  ),
                  Text("${orderResponse?.orderSummary?.currency ?? 'KES'} ${orderResponse?.total?.formatCurrency() ?? 0.0}",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: highlightMainLight,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                  ),
                ],
              ),
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => _paginationController.refresh(),
        child: PagedListView<int, OrderData>(
          pagingController: _paginationController.pagingController,
          builderDelegate: PagedChildBuilderDelegate<OrderData>(
            itemBuilder: (context, item, index) {
              return listCustomersOrdersItemBuilder(item).onTap((){
                OrderDetailPage(orderId: item.id).launch(context).then((value) {
                  _paginationController.refresh();
                });
              });
              },
            firstPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
            newPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
            noItemsFoundIndicatorBuilder: (context) =>  const Center(
              child: CompactGifDisplayWidget(
                gifPath: emptyListGif,
                title: "It's empty, over here.",
                subtitle:
                'No Cancelled orders in your business, yet! Add to view them here.',
              ),
            ),
          ),
        ).paddingSymmetric(vertical: 16),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: buildSearchBar(controller: _searchController, onChanged: _debounceSearch, horizontalPadding:1),
        ),
        6.width,
        buildFilterButton(
          text:(_selectedRangeLabel ?? 'Filter').toDisplayLabel,
          isActive: false,
          onTap: _showDateRangeFilter,
          icon: Icons.filter_list,
        ),
      ],
    );
  }
}
