import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/get_business_invoices_by_status/GetBusinessInvoicesByStatusResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/invoices/itemBuilders/invoices_item_builders.dart';
import 'package:zed_nano/screens/widget/common/date_range_filter_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/filter_row_widget.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/date_range_util.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class InvoicesListPaidPage extends StatefulWidget {
  const InvoicesListPaidPage({super.key});

  @override
  _InvoicesListPaidPageState createState() => _InvoicesListPaidPageState();
}

class _InvoicesListPaidPageState extends State<InvoicesListPaidPage> {
  late PaginationController<BusinessInvoice> _paginationController;
  final TextEditingController _searchController = TextEditingController();

  String _searchTerm = '';
  final bool _isInitialized = false;
  Timer? _debounceTimer;
  GetBusinessInvoicesByStatusResponse? getBusinessInvoicesByStatusResponse;

  String _selectedRangeLabel = 'this_month';

  @override
  void initState() {
    super.initState();

    // Initialize the controller but don't start fetching yet
    _paginationController = PaginationController<BusinessInvoice>(
      fetchItems: (page, pageSize) async {
        return fetchByStatus(page: page, limit: pageSize);
      },
    );

    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _paginationController.fetchFirstPage();
    });
  }

  Future<List<BusinessInvoice>> fetchByStatus(
      {required int page, required int limit,}) async {
    final dateRange = DateRangeUtil.getDateRange(_selectedRangeLabel);
    final startDate = dateRange.values.first.removeTimezoneOffset;
    final endDate = dateRange.values.last.removeTimezoneOffset;
    final response = await getBusinessProvider(context).getBusinessInvoicesByStatus(
      page: page,
      limit: limit,
      searchValue: _searchTerm,
      context: context,
      customerId: '',
      status: 'Paid',
      startDate: startDate,
      endDate: endDate,
      cashier: '',
    );
    setState(() {
      getBusinessInvoicesByStatusResponse = response.data;
    });
    return response.data?.data ?? [];
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
                color: lightGreenColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Invoices Count',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.12,

                      ),
                  ),
                  Text('${getBusinessInvoicesByStatusResponse?.invoiceSummary?.orderCount ?? 0}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: successTextColor,
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
                color: lightGreenColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Total',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.12,

                      ),
                  ),
                  Text("${getBusinessInvoicesByStatusResponse?.invoiceSummary?.currency ?? 'KES'} ${getBusinessInvoicesByStatusResponse?.invoiceSummary?.orderTotal ?? 0.0}",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: successTextColor,
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
      child: PagedListView<int, BusinessInvoice>(
        pagingController: _paginationController.pagingController,
        builderDelegate: PagedChildBuilderDelegate<BusinessInvoice>(
          itemBuilder: (context, item, index) {
            return listInvoicesItemBuilder(item);
          },
          firstPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
          newPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
          noItemsFoundIndicatorBuilder: (context) =>  const Center(
            child: CompactGifDisplayWidget(
              gifPath: emptyListGif,
              title: "It's empty, over here.",
              subtitle:
              'No Unpaid orders in your business, yet! Add to view them here.',
            ),
          ),
        ),
      ).paddingSymmetric(vertical: 16),
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
          onTap: _showDateRangeFilter,          icon: Icons.filter_list,
        ),
      ],
    );
  }
}
