import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/sales_report/SalesReportResponse.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/invoices/pdf_invoice_page.dart';
import 'package:zed_nano/screens/reports/sales_report/sub_reports/gross_margin_page.dart';
import 'package:zed_nano/screens/reports/sales_report/sub_reports/quantities_sold_page.dart';
import 'package:zed_nano/screens/reports/sales_report/sub_reports/total_cost_of_goods_page.dart';
import 'package:zed_nano/screens/reports/sales_report/sub_reports/total_sales_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_extended_fab.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/date_range_filter_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/services/BusinessDetailsContextExtension.dart';
import 'package:zed_nano/services/business_setup_extensions.dart';
import 'package:zed_nano/services/pdfs/PdfSalesReportService.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/date_range_util.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({super.key});

  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  bool _isLoading = false;
  String _selectedRangeLabel = 'this_month';
  SalesReportSummaryData? _summaryData;
  final List<SalesReportTotalSalesData> _recentSales = [];

  late PaginationController<SalesReportTotalSalesData> _paginationController;


  String _searchTerm = '';

  Timer? _debounceTimer;

  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _paginationController = PaginationController<SalesReportTotalSalesData>(
      fetchItems: (page, pageSize) async {
        return getTotalSales(page: page, limit: pageSize);
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _paginationController.fetchFirstPage();
    });
    _loadSalesData();
  }

  Future<List<SalesReportTotalSalesData>> getTotalSales({required int page, required int limit}) async {
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

    final response = await getBusinessProvider(context).getTotalSales(
        params:params,
        context: context,
    );
    return response.data?.data ?? [];
  }
  Future<void> _loadSalesData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dateRange = DateRangeUtil.getDateRange(_selectedRangeLabel);
      final startDate = dateRange.values.first.removeTimezoneOffset;
      final endDate = dateRange.values.last.removeTimezoneOffset;

      final summaryResponse = await Provider.of<BusinessProviders>(context, listen: false)
          .getSalesSummary(startDate: startDate, endDate: endDate, context: context);

      if (summaryResponse.isSuccess && summaryResponse.data?.data != null) {
        _summaryData = summaryResponse.data!.data;
      }
    } catch (e) {
      showCustomToast('Error loading sales data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
          _loadSalesData();
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
    super.dispose();
  }

  Future<void> _showGenerateReport() async {
    final dateRange = DateRangeUtil.getDateRange(_selectedRangeLabel);
    final startDate = dateRange.values.first.removeTimezoneOffset;
    final endDate = dateRange.values.last.removeTimezoneOffset;
    await PdfSalesReportService.generateSalesReportPdf(
      context,
      businessAddress: context.businessAddress,
      businessEmail: context.businessEmail,
      businessLogo: context.businessLogo,
      businessName: context.businessName,
      businessPhone: context.businessPhone,
      endDate: startDate,
      startDate: endDate,
      summaryData: _summaryData,
    ).then((value) async {
      if (value != null) {
        PdfPage(
        pdfBytes: value,
        title: 'Sales Report - ${startDate.toDateOnly} to ${endDate.toDateOnly}',
        fileName: 'Sales Report - ${startDate.toDateOnly} to ${endDate.toDateOnly}.pdf',
        ).launch(context);
      }
    });
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sales Report',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'An overview of sales performance.',
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
                title: 'Quantities\nSold',
                value: _summaryData?.soldQuantity?.toStringAsFixed(0) ?? '0',
                icon: approvalStockTake,
                iconColor: emailBlue,
                backgroundColor: lightGreyColor,
              ).onTap(
                  ()=> const QuantitiesSoldPage().launch(context),
              ) ,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                title: 'Total\nSales',
                value: 'KES ${_summaryData?.totalSales?.formatCurrency() ?? 0}',
                icon: outOfStockIcon,
                iconColor: successTextColor,
                backgroundColor: lightGreenColor,
              ).onTap(
                  () => const TotalSalesPage().launch(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Total Cost of\nGoods Sold',
                value: "${_summaryData?.currency ?? context.businessCurrency} ${_summaryData?.totalCostOfGoodsSold?.toStringAsFixed(0) ?? '0'}",
                icon: moneyInIcon,
                iconColor: primaryOrangeTextColor,
                backgroundColor: lightOrange,
              ).onTap(
                      ()=> const TotalCostOfGoodsPage().launch(context),
              ) ,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                title: 'Gross\nMargin',
                value: 'KES ${_summaryData?.grossMargin?.formatCurrency() ?? 0}',
                icon: approvalCustomers,
                iconColor: primaryBlueTextColor,
                backgroundColor: lightBlueColor,
              ).onTap(
                      () => const GrossMarginPage().launch(context),
              ),
            ),
          ],
        ),
        // Row(
        //   children: [
        //     Expanded(
        //       child: _buildSummaryCard(
        //         title: 'Total Cost of\nGoods Sold',
        //         value: 'KES ${(_summaryData?.totalCostOfGoodsSold?.formatCurrency() ?? 0)}',
        //         icon: moneyInIcon,
        //         iconColor: primaryOrangeTextColor,
        //         backgroundColor: lightOrange,
        //       ),
        //     ).onTap(()=>TotalCostOfGoodsPage().launch(context)),
        //     const SizedBox(width: 16),
        //     Expanded(
        //       child: _buildSummaryCard(
        //         title: 'Gross\nMargin',
        //         value: 'KES ${(_summaryData?.grossMargin?.formatCurrency() ?? 0)}',
        //         icon: approvalCustomers,
        //         iconColor: primaryBlueTextColor,
        //         backgroundColor: lightBlueColor,
        //       ).onTap(()=>GrossMarginPage().launch(context)),
        //     ),
        //   ],
        // ),
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
          'Recent Sales',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(0),
            child: _buildRecentSalesList(),
          ),
        ),
      ],
    );
  }
  Widget _buildRecentSalesList() {
    return PagedListView<int, SalesReportTotalSalesData>(
      pagingController: _paginationController.pagingController,
      padding: const EdgeInsets.all(0),
      builderDelegate: PagedChildBuilderDelegate<SalesReportTotalSalesData>(
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
    );
  }
  Widget _buildRecentSaleItem(SalesReportTotalSalesData sale) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
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
        const SizedBox(width: 10),
        // Product details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Text(
                    'KES ${sale.totalSales?.formatCurrency() ?? 0}',
                    style: const TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProductDetail('Qty:', sale.quantitySold?.toStringAsFixed(0) ?? '0'),
                  _buildProductDetail('Selling Price:', 'KES ${sale.sellingPrice?.formatCurrency() ?? 0}'),
                  _buildProductDetail('Discount:', 'KES ${sale.discount?.formatCurrency() ?? 0}'),
                ],
              ),
            ],
          ),
        ),
        // Total amount

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
    await _loadSalesData();
    _paginationController.refresh();
  }
}
