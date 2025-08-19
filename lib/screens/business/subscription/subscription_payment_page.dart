import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/business/BusinessDetails.dart';
import 'package:zed_nano/models/createbillingInvoice/CreateBillingInvoiceResponse.dart';
import 'package:zed_nano/models/posLoginVersion2/login_response.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/business/subscription/mpesa_payment_waiting_screen.dart';
import 'package:zed_nano/screens/business/subscription/webview_payment_page.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';



class CompleteSubscriptionScreen extends StatefulWidget {

  const CompleteSubscriptionScreen({
    required this.onSkip, super.key,
    this.invoiceData,
  });
  final VoidCallback onSkip;
  final CreateBillingInvoiceResponse? invoiceData;

  @override
  State<CompleteSubscriptionScreen> createState() => _CompleteSubscriptionScreenState();
}

class _CompleteSubscriptionScreenState extends State<CompleteSubscriptionScreen> {
  String selectedPayment = 'Credit Card';

  final List<String> paymentMethods = ['Credit Card', 'MPESA'];

  LoginResponse? loginUserDetails;
  BusinessDetails? businessDetails;
  final TextEditingController countryCodeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();


  @override
  void initState() {
    super.initState();
    loginUserDetails = getAuthProvider(context).loginResponse;
    businessDetails = getBusinessDetails(context);
  }

  void _launchWebViewPayment() {
    if (widget.invoiceData == null) {
      showCustomToast('Something went wrong');
      return;
    }

    logger.d('InvoiceData: ${widget.invoiceData?.toJson()}');
    logger.d('businessDetails: ${businessDetails?.toJson()}');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPaymentPage(
          invoiceData: widget.invoiceData!,
          userEmail: loginUserDetails?.email ?? '',
          firstName: loginUserDetails?.username ?? '',
          lastName: loginUserDetails?.username ?? '',
          businessNumber: businessDetails?.businessNumber ?? '',
          onPaymentComplete: () {
            showCustomToast('Payment completed successfully!', isError: false);
            widget.onSkip();
          },
          onPaymentCancelled: () {
            Navigator.pop(context);
            showCustomToast('Payment was cancelled');
          },
        ),
      ),
    );
  }


  Future<void> _doMpesaStkPayment(String? phoneNumber) async {

    final data = <String, dynamic>{
      'phone': phoneNumber,
      'amount': widget.invoiceData?.amount,
      'orderID': widget.invoiceData?.invoiceNumber,
    };

    try {
      final response = await getBusinessProvider(context).doInitiateKcbStkPush(
        requestData: data, 
        context: context,
      );
      
      if (response.isSuccess) {
        final stkResponse = response.data;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MpesaPaymentWaitingScreen(
              invoiceNumber: stkResponse?.data?.stkOrderId ?? '',
              referenceNumber: stkResponse?.data?.requestReferenceId  ?? '',
              paymentData: data,
              sTKPaymentType: STKPaymentType.KCB,
              onPaymentSuccess: () {
                showCustomToast('Payment completed successfully!', isError: false);
                widget.onSkip();
                // // Navigate back to parent screens or home
                // Navigator.of(context).popUntil((route) => route.isFirst);
              },
              onPaymentError: showCustomToast,
              onCancel: () {
                showCustomToast('Payment cancelled');
              },
            ),
          ),
        );
      } else {
        showCustomToast(response.message ?? 'Failed to initiate payment');
      }
    } catch (e) {
      logger.e('Error initiating M-Pesa payment: $e');
      showCustomToast('Failed to initiate payment');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Subscription Plan',
          style: TextStyle(
            color: Color(0xff1f2024),
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headings(
              label: 'Complete Your Subscription',
              subLabel: 'Enjoy a free ${widget.invoiceData?.freeTrialDays ?? "0"} Day trial period.',
            ),
            const SizedBox(height: 24),
            // Plan Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xfff5f7f8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.invoiceData?.billingPlanName ?? 'Monthly Plan',
                          style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1f2024),),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Invoice: ${widget.invoiceData?.invoiceNumber ?? 'N/A'}",
                          style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              color: Color(0xff71727a),),
                        ),
                      ],),
                  Text(
                    "KES ${widget.invoiceData?.amount?.toString() ?? '1000.00'}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Color(0xff1f2024),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Expandable Payment Options
            ...paymentMethods.map(_buildPaymentOption),

            const SizedBox(height: 80),

            // Subscribe Button
            appButton(
                text: 'Subscribe',
                onTap:()async{
                  final phone = phoneNumberController.text;
                  var selectedCountry = countryCodeController.text;

                  if(selectedPayment == 'Credit Card'){
                    _launchWebViewPayment();
                  }else if(selectedPayment == 'MPESA'){
                    logger.d('phone $phone');
                    logger.d('selectedCountry $selectedCountry');
                    if(!phone.isValidPhoneNumber){
                      showCustomToast('Please enter a valid phone number');
                      return;
                    }

                    //remove + from selectedCountry
                    if(selectedCountry.startsWith('+')){
                      selectedCountry = selectedCountry.substring(1);
                    }

                    final phoneNumber = '254$phone';

                    await _doMpesaStkPayment(phoneNumber);

                  }else{
                    showCustomToast('Please select a payment method');
                  }
                },
                context: context,)
                .paddingSymmetric(horizontal: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String method) {
    final selected = selectedPayment == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = method;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? const Color(0xffdcdcdc) : const Color(0xffdcdcdc),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  selected ? Icons.radio_button_checked : Icons.radio_button_off,
                  size: 20,
                  color: selected ? const Color(0xff032541) : Colors.grey,
                ),
                const SizedBox(width: 12),
                Text(
                  method,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: selected ? const Color(0xff1f2024) : const Color(0xff71727a),
                  ),
                ),
              ],
            ),
            if (selected && method == 'Credit Card') ...[
              // const SizedBox(height: 16),
              // appButton(
              //   text: "Pay with Credit Card",
              //   onTap: _launchWebViewPayment,
              //   context: context,
              // ).paddingSymmetric(horizontal: 1),
            ] else if (selected && method == 'MPESA') ...[
              10.height,
              PhoneInputField(
                controller: phoneNumberController,
                codeController: countryCodeController,
                maxLength: 10,
              ).paddingSymmetric(horizontal: 2),
            ],
          ],
        ),
      ),
    );
  }

  Widget progressBarSegment({bool filled = true, int flex = 0}) {
    return Expanded(
      flex: flex == 0 ? 2 : flex,
      child: Container(
        height: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: filled ? const Color(0xff17ae7b) : const Color(0xffe7e8ec),
        ),
      ),
    );
  }
}
