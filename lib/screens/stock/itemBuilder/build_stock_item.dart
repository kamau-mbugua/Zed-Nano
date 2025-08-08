import 'package:flutter/material.dart';
import 'package:zed_nano/models/get_all_activeStock/GetAllActiveStockResponse.dart';
import 'package:zed_nano/utils/Colors.dart';

Widget buildStockItem(ActiveStockProduct item) {
  Color statusColor;
  String statusText;

  switch (item.stockStatus) {
    case 'LOW_STOCK':
      statusColor = warning;
      statusText = 'Low stock: ${item.inStockQuantity} items left';
    case 'OUT_OF_STOCK':
      statusColor = errorColors;
      statusText = 'Out of stock';
    case 'IN_STOCK':
    default:
      statusColor = successTextColor;
      statusText = 'In Stock: ${item.inStockQuantity} items';
  }

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        Row(
          children: [
            // Status indicator bar
            Container(
              width: 5,
              height: 50,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.productName ?? '',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: darkGreyColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                            '${item.productCategory} .',
                            style: const TextStyle(
                                color:  textSecondary,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                                fontStyle:  FontStyle.normal,
                                fontSize: 10,
                            ),
                            textAlign: TextAlign.left,
                        ),
                        Text(' $statusText',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                            ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child:  Text('${item.currency ?? "KES"} ${item.sellingPrice?.toStringAsFixed(0) ?? "0"}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: emailBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.12,

                    ),
                ),
            ),
          ],
        ),
        Container(
          height: 1,
          color: const Color(0xFFD4D6DD),
        ),
      ],
    ),
  );
}
