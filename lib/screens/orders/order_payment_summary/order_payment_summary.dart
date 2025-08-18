import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/get_invoice_by_invoice_number/GetInvoiceByInvoiceNumberResponse.dart';
import 'package:zed_nano/models/get_invoice_receipt_payment_methods_no_login/GetInvoiceReceiptPaymentMethodsNoLoginResponse.dart';
import 'package:zed_nano/models/order_payment_status/OrderDetailResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/invoices/itemBuilders/invoices_item_builders.dart';
import 'package:zed_nano/screens/orders/itemBuilder/order_item_builders.dart';
import 'package:zed_nano/screens/payments/checkout_payment/check_out_payments_page.dart';
import 'package:zed_nano/screens/widget/common/bottom_sheet_helper.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/Images.dart';

class OrderPaymentSummary extends StatefulWidget {

  OrderPaymentSummary({required this.orderId, super.key, this.checkOutType = CheckOutType.Order});
  String? orderId;
  CheckOutType? checkOutType;

  @override
  _OrderPaymentSummaryState createState() => _OrderPaymentSummaryState();
}

class _OrderPaymentSummaryState extends State<OrderPaymentSummary> {
  OrderDetail? orderDetail;
  List<OrderTransactionTotals>? orderTransactionTotals;

  InvoiceDetail? getInvoiceByInvoiceNumberResponse;
  List<PaymentReceipt>? paymentReceipt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.checkOutType == CheckOutType.Invoice) {
        getInvoiceByInvoiceNumber();
      }else{
        getOrderPaymentStatus();
      }
    });
  }

  Future<void> getOrderPaymentStatus() async {
    final requestData = <String, dynamic>{'pushyTransactionId': widget.orderId};

    try {
      final response = await getBusinessProvider(context)
          .getOrderPaymentStatus(requestData: requestData, context: context);

      if (response.isSuccess) {
        if (mounted) {
          setState(() {
            orderDetail = response.data?.order;
            orderTransactionTotals = response.data?.transactionsList;
          });
        }
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      logger.e('OrderPaymentSummary getOrderPaymentStatus $e');
      showCustomToast('Failed to load Order details');
    }
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
        if (mounted) {
          setState(() {
            getInvoiceByInvoiceNumberResponse = response.data?.data;
          });
        }
        if ((response.data?.data?.invoiceStatus?.toLowerCase() == 'paid') || response.data?.data?.invoiceStatus?.toLowerCase() == 'partially paid') {
          await getInvoiceReceiptPaymentMethodsNoLogin();
        }
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      logger.e('OrderPaymentSummary getInvoiceByInvoiceNumber $e');
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
        if (mounted) {
          setState(() {
            paymentReceipt = response.data?.data;
          });
        }
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      logger.e('OrderPaymentSummary getInvoiceReceiptPaymentMethodsNoLogin $e');

      showCustomToast('Failed to load Invoice details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: getOrderPaymentStatus,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _orderHearder(),
                _buildPaymentMethod(),
                _buildOrderSummary(),
              ],
            ).paddingSymmetric(horizontal: 18, vertical: 30),
          ),
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
        child: Row(
          children: [
            Expanded(
              flex: 7,
              child: Visibility(
                child: appButton(
                  text: 'Done',
                  onTap: () {
                    finish(context);
                  },
                  context: context,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: appButtonWithIcon(
                text: '',
                iconPath: fabMenuIcon,
                context: context,
                onTap: () {

                  if(widget.checkOutType == CheckOutType.Order) {
                    BottomSheetHelper.showPrintingOptionsBottomSheet(context,
                      printOrderInvoiceId: orderDetail?.id,)
                        .then((value) {
                      finish(context);
                    });

                  }else{
                    BottomSheetHelper.showInvoiceOptionsBottomSheet(context, invoiceNumber: getInvoiceByInvoiceNumberResponse?.invoiceNumber).then((value) {
                      finish(context);
                    });
                  }


                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return  widget.checkOutType == CheckOutType.Order ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Summary',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xff000000),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            ),),
        Container(
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
                        ),),
                    Text('${orderDetail?.orderNumber}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,
                        ),),
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
                        ),),
                    Text('${orderDetail?.items?.length}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,
                        ),),
                  ],
                ).paddingSymmetric(vertical: 8),
              ],
            ),),
      ],
    ):Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Summary',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xff000000),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            ),),
        Container(
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
                        ),),
                    Text('${getInvoiceByInvoiceNumberResponse?.invoiceNumber}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,
                        ),),
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
                        ),),
                    Text('${getInvoiceByInvoiceNumberResponse?.items?.length}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,
                        ),),
                  ],
                ).paddingSymmetric(vertical: 8),
              ],
            ),),
      ],
    );
  }

  Widget _orderHearder() {
    return widget.checkOutType == CheckOutType.Invoice ? const CompactSuccessGifDisplayWidget(
      gifPath: successGif,
      title: 'Payment Successful!',
      subtitle: 'Thank you. Your Invoice has been processed successfully.',
    ):const CompactSuccessGifDisplayWidget(
      gifPath: successGif,
      title: 'Payment Successful!',
      subtitle: 'Thank you. Your order has been processed successfully.',
    );
  }

  Widget _buildPaymentMethod() {
    final cartItems = orderTransactionTotals ?? [];
    final invoiceItems = paymentReceipt ?? [];
    return widget.checkOutType == CheckOutType.Order ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment Summary',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              ),),
          8.height,
          if (cartItems.isEmpty)
            const Center(
              child: CompactGifDisplayWidget(
                gifPath: emptyListGif,
                title: "It's empty, over here.",
                subtitle:
                    'No Payments in for this order yet! Add to view them here.',
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(),
              itemCount: cartItems.length,
              separatorBuilder: (context, index) => const Divider(
                height: 0.5,
                color: innactiveBorderCart,
              ),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return buildOrderPaymentSummary(item: item, context: context);
              },
            ),
        ],).paddingSymmetric(vertical: 16)
        : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment Summary',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              ),
          ),
          8.height,
          if (invoiceItems.isEmpty) const Center(
            child: CompactGifDisplayWidget(
              gifPath: emptyListGif,
              title: "It's empty, over here.",
              subtitle:
              'No Payments in for this Invoice yet! Add to view them here.',
            ),
          ) else ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(),
            itemCount: invoiceItems.length,
            separatorBuilder: (context, index) => const Divider(height: 0.5, color: innactiveBorderCart,),
            itemBuilder: (context, index) {
              final item = invoiceItems[index];
              return buildInvoicePaymentSummary(
                  item: item,
                  context: context,
              );
            },
          ),
        ],
    ).paddingSymmetric(vertical: 16);

  }
}
