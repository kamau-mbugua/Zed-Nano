import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/order_payment_status/OrderDetailResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/orders/itemBuilder/order_item_builders.dart';
import 'package:zed_nano/screens/orders/void_transaction/void_order_transaction_page.dart';
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
import 'package:zed_nano/viewmodels/data_refresh_extensions.dart';

class OrderDetailPage extends StatefulWidget {

  OrderDetailPage({super.key, this.orderId});
  String? orderId;

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderDetail? orderDetail;
  OrderDetailData? orderDetailData;
  List<OrderTransactionTotals>? orderTransactionTotals;

  @override
  void initState() {
    super.initState();
    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOrderPaymentStatus();
    });
  }

  Future<void> getOrderPaymentStatus() async {
    final requestData = <String, dynamic>{'pushyTransactionId': widget.orderId};

    try {
      final response = await getBusinessProvider(context)
          .getOrderPaymentStatus(requestData: requestData, context: context);

      if (response.isSuccess) {
        setState(() {
          orderDetail = response.data?.order;
          orderDetailData = response.data?.data;
          orderTransactionTotals = response.data?.transactionsList;
        });
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load Order details');
    }
  }

  Future<void> cancelPushyTransaction() async {
    try {
      final response = await getBusinessProvider(context)
          .cancelPushyTransaction(orderId: widget.orderId, context: context);

      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        await getOrderPaymentStatus();
        triggerRefreshEvent();
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load Order details');
    }
  }

  void _showCancelOrderBottomSheet() {
    showCustomDialog(
      context: context,
      title: 'Cancel Order?',
      subtitle:
          "Are you sure you want to cancel order #${orderDetail?.orderNumber ?? 'N/A'}. This action can not be undone.",
      negativeButtonText: 'Keep Order',
      positiveButtonText: 'Cancel Order',
      onNegativePressed: () => Navigator.pop(context),
      onPositivePressed: () async {
        // Add subscription cancellation logic here
        Navigator.pop(context); // Close dialog
        await cancelPushyTransaction();
      },
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
              _orderHearder(),
              _buildSummary(),
              _buildOrderItems(),
              _buildNaration(),
              if (orderDetail?.status == 'paid' || orderDetail?.status == 'partial') _buildPaymentMethod() else Container(),
              _buildOrderSummary(),
              _buildServedBy(),
            ],
          ).paddingSymmetric(horizontal: 18),
        ),
      ),
      bottomNavigationBar: _buildSubmitButton(),
    );
  }

  Widget _buildPaymentMethod() {
    final cartItems = orderTransactionTotals ?? [];
    return Column(
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
        ],).paddingSymmetric(vertical: 16);
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
            // Checkout button takes most of the width

            Expanded(
              flex: 7,
              child: Visibility(
                visible: orderDetail?.status == 'unpaid' ||
                    orderDetail?.status == 'partial',
                child: appButton(
                  text: orderDetail?.status == 'paid'
                      ? 'Cancel Transaction'
                      : 'Checkout',
                  onTap: () {
                    if (orderDetail?.status == 'paid') {
                      VoidOrderTransactionPage(
                        transactionId: orderDetail?.transactionId,
                        quantity: '${orderDetail?.items?.length ?? 0}',
                        amount: orderDetail?.transamount?.formatCurrency() ?? '0',
                        date: orderDetail?.createdAt?.toFormattedDateTime() ?? 'N/A',)
                          .launch(context).then((value) {
                            getOrderPaymentStatus();
                            triggerRefreshEvent();
                      });
                    } else {
                      SellStepperPage(
                        initialStep: 2,
                        initialStepData: {'orderId': widget.orderId},
                      ).launch(context).then((value) {
                        getOrderPaymentStatus();
                        triggerRefreshEvent();
                      });
                    }
                  },
                  context: context,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: appButtonWithIcon(
                text: '',
                iconPath: fabMenuIcon,
                context: context,
                onTap: () {
                  BottomSheetHelper.showPrintingOptionsBottomSheet(context,
                          printOrderInvoiceId: orderDetail?.id,)
                      .then((value) {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServedBy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Served By',
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
                Text(orderDetail?.cashier ?? 'N/A',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,
                    ),),
              ],
            ),),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Column(
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
                    const Text('Date',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,
                        ),),
                    Text(
                        orderDetail?.createdAt?.toFormattedDateTime() ?? 'N/A',
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
                    const Text('Subtotal',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,
                        ),),
                    Text(
                        "${orderDetail?.currency ?? 'KES'} ${orderDetail?.subTotal?.formatCurrency() ?? 'N/A'}",
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
                    const Text('Discount',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,
                        ),),
                    Text(
                        "${orderDetail?.currency ?? 'KES'} ${orderDetail?.discountAmount?.formatCurrency() ?? 'N/A'}",
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
                    const Text('Total',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),),
                    Text(
                        "${orderDetail?.currency ?? 'KES'} ${orderDetail?.transamount?.formatCurrency() ?? 'N/A'}",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),),
                  ],
                ).paddingSymmetric(vertical: 10),
              ],
            ),),
      ],
    );
  }

  Widget _buildNaration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Narration',
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
                Text(orderDetail?.orderTable ?? 'N/A',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,
                    ),),
              ],
            ),),
      ],
    );
  }

  Widget _buildOrderItems() {
    final cartItems = orderDetail?.items ?? [];
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Items',
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
                    'No products in your cart yet! Add to view them here.',
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
                return buildOrderItem(item: item);
              },
            ),
        ],).paddingSymmetric(vertical: 16);
  }

  Widget _buildSummary() {
    return Row(
      children: [
        Expanded(
          flex: 2,
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
                  const Text('Order Number',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.15,
                      ),),
                  6.height,
                  Text(orderDetail?.orderNumber ?? 'N/A',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),),
                ],
              ),),
        ),
        8.width,
        Expanded(
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
                      ),),
                  6.height,
                  Text('${orderDetail?.items?.length ?? 0}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: highlightMainLight,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),),
                ],
              ),),
        ),
        8.width,
        Expanded(
          flex: 2,
          child: Container(
              height: 85,
              decoration: BoxDecoration(
                color: orderDetail?.status == 'paid'
                    ? lightGreenColor
                    : orderDetail?.status == 'partial'
                        ? lightOrange
                        : primaryYellowTextColor,
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
                      ),),
                  6.height,
                  Text(
                      "${orderDetail?.currency ?? 'KES'} ${orderDetail?.status == 'partial' ? orderDetailData?.deficit?.formatCurrency() : orderDetail?.transamount?.formatCurrency() ?? 'N/A'}",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: orderDetail?.status == 'paid'
                            ? successTextColor
                            : orderDetail?.status == 'partial'
                                ? primaryOrangeTextColor
                                : googleRed,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),),
                ],
              ),),
        ),
      ],
    ).paddingSymmetric(vertical: 16);
  }

  Widget _orderHearder() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Order Details',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0.09,
                ),),
            Container(
              margin: const EdgeInsets.only(),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: orderDetail?.status == 'paid'
                    ? lightGreenColor
                    : orderDetail?.status == 'partial'
                        ? lightOrange
                        : primaryYellowTextColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(orderDetail?.status?.toUpperCase() ?? 'N/A',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: orderDetail?.status == 'paid'
                        ? successTextColor
                        : orderDetail?.status == 'partial'
                            ? primaryOrangeTextColor
                            : googleRed,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),),
            ),
          ],
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AuthAppBar(
      title: 'View Order',
      actions: [
        if (orderDetail?.status == 'unpaid')
          TextButton(
            onPressed: _showCancelOrderBottomSheet,
            child: const Text(
              'Cancel Order',
              style: TextStyle(
                color: accentRed,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          )
        else
          Container(),
      ],
    );
  }

  /// Trigger refresh events for other pages listening to order changes
  void triggerRefreshEvent() {
    try {
      // Trigger refresh for order-related data across the app
      context.dataRefresh.refreshAfterOrderOperation(operation: 'order_updated');
      logger.d('OrderDetailPage: Triggered refresh event for order operation');
    } catch (e) {
      logger.e('OrderDetailPage: Failed to trigger refresh event: $e');
    }
  }
}
