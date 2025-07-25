import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/customerTransactions/CustomerTransactionsResponse.dart';
import 'package:zed_nano/models/customers_list/CustomerListResponse.dart';
import 'package:zed_nano/models/get_user_invoices/InvoiceListResponse.dart';
import 'package:zed_nano/screens/customers/details/customer_details_page.dart';
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
        decoration: BoxDecoration(
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
                    Text("${customerTransaction?.transactionNo ?? ""}",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textPrimaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        )
                    )
                  ],
                ),
                Text("- ${customerTransaction.currency} ${customerTransaction.amount?.formatCurrency()}",
                    style: TextStyle(
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
                Text("${customerTransaction?.transactionTime?.toShortDateTime ?? ""}",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.15,

                    )
                ),
                 Text("Balance: ${customerTransaction.currency} ${customerTransaction.customerBalance?.formatCurrency()}",
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

            const Divider(height: 1, thickness: 0.9),
          ],
        ),
      ),
    ),
  );
}
Widget listCustomersOrdersItemBuilder(CustomerTransaction customerTransaction) {
  return Builder(
    builder: (context) => GestureDetector(
      onTap: () {
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
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
                      customerTransactionsIcon,
                        fit: BoxFit.fitHeight,
                        height: 20,
                        width: 15,
                    ),
                    8.width,
                    Text("${customerTransaction?.transactionNo ?? ""}",
                        style: TextStyle(
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
                    color: customerTransaction?.status == "Paid"
                        ?lightGreenColor
                        :primaryYellowTextColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(customerTransaction?.status ?? "",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: customerTransaction?.status == "Paid"
                            ? successTextColor
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
                Text("Created: Jan 15, 2025 15:33",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.15,

                    )
                ),
                 Text("Balance",
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
                Text("Served by: Kelvin",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textPrimaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.15,
                    )
                ),
                Text("KES 1000",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: customerTransaction?.status == "Paid"
                          ? successTextColor
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
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
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
                      customerTransactionsIcon,
                        fit: BoxFit.fitHeight,
                        height: 20,
                        width: 15,
                    ),
                    8.width,
                    Text("${customerTransaction?.invoiceNumber ?? ""}",
                        style: TextStyle(
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
                    color: customerTransaction?.invoiceStatus == "Paid"
                        ?lightGreenColor
                    :customerTransaction?.invoiceStatus == "Unpaid"
                        ?primaryYellowTextColor
                        :lightOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(customerTransaction?.invoiceStatus ?? "",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: customerTransaction?.invoiceStatus == "Paid"
                            ? successTextColor
                            :customerTransaction?.invoiceStatus == "Unpaid"
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
                Text("Created: Jan 15, 2025 15:33",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.15,

                    )
                ),
                 Text("Balance",
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
                Text("Served by: Kelvin",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textPrimaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.15,
                    )
                ),
                Text("KES 1000",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: customerTransaction?.invoiceStatus == "Paid"
                          ? successTextColor
                          : googleRed,
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
