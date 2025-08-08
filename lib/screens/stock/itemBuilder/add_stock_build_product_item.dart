import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/get_all_activeStock/GetAllActiveStockResponse.dart';
import 'package:zed_nano/models/listStockTake/GetActiveStockTakeResponse.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/extensions.dart';


Widget addStockBuildProductItem({
  required ActiveStockProduct product,
  required int quantity,
  required VoidCallback onTap,
}) {
  final isSelected = quantity > 0;
  final totalPrice = product.productPrice! * quantity;


  Color statusColor;
  String statusText;

  switch (product.stockStatus) {
    case 'LOW_STOCK':
      statusColor = warning;
      statusText = 'Low stock: ${product.inStockQuantity} items left';
    case 'OUT_OF_STOCK':
      statusColor = errorColors;
      statusText = 'Out of stock';
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
                    Text('${product.inStockQuantity}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
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
                    Text(statusText,
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

                  ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


Widget addStockTakeBuildProductItem({
  required StockTakeProduct product,
  required int quantity,
  required int variance,
  required VoidCallback onTap,
}) {
  final isSelected = quantity > 0;

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
    child: Column(
      children: [
        Row(
          children: [
            rfCommonCachedNetworkImage(
              product.imagePath ?? '',
              fit: BoxFit.cover,
              height: 42,
              width: 42,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                 _buildProductDetails(
                     product: product,
                     quantity: quantity,
                     onTap: onTap,
                 ),
                 _buildProductDetailsCounts(
                     product: product,
                     quantity: quantity,
                     variance: variance,
                     onTap: onTap,
                 ).onTap(onTap),
                ],
              ),
            ),
            // Product details

          ],
        ),

      ],
    ),
  );


}

Widget _buildProductDetails({
  required StockTakeProduct product,
  required int quantity,
  required VoidCallback onTap,
}) {
  return Row(
    children: [
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
                  'Last Updated:${product.updatedAt?.toFormattedDate()}',
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
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                editIcon,
                width: 15,
                height: 15,
              ),
              const Text(' Take stock',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.12,
          
                  ),
              ),
            ],
          ).onTap(onTap),
        ],
      ),
    ],
  ).paddingSymmetric(
      vertical: 10,
      horizontal: 10,
  );
}

Widget _buildProductDetailsCounts({
  required StockTakeProduct product,
  required int quantity,
  required int variance,
  required VoidCallback onTap,
}) {

  return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Expected',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0.15,

                ),
            ),
            Text('${product.expectedQuantity}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,


                ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Actual',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0.15,

                ),
            ),
            Text(quantity != 0 ? '$quantity' : '${product.actualQuantity}',
                style:  TextStyle(
                  fontFamily: 'Poppins',
                  color: variance != 0
                      ? variance < 0
                      ? errorColors
                      : successTextColor
                      : primaryBlueTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,


                ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Variance',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0.15,

                ),
            ),
            Text(
              variance != 0 ? '$variance' :
              '${product.varianceQuantity}',
                style:  TextStyle(
                  fontFamily: 'Poppins',
                  color: variance != 0
                      ? variance < 0
                          ? errorColors
                          : successTextColor
                      : primaryBlueTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
            ),
          ],
        ),
      ],
  ).paddingSymmetric(
      vertical: 10,
      horizontal: 10,
  );
}