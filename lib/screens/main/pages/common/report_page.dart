import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/screens/reports/all_transactions/all_t_ranasctions_page.dart';
import 'package:zed_nano/screens/reports/opening_closing_report/opening_closing_report_page.dart';
import 'package:zed_nano/screens/reports/sales_by_day/sales_report_by_day_page.dart';
import 'package:zed_nano/screens/reports/sales_report/sales_report_page.dart';
import 'package:zed_nano/screens/reports/void_transaactions/voided_transactions_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';

class ReportPage extends StatefulWidget {
  ReportPage({super.key, this.isShowAppBar = false});
  bool isShowAppBar;

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  // Define report types with their properties
  final List<ReportType> reportTypes = const [
    ReportType(
      icon: salesReportIcon,
      iconColor: successTextColor,
      title: 'Sales Report',
      description: 'Comprehensive overview of sales performance, products sold and margins.',
    ),
    ReportType(
      icon: calenderIcon,
      iconColor: primaryBlueTextColor,
      title: 'Sales Report By Day',
      description: 'Daily breakdown of sales performance and transactions.',
    ),
    ReportType(
      icon: productIcon,
      iconColor: highlightMainDark,
      title: 'Opening and Closing Stock Report',
      description: 'View stock report showing opening balance, sales and closing variance.',
    ),
    ReportType(
      icon: customerTransactionsIcon,
      iconColor: successTextColor,
      title: 'All Transactions Report',
      description: 'Complete payment history with payment methods, customers and amount.',
    ),
    ReportType(
      icon: salesReportIcon,
      iconColor: googleRed,
      title: 'Void Transactions Report',
      description: 'Track cancelled transactions with reasons and authorization.',
    ),
  ];
  @override
  void initState() {
    final viewModel = Provider.of<WorkflowViewModel>(context, listen: false);
    if (viewModel.businessInfoData == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.fetchBusinessProfile(context);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: !widget.isShowAppBar ? null : const AuthAppBar(title: 'Reports'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Add refresh logic here if needed
            await Future.delayed(const Duration(seconds: 1));
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
                const SizedBox(height: 32),
                _buildReportsList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reports',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 28,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'View and generate reports for your business.',
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

  Widget _buildReportsList(BuildContext context) {
    return Column(
      children: reportTypes
          .map((reportType) => _buildReportCard(reportType, context))
          .toList(),
    );
  }

  Widget _buildReportCard(ReportType reportType, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Handle report navigation here
          _handleReportTap(reportType, context);
        },
        borderRadius: BorderRadius.circular(12),
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
          child: Row(
            children: [
              // Icon container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: reportType.iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: rfCommonCachedNetworkImage(
                    reportType.icon,
                    height: 24,
                    width: 24,
                    color: reportType.iconColor,
                    fit: BoxFit.contain,
                    radius: 0,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reportType.title,
                      style: const TextStyle(
                        color: textPrimary,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reportType.description,
                      style: const TextStyle(
                        color: textSecondary,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Arrow icon
              const Icon(
                Icons.chevron_right,
                color: textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleReportTap(ReportType reportType, BuildContext context) {
    switch (reportType.title) {
      case 'Sales Report':
        const SalesReportPage().launch(context);
      case 'Sales Report By Day':
        const SalesReportByDayPage().launch(context);
      case 'Opening and Closing Stock Report':
        const OpeningClosingReportPage().launch(context);
      case 'All Transactions Report':
        const AllTRanasctionsPage().launch(context);
      case 'Void Transactions Report':
        const VoidedTransactionsPage().launch(context);
    }
  }
}

// Data model for report types
class ReportType {

  const ReportType({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });
  final String icon;
  final Color iconColor;
  final String title;
  final String description;
}
