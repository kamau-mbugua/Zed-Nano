import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zed_nano/models/get_approved_add_stock_batches_by_branch/GetBatchesListResponse.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';

Widget buildBatchItem(BatchData batch, {VoidCallback? onTap}) {
  // Format the approval date
  String formattedDate = '';
  if (batch.dateApproved != null) {
    try {
      DateTime date = DateTime.parse(batch.dateApproved!);
      formattedDate = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      formattedDate = batch.dateApproved!;
    }
  }

  // Get supplier name from batch header or use default
  String supplierName = batch.batchHeader?.to ?? 'Unknown Supplier';
  
  // Get batch number or use batch ID
  String batchNumber = batch.batchNumber ?? batch.batchId ?? 'N/A';

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      border: Border.all(
        color: Colors.grey.withOpacity(0.7),
        width: 1,
      ),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          batch.status != 'APPROVED' ? pendingBatchIcon : batchIcon,
                          width: 15,
                          height: 15,
                        ),
                        const SizedBox(width: 8),
                        Text(batchNumber,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: darkGreyColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                            )
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    
                    // Supplier information
                    Text(
                      'Supplier: $supplierName',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Approval date and product count row
                    Row(
                      children: [
                        Text(
                          'Approved on: $formattedDate',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: textSecondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '4 Products',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: textPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: textSecondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '+150 Items',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: successTextColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Items count and arrow
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 8),
                  
                  // Arrow icon
                  Icon(
                    Icons.chevron_right,
                    color: textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
