import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zed_nano/models/get_invoice_by_invoice_number/GetInvoiceByInvoiceNumberResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/invoices/pdf_invoice_example.dart';
import 'package:zed_nano/screens/invoices/pdf_invoice_page.dart';
import 'package:zed_nano/screens/widget/common/base_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';

class InvoiceOptionsBottomSheet extends StatefulWidget {
  InvoiceOptionsBottomSheet({super.key, this.invoiceNumber});
  String? invoiceNumber;

  @override
  State<InvoiceOptionsBottomSheet> createState() => _InvoiceOptionsBottomSheetState();
}

class _InvoiceOptionsBottomSheetState extends State<InvoiceOptionsBottomSheet> {

  InvoiceDetail? getInvoiceByInvoiceNumberResponse;

  bool _isContactDetailsExpanded = false;



  @override
  void initState() {
    super.initState();
    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getInvoiceByInvoiceNumber();
    });
  }

  Future<void> getInvoiceByInvoiceNumber() async {
    final requestData = <String, dynamic>{
      'invoiceNumber': widget.invoiceNumber,
      'businessNumber': getBusinessDetails(context)?.businessNumber,
      'purchaseOrderNumber': '',
    };

    try {
      final response =
      await getBusinessProvider(context).getInvoiceByInvoiceNumber(requestData: requestData, context: context);

      if (response.isSuccess) {
        setState(() {
          getInvoiceByInvoiceNumberResponse = response.data?.data;
        });
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load Invoice details');
    }
  }
  Future<void> resendInvoice() async {
    final requestData = <String, dynamic>{
      'invoiceNumber': widget.invoiceNumber,
    };

    try {
      final response =
      await getBusinessProvider(context).resendInvoice(requestData: requestData, context: context);

      if (response.isSuccess) {
        showCustomToast(response.message ?? 'Invoice resent successfully', isError: false);
        finish(context);
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load Invoice details');
    }
  }

  Future<void> shareInvoice() async {
    final requestData = <String, dynamic>{
      'invoiceNumber': widget.invoiceNumber,
    };

    try {
      final response =
      await getBusinessProvider(context).shareInvoice(requestData: requestData, context: context);

      if (response.isSuccess) {
        showCustomToast('Invoice shared successfully', isError: false);

        // Get the WhatsApp message response data
        final whatsappResponse = response.data;
        //
        // if (whatsappResponse != null && whatsappResponse.isValidWhatsappUrl) {
        //   // Extract information for logging/debugging if needed
        //   String phone = whatsappResponse.phoneNumber ?? '';
        //   String message = whatsappResponse.shareableMessage;
        //
        //   // Launch WhatsApp with the complete URL
        // }
        await launchUrl(Uri.parse(whatsappResponse!.data!));

        finish(context);
      } else {
        showCustomToast(response.message ?? 'Failed to share invoice');
      }
    } catch (e) {
      showCustomToast('Failed to load Invoice details');
    }
  }

  final List<String> steps = [
    'Resend invoice to email',
    'Share invoice',
    'Download PDF'
  ];

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      title: 'More Actions',
      initialChildSize: 0.5,
      headerContent:  const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'More Actions',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xff1f2024),
            ),
          ),
          Text(
            'Select an option to proceed.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              color: Color(0xff71727a),
            ),
          ),
        ],
      ).paddingTop(16),
      bodyContent: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: ListView.builder(
          itemCount: steps.length,
          itemBuilder: (context, index) {
            return arrowListItem(
              index: index,
              steps: steps,
              onTab: (index) async {
                final stepName = steps[index as int];
                switch (stepName) {
                  case 'Resend invoice to email':
                    await resendInvoice();
                  case 'Share invoice':
                    Navigator.pop(context);
                    await shareInvoice();
                  case 'Download PDF':
                    PdfInvoicePage(invoiceData: getInvoiceByInvoiceNumberResponse).launch(context);
                    break;
                  default:
                    break;
                }
              },
            );
          },
        ),
      ),
    );
  }
}
