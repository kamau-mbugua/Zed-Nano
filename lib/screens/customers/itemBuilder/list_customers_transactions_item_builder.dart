import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/customerTransactions/CustomerTransactionsResponse.dart';
import 'package:zed_nano/models/customers_list/CustomerListResponse.dart';
import 'package:zed_nano/models/fetchByStatus/OrderResponse.dart';
import 'package:zed_nano/models/get_user_invoices/InvoiceListResponse.dart';
import 'package:zed_nano/screens/customers/details/customer_details_page.dart';
import 'package:zed_nano/screens/invoices/detail/invoice_detail_page.dart';
import 'package:zed_nano/screens/orders/detail/order_detail_page.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/extensions.dart';

Widget listCustomersTransactionsItemBuilder(CustomerTransaction customerTransaction) {
  return Builder(
    builder: (context) => GestureDetector(
      onTap: () {
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
                      customersTranascionIcons,
                        fit: BoxFit.fitHeight,
                        height: 20,
                        width: 15,
                    ),
                    8.width,
                    Text("${customerTransaction.transactionNo ?? ""}",
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
                Text('- ${customerTransaction.currency} ${customerTransaction.amount?.formatCurrency()}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: googleRed,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,

                    )
                )
              ],
            ),
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${customerTransaction.transactionTime?.toShortDateTime ?? ""}",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.15,

                    )
                ),
                 Text('Balance: ${customerTransaction.currency} ${customerTransaction.customerBalance?.formatCurrency()}',
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

            const Divider(height: 1, thickness: 0.9),
          ],
        ),
      ),
    ),
  );
}
Widget listCustomersOrdersItemBuilder(OrderData customerTransaction) {
  return Builder(
    builder: (context) => GestureDetector(
      onTap: () {
        OrderDetailPage(orderId: customerTransaction.id).launch(context);
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
                      customerOrdersIcon,
                        fit: BoxFit.fitHeight,
                        height: 20,
                        width: 15,
                    ),
                    8.width,
                    Text("#${customerTransaction.orderNumber ?? ""}",
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
                    color: customerTransaction.status == 'paid'
                        ?lightGreenColor
                        : customerTransaction.status == 'partial'
                        ?lightOrange
                        :primaryYellowTextColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(customerTransaction.status?.toUpperCase() ?? '',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: customerTransaction.status == 'paid'
                            ? successTextColor
                            : customerTransaction.status == 'partial'
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
                Text("Created: ${customerTransaction.createdAt?.toShortDateTime ?? ""}",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.15,

                    )
                ),
                  Text(customerTransaction.status == 'partial' ? 'Balance' : 'Amount',
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
                Text("Served by: ${customerTransaction.servedBy ?? customerTransaction.cashier ?? "N/A"}",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textPrimaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.15,
                    )
                ),
                Text("${customerTransaction.currency ?? "KES"} ${customerTransaction.status == 'partial' ? customerTransaction.deficit?.formatCurrency() : customerTransaction.total?.formatCurrency()}",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: customerTransaction.status == 'paid'
                          ? successTextColor
                          : customerTransaction.status == 'partial'
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
Widget listCustomersInvoicesItemBuilder(CustomerInvoiceData customerTransaction) {
  return Builder(
    builder: (context) => GestureDetector(
      onTap: () {
        InvoiceDetailPage(invoiceNumber: customerTransaction?.invoiceNumber).launch(context).then((value) {
        });
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
                    Text("${customerTransaction.invoiceNumber ?? ""}",
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
                    color: customerTransaction.invoiceStatus == 'Paid'
                        ?lightGreenColor
                    :customerTransaction.invoiceStatus == 'Unpaid'
                        ?primaryYellowTextColor
                        :lightOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(customerTransaction.invoiceStatus ?? '',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: customerTransaction.invoiceStatus == 'Paid'
                            ? successTextColor
                            :customerTransaction.invoiceStatus == 'Unpaid'
                            ? googleRed
                        :primaryOrangeTextColor,
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
                Text("Issued on: ${customerTransaction.createdAt?.toFormattedDateTime() ?? ""}",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.15,

                    )
                ),
                 const Text('Amount',
                    style: TextStyle(
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
                Text('${customerTransaction.invoiceType} Invoice',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textPrimaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.15,
                    )
                ),
                Text(customerTransaction.invoiceStatus == 'Paid'
                    ? 'KES ${customerTransaction.invoiceAmount?.formatCurrency()}'
                    : customerTransaction.invoiceStatus == 'Unpaid'
                    ? 'KES ${customerTransaction.invoiceAmount?.formatCurrency()}'
                    : 'KES ${customerTransaction.invoiceBalance?.formatCurrency()}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: customerTransaction.invoiceStatus == 'Paid'
                          ? successTextColor
                      :customerTransaction.invoiceStatus == 'Unpaid'
                          ? googleRed
                      :primaryOrangeTextColor,
                      fontSize: 14,
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
