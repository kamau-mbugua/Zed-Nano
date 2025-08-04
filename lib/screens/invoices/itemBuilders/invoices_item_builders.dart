import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/get_business_invoices_by_status/GetBusinessInvoicesByStatusResponse.dart';
import 'package:zed_nano/models/get_invoice_by_invoice_number/GetInvoiceByInvoiceNumberResponse.dart';
import 'package:zed_nano/models/get_invoice_receipt_payment_methods_no_login/GetInvoiceReceiptPaymentMethodsNoLoginResponse.dart';
import 'package:zed_nano/screens/invoices/detail/invoice_detail_page.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/extensions.dart';

Widget listInvoicesItemBuilder(BusinessInvoice customerTransaction) {
  return Builder(
    builder: (context) => GestureDetector(
      onTap: () {
        InvoiceDetailPage(invoiceNumber: customerTransaction.invoiceNumber).launch(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    rfCommonCachedNetworkImage(
                      invoiceIcon,
                      fit: BoxFit.fitHeight,
                      height: 20,
                      width: 15,
                    ),
                    8.width,
                    Text("#${customerTransaction.invoiceNumber ?? ""}",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: textPrimaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        )
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(right: 0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: customerTransaction.invoiceStatus?.toLowerCase() == 'paid'
                        ?lightGreenColor
                        : customerTransaction.invoiceStatus?.toLowerCase() == 'partially paid'
                        ?lightOrange
                        :primaryYellowTextColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(customerTransaction.invoiceStatus?.toUpperCase() ?? '',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: customerTransaction.invoiceStatus?.toLowerCase() == 'paid'
                            ? successTextColor
                            : customerTransaction.invoiceStatus?.toLowerCase() == 'partially paid'
                            ? primaryOrangeTextColor
                            : googleRed,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      )
                  ),
                ),
              ],
            ),
            8.height,
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Issued on: ${customerTransaction.createdAt?.toShortDateTime ?? ""}",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.15,

                      )
                  ),
                  Text(customerTransaction.invoiceStatus?.toLowerCase() == 'partially paid' ? 'Balance' : 'Amount',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.15,
                      )
                  )
                ]
            ),
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${customerTransaction.invoiceType ?? "N/A"} Invoice",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textPrimaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.15,
                    )
                ),
                Text("${customerTransaction.currency ?? "KES"} ${ customerTransaction.invoiceStatus?.toLowerCase() == 'partially paid' ? customerTransaction.invoiceBalance?.formatCurrency() : customerTransaction.invoiceAmount?.formatCurrency()}",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: customerTransaction.invoiceStatus?.toLowerCase() == 'paid'
                          ? successTextColor
                          : customerTransaction.invoiceStatus?.toLowerCase() == 'partially paid'
                          ? primaryOrangeTextColor
                          : googleRed,                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,

                    )
                )
              ],
            ),
            const Divider(height: 1, thickness: 0.9),
          ],
        ),
      ),
    ),
  );
}


Widget buildInvoicePaymentSummary({
  required PaymentReceipt item,
  required BuildContext context,
}) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Amount paid",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.12,

                  )
              ),
              Text("${item?.currency ?? 'KES'} ${item?.amount?.formatCurrency() ?? 'N/A'}",
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
              const Text("Paid via",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.12,

                  )
              ),
              Text("${item?.modeOfPayment?? 'N/A'}",
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
              const Text("Transaction ID",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.12,

                  )
              ),
              Text("${item?.receiptNumber?? 'N/A'}",
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
              const Text("Date & Time",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.12,

                  )
              ),
              Text("${item?.transactionDate?.toFormattedDateTime() ?? 'N/A'}",
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


Widget buildInvoiceItem({
  required InvoiceDetailItem item,
}) {
  return Container(
    margin: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Row(
          children: [
            rfCommonCachedNetworkImage(
              item.imagePath ?? '',
              fit: BoxFit.cover,
              height: 42,
              width: 42,
            ),
            const SizedBox(width: 16),
            // Product details
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: Color(0xFF323232),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        item?.productCategory ?? 'N/A',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        ' · ',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        '${item.currency ?? 'KES'} ${item.productPrice?.formatCurrency()}',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("x${item.quantity ?? 0}",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      )
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${item.currency ?? 'KES'} ${((item.productPrice ?? 0) * (item.quantity ?? 0))?.formatCurrency()}",
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: textPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                            )
                        ),
                        Text("${item.currency ?? 'KES'} ${item.discount?.formatCurrency()}",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: item.discount == 0 ? Colors.grey : successTextColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.15,

                            )
                        )

                      ]
                  )

                ],
              ),
            )
          ],
        ),
        Divider(
          color: Colors.grey.shade300,
          thickness: 1,
        ),
      ],
    ),
  );
}
