import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/viewAllTransactions/TransactionListResponse.dart';
import 'package:zed_nano/screens/reports/transaction_detail/transaction_detail_page.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/extensions.dart';

Widget allTransactionsItemBuilder(ViewTransactionData item, BuildContext context) {
  return GestureDetector(
    onTap: () {
      TransactionDetailPage(transactionId: item.transactionID,).launch(context);
    },
    child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.3),
          //     spreadRadius: 2,
          //     blurRadius: 5,
          //     offset: const Offset(0, 3),
          //   ),
          // ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            rfCommonCachedNetworkImage(customerTransactionsIcon,
                height: 14, width: 14, radius: 0, color: successTextColor,),
            10.width,
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.transactionID ?? '',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              ),
                          ),
                          Text(item.transtime?.toFormattedDateTime() ?? '',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.15,

                              ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("KES ${item.transamount?.formatCurrency() ?? ""}",
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                          ),
                          Text(item.transactionType ?? '',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Completed By:',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.15,

                              ),
                          ),
                          Text(item.cashier ?? '',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.12,

                              ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Phone Number:',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.15,

                              ),
                          ),
                          Text(item.customerPhone ?? 'N/A',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.12,

                              ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),),
  );
}
