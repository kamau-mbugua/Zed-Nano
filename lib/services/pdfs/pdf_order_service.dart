import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:zed_nano/models/get_invoice_by_invoice_number/GetInvoiceByInvoiceNumberResponse.dart';
import 'package:zed_nano/models/order_payment_status/OrderDetailResponse.dart';
import 'package:zed_nano/services/BusinessDetailsContextExtension.dart';
import 'package:zed_nano/services/business_setup_extensions.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:http/http.dart' as http;

class PdfOrderService {
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

  static Future<Uint8List> generateOrderPdf(OrderDetail invoiceData, BuildContext buildContext) async {
    final pdf = pw.Document();

    // Load font for better text rendering
    final font = await PdfGoogleFonts.poppinsRegular();
    final fontBold = await PdfGoogleFonts.poppinsBold();
    final fontSemiBold = await PdfGoogleFonts.poppinsSemiBold();

    // Download business logo if available
    Uint8List? logoBytes;
    if (buildContext.businessLogo != null && buildContext.businessLogo!.isNotEmpty) {
      logoBytes = await _downloadNetworkImage(buildContext.businessLogo);
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
                'Order #${invoiceData.orderNumber ?? 'N/A'} - Page ${context.pageNumber}',
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
            _buildHeader(invoiceData, font, fontBold, fontSemiBold, logoBytes, buildContext),

            pw.SizedBox(height: 32),



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
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Billing Section
                  // _buildBillingSection(invoiceData, font, fontBold),

                  // pw.SizedBox(height: 32),

                  // Items Table
                  _buildItemsTable(invoiceData, font, fontBold),

                  pw.SizedBox(height: 32),

                  // Totals Section
                  _buildTotalsSection(invoiceData, font, fontBold),

                  pw.SizedBox(height: 40),
                ]
              ),
            ),

            // Thank You Message
            // _buildThankYouMessage(font, fontSemiBold),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(OrderDetail invoiceData, pw.Font font, pw.Font fontBold, pw.Font fontSemiBold, Uint8List? logoBytes, BuildContext context) {
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
                  color: logoBytes == null ? const PdfColor.fromInt(0xFF144166) : null,
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
                          invoiceData.orderNumber.toString().toUpperCase().substring(0, 3),
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
                context.businessName ?? 'N/A',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFF144166),
                  fontSize: 12,
                  font: fontSemiBold,
                ),
              ),

              pw.SizedBox(height: 8),

              // Business Details
              pw.Text(
                context.businessAddress ?? 'N/A',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFF000000),
                  fontSize: 10,
                  font: font,
                ),
              ),

              pw.SizedBox(height: 4),

              pw.Text(
                context.businessPhone  ?? 'N/A',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFF000000),
                  fontSize: 10,
                  font: font,
                ),
              ),

              pw.SizedBox(height: 4),

              pw.Text(
                context.businessEmail ?? 'N/A',
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
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: pw.BoxDecoration(
                  color: _getStatusColor(invoiceData.status ?? 'N/A'),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Text(
                  invoiceData.status ?? 'N/A',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 12,
                    font: fontSemiBold,
                  ),
                ),
              ),

              pw.SizedBox(height: 12),

              // Invoice Title
              pw.Text(
                'Order',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFF333333),
                  fontSize: 28,
                  font: fontSemiBold,
                ),
              ),

              pw.SizedBox(height: 1),

              // Invoice Number
              pw.Text(
                "#${invoiceData.orderNumber ?? 'N/A'}",
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFF000000),
                  fontSize: 12,
                  font: fontSemiBold,
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                  // _buildInvoiceDetail('Purchase order', invoiceData.purchaseOrder, font, fontSemiBold),
                  _buildInvoiceDetail('Cashier', invoiceData.cashier ?? 'N/A', font, fontSemiBold),
                  _buildInvoiceDetail('Order date', invoiceData.createdAt?.toFormattedDateTime() ?? 'N/A' , font, fontSemiBold),
                ]
              )
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildInvoiceDetail(String label, String value, pw.Font font, pw.Font fontSemiBold) {
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

  static pw.Widget _buildBillingSection(InvoiceDetail invoiceData, pw.Font font, pw.Font fontSemiBold) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        // Billed To
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Billed to',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFF000000),
                  fontSize: 10,
                  font: font,
                ),
              ),

              pw.SizedBox(height: 12),

              pw.Text(
                invoiceData.customerName ?? 'N/A',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFF1A1C21),
                  fontSize: 10,
                  font: fontSemiBold,
                ),
              ),

              pw.SizedBox(height: 8),

              pw.Text(
                '${invoiceData.businessLocation}\n${invoiceData.customerPhoneNumber}\n${invoiceData.sentTo}',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFF000000),
                  fontSize: 10,
                  font: font,
                  lineSpacing: 1.4,
                ),
              ),
            ],
          ),
        ),

        // Amount Due
        pw.Expanded(
          flex: 1,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Amount Due',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFF000000),
                  fontSize: 10,
                  font: font,
                ),
              ),

              pw.SizedBox(height: 8),

              pw.Text(
                'KES ${invoiceData.invoiceAmount?.formatCurrency() ?? 'N/A'}',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xFFDC3545),
                  fontSize: 18,
                  font: fontSemiBold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildItemsTable(OrderDetail invoiceData, pw.Font font, pw.Font fontSemiBold) {
    return pw.Column(
      children: [
        // Table Header
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: const pw.BoxDecoration(
            color: PdfColor.fromInt(0xFFF8F9FA),
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColor.fromInt(0xFFE5E7EB), width: 0.5),
            ),
          ),
          child: pw.Row(
            children: [
              pw.SizedBox(width: 20, child: pw.Text('#', style: pw.TextStyle(color: const PdfColor.fromInt(0xFF000000), fontSize: 10, font: fontSemiBold))),
              pw.Expanded(flex: 3, child: pw.Text('Item Name', style: pw.TextStyle(color: const PdfColor.fromInt(0xFF000000), fontSize: 10, font: fontSemiBold))),
              pw.SizedBox(width: 40, child: pw.Text('Qty', style: pw.TextStyle(color: const PdfColor.fromInt(0xFF000000), fontSize: 10, font: fontSemiBold), textAlign: pw.TextAlign.center)),
              pw.SizedBox(width: 80, child: pw.Text('Unit Price', style: pw.TextStyle(color: const PdfColor.fromInt(0xFF000000), fontSize: 10, font: fontSemiBold))),
              pw.SizedBox(width: 80, child: pw.Text('Discount', style: pw.TextStyle(color: const PdfColor.fromInt(0xFF000000), fontSize: 10, font: fontSemiBold))),
              pw.SizedBox(width: 100, child: pw.Text('Total', style: pw.TextStyle(color: const PdfColor.fromInt(0xFF000000), fontSize: 10, font: fontSemiBold), textAlign: pw.TextAlign.right)),
            ],
          ),
        ),

        // Table Items
        ...?invoiceData.items?.asMap().entries.map((entry) {
          int index = entry.key;
          OrderItem item = entry.value;
          return _buildItemRow(index + 1, item, font);
        }).toList(),
      ],
    );
  }

  static pw.Widget _buildItemRow(int index, OrderItem item, pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColor.fromInt(0xFFE5E7EB), width: 0.5),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 20,
            child: pw.Text(
              index.toString(),
              style: pw.TextStyle(
                color: const PdfColor.fromInt(0xFF333333),
                fontSize: 10,
                font: font,
              ),
            ),
          ),

          pw.Expanded(
            flex: 3,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  item.itemName ?? 'N/A',
                  style: pw.TextStyle(
                    color: const PdfColor.fromInt(0xFF333333),
                    fontSize: 10,
                    font: font,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  item.itemCategory ?? 'N/A',
                  style: pw.TextStyle(
                    color: const PdfColor.fromInt(0xFF000000),
                    fontSize: 10,
                    font: font,
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(
            width: 40,
            child: pw.Text(
              item.itemCount.toString(),
              style: pw.TextStyle(
                color: const PdfColor.fromInt(0xFF333333),
                fontSize: 10,
                font: font,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),

          pw.SizedBox(
            width: 80,
            child: pw.Text(
              item.itemAmount?.formatCurrency() ?? 'N/A',
              style: pw.TextStyle(
                color: const PdfColor.fromInt(0xFF333333),
                fontSize: 10,
                font: font,
              ),
            ),
          ),

          pw.SizedBox(
            width: 80,
            child: pw.Text(
              item.discount?.formatCurrency() ?? 'N/A',
              style: pw.TextStyle(
                color: const PdfColor.fromInt(0xFF333333),
                fontSize: 10,
                font: font,
              ),
            ),
          ),

          pw.SizedBox(
            width: 100,
            child: pw.Text(
              'KES ${(item.totalAmount?.toDouble() ?? 0).formatCurrency()}',
              style: pw.TextStyle(
                color: const PdfColor.fromInt(0xFF333333),
                fontSize: 10,
                font: font,
              ),
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTotalsSection(OrderDetail invoiceData, pw.Font font, pw.Font fontSemiBold) {
    return pw.Row(
      children: [
        pw.Spacer(),
        pw.SizedBox(
          width: 240,
          child: pw.Column(
            children: [
              _buildTotalRow('Subtotal', invoiceData.transamount ?? 0, false, font, fontSemiBold),
              pw.SizedBox(height: 8),
              _buildTotalRow('Discount', invoiceData.discountAmount ?? 0, false, font, fontSemiBold),
              pw.SizedBox(height: 8),
              pw.Container(
                height: 0.5,
                color: const PdfColor.fromInt(0xFFE5E7EB),
              ),
              pw.SizedBox(height: 8),
              _buildTotalRow('Total', invoiceData.transamount ?? 0, true, font, fontSemiBold),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTotalRow(String label, double amount, bool isTotal, pw.Font font, pw.Font fontSemiBold) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            color: const PdfColor.fromInt(0xFF1A1C21),
            fontSize: 10,
            font: isTotal ? fontSemiBold : font,
          ),
        ),
        pw.Text(
          'KES ${amount.formatCurrency()}',
          style: pw.TextStyle(
            color: const PdfColor.fromInt(0xFF1A1C21),
            fontSize: 10,
            font: isTotal ? fontSemiBold : font,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildThankYouMessage(pw.Font font, pw.Font fontSemiBold) {
    return pw.Text(
      'Thanks for the business.',
      style: pw.TextStyle(
        color: const PdfColor.fromInt(0xFF1A1C21),
        fontSize: 10,
        font: fontSemiBold,
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

  static PdfColor _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return const PdfColor.fromInt(0xFF17AE7B);
      case 'partial':
        return const PdfColor.fromInt(0xFFFF8503);
      case 'unpaid':
        return const PdfColor.fromInt(0xFFDC3545);
      default:
        return const PdfColor.fromInt(0xFF000000);
    }
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
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfBytes);
  }
}
