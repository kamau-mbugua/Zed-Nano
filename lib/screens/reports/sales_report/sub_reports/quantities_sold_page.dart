import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/quantities_sold/QuantitiesSoldResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/pdf/pdf_preview_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_extended_fab.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/date_range_filter_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/services/BusinessDetailsContextExtension.dart';
import 'package:zed_nano/services/business_setup_extensions.dart';
import 'package:zed_nano/services/pdfs/QuantitiesSoldReportService.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/date_range_util.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class QuantitiesSoldPage extends StatefulWidget {
  const QuantitiesSoldPage({super.key});

  @override
  State<QuantitiesSoldPage> createState() => _QuantitiesSoldPageState();
}

class _QuantitiesSoldPageState extends State<QuantitiesSoldPage> {
  final bool _isLoading = false;
  String _selectedRangeLabel = 'this_month';
  QuantitiesSoldResponse? _summaryData;
  final List<QuantitiesSoldData> _recentSales = [];

  late PaginationController<QuantitiesSoldData> _paginationController;


  String _searchTerm = '';

  Timer? _debounceTimer;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _paginationController = PaginationController<QuantitiesSoldData>(
      fetchItems: (page, pageSize) async {
        return getTotalQuantitiesSold(page: page, limit: pageSize);
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _paginationController.fetchFirstPage();
    });
  }

  Future<List<QuantitiesSoldData>> getTotalQuantitiesSold({required int page, required int limit}) async {
    final dateRange = DateRangeUtil.getDateRange(_selectedRangeLabel);
    final startDate = dateRange.values.first.removeTimezoneOffset;
    final endDate = dateRange.values.last.removeTimezoneOffset;

    final params = <String, dynamic>{
      'startDate': startDate,
      'endDate': endDate,
      'page': page,
      'limit': limit,
      'searchValue': _searchTerm,
    };

    final response = await getBusinessProvider(context).getTotalQuantitiesSold(
        params: params,
        context: context,
    );
    setState(() {
      _summaryData = response.data;
    });
    return response.data?.data ?? [];
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
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: const AuthAppBar(title: 'Reports'),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            // Fixed header and summary section
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildSummarySection(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Expandable recent sales section
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildRecentSalesSection(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: GeneratePdfFAB(
        onPressed: _showGenerateReport,
      ),
    );
  }


  Future<void> _showGenerateReport() async {
    final dateRange = DateRangeUtil.getDateRange(_selectedRangeLabel);
    final startDate = dateRange.values.first.removeTimezoneOffset;
    final endDate = dateRange.values.last.removeTimezoneOffset;
    await QuantitiesSoldReportService.generateSalesReportPdf(
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
          title: 'Quantities Sold Report - ${startDate.toDateOnly} to ${endDate.toDateOnly}',
          fileName: 'Quantities Sold Report - ${startDate.toDateOnly} to ${endDate.toDateOnly}.pdf',
        ).launch(context);
      }
    });
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quantities Sold',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Detailed report on the quantities sold.',
          style: TextStyle(
            color: textSecondary,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        buildSearchBar(
            controller: _searchController,
            onChanged: _debounceSearch,
            horizontalPadding:5,
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryHeader(),
        const SizedBox(height: 16),
        _buildSummaryCards(),
      ],
    );
  }

  Widget _buildSummaryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Summary',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: _showDateRangeFilter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: textSecondary.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.filter_list,
                  size: 16,
                  color: textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  (_selectedRangeLabel ?? 'Filter').toDisplayLabel,
                  style: const TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.keyboard_arrow_right,
                  size: 16,
                  color: textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Quantity Sold',
                value: _summaryData?.quantitiesSoldTotals?.toStringAsFixed(0) ?? '0',
                icon: approvalStockTake,
                iconColor: emailBlue,
                backgroundColor: lightGreyColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                title: 'Quantity Instock',
                value: '${_summaryData?.quantityInStockTotal ?? 0}',
                icon: outOfStockIcon,
                iconColor: successTextColor,
                backgroundColor: lightGreenColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rfCommonCachedNetworkImage(
              icon,
              width: 25,
              height: 25,
              color: iconColor,radius: 0,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: textSecondary,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSalesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Items',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: PagedListView<int, QuantitiesSoldData>(
            pagingController: _paginationController.pagingController,
            padding: const EdgeInsets.all(0),
            builderDelegate: PagedChildBuilderDelegate<QuantitiesSoldData>(
              itemBuilder: (context, item, index) {
                return _buildRecentSaleItem(item).paddingSymmetric(horizontal: 16,vertical: 8);
              },
              firstPageProgressIndicatorBuilder: (_) => const Center(
                child: SizedBox(),
              ),
              newPageProgressIndicatorBuilder: (_) => const Center(
                child: SizedBox(),
              ),
              noItemsFoundIndicatorBuilder: (context) => const Center(
                child: CompactGifDisplayWidget(
                  gifPath: emptyListGif,
                  title: "It's empty, over here.",
                  subtitle: 'No recent sales in your business, yet! Add to view them here.',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildRecentSaleItem(QuantitiesSoldData sale) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: lightGreyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: rfCommonCachedNetworkImage(
              sale.imageUrl ?? '',
              width: 25,
              height: 25
              ,radius: 0,
          ),
        ),
        const SizedBox(width: 16),
        // Product details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sale.productName ?? 'Unknown Product',
                style: const TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProductDetail('Qty Sold:', sale.quantitySold?.toStringAsFixed(0) ?? '0'),
                  _buildProductDetail('Instock:', 'KES ${sale.inStock ?? 0}'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: textSecondary,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Future<void> _refreshData() async {
    _paginationController.refresh();
  }
}
