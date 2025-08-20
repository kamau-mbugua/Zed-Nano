import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/services/pdfs/pdf_invoice_service.dart';

class PdfPage extends StatefulWidget {
  final Uint8List pdfBytes;
  final String title;
  final String? fileName;

  const PdfPage({
    Key? key,
    required this.pdfBytes,
    required this.title,
    this.fileName,
  }) : super(key: key);

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  late Uint8List _pdfBytes;

  @override
  void initState() {
    super.initState();
    _pdfBytes = widget.pdfBytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(
        title: widget.title,
      ),
      body: Column(
        children: [
          // PDF Preview without custom actions
          Expanded(
            child: PdfPreview(
              build: (format) => _pdfBytes,
              allowPrinting: false,
              allowSharing: false,
              canChangePageFormat: false,
              canDebug: false,
              useActions: false, // This completely disables the bottom bar
              maxPageWidth: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Platform.isAndroid
        ? SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF144166),
                border: Border(
                  top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: _buildActionButton(
                      icon: Icons.print,
                      label: 'Print',
                      onPressed: _printPdf,
                    ),
                  ),
                  Flexible(
                    child: _buildActionButton(
                      icon: Icons.share,
                      label: 'Share',
                      onPressed: _sharePdf,
                    ),
                  ),
                  Flexible(
                    child: _buildActionButton(
                      icon: Icons.download,
                      label: 'Download',
                      onPressed: _downloadPdf,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            decoration: const BoxDecoration(
              color: Color(0xFF144166),
              border: Border(
                top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: _buildActionButton(
                    icon: Icons.print,
                    label: 'Print',
                    onPressed: _printPdf,
                  ),
                ),
                Flexible(
                  child: _buildActionButton(
                    icon: Icons.share,
                    label: 'Share',
                    onPressed: _sharePdf,
                  ),
                ),
                Flexible(
                  child: _buildActionButton(
                    icon: Icons.download,
                    label: 'Download',
                    onPressed: _downloadPdf,
                  ),
                ),
              ],
            ),
          );
  }

  Future<void> _sharePdf() async {
    try {
      await PdfInvoiceService.sharePdf(
        _pdfBytes,
        widget.fileName ?? 'document.pdf',
      );
    } catch (e) {
      if (mounted) {
        showCustomToast('Error sharing PDF: $e');
      }
    }
  }

  Future<void> _downloadPdf() async {
    try {
      final fileName = widget.fileName ?? 'document.pdf';
      final file = await PdfInvoiceService.savePdfToFile(_pdfBytes, fileName);
      
      if (mounted) {
        showCustomToast('PDF downloaded successfully: ${file.path}', isError: false);
      }
    } catch (e) {
      if (mounted) {
        showCustomToast('Error downloading PDF: $e');
      }
    }
  }

  Future<void> _printPdf() async {
    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => _pdfBytes,
      );
    } catch (e) {
      if (mounted) {
        showCustomToast('Error printing PDF: $e');
      }
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data models are now imported from PdfInvoiceService
