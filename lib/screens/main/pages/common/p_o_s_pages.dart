import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/sales_dashboard/SalesDashboardResponse.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/screens/invoices/invoices_list_main_page.dart';
import 'package:zed_nano/screens/orders/orders_list_main_page.dart';
import 'package:zed_nano/screens/reports/sales_report/sub_reports/quantities_sold_page.dart';
import 'package:zed_nano/screens/reports/sales_report/sub_reports/total_sales_page.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/date_range_filter_bottom_sheet.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/date_range_util.dart';
import 'package:zed_nano/utils/extensions.dart';

class POSPagesScreen extends StatefulWidget {
  const POSPagesScreen({super.key});

  @override
  State<POSPagesScreen> createState() => _POSPagesScreenState();
}

class _POSPagesScreenState extends State<POSPagesScreen> {
  SalesDashboardData? _dashboardData;
  bool _isLoading = true;
  // Default selected range label
  String _selectedRangeLabel = 'this_month';
  late Map<String, String> _dateRange;
  final _dateRangeOptions = [
    'today',
    'this_week',
    'this_month',
    'this_year',
  ];

  final Map<String, String> _dateRangeLabels = {
    'today': 'Today',
    'this_week': 'This Week',
    'this_month': 'This Month',
    'this_year': 'This Year',
  };
  late ScrollController _chartScrollController;

  var defaultYear;

  @override
  void initState() {
    super.initState();
    _chartScrollController = ScrollController();
    defaultYear = DateTime.now().year;
    _dateRange = DateRangeUtil.getDateRange(_selectedRangeLabel);
    _loadDashboardData();
  }

  @override
  void dispose() {
    _chartScrollController.dispose();
    super.dispose();
  }

