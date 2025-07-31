import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/order_payment_status/OrderDetailResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/orders/itemBuilder/order_item_builders.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/extensions.dart';

class VoidOrderTransactionPage extends StatefulWidget {
  String? orderId;
  VoidOrderTransactionPage({Key? key, this.orderId}) : super(key: key);

  @override
  _VoidOrderTransactionPageState createState() =>
      _VoidOrderTransactionPageState();
}

class _VoidOrderTransactionPageState extends State<VoidOrderTransactionPage> {

  OrderDetail? orderDetail;
  List<OrderTransactionTotals>? orderTransactionTotals;

  TextEditingController reasonController = TextEditingController();
  FocusNode reasonFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOrderPaymentStatus();
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
          orderTransactionTotals = response.data?.transactionsList;
        });
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load Order details');
    }
  }

  @override
  dispose() {
    reasonController.dispose();
    reasonFocusNode.dispose();
    super.dispose();
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
                label: 'Void Transaction Request',
                subLabel: 'Enter a reason why you want to void the transaction.',
              ),
              _buildOrderSummary(),
              _buildPaymentMethod(),
              _buildReasonInputField(),
            ],
          ).paddingSymmetric(horizontal: 18),
        ),
      ),
      bottomNavigationBar: _buildSubmitButton(),
    );
  }

  Widget _buildReasonInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Reason to Void",
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xff000000),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,


            )
        ),
        16.height,
        StyledTextField(
          textFieldType: TextFieldType.MULTILINE,
          hintText: 'Enter a reason why you want to void the transaction.',
          focusNode: reasonFocusNode,
          controller: reasonController,
        ),
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
          text: 'Request to Void',
          onTap: () {

          },
          context: context,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return  AuthAppBar(
      title: 'Void Transaction',
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
  Widget _buildPaymentMethod(){
    final cartItems = orderTransactionTotals ?? [];
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Payment Summary',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              )
          ),
          8.height,
          if (cartItems.isEmpty) const Center(
            child: CompactGifDisplayWidget(
              gifPath: emptyListGif,
              title: "It's empty, over here.",
              subtitle:
              'No Payments in for this order yet! Add to view them here.',
            ),
          ) else ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 0),
            itemCount: cartItems.length,
            separatorBuilder: (context, index) => const Divider(height: 0.5, color: innactiveBorderCart,),
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return buildOrderPaymentSummary(
                  item: item,
                  context: context
              );
            },
          ),
        ]
    ).paddingSymmetric(vertical: 16);
  }
}
