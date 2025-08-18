import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:zed_nano/models/get_invoice_by_invoice_number/GetInvoiceByInvoiceNumberResponse.dart';
import 'package:zed_nano/models/get_total_sales/GetTotalSalesResponse.dart';
import 'package:zed_nano/models/sales_report/SalesReportResponse.dart';
import 'package:zed_nano/models/viewAllTransactions/TransactionListResponse.dart';
import 'package:zed_nano/models/void-approved/VoidApprovedResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:http/http.dart' as http;

class VoidedTransactionsReportService {
  /// Fetches ALL sales data for PDF generation (handles pagination internally)
  static Future<List<VoidApprovedTransaction>> fetchAllSalesDataForPdf(
    BuildContext context, {
    required String startDate,
    required String endDate,
    String searchValue = '',
  }) async {
    List<VoidApprovedTransaction> allSalesData = [];
    int currentPage = 1;
    const int pageSize = 100; // Use larger page size for efficiency
    bool hasMoreData = true;

    try {
      while (hasMoreData) {
        final params = <String, dynamic>{
          'startDate': endDate,
          'endDate': startDate,
          'page': currentPage,
          'limit': pageSize,
          'search': searchValue,
        };

        final response = await getBusinessProvider(context).getVoidedTRansactionReports(
          params: params,
          context: context,
        );

        if (response.isSuccess && response.data?.transactions != null) {
          final pageData = response.data!.transactions!;
          allSalesData.addAll(pageData);

          // Check if we have more data to fetch
          // If the returned data is less than pageSize, we've reached the end
          hasMoreData = pageData.length == pageSize;
          currentPage++;

          // Safety check to prevent infinite loops (max 50 pages = 5000 items)
          if (currentPage > 50) {
            print('Warning: Reached maximum page limit for PDF generation');
            break;
          }
        } else {
          hasMoreData = false;
        }
      }
    } catch (e) {
      print('Error fetching sales data for PDF: $e');
      // Return whatever data we managed to fetch
    }

    return allSalesData;
  }

  /// Generates a complete sales report PDF with summary data
  static Future<Uint8List> generateSalesReportPdf(
    BuildContext context, {
    required String businessName,
    required String businessAddress,
    required String businessPhone,
    required String businessEmail,
    required String businessLogo,
    required String startDate,
    required String endDate,
    String searchValue = '',
  }) async {
    // Fetch all sales data for the PDF
    final allSalesData = await fetchAllSalesDataForPdf(
      context,
      startDate: startDate,
      endDate: endDate,
      searchValue: searchValue,
    );

    // Generate PDF with complete data
    return generatePdfSalesReportPDF(
      businessName,
      businessAddress,
      businessPhone,
      businessEmail,
      businessLogo,
      startDate,
      endDate,
      allSalesData,
    );
  }

