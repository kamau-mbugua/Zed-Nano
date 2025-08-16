import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:printing/printing.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/services/pdf_invoice_service.dart';
import 'package:zed_nano/models/get_invoice_by_invoice_number/GetInvoiceByInvoiceNumberResponse.dart';


class PdfInvoicePage extends StatefulWidget {
  final InvoiceDetail? invoiceData;

  const PdfInvoicePage({
    Key? key,
    required this.invoiceData,
  }) : super(key: key);

  @override
  State<PdfInvoicePage> createState() => _PdfInvoicePageState();
}

class _PdfInvoicePageState extends State<PdfInvoicePage> {
  bool _isGeneratingPdf = false;
  Uint8List? _pdfBytes;

  @override
  void initState() {
    super.initState();
    _generatePdf();
  }

  Future<void> _generatePdf() async {
    setState(() {
      _isGeneratingPdf = true;
    });

    try {
      final pdfBytes = await PdfInvoiceService.generateInvoicePdf(widget.invoiceData!);
      setState(() {
        _pdfBytes = pdfBytes;
        _isGeneratingPdf = false;
      });
    } catch (e) {
      setState(() {
        _isGeneratingPdf = false;
      });
      if (mounted) {
        showCustomToast('Error generating PDF: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(
        title: 'Invoice ${widget.invoiceData?.invoiceNumber}',
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareInvoice(),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _downloadPdf(),
          ),
        ],
      ),
      body: _isGeneratingPdf
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Generating PDF...',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            )
          : _pdfBytes != null
              ? PdfPreview(
                  build: (format) => _pdfBytes!,
                  allowPrinting: true,
                  allowSharing: true,
                  canChangePageFormat: false,
                  canDebug: false,
                  maxPageWidth: MediaQuery.of(context).size.width,
                )
              : const Center(
                  child: Text(
                    'Failed to generate PDF',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: Color(0xFFDC3545),
                    ),
                  ),
                ),
    );
  }

  Future<void> _shareInvoice() async {
    if (_pdfBytes != null) {
      try {
        await PdfInvoiceService.sharePdf(
          _pdfBytes!,
          'Invoice_${widget.invoiceData?.invoiceNumber}.pdf',
        );
      } catch (e) {
        if (mounted) {
          showCustomToast('Error sharing PDF: $e');
        }
      }
    }
  }

  Future<void> _downloadPdf() async {
    if (_pdfBytes != null) {
      try {
        final fileName = 'Invoice_${widget.invoiceData?.invoiceNumber}.pdf';
        final file = await PdfInvoiceService.savePdfToFile(_pdfBytes!, fileName);
        
        if (mounted) {
          showCustomToast('PDF downloaded successfully: ${file.path}', isError: false);
        }
      } catch (e) {
        if (mounted) {
          showCustomToast('Error downloading PDF: $e');
        }
      }
    }
  }
}

// Data models are now imported from PdfInvoiceService
