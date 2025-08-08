import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/by-transaction-id/TransactionDetailResponse.dart';
import 'package:zed_nano/models/order_payment_status/OrderDetailResponse.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/extensions.dart';

Widget buildOrderItem({
  required OrderItem item,
}) {
  return Container(
    margin: const EdgeInsets.only(),
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
                    item.itemName ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: Color(0xFF323232),
                    ),
                  ),
                  const SizedBox(height: 0),
                  Row(
                    children: [
                      Text(
                        item.itemCategory ?? '',
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
                        '${item.currency ?? 'KES'} ${item.totalAmount?.formatCurrency()}',
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
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('x${item.itemCount ?? 0}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                  ),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.end,
                     crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${item.currency ?? 'KES'} ${item.itemAmount?.formatCurrency()}",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,


                          ),
                      ),
                      Text("${item.currency ?? 'KES'} ${item.discount?.formatCurrency()}",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: item.discount == 0 ? Colors.grey : successTextColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.15,

                          ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
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

Widget buildTransactionItem({
  required TransactionItem item,
}) {
  return Container(
    margin: const EdgeInsets.only(),
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
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemName ?? '',
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
                        item.itemCategory ?? '',
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
                        '${item.currency ?? 'KES'} ${item.totalAmount?.formatCurrency()}',
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
                  Text('x${item.itemCount ?? 0}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                  ),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.end,
                     crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${item.currency ?? 'KES'} ${item.itemAmount?.formatCurrency()}",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,


                          ),
                      ),
                      Text("${item.currency ?? 'KES'} ${item.discount?.formatCurrency() ?? '0.00'}",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: item.discount == 0 ? Colors.grey : successTextColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.15,

                          ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
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

Widget buildOrderPaymentSummary({
  required OrderTransactionTotals item,
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
              const Text('Amount paid',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.12,

                  ),
              ),
              Text("${item.currency ?? 'KES'} ${item.amount?.formatCurrency() ?? 'N/A'}",
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
              const Text('Paid via',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.12,

                  ),
              ),
              Text(item.transactionType?? 'N/A',
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
              const Text('Transaction ID',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.12,

                  ),
              ),
              Text(item.receiptId?? 'N/A',
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
              const Text('Date & Time',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.12,

                  ),
              ),
              Text(item.transactionDate?.toFormattedDateTime() ?? 'N/A',
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