import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/get_invoice_by_invoice_number/GetInvoiceByInvoiceNumberResponse.dart';
import 'package:zed_nano/models/get_invoice_receipt_payment_methods_no_login/GetInvoiceReceiptPaymentMethodsNoLoginResponse.dart';
import 'package:zed_nano/models/order_payment_status/OrderDetailResponse.dart';
import 'package:zed_nano/models/pushstk/PushStkResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/business/subscription/mpesa_payment_waiting_screen.dart';
import 'package:zed_nano/screens/orders/order_payment_summary/order_payment_summary.dart';
import 'package:zed_nano/screens/payments/settle_invoice/settle_invoice_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/viewmodels/data_refresh_extensions.dart';

enum CheckOutType{
  Invoice,
  Order
}

class CheckOutPaymentsPage extends StatefulWidget {

  CheckOutPaymentsPage({super.key, this.onNext,  this.onPrevious, this.orderId, this.checkOutType = CheckOutType.Order});
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  String? orderId;
  CheckOutType? checkOutType;

  @override
  _CheckOutPaymentsPageState createState() => _CheckOutPaymentsPageState();
}

class _CheckOutPaymentsPageState extends State<CheckOutPaymentsPage> {

  OrderDetail? orderDetail;
  OrderDetailData? orderDetailData;
  List<String> paymentMethods = [];
  String selectedPayment = '';
  List<String> orderId = [];
  InvoiceDetail? getInvoiceByInvoiceNumberResponse;
  List<PaymentReceipt>? paymentReceipt;


  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  final TextEditingController amountToPayController = TextEditingController();
  final FocusNode amountToPayFocusNode = FocusNode();


  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) {

      if (widget.checkOutType == CheckOutType.Invoice) {
        getInvoiceByInvoiceNumber();
      } else{
        getOrderPaymentStatus();
      }
      getPaymentMethodsStatusNoAuth();
    });
  }

  Future<void> getInvoiceByInvoiceNumber() async {
    final requestData = <String, dynamic>{
      'invoiceNumber': widget.orderId,
      'businessNumber': getBusinessDetails(context)?.businessNumber,
      'purchaseOrderNumber': '',
    };

    try {
      final response =
      await getBusinessProvider(context).getInvoiceByInvoiceNumber(requestData: requestData, context: context);

      if (response.isSuccess) {
        setState(() {
          amountToPayController.text = response.data?.data?.invoiceBalance.toString() ?? '';
          getInvoiceByInvoiceNumberResponse = response.data?.data;
        });
        if ((response.data?.data?.invoiceStatus?.toLowerCase() == 'paid') || response.data?.data?.invoiceStatus?.toLowerCase() == 'partially paid') {
          await getInvoiceReceiptPaymentMethodsNoLogin();
        }
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load Invoice details');
    }
  }

  Future<void> getInvoiceReceiptPaymentMethodsNoLogin() async {
    final requestData = <String, dynamic>{
      'invoiceNumber': widget.orderId,
      'businessNumber': getBusinessDetails(context)?.businessNumber,
    };

    try {
      final response =
      await getBusinessProvider(context).getInvoiceReceiptPaymentMethodsNoLogin(requestData: requestData, context: context);

      if (response.isSuccess) {
        setState(() {
          paymentReceipt = response.data?.data;
        });
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load Invoice details');
    }
  }

  Future<void> getOrderPaymentStatus() async {
    final requestData = <String, dynamic>{
      'pushyTransactionId': widget.orderId,
    };

    try {
      final response =
      await getBusinessProvider(context).getOrderPaymentStatus(requestData: requestData, context: context);

      if (response.isSuccess) {
        setState(() {
          orderDetail = response.data?.order;
          orderDetailData = response.data?.data;
          amountToPayController.text = response.data?.data?.deficit.toString() ?? '';
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
      'businessNumber': getBusinessDetails(context)?.businessNumber,
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

  double? textToDouble(String amount) {
    return double.parse(amount);
  }

  Future<void> doCashPayment() async {

    final currentDateTime = DateFormatter.getCurrentShortDateTime();
    final receiptNumber = DateTime.now().millisecondsSinceEpoch.toString().substring(0, 13);


    final requestData = <String, dynamic>{
      'billRefNo': receiptNumber,
      'paymentChanel': 'Mobile',
      'transamount': textToDouble(amountToPayController.text) ?? orderDetailData?.deficit,
      'pushyTransactionId': orderId,
      'transactionType': 'Cash Payment',
    };

    try {
      final response =
      await getBusinessProvider(context).doCashPayment(requestData: requestData, context: context);

      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        await OrderPaymentSummary(orderId: orderDetail?.id).launch(context).then((value) async {
          await triggerRefreshEvent();
          widget.onNext!();
        });
      } else {
        showCustomToast(response.message);
      }
    } catch (e) {
      logger.e(e);
      showCustomToast('Failed to load Order details');
    }
  }

  Future<void> doCashPaymentInvoice() async {
    final currentDateTime = DateFormatter.getCurrentShortDateTime();

    final requestData = <String, dynamic>{
      'paymentChanel': 'Mobile',
      'amount': textToDouble(amountToPayController.text) ?? getInvoiceByInvoiceNumberResponse?.invoiceBalance,
      'invoiceNumber': getInvoiceByInvoiceNumberResponse?.invoiceNumber,
      'paymentMethod': 'Cash Payment',
      'businessNumber': getBusinessDetails(context)?.businessNumber,
      'referenceNo':currentDateTime,
    };

    try {
      final response =
      await getBusinessProvider(context).doCashPaymentInvoice(requestData: requestData, context: context);

      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        await OrderPaymentSummary(orderId: getInvoiceByInvoiceNumberResponse?.invoiceNumber, checkOutType: widget.checkOutType).launch(context).then((value) async {
          await triggerRefreshEvent();
          finish(context);
        });
      } else {
        showCustomToast(response.message);
      }
    } catch (e) {
      logger.e(e);
      showCustomToast('Failed to load Order details');
    }
  }

  Future<void> doMpesaPayment(String phoneNumber) async {
    var requestData = <String, dynamic>{};

    if (widget.checkOutType == CheckOutType.Order) {
      requestData = <String, dynamic>{
        'paymentChanel': 'mobile',
        'amount': orderDetailData?.deficit,
        'orderIds': orderId,
        'businessId': getBusinessDetails(context)?.businessId,
        'phone': phoneNumber,
        'type': 'order',
      };
    }else {
      requestData = <String, dynamic>{
        'paymentChanel': 'mobile',
        'amount': textToDouble(amountToPayController.text) ?? getInvoiceByInvoiceNumberResponse?.invoiceBalance,
        'orderID': getInvoiceByInvoiceNumberResponse?.invoiceNumber,
        'businessId': getBusinessDetails(context)?.businessId,
        'phone': phoneNumber,
      };
    }


    try {
      final response =
      await getBusinessProvider(context).doPushStk(requestData: requestData, context: context);
      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        final stkResponse = response.data;
        await handleStkPushWebsocket(stkResponse, requestData, STKPaymentType.Mpesa);
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load Order details');
    }
  }

  Future<void> doKcbMpesaPayment(String phoneNumber) async {
    var requestData = <String, dynamic>{};
    if (widget.checkOutType == CheckOutType.Order) {
      requestData = <String, dynamic>{
        'paymentChanel': 'mobile',
        'amount': textToDouble(amountToPayController.text) ?? orderDetailData?.deficit,
        'orderIds': orderId,
        'businessId': getBusinessDetails(context)?.businessId,
        'phone': phoneNumber,
        'type': 'order',
      };
    }else{
      requestData = <String, dynamic>{
        'paymentChanel': 'mobile',
        'amount': textToDouble(amountToPayController.text) ?? getInvoiceByInvoiceNumberResponse?.invoiceBalance,
        'orderID': getInvoiceByInvoiceNumberResponse?.invoiceNumber,
        'phone': phoneNumber,
        'type':'invoice',
      };
    }


    try {
      final response =
      await getBusinessProvider(context).doInitiateKcbStkPush(requestData: requestData, context: context);
      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        final stkResponse = response.data;
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
      'transactionType': 'Cash Payment',
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

            Navigator.of(context).pop();


            if (widget.checkOutType == CheckOutType.Order) {
              await OrderPaymentSummary(orderId: orderDetail?.id, checkOutType: widget.checkOutType).launch(context).then((value) async {
                await triggerRefreshEvent();
                widget.onNext!();
              });
            }else{
              // finish(context);
              await OrderPaymentSummary(orderId: getInvoiceByInvoiceNumberResponse?.invoiceNumber, checkOutType: widget.checkOutType).launch(context).then((value) async {
                await triggerRefreshEvent();
                finish(context);
              });
            }
          },
          sTKPaymentType: STKPaymentType.Mpesa,
          onPaymentError: showCustomToast,
          onCancel: () {
            showCustomToast('Payment cancelled');
          },
        ),
      ),
    );
  }

  Future<void> triggerRefreshEvent() async {
    try {
      // Trigger refresh for order-related data across the app
      context.dataRefresh.refreshAfterOrderOperation(operation: 'order_updated');
      logger.d('OrderDetailPage: Triggered refresh event for order operation');
    } catch (e) {
      logger.e('OrderDetailPage: Failed to trigger refresh event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: widget.checkOutType == CheckOutType.Order ? getOrderPaymentStatus : getInvoiceByInvoiceNumber,
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
              if (widget.checkOutType == CheckOutType.Invoice) {
               await doCashPaymentInvoice();
              }else {
                await doCashPayment();
              }
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
            }else if (selectedPayment == 'settleInvoiceStatus') {
              await SettleInvoicePage(
                orderId: widget.orderId,
                checkOutType: widget.checkOutType,
              ).launch(context).then((value) async {
                if(widget.checkOutType == CheckOutType.Order) {
                  await OrderPaymentSummary(orderId: orderDetail?.id).launch(context).then((value) async {
                    await triggerRefreshEvent();
                    widget.onNext!();
                  });
                }else{
                  await OrderPaymentSummary(orderId: getInvoiceByInvoiceNumberResponse?.invoiceNumber, checkOutType: widget.checkOutType).launch(context).then((value) async {
                    await triggerRefreshEvent();
                    finish(context);
                  });
                }
              });
            }else{
              showCustomToast('Please select a payment method');
            }

          },
          context: context,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodList() {
    // Filter to only include specific payment methods
    final allowedMethods = ['cash', 'mpesa', 'kcbBankPaybill', 'card', 'settleInvoiceStatus'];
    final filteredMethods = paymentMethods.where(allowedMethods.contains).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        const Text(
          'Amount to Pay',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Color(0xFF484848),
          ),
        ),
        const SizedBox(height: 8),
        StyledTextField(
          textFieldType: TextFieldType.NUMBER,
          hintText: '',
          prefixText:widget.checkOutType == CheckOutType.Invoice ? getInvoiceByInvoiceNumberResponse?.currency ?? 'KES':  orderDetail?.currency ?? 'KES',
          focusNode: amountToPayFocusNode,
          controller: amountToPayController,
        ),
        8.height,
        ...filteredMethods.map(_buildPaymentOption),
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
                      : method == 'settleInvoiceStatus'
                      ? widget.checkOutType == CheckOutType.Invoice ? 'Settle Invoice' : 'Settle Order'
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
            ],
          ],
        ),
      ),
    );
  }


  Widget _buildOrderSummary() {
    return widget.checkOutType == CheckOutType.Invoice ? Container(
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
            const Text('Invoice Summary',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xff000000),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Invoice Number',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,

                    ),
                ),
                Text(getInvoiceByInvoiceNumberResponse?.invoiceNumber ?? 'N/A',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,
                    ),
                ),
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

                    ),
                ),
                Text("${getInvoiceByInvoiceNumberResponse?.currency ?? ''} ${getInvoiceByInvoiceNumberResponse?.invoiceBalance?.formatCurrency() ?? '0'}",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,
                    ),
                ),
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

                    ),
                ),
                Text('${getInvoiceByInvoiceNumberResponse?.items?.length ?? 0}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,
                    ),
                ),
              ],
            ).paddingSymmetric(vertical: 8),
          ],
        ),
    ) : Container(
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
                ),
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

                    ),
                ),
                Text(orderDetail?.orderNumber ?? 'N/A',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,
                    ),
                ),
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

                    ),
                ),
                Text("${orderDetail?.currency ?? ''} ${orderDetailData?.deficit?.formatCurrency() ?? '0'}",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,
                    ),
                ),
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

                    ),
                ),
                Text('${orderDetail?.items?.length ?? 0}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,
                    ),
                ),
              ],
            ).paddingSymmetric(vertical: 8),
          ],
        ),);
  }
  PreferredSizeWidget _buildAppBar() {
    return AuthAppBar(
      title: 'Complete Transaction',
      onBackPressed: widget.checkOutType == CheckOutType.Order ? widget.onNext : () => finish(context),
    );
  }
}
