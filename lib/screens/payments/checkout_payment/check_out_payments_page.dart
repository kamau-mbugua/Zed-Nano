import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/order_payment_status/OrderDetailResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';

class CheckOutPaymentsPage extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  String? orderId;

  CheckOutPaymentsPage({Key? key, required this.onNext, required this.onPrevious, this.orderId}) : super(key: key);

  @override
  _CheckOutPaymentsPageState createState() => _CheckOutPaymentsPageState();
}

class _CheckOutPaymentsPageState extends State<CheckOutPaymentsPage> {

  OrderDetail? orderDetail;
  List<String> paymentMethods = [];
  String selectedPayment = '';

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();


  @override
  void initState() {
    super.initState();
    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // getOrderPaymentStatus();
      getPaymentMethodsStatusNoAuth();
    });
  }

  Future<void> getOrderPaymentStatus() async {
    Map<String, dynamic> requestData = {
      'pushyTransactionId': widget.orderId
    };

    try {
      final response =
      await getBusinessProvider(context).getOrderPaymentStatus(requestData: requestData, context: context);

      if (response.isSuccess) {
        setState(() {
          orderDetail = response.data?.order;
        });
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load Order details');
    }
  }

  Future<void> getPaymentMethodsStatusNoAuth() async {
    Map<String, dynamic> requestData = {
      'businessNumber': getBusinessDetails(context)?.businessNumber
    };

    try {
      final response =
      await getBusinessProvider(context).getPaymentMethodsStatusNoAuth(requestData: requestData, context: context);

      if (response.isSuccess) {
        setState(() {
          paymentMethods = response.data?.data ?? [];
        });
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load Order details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: getOrderPaymentStatus,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headings(
                label: 'Choose Payment Method',
                subLabel: 'Complete the order by selecting a payment method.',
              ),
              _buildOrderSummary(),
              _buildPaymentMethodList(),
            ],
          ).paddingSymmetric(horizontal: 18),
        ),
      ),
      bottomNavigationBar: _buildSubmitButton(),
    );
  }


  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: appButton(
          text: 'Pay Now',
          onTap: () {

          },
          context: context,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodList() {
    // Filter to only include specific payment methods
    final allowedMethods = ['cash', 'mpesa', 'kcbBankPaybill', 'card'];
    final filteredMethods = paymentMethods.where((method) => allowedMethods.contains(method)).toList();
    
    return Column(
      children: [
        ...filteredMethods.map((method) => _buildPaymentOption(method)).toList(),
      ],
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
                  method == 'cash'
                      ? 'Cash'
                      : method == 'card'
                      ? 'Credit Card'
                      : method == 'kcbBankPaybill'
                      ? 'Mobile to Bank'
                      : method == 'mpesa'
                      ? 'Mpesa'
                      : method,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: selected ? const Color(0xff1f2024) : const Color(0xff71727a),
                  ),
                ),
              ],
            ),
            if (selected && method == 'card') ...[
              // const SizedBox(height: 16),
              // appButton(
              //   text: "Pay with Credit Card",
              //   onTap: _launchWebViewPayment,
              //   context: context,
              // ).paddingSymmetric(horizontal: 1),
            ] else if (selected && method == 'kcbBankPaybill') ...[
              10.height,
              PhoneInputField(
                controller: phoneNumberController,
                codeController: countryCodeController,
                maxLength: 10,
              ).paddingSymmetric(horizontal: 2),
            ] else if (selected && method == 'mpesa') ...[
              10.height,
              PhoneInputField(
                controller: phoneNumberController,
                codeController: countryCodeController,
                maxLength: 10,
              ).paddingSymmetric(horizontal: 2),
            ] else if (selected && method == 'cash') ...[
              // 10.height,
              // PhoneInputField(
              //   controller: phoneNumberController,
              //   codeController: countryCodeController,
              //   maxLength: 10,
              // ).paddingSymmetric(horizontal: 2),
            ]
          ],
        ),
      ),
    );
  }


  Widget _buildOrderSummary() {
    return Container(
        width: context.width(),
        decoration: BoxDecoration(
          color: lightGreyColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Order Summary',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xff000000),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order Number',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,

                    )
                ),
                Text("${orderDetail?.orderNumber ?? 'N/A'}",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,
                    )
                )
              ],
            ).paddingSymmetric(vertical: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('No. of Items',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,

                    )
                ),
                Text('${orderDetail?.items?.length ?? 0}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,
                    )
                )
              ],
            ).paddingSymmetric(vertical: 8),
          ],
        ));
  }
  PreferredSizeWidget _buildAppBar() {
    return AuthAppBar(
      title: 'Void Transaction',
      onBackPressed: widget.onPrevious,
    );
  }
}
