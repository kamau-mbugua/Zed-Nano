import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/by-transaction-id/TransactionDetailResponse.dart';
import 'package:zed_nano/models/order_payment_status/OrderDetailResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/orders/itemBuilder/order_item_builders.dart';
import 'package:zed_nano/screens/orders/void_transaction/void_order_transaction_page.dart';
import 'package:zed_nano/screens/payments/checkout_payment/check_out_payments_page.dart';
import 'package:zed_nano/screens/sell/sell_stepper_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/bottom_sheet_helper.dart';
import 'package:zed_nano/screens/widget/common/custom_dialog.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/extensions.dart';

class TransactionDetailPage extends StatefulWidget {
  String? transactionId;

  TransactionDetailPage({Key? key, this.transactionId}) : super(key: key);

  @override
  _TransactionDetailPageState createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  ByTransactionIdDetailResponse? byTransactionIdDetailResponse;

  @override
  void initState() {
    super.initState();
    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOrderPaymentStatus();
    });
  }

  Future<void> getOrderPaymentStatus() async {
    Map<String, dynamic> requestData = {'transactionId': widget.transactionId};

    try {
      final response = await getBusinessProvider(context)
          .getTransactionByTransactionId(
              requestData: requestData, context: context);

      if (response.isSuccess) {
        setState(() {
          byTransactionIdDetailResponse = response.data;
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
              _orderHearder(),
              _buildSummary(),
              _buildOrderItems(),
              _buildOrderSummary(),
              _buildServedBy(),
            ],
          ).paddingSymmetric(horizontal: 18),
        ),
      ),
      bottomNavigationBar: _buildSubmitButton(),
    );
  }

  Widget _buildSubmitButton() {
    return Visibility(
      visible: (byTransactionIdDetailResponse?.data?.voidStatus.isEmptyOrNull ==
              true) ||
          (byTransactionIdDetailResponse?.data?.voidStatus == 'VOIDED'),
      child: Container(
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
                child: Visibility(
                  child: appButton(
                    text: 'Cancel Transaction',
                    onTap: () {
                      VoidOrderTransactionPage(
                        transactionId: widget.transactionId,
                        quantity: '${byTransactionIdDetailResponse?.data?.items?.length ?? 0}',
                        amount: byTransactionIdDetailResponse?.data?.transamount?.formatCurrency() ?? '0',
                        date: byTransactionIdDetailResponse?.data?.createdAt?.toFormattedDateTime() ?? 'N/A',
                      ).launch(context).then((value) {
                        getOrderPaymentStatus();
                      });
                    },
                    context: context,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServedBy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('Served By',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xff000000),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            )),
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
                Text("${byTransactionIdDetailResponse?.data?.cashier ?? 'N/A'}",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,
                    ))
              ],
            )),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('Summary',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xff000000),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            )),
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
                    const Text('Date',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,
                        )),
                    Text(
                        "${byTransactionIdDetailResponse?.data?.createdAt?.toFormattedDateTime() ?? 'N/A'}",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,
                        ))
                  ],
                ).paddingSymmetric(vertical: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,
                        )),
                    Text(
                        "${byTransactionIdDetailResponse?.currency ?? 'KES'} ${byTransactionIdDetailResponse?.data?.subTotal?.formatCurrency() ?? 'N/A'}",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,
                        ))
                  ],
                ).paddingSymmetric(vertical: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Discount',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,
                        )),
                    Text(
                        "${byTransactionIdDetailResponse?.currency ?? 'KES'} ${byTransactionIdDetailResponse?.data?.discountAmount?.formatCurrency() ?? 'N/A'}",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,
                        ))
                  ],
                ).paddingSymmetric(vertical: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        )),
                    Text(
                        "${byTransactionIdDetailResponse?.currency ?? 'KES'} ${byTransactionIdDetailResponse?.data?.transamount?.formatCurrency() ?? 'N/A'}",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        )),
                  ],
                ).paddingSymmetric(vertical: 10),
              ],
            )),
      ],
    );
  }

  Widget _buildOrderItems() {
    final cartItems = byTransactionIdDetailResponse?.data?.items ?? [];
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Transaction Items',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              )),
          8.height,
          if (cartItems.isEmpty)
            const Center(
              child: CompactGifDisplayWidget(
                gifPath: emptyListGif,
                title: "It's empty, over here.",
                subtitle:
                    'No products in your cart yet! Add to view them here.',
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 0),
              itemCount: cartItems.length,
              separatorBuilder: (context, index) => const Divider(
                height: 0.5,
                color: innactiveBorderCart,
              ),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return buildTransactionItem(item: item);
              },
            ),
        ]).paddingSymmetric(vertical: 16);
  }

  Widget _buildSummary() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
              height: 85,
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Transaction Id',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.15,
                      )),
                  6.height,
                  Text(
                      "${byTransactionIdDetailResponse?.data?.transactionID ?? 'N/A'}",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ))
                ],
              )),
        ),
        8.width,
        Expanded(
          flex: 1,
          child: Container(
              height: 85,
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Items',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.15,
                      )),
                  6.height,
                  Text(
                      '${byTransactionIdDetailResponse?.data?.items?.length ?? 0}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: highlightMainLight,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ))
                ],
              )),
        ),
        8.width,
        Expanded(
          flex: 2,
          child: Container(
              height: 85,
              decoration: BoxDecoration(
                color: lightGreenColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Amount',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.12,
                      )),
                  6.height,
                  Text(
                      "${byTransactionIdDetailResponse?.currency ?? 'KES'} ${byTransactionIdDetailResponse?.data?.transamount?.formatCurrency() ?? 'N/A'}",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: successTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ))
                ],
              )),
        ),
      ],
    ).paddingSymmetric(vertical: 16);
  }

  Widget _orderHearder() {
    return Column(
      children: [
        if (byTransactionIdDetailResponse?.data?.voidStatus == 'REQUEST')
          Container(
            height: 50,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: appThemePrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info,
                  color: colorBackground,
                  size: 16,
                ),
                8.width,
                const Expanded(
                  child: Text('Void Request initiated, pending approval',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: colorBackground,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      )),
                ),
              ],
            ),
          )
        else if (byTransactionIdDetailResponse?.data?.voidStatus == 'DECLINED')
          Container(
            height: 50,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: appThemePrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info,
                  color: colorBackground,
                  size: 16,
                ),
                8.width,
                const Expanded(
                  child: Text('Void Request Declined. Please try again',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: colorBackground,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      )),
                ),
              ],
            ),
          )
        else if (byTransactionIdDetailResponse?.data?.voidStatus == 'VOIDED')
          Container(
            height: 50,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: appThemePrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info,
                  color: colorBackground,
                  size: 16,
                ),
                8.width,
                const Expanded(
                  child: Text('Void Request Approved',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: colorBackground,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      )),
                ),
              ],
            ),
          )
        else
          Container(),
        8.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Transaction Details',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0.09,
                )),
            Container(
              margin: const EdgeInsets.only(right: 0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: lightGreenColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                  byTransactionIdDetailResponse?.data?.status?.toUpperCase() ??
                      'N/A',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: successTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  )),
            ),
          ],
        )
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AuthAppBar(
      title: 'View Transaction',
    );
  }
}