  // Helper method to download network image for PDF
  static Future<Uint8List?> _downloadNetworkImage(String? url) async {
    if (url == null || url.isEmpty || !url.startsWith('http')) {
      return null;
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
    return null;
  }


  static Future<Uint8List> generatePdfSalesReportPDF(
      String businessName,
      String businessAddress,
      String businessPhone,
      String businessEmail,
      String businessLogo,
      String startDate,
      String endDate,
      List<VoidApprovedTransaction> salesReportTotalSalesData,) async {
    final pdf = pw.Document();


    // Load font for better text rendering
    final font = await PdfGoogleFonts.poppinsRegular();
    final fontBold = await PdfGoogleFonts.poppinsBold();
    final fontSemiBold = await PdfGoogleFonts.poppinsSemiBold();

    // Download business logo if available
    Uint8List? logoBytes;
    if (businessLogo != null && businessLogo!.isNotEmpty) {
      logoBytes = await _downloadNetworkImage(businessLogo);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        header: (pw.Context context) {
          if (context.pageNumber > 1) {
            return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 20),
              child: pw.Text(
                'Page ${context.pageNumber}',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFF000000),
                  fontSize: 10,
                  font: font,
                ),
              ),
            );
          }
          return pw.Container();
        },
        footer: (pw.Context context) {
          return _buildFooter(font, context);
        },
        build: (pw.Context context) {
          return [
            // Header Section (only on first page)
            _buildHeader(
              businessName,
              businessAddress,
              businessPhone,
              businessEmail,
              businessLogo,
              startDate,
              endDate,
              font,
              fontBold,
              fontSemiBold,
              logoBytes,
            ),
            pw.SizedBox(height: 24),

            // Summary Section
            // _buildSummarySection(summaryData!, font, fontBold, fontSemiBold),


            // Items Table
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(12),
                border: pw.Border.all(
                  color: const PdfColor.fromInt(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              child: _buildItemsTable(salesReportTotalSalesData, font, fontBold),
            ),

            pw.SizedBox(height: 32),

          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildSummarySection(
    SalesReportSummaryData summaryData,
    pw.Font font,
    pw.Font fontBold,
    pw.Font fontSemiBold,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Summary',
          style: pw.TextStyle(
            color: const PdfColor.fromInt(0xFF1A1C21),
            fontSize: 16,
            font: fontBold,
          ),
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          children: [
            pw.Expanded(
              child: _buildSummaryCard(
                'Quantities Sold',
                summaryData.soldQuantity?.toStringAsFixed(0) ?? '0',
                font,
                fontSemiBold,
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              child: _buildSummaryCard(
                'Total Sales',
                'KES ${summaryData.totalSales?.formatCurrency() ?? '0'}',
                font,
                fontSemiBold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 12),
        pw.Row(
          children: [
            pw.Expanded(
              child: _buildSummaryCard(
                'Cost of Goods Sold',
                '${summaryData.currency ?? 'KES'} ${summaryData.totalCostOfGoodsSold?.formatCurrency() ?? '0'}',
                font,
                fontSemiBold,
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              child: _buildSummaryCard(
                'Gross Margin',
                'KES ${summaryData.grossMargin?.formatCurrency() ?? '0'}',
                font,
                fontSemiBold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildSummaryCard(
    String title,
    String value,
    pw.Font font,
    pw.Font fontSemiBold,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xFFF8F9FA),
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(
          color: const PdfColor.fromInt(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              color: const PdfColor.fromInt(0xFF6B7280),
              fontSize: 10,
              font: font,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            value,
            style: pw.TextStyle(
              color: const PdfColor.fromInt(0xFF1A1C21),
              fontSize: 14,
              font: fontSemiBold,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildHeader(
    String businessName,
    String businessAddress,
    String businessPhone,
    String businessEmail,
    String businessLogo,
    String startDate,
    String endDate,
    pw.Font font,
    pw.Font fontBold,
    pw.Font fontSemiBold,
    Uint8List? logoBytes,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        // Business Info
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Business Logo
              pw.Container(
                width: 102,
                height: 50,
                decoration: pw.BoxDecoration(
                  color: logoBytes == null
                      ? const PdfColor.fromInt(0xFF144166)
                      : null,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: logoBytes != null
                    ? pw.ClipRRect(
                  horizontalRadius: 8,
                  verticalRadius: 8,
                  child: pw.Image(
                    pw.MemoryImage(logoBytes),
                    width: 180,
                    height: 100,
                    fit: pw.BoxFit.fill,
                  ),
                )
                    : pw.Center(
                        child: pw.Text(
                          businessName.substring(0, 1).toUpperCase(),
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 16,
                            font: fontBold,
                          ),
                        ),
                      ),
              ),

              pw.SizedBox(height: 16),

              // Business Name
              pw.Text(
                businessName ?? 'N/A',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFF144166),
                  fontSize: 12,
                  font: fontSemiBold,
                ),
              ),

              pw.SizedBox(height: 8),

              // Business Details
              pw.Text(
                businessAddress ?? 'N/A',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFF000000),
                  fontSize: 10,
                  font: font,
                ),
              ),

              pw.SizedBox(height: 4),

              pw.Text(
                businessPhone ?? 'N/A',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFF000000),
                  fontSize: 10,
                  font: font,
                ),
              ),

              pw.SizedBox(height: 4),

              pw.Text(
                businessEmail ?? 'N/A',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFF000000),
                  fontSize: 10,
                  font: font,
                ),
              ),
            ],
          ),
        ),

        // Invoice Info
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              // Status Badge
              // pw.Container(
              //   padding:
              //       const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              //   decoration: pw.BoxDecoration(
              //     color: PdfColor.fromInt(0xFF000000),
              //     borderRadius: pw.BorderRadius.circular(4),
              //   ),
              //   child: pw.Text(
              //     'Sales Report',
              //     style: pw.TextStyle(
              //       color: PdfColors.white,
              //       fontSize: 12,
              //       font: fontSemiBold,
              //     ),
              //   ),
              // ),
              //
              // pw.SizedBox(height: 12),

              // Invoice Title
              pw.Text(
                'Transactions',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFF333333),
                  fontSize: 28,
                  font: fontSemiBold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Voided Transactions',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFF333333),
                  fontSize: 18,
                  font: fontSemiBold,
                ),
              ),

              pw.SizedBox(height: 1),

              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    // _buildInvoiceDetail('Purchase order', invoiceData.purchaseOrder, font, fontSemiBold),
                    _buildInvoiceDetail(
                        'Start Date',
                        startDate,
                        font,
                        fontSemiBold),
                    _buildInvoiceDetail(
                        'End Date',
                        endDate,
                        font,
                        fontSemiBold),
                  ])
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildInvoiceDetail(
      String label, String value, pw.Font font, pw.Font fontSemiBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            color: const PdfColor.fromInt(0xFF000000),
            fontSize: 10,
            font: font,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            color: const PdfColor.fromInt(0xFF1A1C21),
            fontSize: 10,
            font: fontSemiBold,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildItemsTable(
      List<VoidApprovedTransaction> salesReportTotalSalesData, pw.Font font, pw.Font fontSemiBold) {
    return pw.Column(
      children: [
        // Table Header

        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: const pw.BoxDecoration(
            color: PdfColor.fromInt(0xFFE7F1FF),
            borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total Transactions: ${salesReportTotalSalesData.length}',
                  style: pw.TextStyle(
                    font: fontSemiBold,
                    color: const PdfColor.fromInt(0xFF1A1C21),
                    fontSize: 10,
                  )
              ),

              pw.Text('Total Amount: KES ${salesReportTotalSalesData.isEmpty ? "0.00" : salesReportTotalSalesData.where((e) => e.transamount != null).map((e) => e.transamount!).fold(0.0, (a, b) => a + b).toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    font: fontSemiBold,
                    color: const PdfColor.fromInt(0xFF1A1C21),
                    fontSize: 10,
                  )
              ),


            ]
          )
        ),

        pw.SizedBox(height: 12),

        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: const pw.BoxDecoration(
            color: PdfColor.fromInt(0xFFF8F9FA),
            // border: pw.Border(
            //   bottom:
            //       pw.BorderSide(color: PdfColor.fromInt(0xFFE5E7EB), width: 0.5),
            // ),
            borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
          ),
          child: pw.Row(
            children: [
              pw.SizedBox(
                  width: 20,
                  child: pw.Text('#',
                      style: pw.TextStyle(
                          color: const PdfColor.fromInt(0xFF000000),
                          fontSize: 10,
                          font: fontSemiBold))),
              pw.Expanded(
                  flex: 1,
                  child: pw.Text('Transaction ID',
                      style: pw.TextStyle(
                          color: const PdfColor.fromInt(0xFF000000),
                          fontSize: 10,
                          font: fontSemiBold))),
              pw.Expanded(
                  flex: 1,
                  child: pw.Text('Date Voided',
                      style: pw.TextStyle(
                          color: const PdfColor.fromInt(0xFF000000),
                          fontSize: 10,
                          font: fontSemiBold),
                      textAlign: pw.TextAlign.center)),
              pw.SizedBox(
                  width: 80,
                  child: pw.Text('Pay Mode',
                      style: pw.TextStyle(
                          color: const PdfColor.fromInt(0xFF000000),
                          fontSize: 10,
                          font: fontSemiBold))),
              pw.SizedBox(
                  width: 80,
                  child: pw.Text('Amount',
                      textAlign: pw.TextAlign.end,
                      style: pw.TextStyle(
                          color: const PdfColor.fromInt(0xFF000000),
                          fontSize: 10,
                          font: fontSemiBold))),
            ],
          ),
        ),

        // Table Items
        if (salesReportTotalSalesData.isNotEmpty)
          ...salesReportTotalSalesData.asMap().entries.map((entry) {
            int index = entry.key;
            VoidApprovedTransaction item = entry.value;
            return _buildItemRow(index + 1, item, font);
          }).toList()
        else
          pw.Container(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Center(
              child: pw.Text(
                'No sales data available for the selected period.',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFF6B7280),
                  fontSize: 12,
                  font: font,
                ),
              ),
            ),
          ),
      ],
    );
  }

  static pw.Widget _buildItemRow(
      int index, VoidApprovedTransaction item, pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom:
              pw.BorderSide(color: PdfColor.fromInt(0xFFE5E7EB), width: 0.5),
        ),
      ),
      child: pw.Row(
        children: [
          pw.SizedBox(
              width: 20,
              child: pw.Text(index.toString(),
                  style: pw.TextStyle(
                      color: const PdfColor.fromInt(0xFF333333),
                      fontSize: 10,
                      font: font))),
          pw.Expanded(
              flex: 1,
              child: pw.Text(item.transactionID ?? 'N/A',
                  style: pw.TextStyle(
                      color: const PdfColor.fromInt(0xFF333333),
                      fontSize: 10,
                      font: font))),
          pw.Expanded(
              flex: 1,
              child: pw.Text(item.dateVoided?.toFormattedDateTime() ?? 'N/A',
                  style: pw.TextStyle(
                      color: const PdfColor.fromInt(0xFF333333),
                      fontSize: 10,
                      font: font),
                  textAlign: pw.TextAlign.center)),
          pw.SizedBox(
              width: 80,
              child: pw.Text(item.transactionType?.toString() ?? 'N/A',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      color: const PdfColor.fromInt(0xFF333333),
                      fontSize: 10,
                      font: font))),
          pw.SizedBox(
              width: 80,
              child: pw.Text(item.transamount?.formatCurrency() ?? 'N/A',
                  textAlign: pw.TextAlign.end,
                  style: pw.TextStyle(
                      color: const PdfColor.fromInt(0xFF333333),
                      fontSize: 10,
                      font: font))),
        ],
      ),
    );
  }


  static pw.Widget _buildFooter(pw.Font font, pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'This system generated invoice is created without any alteration whatsoever.',
          style: pw.TextStyle(
            color: const PdfColor.fromInt(0xFF000000),
            fontSize: 10,
            font: font,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Container(
          height: 0.5,
          color: const PdfColor.fromInt(0xFFE5E7EB),
        ),
        pw.SizedBox(height: 12),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Powered by ZED Payments Ltd       .      info@zed.business',
              style: pw.TextStyle(
                color: const PdfColor.fromInt(0xFF9CA3AF),
                fontSize: 10,
                font: font,
              ),
            ),
            pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.TextStyle(
                color: const PdfColor.fromInt(0xFF9CA3AF),
                fontSize: 10,
                font: font,
              ),
            ),
          ],
        ),
      ],
    );
  }


  static Future<File> savePdfToFile(Uint8List pdfBytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(pdfBytes);
    return file;
  }

  static Future<void> sharePdf(Uint8List pdfBytes, String fileName) async {
    await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
  }

  static Future<void> printPdf(Uint8List pdfBytes) async {
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes);
  }
}
