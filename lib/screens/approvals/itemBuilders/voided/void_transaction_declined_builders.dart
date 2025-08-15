import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/customers_list/CustomerListResponse.dart';
import 'package:zed_nano/models/void-pending-approval/VoidPendingApprovalResponse.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/extensions.dart';

Widget addVoidApprovedTransactionsDeclinedItemBuilder(VoidPendingTransaction batch,
    {VoidCallback? onChecked,
    VoidCallback? onApprove,
    VoidCallback? onDecline,
    VoidCallback? onTap,
    bool isSelected = false,
    BuildContext? context,}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: cardBackgroundColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      rfCommonCachedNetworkImage(
                        voidedTransactionsIcon,
                        color: googleRed,
                        fit: BoxFit.fitHeight,
                        height: 20,
                        width: 15,
                      ),
                      8.width,
                      Expanded(
                        child: Text(batch.transactionID.toString(),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            ),),
                      ),
                    ],
                  ),
                  8.height,
                  // Subtitle
                  Text(
                      'Declined on:  ${batch.dateVoidDeclined?.toFormattedDate()}',
                      style: const TextStyle(
                          color: textSecondary,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.normal,
                          fontSize: 10,),
                      textAlign: TextAlign.left,),
                ],
              ),
            ),
          ],
        ),
        8.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    'Declined by:',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.15,
                    ),),
                Text(batch.voidDeclinedBy ?? 'N/A',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,
                    ),),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Type:',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.15,
                    ),),
                8.height,
                Text(batch.transactionType ?? 'N/A',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,
                    ),),
              ],
            ),
          ],
        ),
        8.height,
      ],
    ),
  ).paddingSymmetric(vertical:4);
}
