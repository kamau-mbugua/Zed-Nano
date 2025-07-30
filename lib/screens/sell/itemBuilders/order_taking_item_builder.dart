import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/models/listProducts/ListProductsResponse.dart';
import 'package:zed_nano/providers/cart/CartViewModel.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Images.dart';

Widget buildProductItem({
  required ProductData product,
  required int quantity,
  required double discount,
  required CartViewModel cartViewModel,
  required VoidCallback onDecrease,
  required VoidCallback onIncrease,
  required VoidCallback onDecreaseLongPress,
  required VoidCallback onIncreaseLongPress,
  required VoidCallback onAddDiscount,
}) {
  final bool isSelected = quantity > 0;
  final int totalPrice = product.productPrice! * quantity;

  return Container(
    margin: const EdgeInsets.only(left: 0, right: 0, bottom: 8),
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
                      Text(
                        '${product.currency} ${product.productPrice}',
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
            16.width,
            Visibility(
              visible: discount > 0,
              child: Text("-${product.currency} ${discount.round()} Off",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: discount > 0
                        ? successTextColor
                        : Colors.grey.shade400,
                    fontSize: 14,
                    fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  )),
            ),

            // Quantity controls
          ],
        ),
        10.height,
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  // Minus button
                  InkWell(
                    onTap: onDecrease,
                    onLongPress: onDecreaseLongPress,
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: lightGreyColor,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: 8,
                        height: 1.5,
                        color: isSelected
                            ? highlightMainDark
                            : Colors.grey.shade400,
                      ),
                    ),
                  ),
                  16.width,
                  // Quantity
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: lightGreyColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      key: ValueKey('quantity_${product.id}_$quantity'),
                      initialValue: quantity.toString(),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        color: highlightMainDark,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) {
                        final newQuantity = int.tryParse(value) ?? 0;
                        if (newQuantity > 0) {
                          if (quantity == 0) {
                            // Add new item
                            cartViewModel.addItem(
                              product.id ?? '',
                              product.productName ?? '',
                              product.productPrice?.toDouble() ?? 0.0,
                              product.imagePath ?? '',
                              product.currency ?? '',
                              product.productCategory ?? '',
                              0.0,
                              quantity: newQuantity,
                            );
                          } else {
                            // Update existing item
                            cartViewModel.updateQuantity(
                                product.id ?? '', newQuantity);
                          }
                        } else if (value.isEmpty) {
                          // Don't remove item if field is just empty (user might be typing)
                          return;
                        } else {
                          // Remove item if quantity is 0 or invalid
                          cartViewModel.removeItem(product.id ?? '');
                        }
                      },
                    ),
                  ),
                  16.width,
                  // Plus button
                  InkWell(
                    onTap: onIncrease,
                    onLongPress: onIncreaseLongPress,
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: lightGreyColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 10,
                        color: highlightMainDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: onAddDiscount,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.zero,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: lightOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        rfCommonCachedNetworkImage(
                          discountIcon,
                          fit: BoxFit.fitHeight,
                          height: 20,
                          width: 15,
                        ),
                        8.width,
                        const Text('Discount',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: primaryOrangeTextColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                            )),
                      ],
                    ),
                  ),
                  16.width,
                  Text("${product.currency} ${totalPrice.round()}",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: isSelected
                            ? const Color(0xFF323232)
                            : Colors.grey.shade400,
                        fontSize: 14,
                        fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      )),
                ],
              ),
            )
          ],
        ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.end,
        //   children: [
        //
        //     const SizedBox(height: 8),
        //
        //     // Total price
        //     Text(
        //       'KES ${totalPrice.round()}',
        //       style: TextStyle(
        //         fontSize: 12,
        //         fontFamily: 'Poppins',
        //         fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        //         color: isSelected
        //             ? const Color(0xFF323232)
        //             : Colors.grey.shade400,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    ),
  );
}