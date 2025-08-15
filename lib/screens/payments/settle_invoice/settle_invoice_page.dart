import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/get_invoice_by_invoice_number/GetInvoiceByInvoiceNumberResponse.dart';
import 'package:zed_nano/models/get_invoice_receipt_payment_methods_no_login/GetInvoiceReceiptPaymentMethodsNoLoginResponse.dart';
import 'package:zed_nano/models/getpaymentmethod/GetPaymentMethodResponse.dart';
import 'package:zed_nano/models/order_payment_status/OrderDetailResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/payments/checkout_payment/check_out_payments_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/screens/widget/common/sub_category_picker.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';

class SettleInvoicePage extends StatefulWidget {
  String? orderId;
  CheckOutType? checkOutType;
  SettleInvoicePage({Key? key, this.orderId, this.checkOutType}) : super(key: key);

  @override
  _SettleInvoicePageState createState() => _SettleInvoicePageState();
}

class _SettleInvoicePageState extends State<SettleInvoicePage> {

  String? selectedPaymentTypeName;
  String? selectedPaymentTypeValue;
  OrderDetail? orderDetail;
  OrderDetailData? orderDetailData;
  GetPaymentMethodResponse? getPaymentMethodResponse;
  List<String> paymentMethods = [];
  String selectedPayment = '';
  List<String> orderId = [];
  InvoiceDetail? getInvoiceByInvoiceNumberResponse;
  List<PaymentReceipt>? paymentReceipt;

  final TextEditingController amountToPayController = TextEditingController();
  final TextEditingController refferenceController = TextEditingController();
  final FocusNode amountToPayFocusNode = FocusNode();
  final FocusNode refferenceFocusNode = FocusNode();


  Future<void> _doSettleOrderPayment(String refference, String? paymentType, String amountToPay) async {
    var pushyTransactionIdList = <String>[];
    pushyTransactionIdList.add(widget?.orderId ?? '');

    var payload = <String, dynamic>{};
    payload['billRefNo'] = refference;
    payload['paymentChanel'] = 'Mobile';
    payload['transamount'] = amountToPay;
    payload['pushyTransactionId'] = pushyTransactionIdList;
    payload['transactionType'] = paymentType;
    payload['referenceNo'] = refference;

    try {
      final response =
      await getBusinessProvider(context).doCashPayment(requestData: payload, context: context);

      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        finish(context);
      } else {
        showCustomToast(response.message);
      }
    } catch (e) {
      logger.e(e);
      showCustomToast('Failed to load Order details');
    }
  }

  Future<void> _doSettleInvoicePayment(String refference, String? paymentType, String amountToPay) async {



    final requestData = <String, dynamic>{
      'paymentChanel': 'Mobile',
      'amount': amountToPay,
      'invoiceNumber': widget?.orderId,
      'paymentMethod': paymentType,
      'businessNumber': getBusinessDetails(context)?.businessNumber,
      'referenceNo':refference,
    };


    try {
      final response =
      await getBusinessProvider(context).doCashPaymentInvoice(requestData: requestData, context: context);

      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        finish(context);
      } else {
        showCustomToast(response.message);
      }
    } catch (e) {
      logger.e(e);
      showCustomToast('Failed to load Order details');
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      if (widget.checkOutType == CheckOutType.Invoice) {
        getInvoiceByInvoiceNumber();
      } else{
        getOrderPaymentStatus();
      }

      getPaymentMethodSettleInvoice();
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
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load Invoice details');
    }
  }
  Future<void> getPaymentMethodSettleInvoice() async {

    try {
      final response =
      await getBusinessProvider(context).getPaymentMethodSettleInvoice(context: context);

      if (response.isSuccess) {
        setState(() {
          getPaymentMethodResponse = response.data;
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
                label: 'Settle Payment',
                subLabel: 'Settle invoice or order made through bank transfer, RTGS, PesaLink, EFT or cheque easily.',
              ),
              _buildOrderSummary(),
              8.height,
              _buildedAmountToPayField(),
            ],
          ).paddingSymmetric(horizontal: 18),
        ),
      ),
      bottomNavigationBar: _buildSubmitButton(),
    );
  }

  Widget _buildedAmountToPayField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaction Type',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Color(0xFF484848),
          ),
        ),
        const SizedBox(height: 8),
        SubCategoryPicker(
          label: 'Transaction Type',
          options: getPaymentMethodResponse?.paymentMethodNames ?? [],
          selectedValue: selectedPaymentTypeName,
          onChanged: (value) {
            final selectedCat = value;
            setState(() {
              selectedPaymentTypeName = selectedCat;
              selectedPaymentTypeValue = getPaymentMethodResponse?.findByName(selectedCat)?.value ?? '';
            });
          },
        ),
        10.height,
        const Text(
          'Reference Number',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Color(0xFF484848),
          ),
        ),
        const SizedBox(height: 8),
        StyledTextField(
          textFieldType: TextFieldType.NAME,
          hintText: 'Reference Number',
          focusNode: refferenceFocusNode,
          controller: refferenceController,
        ),
        10.height,
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
          hintText: 'Amount Paid',
          prefixText:widget.checkOutType == CheckOutType.Invoice ? getInvoiceByInvoiceNumberResponse?.currency ?? 'KES':  orderDetail?.currency ?? 'KES',
          focusNode: amountToPayFocusNode,
          controller: amountToPayController,
        ),
        8.height,
      ],
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
          text: 'Settle Payment',
          onTap: () async {
            var amountToPay = amountToPayController.text;
            var refference = refferenceController.text;
            var paymentType = selectedPaymentTypeValue;
            if (!amountToPay.isValidInput) {
              showCustomToast('Please enter amount to pay');
              return;
            }else if (!refference.isValidInput) {
              showCustomToast('Please enter refference number');
              return;
            }else if (paymentType.isEmptyOrNull) {
              showCustomToast('Please select transaction type');
              return;
            } else if (widget.orderId.isEmptyOrNull) {
              var message  = widget.checkOutType == CheckOutType.Invoice ? 'Failed to settle invoice' : 'Failed to settle order';
              showCustomToast(message);
              return;
            }

            if (widget.checkOutType == CheckOutType.Invoice) {
              await _doSettleInvoicePayment(refference, paymentType, amountToPay);
            }else {
              await _doSettleOrderPayment(refference, paymentType, amountToPay);
            }




          },
          context: context,
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
    return const AuthAppBar(
      title: 'Settle Payment',
    );
  }

}
