import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/business/BusinessDetails.dart';
import 'package:zed_nano/models/posLoginVersion2/login_response.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/sub_category_picker.dart';
import 'package:zed_nano/screens/widget/payment/card_number_field.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/models/createbillingInvoice/CreateBillingInvoiceResponse.dart';
import 'package:zed_nano/screens/business/subscription/webview_payment_page.dart';
import 'package:zed_nano/utils/extensions.dart';



class CompleteSubscriptionScreen extends StatefulWidget {
  final VoidCallback onSkip;
  final CreateBillingInvoiceResponse? invoiceData;

  const CompleteSubscriptionScreen({
    super.key, 
    required this.onSkip,
    this.invoiceData,
  });

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
  Future<void> initState() async {
    loginUserDetails = getAuthProvider(context).loginResponse;
    businessDetails = getAuthProvider(context).businessDetails;
    super.initState();
  }

  void _launchWebViewPayment() {
    if (widget.invoiceData == null) {
      showCustomToast('Something went wrong');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPaymentPage(
          invoiceData: widget.invoiceData!,
          userEmail: loginUserDetails?.email ?? '',
          firstName: loginUserDetails?.username ?? '',
          lastName: loginUserDetails?.username ?? '',
          onPaymentComplete: () {
            showCustomToast('Payment completed successfully!', isError: false);
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

    Map<String, dynamic> data = {
      'phone': phoneNumber,
      'amount': widget.invoiceData?.amount,
      'orderID': widget.invoiceData?.invoiceNumber
    };

    await getBusinessProvider(context).doPushStk(requestData:data, context: context)
        .then((value) {
      if (value.isSuccess) {

      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });

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
            fontSize: 16.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Scroll View
            Positioned.fill(
              top: 1,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Complete Your Subscription',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Color(0xff1f2024),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Enjoy a free ${widget.invoiceData?.freeTrialDays ?? "0"} trial period.",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        color: Color(0xff71727a),
                      ),
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
                                      color: Color(0xff1f2024)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Invoice: ${widget.invoiceData?.invoiceNumber ?? 'N/A'}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      color: Color(0xff71727a)),
                                )
                              ]),
                          Text(
                            "KES ${widget.invoiceData?.amount?.toString() ?? '1000.00'}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: Color(0xff1f2024),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Expandable Payment Options
                    ...paymentMethods.map((method) => _buildPaymentOption(method)).toList(),

                    const SizedBox(height: 40),

                    // Subscribe Button
                    appButton(
                        text: 'Subscribe',
                        onTap:()async{
                          final phone = phoneNumberController.text;
                          final selectedCountry = countryCodeController.text;

                          if(selectedPayment == 'Credit Card'){
                            _launchWebViewPayment();
                          }else if(selectedPayment == 'MPESA'){
                            if(!phone.isValidPhoneNumber){
                              showCustomToast('Please enter a valid phone number');
                              return;
                            }
                            final phoneNumber = '$selectedCountry$phone';

                            await _doMpesaStkPayment(phoneNumber);

                          }else{
                            showCustomToast('Please select a payment method');
                          }
                        },
                        context: context)
                        .paddingSymmetric(horizontal: 1),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String method) {
    final bool selected = selectedPayment == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = method;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? const Color(0xffdcdcdc) : const Color(0xffdcdcdc),
          ),
          borderRadius: BorderRadius.circular(5),
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
                controller: countryCodeController,
                  codeController: countryCodeController,
              ).paddingSymmetric(horizontal: 2),
            ]
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
