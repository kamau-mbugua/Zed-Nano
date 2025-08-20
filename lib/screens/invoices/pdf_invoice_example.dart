// import 'package:flutter/material.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:zed_nano/screens/invoices/pdf_invoice_page.dart';
// import 'package:zed_nano/services/pdf_invoice_service.dart';
// import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
//
// class PdfInvoiceExamplePage extends StatelessWidget {
//   const PdfInvoiceExamplePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: const AuthAppBar(
//         title: 'PDF Invoice Examples',
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Header
//             const Text(
//               'PDF Invoice Generation',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w600,
//                 fontFamily: 'Poppins',
//                 color: Color(0xFF1A1C21),
//               ),
//             ),
//
//             16.height,
//
//             const Text(
//               'Test the PDF invoice generation with sample data. You can view, share, and download the generated PDF.',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//                 fontFamily: 'Poppins',
//                 color: Color(0xFF6B7280),
//               ),
//             ),
//
//             32.height,
//
//             // Sample Invoice Cards
//             _buildInvoiceCard(
//               context,
//               'Unpaid Invoice',
//               'Sample invoice with unpaid status',
//               InvoiceData.sample(),
//               const Color(0xFFDC3545),
//             ),
//
//             16.height,
//
//             _buildInvoiceCard(
//               context,
//               'Paid Invoice',
//               'Sample invoice with paid status',
//               InvoiceData.samplePaid(),
//               const Color(0xFF17AE7B),
//             ),
//
//             16.height,
//
//             _buildInvoiceCard(
//               context,
//               'Partial Payment Invoice',
//               'Sample invoice with partial payment',
//               InvoiceData.samplePartial(),
//               const Color(0xFFFF8503),
//             ),
//
//             const Spacer(),
//
//             // Info Section
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF8F9FA),
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: const Color(0xFFE5E7EB)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Features:',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: 'Poppins',
//                       color: Color(0xFF1A1C21),
//                     ),
//                   ),
//                   8.height,
//                   const Text(
//                     '• Professional PDF generation with proper formatting\n'
//                     '• Business branding with logo placeholder\n'
//                     '• Complete invoice details and itemization\n'
//                     '• Share and download functionality\n'
//                     '• Print-ready format\n'
//                     '• Status-based color coding',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                       fontFamily: 'Poppins',
//                       color: Color(0xFF6B7280),
//                       height: 1.4,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInvoiceCard(
//     BuildContext context,
//     String title,
//     String description,
//     InvoiceData invoiceData,
//     Color statusColor,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: const Color(0xFFE5E7EB)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 4,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   color: statusColor,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               12.width,
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         fontFamily: 'Poppins',
//                         color: Color(0xFF1A1C21),
//                       ),
//                     ),
//                     4.height,
//                     Text(
//                       description,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w400,
//                         fontFamily: 'Poppins',
//                         color: Color(0xFF6B7280),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//
//           16.height,
//
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Invoice: ${invoiceData.invoiceNumber}',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                         fontFamily: 'Poppins',
//                         color: Color(0xFF374151),
//                       ),
//                     ),
//                     4.height,
//                     Text(
//                       'Total: KES ${invoiceData.totalAmount.toStringAsFixed(2)}',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                         fontFamily: 'Poppins',
//                         color: Color(0xFF374151),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(
//                   //     builder: (context) => PdfInvoicePage(
//                   //       invoiceData: invoiceData,
//                   //     ),
//                   //   ),
//                   // );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF144166),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                 ),
//                 child: const Text(
//                   'View PDF',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Sample data methods are now factory constructors in InvoiceData class
