import 'package:flutter/material.dart';
import 'package:zed_nano/models/approval_data.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';

Widget createListItem(
    ApprovalData? pendingApproval,
    String getStatus,
    {VoidCallback? onTap}
    ) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
        margin: const EdgeInsets.all(4), // Reduced margin for grid
        decoration: BoxDecoration(
          color: getStatus == 'Pending'
              ? lightOrange
              : getStatus == 'Approved'
                  ? lightGreenColor
                  : primaryYellowTextColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      rfCommonCachedNetworkImage(
                        pendingApproval?.name == 'Stock Take'
                            ? approvalStockTake
                            : pendingApproval?.name == 'Add Stock'
                                ? approvalAddStock
                                : pendingApproval?.name == 'Users'
                                    ? approvalUsers
                                    : approvalCustomers,
                        fit: BoxFit.fitHeight,
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(height: 8),
                      Text(pendingApproval?.name ?? "N/A",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          )),
                    ],
                  )),
                  Container(
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      color: getStatus == 'Pending'
                          ? primaryOrangeTextColor
                          : getStatus == 'Approved'
                          ? successTextColor
                          : errorColors,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: getStatus == 'Pending'
                            ? primaryOrangeTextColor
                            : getStatus == 'Approved'
                                ? successTextColor
                                : errorColors,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text("${pendingApproval?.count ?? 0}",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          )),
                    ),
                  )
                ],
              )
            ],
          ),
        )),
  );
}
