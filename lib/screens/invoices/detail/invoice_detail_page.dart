import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/get_invoice_by_invoice_number/GetInvoiceByInvoiceNumberResponse.dart';
import 'package:zed_nano/models/get_invoice_receipt_payment_methods_no_login/GetInvoiceReceiptPaymentMethodsNoLoginResponse.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/invoices/itemBuilders/invoices_item_builders.dart';
import 'package:zed_nano/screens/payments/checkout_payment/check_out_payments_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/bottom_sheet_helper.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_dialog.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/extensions.dart';

class InvoiceDetailPage extends StatefulWidget {

  InvoiceDetailPage({super.key, this.invoiceNumber});
  String? invoiceNumber;

  @override
  _InvoiceDetailPageState createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  InvoiceDetail? getInvoiceByInvoiceNumberResponse;
  List<PaymentReceipt>? paymentReceipt;

  bool _isContactDetailsExpanded = false;



  @override
  void initState() {
    super.initState();
    // Defer the first data fetch until after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getInvoiceByInvoiceNumber();
    });
  }

  Future<void> getInvoiceByInvoiceNumber() async {
    final requestData = <String, dynamic>{
      'invoiceNumber': widget.invoiceNumber,
      'businessNumber': getBusinessDetails(context)?.businessNumber,
      'purchaseOrderNumber': '',
    };

    try {
      final response =
      await getBusinessProvider(context).getInvoiceByInvoiceNumber(requestData: requestData, context: context);

      if (response.isSuccess) {
        setState(() {
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
      'invoiceNumber': widget.invoiceNumber,
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

  Future<void> cancelPushyTransaction() async {
    try {
      final response =
      await getBusinessProvider(context).cancelPushyTransaction(orderId: widget.invoiceNumber, context: context);

      if (response.isSuccess) {
        showCustomToast(response.message, isError: false);
        await getInvoiceByInvoiceNumber();
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load Invoice details');
    }
  }


  void _showCancelOrderBottomSheet() {
    showCustomDialog(
      context: context,
      title: 'Cancel Invoice?',
      subtitle:
      "Are you sure you want to cancel invoice #${getInvoiceByInvoiceNumberResponse?.invoiceNumber ?? 'N/A'}. This action can not be undone.",
      negativeButtonText: 'Keep Invoice',
      positiveButtonText: 'Cancel Invoice',
      onNegativePressed: () => Navigator.pop(context),
      onPositivePressed: () async {
        // Add subscription cancellation logic here
        Navigator.pop(context); // Close dialog
        // await cancelPushyTransaction();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: getInvoiceByInvoiceNumber,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _invoiceHearder(),
              _buildSummary(),
              _buildCustomerDetails(),
              _buildInvoiceItems(),
              // _buildNaration(),
              if (getInvoiceByInvoiceNumberResponse?.invoiceStatus?.toLowerCase() == 'paid') _buildPaymentMethod() else Container(),
              _buildInvoiceSummary(),
              // _buildServedBy(),
            ],
          ).paddingSymmetric(horizontal: 18),
        ),
      ),
      bottomNavigationBar: _buildSubmitButton(),
    );
  }

  Widget _buildCustomerDetails(){
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 6,),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isContactDetailsExpanded = !_isContactDetailsExpanded;
              });
            },
            child: Row(
              children: [
                Expanded(
                  child: Text("To: ${getInvoiceByInvoiceNumberResponse?.customerName ?? 'N/A'}",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                  ),
                ),
                rfCommonCachedNetworkImage(
                    _isContactDetailsExpanded ? upIcon : dropIcon,
                    fit: BoxFit.cover,
                    height: 15,
                    width: 15,
                    radius: 8,
                ),
              ],
            ).paddingSymmetric(vertical: 10),
          ),
          if (_isContactDetailsExpanded) ...[
            Row(
                children: [
                  rfCommonCachedNetworkImage(
                      phoneIconGray,
                      fit: BoxFit.cover,
                      height: 15,
                      width: 15,
                      radius: 8,
                  ),
                  6.width,
                  Text(getInvoiceByInvoiceNumberResponse?.customerPhoneNumber ?? 'N/A',
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
            ).paddingSymmetric(vertical: 5),
            Row(
                children: [
                  rfCommonCachedNetworkImage(
                      emailIconGray,
                      fit: BoxFit.cover,
                      height: 15,
                      width: 15,
                      radius: 0,
                  ),
                  6.width,
                  Text(getInvoiceByInvoiceNumberResponse?.sentTo ?? 'N/A',
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
            ).paddingSymmetric(vertical: 5),
            Row(
                children: [
                  rfCommonCachedNetworkImage(
                      locationIcon,
                      fit: BoxFit.cover,
                      height: 15,
                      width: 15,
                      radius: 0,
                  ),
                  6.width,
                  Expanded(
                    child: Text(getInvoiceByInvoiceNumberResponse?.businessLocation ?? 'N/A',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,
                        ),
                    ),
                  ),
                ],
            ).paddingSymmetric(vertical: 5),
          ],
        ],
      ),
    );
  }


  Widget _buildPaymentMethod(){
    final cartItems = paymentReceipt ?? [];
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
              ),
          ),
          8.height,
          if (cartItems.isEmpty) const Center(
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
            itemCount: cartItems.length,
            separatorBuilder: (context, index) => const Divider(height: 0.5, color: innactiveBorderCart,),
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return buildInvoicePaymentSummary(
                  item: item,
                  context: context,
              );
            },
          ),
        ],
    ).paddingSymmetric(vertical: 16);
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
                visible: getInvoiceByInvoiceNumberResponse?.invoiceStatus?.toLowerCase() == 'unpaid' || getInvoiceByInvoiceNumberResponse?.invoiceStatus?.toLowerCase() == 'partially paid',
                child: appButton(
                  text: getInvoiceByInvoiceNumberResponse?.invoiceStatus?.toLowerCase() == 'paid' ? 'Cancel Transaction' : 'Pay Invoice',
                  onTap: () {
                    if (getInvoiceByInvoiceNumberResponse?.invoiceStatus?.toLowerCase() == 'paid') {
                      // VoidOrderTransactionPage(
                      //   orderId: widget.invoiceNumber
                      // ).launch(context);
                    }else{
                      // SellStepperPage(
                      //   initialStep: 2,
                      //   initialStepData: {'orderId': widget.invoiceNumber},
                      // ).launch(context);
                      CheckOutPaymentsPage(checkOutType:CheckOutType.Invoice, orderId: widget.invoiceNumber).launch(context).then((value) {
                        // refreshPage();
                        getInvoiceByInvoiceNumber();
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
              child: Visibility(
                visible: getInvoiceByInvoiceNumberResponse?.invoiceStatus?.toLowerCase() == 'unpaid' || getInvoiceByInvoiceNumberResponse?.invoiceStatus?.toLowerCase() == 'partially paid',
                child: appButtonWithIcon(
                  text: '',
                  iconPath: fabMenuIcon,
                  context: context,
                  onTap: () {
                    BottomSheetHelper.showInvoiceOptionsBottomSheet(context, invoiceNumber: getInvoiceByInvoiceNumberResponse?.invoiceNumber).then((value) {

                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServedBy(){
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
            ),
        ),
        Container(
            width: context.width(),
            decoration: BoxDecoration(
              color: lightGreyColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('N/A',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,

                    ),
                ),
              ],
            ),),
      ],
    );
  }

  Widget _buildInvoiceSummary() {
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
            ),
        ),
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

                        ),
                    ),
                    Text(getInvoiceByInvoiceNumberResponse?.createdAt?.toFormattedDateTime() ?? 'N/A',
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
                    const Text('Subtotal',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,

                        ),
                    ),
                    Text("${getInvoiceByInvoiceNumberResponse?.currency ?? 'KES'} ${getInvoiceByInvoiceNumberResponse?.invoiceAmount?.formatCurrency() ?? 'N/A'}",
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
                    const Text('Discount',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.12,

                        ),
                    ),
                    Text("${getInvoiceByInvoiceNumberResponse?.currency ?? 'KES'} ${getInvoiceByInvoiceNumberResponse?.invoiceDiscountAmount?.formatCurrency() ?? 'N/A'}",
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
                    const Text('Total',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,


                        ),
                    ),
                    Text("${getInvoiceByInvoiceNumberResponse?.currency ?? 'KES'} ${getInvoiceByInvoiceNumberResponse?.total?.formatCurrency() ?? 'N/A'}",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,


                        ),
                    ),
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
            ),
        ),
        Container(
          width: context.width(),
            decoration: BoxDecoration(
              color: lightGreyColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('N/A',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,

                    ),
                ),
              ],
            ),),
      ],
    );
  }

  Widget _buildInvoiceItems() {
    final cartItems = getInvoiceByInvoiceNumberResponse?.items ?? [];
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Invoice Items',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              ),
          ),
          8.height,
          if (cartItems.isEmpty) const Center(
            child: CompactGifDisplayWidget(
              gifPath: emptyListGif,
              title: "It's empty, over here.",
              subtitle:
              'No products in your cart yet! Add to view them here.',
            ),
          ) else ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(),
            itemCount: cartItems.length,
            separatorBuilder: (context, index) => const Divider(height: 0.5, color: innactiveBorderCart,),
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return buildInvoiceItem(
                  item: item,);
            },
          ),
        ],
    ).paddingSymmetric(vertical: 16);
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
                  const Text('Invoice Number',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.15,
                      ),),
                  6.height,
                  Text("#${getInvoiceByInvoiceNumberResponse?.invoiceNumber ?? 'N/A'}",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimary,
                        fontSize: 16,
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
                  Text('${getInvoiceByInvoiceNumberResponse?.items?.length ?? 0}',
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
                color: getInvoiceByInvoiceNumberResponse?.invoiceStatus?.toLowerCase() == 'paid'
                    ? lightGreenColor
                    : getInvoiceByInvoiceNumberResponse?.invoiceStatus?.toLowerCase() == 'partially paid'
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
                  Text("${getInvoiceByInvoiceNumberResponse?.currency ?? 'KES'} ${getInvoiceByInvoiceNumberResponse?.invoiceAmount?.formatCurrency() ?? 'N/A'}",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: getInvoiceByInvoiceNumberResponse?.invoiceStatus?.toLowerCase() == 'paid'
                            ? successTextColor
                            : getInvoiceByInvoiceNumberResponse?.invoiceStatus?.toLowerCase() == 'partially paid'
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

  Widget _invoiceHearder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headings(
          label: 'Preview Invoice',
          subLabel: 'Here is a preview of your invoice.',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Invoice Details',
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
                color: getInvoiceByInvoiceNumberResponse?.invoiceStatus?.toLowerCase() == 'paid'
                    ? lightGreenColor
                    : getInvoiceByInvoiceNumberResponse?.invoiceStatus?.toLowerCase() == 'partially paid'
                        ? lightOrange
                        : primaryYellowTextColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(getInvoiceByInvoiceNumberResponse?.invoiceStatus ?? 'N/A',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: getInvoiceByInvoiceNumberResponse?.invoiceStatus?.toLowerCase() == 'paid'
                        ? successTextColor
                        : getInvoiceByInvoiceNumberResponse?.invoiceStatus?.toLowerCase() == 'partially paid'
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
    return const AuthAppBar(
      title: 'View Invoice',
      // actions: [
      //   if (getInvoiceByInvoiceNumberResponse?.invoiceStatus?.toLowerCase() == 'unpaid') TextButton(
      //     onPressed: () {
      //       _showCancelOrderBottomSheet();
      //     },
      //     child: const Text('Cancel Invoice',
      //       style: TextStyle(
      //         color: accentRed,
      //         fontFamily: 'Poppins',
      //         fontWeight: FontWeight.w500,
      //         fontSize: 14,
      //       ),
      //     ),
      //   ) else Container()
      // ],
    );
  }
}
