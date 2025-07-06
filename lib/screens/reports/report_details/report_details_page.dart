// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/report_model.dart';
// import '../providers/reports_provider.dart';
//
// /// Page that displays the details of a report
// class ReportDetailsPage extends StatelessWidget {
//   /// Creates a new report details page
//   const ReportDetailsPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ReportsProvider>(
//       builder: (context, provider, child) {
//         final report = provider.selectedReport;
//
//         if (report == null) {
//           return const Scaffold(
//             body: Center(
//               child: Text('Report not found'),
//             ),
//           );
//         }
//
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Report Details'),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.delete),
//                 onPressed: () => _confirmDelete(context, report),
//               ),
//             ],
//           ),
//           body: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildReportHeader(context, report),
//                 const SizedBox(height: 24),
//                 _buildReportInfo(context, report),
//                 const SizedBox(height: 24),
//                 _buildActionButtons(context, report),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   /// Builds the report header section
//   Widget _buildReportHeader(BuildContext context, ReportModel report) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           report.title,
//           style: Theme.of(context).textTheme.headlineMedium,
//         ),
//         const SizedBox(height: 8),
//         Row(
//           children: [
//             _buildReportTypeChip(context, report.type),
//             const SizedBox(width: 8),
//             Text(
//               'Generated: ${_formatDate(report.generatedDate)}',
//               style: Theme.of(context).textTheme.bodySmall,
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         Text(
//           report.description,
//           style: Theme.of(context).textTheme.bodyLarge,
//         ),
//       ],
//     );
//   }
//
//   /// Builds the report information section
//   Widget _buildReportInfo(BuildContext context, ReportModel report) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Report Information',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 16),
//             _buildInfoRow(context, 'ID', report.id),
//             const Divider(),
//             _buildInfoRow(context, 'Type', _formatReportType(report.type)),
//             const Divider(),
//             _buildInfoRow(context, 'Date', _formatDate(report.generatedDate)),
//             const Divider(),
//             _buildInfoRow(context, 'File Path', report.filePath),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Builds a row in the report information section
//   Widget _buildInfoRow(BuildContext context, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               label,
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Builds the action buttons section
//   Widget _buildActionButtons(BuildContext context, ReportModel report) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ElevatedButton.icon(
//           onPressed: () {
//             // Implement download functionality
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Downloading report...'),
//               ),
//             );
//           },
//           icon: const Icon(Icons.download),
//           label: const Text('Download'),
//         ),
//         ElevatedButton.icon(
//           onPressed: () {
//             // Implement share functionality
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Sharing report...'),
//               ),
//             );
//           },
//           icon: const Icon(Icons.share),
//           label: const Text('Share'),
//         ),
//       ],
//     );
//   }
//
//   /// Builds a chip displaying the report type
//   Widget _buildReportTypeChip(BuildContext context, ReportType type) {
//     Color chipColor;
//
//     switch (type) {
//       case ReportType.sales:
//         chipColor = Colors.blue;
//         break;
//       case ReportType.inventory:
//         chipColor = Colors.green;
//         break;
//       case ReportType.customers:
//         chipColor = Colors.orange;
//         break;
//       case ReportType.financial:
//         chipColor = Colors.purple;
//         break;
//     }
//
//     return Chip(
//       label: Text(
//         _formatReportType(type),
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 12,
//         ),
//       ),
//       backgroundColor: chipColor,
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//     );
//   }
//
//   /// Formats a report type as a string
//   String _formatReportType(ReportType type) {
//     final typeString = type.toString().split('.').last;
//     return typeString[0].toUpperCase() + typeString.substring(1);
//   }
//
//   /// Formats a date as a string
//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
//
//   /// Shows a confirmation dialog for deleting a report
//   void _confirmDelete(BuildContext context, ReportModel report) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Report'),
//         content: Text('Are you sure you want to delete "${report.title}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Close dialog
//               _deleteReport(context, report.id);
//             },
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Deletes a report and navigates back
//   void _deleteReport(BuildContext context, String reportId) {
//     final provider = context.read<ReportsProvider>();
//     provider.deleteReport(reportId).then((_) {
//       Navigator.pop(context); // Go back to reports list
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Report deleted successfully'),
//         ),
//       );
//     });
//   }
// }