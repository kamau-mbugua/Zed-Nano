import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/viewAllTransactions/TransactionListResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/pdf/pdf_preview_page.dart';
import 'package:zed_nano/screens/reports/itemBuilders/all_transactions_item_builder.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_extended_fab.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/date_range_filter_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/filter_row_widget.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/services/BusinessDetailsContextExtension.dart';
import 'package:zed_nano/services/business_setup_extensions.dart';
import 'package:zed_nano/services/pdfs/AllTransactionsReportService.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/date_range_util.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class AllTRanasctionsPage extends StatefulWidget {
  const AllTRanasctionsPage({super.key});

  @override
  _AllTRanasctionsPageState createState() => _AllTRanasctionsPageState();
}

class _AllTRanasctionsPageState extends State<AllTRanasctionsPage> {
  late PaginationController<ViewTransactionData> _paginationController;
  final TextEditingController _searchController = TextEditingController();

  String _searchTerm = '';
  final bool _isInitialized = false;
  Timer? _debounceTimer;
  TransactionListResponse? transactionListResponse;

  String _selectedRangeLabel = 'this_month';


  @override
  void initState() {
    super.initState();

    // Initialize the controller but don't start fetching yet
    _paginationController = PaginationController<ViewTransactionData>(
      fetchItems: (page, pageSize) async {
        return viewAllTransactions(page: page, limit: pageSize);
      },
    );

    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _paginationController.fetchFirstPage();
    });
  }

  Future<List<ViewTransactionData>> viewAllTransactions(
      {required int page, required int limit,}) async {
    final dateRange = DateRangeUtil.getDateRange(_selectedRangeLabel);
    final startDate = dateRange.values.first.removeTimezoneOffset;
    final endDate = dateRange.values.last.removeTimezoneOffset;

    final params = <String, dynamic>{
      'startDate': startDate,
      'endDate': endDate,
      'page': page,
      'limit': limit,
      'search': _searchTerm,
    };

    final response = await getBusinessProvider(context).viewAllTransactions(
      params: params,
      context: context,
    );
    setState(() {
      transactionListResponse = response.data;
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
  void dispose() {
    _paginationController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: const AuthAppBar(title: 'All Transactions'),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          const SizedBox(height: 16),
          _buildSummary(),
          const SizedBox(height: 16),
          _buildList(),
        ],
      ).paddingAll(16),
      floatingActionButton: GeneratePdfFAB(
        onPressed: _showGenerateReport,
      ),
    );
  }

  Future<void> _showGenerateReport() async {
    final dateRange = DateRangeUtil.getDateRange(_selectedRangeLabel);
    final startDate = dateRange.values.first.removeTimezoneOffset;
    final endDate = dateRange.values.last.removeTimezoneOffset;
    await AllTransactionsReportService.generateSalesReportPdf(
      context,
      businessAddress: context.businessAddress,
      businessEmail: context.businessEmail,
      businessLogo: context.businessLogo,
      businessName: context.businessName,
      businessPhone: context.businessPhone,
      endDate: startDate,
      startDate: endDate,
    ).then((value) async {
      if (value != null) {
        showCustomToast('Report generated successfully, Opening PDF...', isError: false);        PdfPage(
          pdfBytes: value,
          title: 'All Transactions Report - ${startDate.toDateOnly} to ${endDate.toDateOnly}',
          fileName: 'All Transactions Report - ${startDate.toDateOnly} to ${endDate.toDateOnly}.pdf',
        ).launch(context);
      }
    });
  }


  Widget _buildSummary() {

    return     Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Summary',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xff000000),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,


            ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: customerTransactionsIcon,
                iconColor: primaryBlueTextColor,
                title: 'Quantity Sold',
                value:
                'KES ${transactionListResponse?.total?.formatCurrency() ?? 0}',
                subtitle: '',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                icon: customerTransactionsIcon,
                iconColor: successTextColor,
                title: 'Total Sales',
                value:
                '${transactionListResponse?.count ?? 0} Transactions',
                subtitle: '',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rfCommonCachedNetworkImage(icon,
              height: 24,
              width: 24,
              color: iconColor,
              fit: BoxFit.contain,
              radius: 0,),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: textSecondary,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: textSecondary,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => _paginationController.refresh(),
        child: PagedListView<int, ViewTransactionData>(
          pagingController: _paginationController.pagingController,
          builderDelegate: PagedChildBuilderDelegate<ViewTransactionData>(
            itemBuilder: (context, item, index) {
              return allTransactionsItemBuilder(item, context).paddingSymmetric(vertical: 3, horizontal: 3);
            },
            firstPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
            newPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(),
            noItemsFoundIndicatorBuilder: (context) =>  const Center(
              child: CompactGifDisplayWidget(
                gifPath: emptyListGif,
                title: "It's empty, over here.",
                subtitle:
                'No Transactions in your business, yet! Add to view them here.',
              ),
            ),
          ),
        ).paddingSymmetric(vertical: 16),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headings(
          label: 'All Transactions Report',
          subLabel: 'A complete payment history in your business.',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: buildSearchBar(
                  controller: _searchController,
                  onChanged: _debounceSearch,
                  horizontalPadding:5,
              ),
            ),
            buildFilterButton(
              text:(_selectedRangeLabel ?? 'Filter').toDisplayLabel,
              isActive: false,
              onTap: _showDateRangeFilter,
              icon: Icons.filter_list,
            ),
          ],
        ),
      ],
    );
  }
}
