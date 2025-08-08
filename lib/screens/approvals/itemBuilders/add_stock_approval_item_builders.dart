import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/get_approved_add_stock_batches_by_branch/GetBatchesListResponse.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/extensions.dart';

Widget addStockApprovalItemBuilder(BatchData batch,
    {VoidCallback? onChecked,
    VoidCallback? onApprove,
    VoidCallback? onDecline,
    VoidCallback? onTap,
    bool isSelected = false,
    BuildContext? context,}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
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
                          approvalStockTake,
                          fit: BoxFit.fitHeight,
                          height: 20,
                          width: 15,
                        ),
                        8.width,
                        Expanded(
                          child: Text('${batch.batchNumber}',
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
                        batch.status == 'APPROVED' || batch.status == 'DECLINED'
                            ? 'Approved on ${batch.dateCreated?.toFormattedDate()}'
                            : 'Requested on:  ${batch.dateCreated?.toFormattedDate()}',
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
              if (batch.status == 'APPROVED' || batch.status == 'DECLINED')
                Container(
                  margin: const EdgeInsets.only(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: batch.status == 'APPROVED'
                        ? lightGreenColor
                        : primaryYellowTextColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(batch.status?.toUpperCase() ?? '',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: batch.status == 'APPROVED'
                            ? successTextColor
                            : googleRed,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),),
                )
              else
                Checkbox(
                  value: isSelected,
                  onChanged: (bool? newValue) {
                    onChecked?.call();
                  },
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
                  Text(
                      batch.status == 'APPROVED' || batch.status == 'DECLINED'
                          ? 'Approved By'
                          : 'Requested by:',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.15,
                      ),),
                  Text(batch.createdByName ?? 'N/A',
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
                  const Text('Products',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.15,
                      ),),
                  8.height,
                  Text(batch.productCount.toString() ?? 'N/A',
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
          if (batch.status == 'APPROVED' || batch.status == 'DECLINED')
            const SizedBox(
              height: 1,
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: onDecline,
                  child: Container(
                      decoration: BoxDecoration(
                        color: primaryYellowTextColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: googleRed,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          rfCommonCachedNetworkImage(
                            cancelIcon,
                            fit: BoxFit.fitHeight,
                            height: 15,
                            width: 15,
                          ),
                          8.width,
                          const Text('Decline',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),),
                        ],
                      ),),
                ),),
                const SizedBox(width: 12), // Add spacing between buttons
                Expanded(
                    child: GestureDetector(
                  onTap: onApprove,
                  child: Container(
                      decoration: BoxDecoration(
                        color: colorBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: successTextColor,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          rfCommonCachedNetworkImage(
                            checkIcon,
                            fit: BoxFit.fitHeight,
                            height: 15,
                            width: 15,
                          ),
                          8.width,
                          const Text('Approve',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),),
                        ],
                      ),),
                ),),
              ],
            ),
        ],
      ),
    ).paddingSymmetric(vertical: 4),
  );
}
