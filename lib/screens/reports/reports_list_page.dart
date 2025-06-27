import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/report_model.dart';
import 'providers/reports_provider.dart';
import 'widgets/report_card_widget.dart';
import 'report_details/report_details_page.dart';
import 'generate_report/generate_report_page.dart';

/// Page that displays a list of reports
class ReportsListPage extends StatefulWidget {
  /// Creates a new reports list page
  const ReportsListPage({Key? key}) : super(key: key);

  @override
  State<ReportsListPage> createState() => _ReportsListPageState();
}

class _ReportsListPageState extends State<ReportsListPage> {
  @override
  void initState() {
    super.initState();
    // Fetch reports when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportsProvider>().fetchReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ReportsProvider>().fetchReports();
            },
          ),
        ],
      ),
      body: Consumer<ReportsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.reports.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.reports.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchReports(),
            child: ListView.builder(
              itemCount: provider.reports.length,
              itemBuilder: (context, index) {
                final report = provider.reports[index];
                return ReportCardWidget(
                  report: report,
                  onTap: () => _navigateToReportDetails(report.id),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToGenerateReport,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Builds the empty state widget when no reports are available
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.description_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No Reports Available',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first report by tapping the + button',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _navigateToGenerateReport,
            child: const Text('Generate Report'),
          ),
        ],
      ),
    );
  }

  /// Navigates to the report details page
  void _navigateToReportDetails(String reportId) {
    context.read<ReportsProvider>().selectReport(reportId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReportDetailsPage(),
      ),
    );
  }

  /// Navigates to the generate report page
  void _navigateToGenerateReport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GenerateReportPage(),
      ),
    );
  }
}