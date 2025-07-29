import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/order_payment_status/OrderDetailResponse.dart';
import 'package:zed_nano/models/pushstk/PushStkResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/business/subscription/mpesa_payment_waiting_screen.dart';
import 'package:zed_nano/screens/orders/order_payment_summary/order_payment_summary.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';


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
  OrderDetailData? orderDetailData;
  List<String> paymentMethods = [];
  String selectedPayment = '';
  List<String> orderId = [];


  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();


  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOrderPaymentStatus();
      getPaymentMethodsStatusNoAuth();
    });
  }

  Future<void> getOrderPaymentStatus() async {
    final requestData = <String, dynamic>{
      'pushyTransactionId': widget.orderId
    };

    try {
      final response =
      await getBusinessProvider(context).getOrderPaymentStatus(requestData: requestData, context: context);

      if (response.isSuccess) {
        setState(() {
          orderDetail = response.data?.order;
          orderDetailData = response.data?.data;
          if (orderDetail?.id != null) {
            orderId.add(orderDetail!.id!);
          }
        });
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      logger.e('getOrderPaymentStatus $e');
      showCustomToast('Failed to load Order details');
    }
  }

  Future<void> getPaymentMethodsStatusNoAuth() async {
    final requestData = <String, dynamic>{
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
      logger.e(e);
      showCustomToast('Failed to load Order details');
    }
  }

  Future<void> doCashPayment() async {

    final requestData = <String, dynamic>{
      'billRefNo': orderDetail?.pushTransactionId,
      'paymentChanel': 'Mobile',
      'transamount': orderDetailData?.deficit,
      'pushyTransactionId': orderId,
      'transactionType': 'Cash Payment'
    };

    try {
      final response =
      await getBusinessProvider(context).doCashPayment(requestData: requestData, context: context);

      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        widget.onNext();
        await OrderPaymentSummary(orderId: orderDetail?.id).launch(context);
      } else {
        showCustomToast(response.message);
      }
    } catch (e) {
      logger.e(e);
      showCustomToast('Failed to load Order details');
    }
  }

  Future<void> doMpesaPayment(String phoneNumber) async {
    final requestData = <String, dynamic>{
      'paymentChanel': 'mobile',
      'amount': orderDetailData?.deficit,
      'orderIds': orderId,
      'businessId': getBusinessDetails(context)?.businessId,
      'phone': phoneNumber,
      'type': 'order'
    };

    try {
      final response =
      await getBusinessProvider(context).doPushStk(requestData: requestData, context: context);
      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        var stkResponse = response.data;
        await handleStkPushWebsocket(stkResponse, requestData, STKPaymentType.Mpesa);
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load Order details');
    }
  }

  Future<void> doKcbMpesaPayment(String phoneNumber) async {
    final requestData = <String, dynamic>{
      'paymentChanel': 'mobile',
      'amount': orderDetailData?.deficit,
      'orderIds': orderId,
      'businessId': getBusinessDetails(context)?.businessId,
      'phone': phoneNumber,
      'type': 'order'
    };

    try {
      final response =
      await getBusinessProvider(context).doInitiateKcbStkPush(requestData: requestData, context: context);
      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        var stkResponse = response.data;
        await handleStkPushWebsocket(stkResponse, requestData, STKPaymentType.KCB);
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load Order details');
    }
  }


  Future<void> doCardPayment() async {
    final requestData = <String, dynamic>{
      'billRefNo': orderDetail?.pushTransactionId,
      'paymentChanel': 'Mobile',
      'transamount': orderDetailData?.deficit,
      'pushyTransactionId': orderDetail?.id,
      'transactionType': 'Cash Payment'
    };

    // try {
    //   final response =
    //   await getBusinessProvider(context).doCardPayment(requestData: requestData, context: context);
    //
    //   if (response.isSuccess) {
    //     showCustomToast(response.message, isError: false);
    //     widget.onNext();
    //   } else {
    //     showCustomToast(response.message ?? 'Failed to load product details');
    //   }
    // } catch (e) {
    //   showCustomToast('Failed to load Order details');
    // }
  }


  Future<void> handleStkPushWebsocket(PushStkResponse? stkResponse, Map<String, dynamic> requestData, STKPaymentType stkPaymentType) async{
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MpesaPaymentWaitingScreen(
          invoiceNumber: stkResponse?.data?.stkOrderId ?? '',
          referenceNumber: stkResponse?.data?.requestReferenceId  ?? '',
          paymentData: requestData,
          onPaymentSuccess: () async {
            showCustomToast('Payment completed successfully!', isError: false);
            widget.onNext();
            await OrderPaymentSummary(orderId: orderDetail?.id).launch(context).then((value) {
              widget.onNext();
            });
          },
          sTKPaymentType: STKPaymentType.Mpesa,
          onPaymentError: (errorMessage) {
            showCustomToast(errorMessage, isError: true);
          },
          onCancel: () {
            showCustomToast('Payment cancelled', isError: true);
          },
        ),
      ),
    );
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
          onTap: () async {
            if (selectedPayment == 'cash') {
              await doCashPayment();
            }else if (selectedPayment == 'mpesa') {
              var phoneNumber = phoneNumberController.text;
              if (!phoneNumber.isValidPhoneNumber) {
                showCustomToast('Please enter phone number');
                return;
              }

              phoneNumber = '254${phoneNumber.removeZero}';
              await doMpesaPayment(phoneNumber);
            }else if (selectedPayment == 'kcbBankPaybill') {
              var phoneNumber = phoneNumberController.text;
              if (!phoneNumber.isValidPhoneNumber) {
                showCustomToast('Please enter phone number');
                return;
              }

              phoneNumber = '254${phoneNumber.removeZero}';
              await doKcbMpesaPayment(phoneNumber);
            }else if (selectedPayment == 'card') {
              await doCardPayment();
            }

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
                const Text('Amount',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,

                    )
                ),
                Text("${orderDetail?.currency} ${orderDetailData?.deficit?.formatCurrency() ?? '0'}",
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
      onBackPressed: widget.onNext,
    );
  }
}