  Future<void> branchStoreSummary() async {
    final requestData = <String, dynamic>{
      'startDate': _dateRange.values.first.removeTimezoneOffset,
      'endDate': _dateRange.values.last.removeTimezoneOffset,
      'year':defaultYear,
    };

    await context
        .read<BusinessProviders>()
        .getbusinessMetrics(context: context, requestData:requestData)
        .then((value) async {
      if (value.isSuccess) {
        if (mounted) {
          setState(() {
            _dashboardData = value.data?.data;
          });
        }
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  void _loadDashboardData() {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    branchStoreSummary().then((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  SalesDashboardData _getMockData() {
    return SalesDashboardData(
      keyMetrics: KeyMetrics(
        totalSales: 20000,
        totalTransactions: 127,
        quantitiesSold: 50,
      ),
      orderSummary: OrderSummary(
        unpaid: SummaryItem(total: 5000, transactions: 5),
        paid: SummaryItem(total: 5000, transactions: 8),
        partial: SummaryItem(total: 1000, transactions: 2),
      ),
      invoiceSummary: InvoiceSummary(
        unpaid: SummaryItem(total: 0, transactions: 0),
        paid: SummaryItem(total: 10000, transactions: 10),
        partial: SummaryItem(total: 4000, transactions: 1),
      ),
      salesTrend: SalesTrend(
        jan: MonthData(totalSales: 90000, totalTransactions: 20),
        feb: MonthData(totalSales: 1000, totalTransactions: 20),
        mar: MonthData(totalSales: 35000, totalTransactions: 20),
        apr: MonthData(totalSales: 15000, totalTransactions: 20),
        may: MonthData(totalSales: 15000, totalTransactions: 20),
        jun: MonthData(totalSales: 18000, totalTransactions: 25),
        jul: MonthData(totalSales: 12000, totalTransactions: 15),
        aug: MonthData(totalSales: 20000, totalTransactions: 30),
        sep: MonthData(totalSales: 0, totalTransactions: 0),
        oct: MonthData(totalSales: 0, totalTransactions: 0),
        nov: MonthData(totalSales: 0, totalTransactions: 0),
        dec: MonthData(totalSales: 0, totalTransactions: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: SizedBox())
            : RefreshIndicator(
                onRefresh: () async {
                  await branchStoreSummary();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 16 + kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildKeyMetrics(),
                      const SizedBox(height: 32),
                      _buildSalesTrend(),
                      const SizedBox(height: 32),
                      _buildOrdersSummary(),
                      const SizedBox(height: 32),
                      _buildInvoicesSummary(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales',
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                fontSize: 28,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Overview of your current sales.',
              style: TextStyle(
                color: textSecondary,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                fontSize: 12,
              ),
            ),
          ],
        ),
        _buildPeriodFilter(),
      ],
    );
  }

  Widget _buildPeriodFilter() {
    return GestureDetector(
      onTap: _showPeriodSelector,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
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
              _dateRangeLabels[_selectedRangeLabel] ?? '',
              style: const TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showPeriodSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DateRangeFilterBottomSheet(
        selectedRangeLabel: _selectedRangeLabel,
        onRangeSelected: (option) {
          setState(() {
            _selectedRangeLabel = option;
            _dateRange = DateRangeUtil.getDateRange(option);
          });
          // Reload data with new date range
          _loadDashboardData();
        },
      ),
    );
  }

  Widget _buildKeyMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Metrics',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: sellQuicker,
                iconColor: successTextColor,
                title: 'Total Sales',
                value:
                    'KES ${_formatNumber(_dashboardData?.keyMetrics?.totalSales ?? 0)}',
                subtitle:
                    '${_dashboardData?.keyMetrics?.totalTransactions ?? 0} Transactions',
              ).onTap(()=> const TotalSalesPage().launch(context)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                icon: batchIcon,
                iconColor: primaryBlueTextColor,
                title: 'Quantities Sold',
                value:
                    _formatNumber(_dashboardData?.keyMetrics?.quantitiesSold ?? 0),
                subtitle: 'Today',
              ).onTap(()=> const QuantitiesSoldPage().launch(context)),
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

  Widget _buildSalesTrend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sales Trend',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(6),
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
          child: _buildChart(),
        ),
      ],
    );
  }

  Widget _buildChart() {
    final salesTrend = _dashboardData?.salesTrend;
    if (salesTrend == null) return buildEmptyCard('Nothing here. For Now!', 'Recent sales will be displayed here.');

    final monthsData = salesTrend.getMonthsData();
    final monthLabels = salesTrend.getMonthLabels();

    // Display all 12 months
    final currentMonth = DateTime.now().month;
    final maxSales = monthsData
        .map((e) => e.totalSales ?? 0)
        .reduce((a, b) => a > b ? a : b);
    const chartHeight = 120.0;
    const barWidth = 40.0;
    const barSpacing = 16.0;

    // Auto-scroll to current month after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chartScrollController.hasClients) {
        final currentMonthIndex = currentMonth - 1;
        final scrollPosition = currentMonthIndex * (barWidth + barSpacing) - 
                              (MediaQuery.of(context).size.width / 2) + (barWidth / 2);
        _chartScrollController.animateTo(
          scrollPosition.clamp(0.0, _chartScrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    return SizedBox(
      height: chartHeight + 60,
      child: SingleChildScrollView(
        controller: _chartScrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(12, (index) {
            final data = monthsData[index];
            final sales = data.totalSales ?? 0;
            final barHeight = maxSales > 0 ? (sales / maxSales) * chartHeight : 0.0;
            final isHighest = sales == maxSales && sales > 0;
            final isCurrentMonth = index == (currentMonth - 1);
            final isFutureMonth = index > (currentMonth - 1);

            // Determine bar color based on month type
            Color barColor;
            if (isCurrentMonth) {
              barColor = const Color(0xFF17AE7B); // Current month - green
            } else if (isFutureMonth) {
              barColor = const Color(0xFFE8E9F1); // Future months - light gray
            } else {
              barColor = const Color(0xFF032541); // Past months - dark blue
            }

            return Container(
              margin: EdgeInsets.only(right: index < 11 ? barSpacing : 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if ((isHighest && sales > 0) || (isCurrentMonth && sales > 0)) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: lightGreyColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _formatNumber(sales),
                        style: const TextStyle(
                          color: highlightMainDark,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ] else
                    SizedBox(height: chartHeight - barHeight + 20),
                  Container(
                    width: barWidth,
                    height: barHeight.clamp(7.0, chartHeight),
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    monthLabels[index],
                    style: TextStyle(
                      color: isCurrentMonth ? const Color(0xFF17AE7B) : textPrimary,
                      fontWeight: isCurrentMonth ? FontWeight.w600 : FontWeight.w400,
                      fontFamily: 'Poppins',
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildOrdersSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Orders Summary',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                count:
                    '${_dashboardData?.orderSummary?.unpaid?.transactions ?? 0}',
                status: 'Unpaid',
                amount:
                    'KES ${_formatNumber(_dashboardData?.orderSummary?.unpaid?.total ?? 0)}',
                statusColor: googleRed,
                onTap: () {
                  OrdersListMainPage(
                    
                  ).launch(context);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSummaryCard(
                count:
                    '${_dashboardData?.orderSummary?.partial?.transactions ?? 0}',
                status: 'Partially Paid',
                amount:
                    'KES ${_formatNumber(_dashboardData?.orderSummary?.partial?.total ?? 0)}',
                statusColor: primaryOrangeTextColor,
                onTap: () {
                  OrdersListMainPage(
                    initialTabIndex: 1, // Partially Paid tab
                  ).launch(context);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSummaryCard(
                count:
                    '${_dashboardData?.orderSummary?.paid?.transactions ?? 0}',
                status: 'Paid',
                amount:
                    'KES ${_formatNumber(_dashboardData?.orderSummary?.paid?.total ?? 0)}',
                statusColor: successTextColor,
                onTap: () {
                  OrdersListMainPage(
                    initialTabIndex: 2, // Paid tab
                  ).launch(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInvoicesSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Invoices Summary',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                count:
                    '${_dashboardData?.invoiceSummary?.unpaid?.transactions ?? 0}',
                status: 'Unpaid',
                amount:
                    'KES ${_formatNumber(_dashboardData?.invoiceSummary?.unpaid?.total ?? 0)}',
                statusColor: googleRed,
                onTap: () {
                  InvoicesListMainPage(
                    
                  ).launch(context);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSummaryCard(
                count:
                    '${_dashboardData?.invoiceSummary?.partial?.transactions ?? 0}',
                status: 'Partially Paid',
                amount:
                    'KES ${_formatNumber(_dashboardData?.invoiceSummary?.partial?.total ?? 0)}',
                statusColor: primaryOrangeTextColor,
                onTap: () {
                  InvoicesListMainPage(
                    initialTabIndex: 1, // Partially Paid tab
                  ).launch(context);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSummaryCard(
                count:
                    '${_dashboardData?.invoiceSummary?.paid?.transactions ?? 0}',
                status: 'Paid',
                amount:
                    'KES ${_formatNumber(_dashboardData?.invoiceSummary?.paid?.total ?? 0)}',
                statusColor: successTextColor,
                onTap: () {
                  InvoicesListMainPage(
                    initialTabIndex: 2, // Paid tab
                  ).launch(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String count,
    required String status,
    required String amount,
    required Color statusColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Text(
              count,
              style: const TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: const TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }
}
