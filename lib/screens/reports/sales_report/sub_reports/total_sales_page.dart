import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/contants/AppConstants.dart';
import 'package:zed_nano/models/get_total_sales/GetTotalSalesResponse.dart';
import 'package:zed_nano/models/quantities_sold/QuantitiesSoldResponse.dart';
import 'package:zed_nano/models/sales_report/SalesReportResponse.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/date_range_filter_bottom_sheet.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/date_range_util.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/utils/pagination_controller.dart';

class TotalSalesPage extends StatefulWidget {
  const TotalSalesPage({Key? key}) : super(key: key);

  @override
  State<TotalSalesPage> createState() => _TotalSalesPageState();
}

class _TotalSalesPageState extends State<TotalSalesPage> {
  bool _isLoading = false;
  String _selectedRangeLabel = 'this_month';
  GetTotalSalesResponse? _summaryData;
  List<GetTotalSalesData> _recentSales = [];

  late PaginationController<GetTotalSalesData> _paginationController;


  @override
  void initState() {
    super.initState();
    _paginationController = PaginationController<GetTotalSalesData>(
      fetchItems: (page, pageSize) async {
        return getTotalSalesReport(page: page, limit: pageSize);
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _paginationController.fetchFirstPage();
    });
  }

  Future<List<GetTotalSalesData>> getTotalSalesReport({required int page, required int limit}) async {
    final dateRange = DateRangeUtil.getDateRange(_selectedRangeLabel);
    final startDate = dateRange.values.first.removeTimezoneOffset;
    final endDate = dateRange.values.last.removeTimezoneOffset;
    final response = await getBusinessProvider(context).getTotalSalesReport(
        page: page,
        limit: limit,
        startDate: startDate,
        endDate: endDate,
        context: context
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

  @override
  void dispose() {
    _paginationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AuthAppBar(title: 'Reports'),
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
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Sales',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 28,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Detailed report on the total sales.',
          style: TextStyle(
            color: textSecondary,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
            fontSize: 12,
          ),
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
                Icon(
                  Icons.filter_list,
                  size: 16,
                  color: textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  (_selectedRangeLabel ?? 'Filter').toDisplayLabel,
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
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
                title: 'Total Sales',
                value: '${(_summaryData?.totalSales?.formatCurrency() ?? 0)}',
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
              color: iconColor,radius: 0
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
          child: PagedListView<int, GetTotalSalesData>(
            pagingController: _paginationController.pagingController,
            padding: const EdgeInsets.all(0),
            builderDelegate: PagedChildBuilderDelegate<GetTotalSalesData>(
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
                  subtitle: "No recent sales in your business, yet! Add to view them here.",
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildRecentSaleItem(GetTotalSalesData sale) {
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
              ,radius: 0
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
                  _buildProductDetail('Qty:', sale.quantitySold?.toStringAsFixed(0) ?? '0'),
                  const SizedBox(width: 24),
                  _buildProductDetail('Selling Price:', 'KES ${(sale.sellingPrice?.formatCurrency() ?? 0)}'),
                  const SizedBox(width: 24),
                  _buildProductDetail('Discount:', 'KES ${(sale.discount?.formatCurrency() ?? 0)}'),
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
