import 'package:flutter/material.dart';
import '../models/report_model.dart';

/// A card widget that displays a report summary
class ReportCardWidget extends StatelessWidget {
  /// The report to display
  final ReportModel report;
  
  /// Callback when the card is tapped
  final VoidCallback? onTap;
  
  /// Creates a new report card widget
  const ReportCardWidget({
    Key? key,
    required this.report,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      report.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildReportTypeChip(context),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                report.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Generated: ${_formatDate(report.generatedDate)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a chip displaying the report type
  Widget _buildReportTypeChip(BuildContext context) {
    Color chipColor;
    
    switch (report.type) {
      case ReportType.sales:
        chipColor = Colors.blue;
        break;
      case ReportType.inventory:
        chipColor = Colors.green;
        break;
      case ReportType.customers:
        chipColor = Colors.orange;
        break;
      case ReportType.financial:
        chipColor = Colors.purple;
        break;
    }
    
    return Chip(
      label: Text(
        _capitalizeFirstLetter(report.type.toString().split('.').last),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
  
  /// Formats a date as a string
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  /// Capitalizes the first letter of a string
  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}