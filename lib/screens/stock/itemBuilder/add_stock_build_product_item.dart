import 'package:flutter/material.dart';
import 'package:zed_nano/models/get_all_activeStock/GetAllActiveStockResponse.dart';
import 'package:zed_nano/models/listProducts/ListProductsResponse.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';


Widget addStockBuildProductItem({
  required ActiveStockProduct product,
  required int quantity,
  required VoidCallback onTap,
}) {
  final bool isSelected = quantity > 0;
  final int totalPrice = product.productPrice! * quantity;


  Color statusColor;
  String statusText;

  switch (product.stockStatus) {
    case 'LOW_STOCK':
      statusColor = warning;
      statusText = 'Low stock: ${product.inStockQuantity} items left';
      break;
    case 'OUT_OF_STOCK':
      statusColor = errorColors;
      statusText = 'Out of stock';
      break;
    case 'IN_STOCK':
    default:
      statusColor = successTextColor;
      statusText = 'In Stock: ${product.inStockQuantity} items';
  }

  return Container(
    margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isSelected ? highlightMainDark : innactiveBorder,
        width: isSelected ? 1.5 : 1.0,
      ),
    ),
    child: InkWell(
      onTap: onTap,
      child: Row(
        children: [
          rfCommonCachedNetworkImage(
            product.imagePath ?? '',
            fit: BoxFit.cover,
            height: 42,
            width: 42,
          ),
          const SizedBox(width: 16),
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName ?? '',
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
                      product.productCategory ?? '',
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
                    Text('$statusText',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        )
                    )
                  ],
                ),
              ],
            ),
          ),

          // Quantity controls
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${product.currency} ${product.productPrice}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.12,

                  )
              )
            ],
          ),
        ],
      ),
    ),
  );
}