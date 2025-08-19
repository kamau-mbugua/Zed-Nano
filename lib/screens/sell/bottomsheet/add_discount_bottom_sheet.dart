import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/listProducts/ListProductsResponse.dart';
import 'package:zed_nano/providers/cart/CartViewModel.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/base_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';

class AddDiscountBottomSheet extends StatefulWidget {

  AddDiscountBottomSheet({required this.productData, super.key});
  ProductData? productData;

  @override
  State<AddDiscountBottomSheet> createState() => _AddDiscountBottomSheetState();
}

class _AddDiscountBottomSheetState extends State<AddDiscountBottomSheet> {

  TextEditingController discountController = TextEditingController();

  FocusNode discountFocusNode = FocusNode();

  List<String> discountType = [
    'Fixed',
    'Percentage',
  ];
  
  String selectedDiscountType = 'Fixed';
  
  // Discount calculation variables
  double discountAmount = 0;
  double finalPrice = 0;

  Timer? _debounce;

  void onDecrease(
      int quantity, CartViewModel cartViewModel, ProductData product,) {
    if (quantity > 0) {
      if (quantity == 1) {
        cartViewModel.removeItem(product.id ?? '');
        onQuantityChange(0);
      } else {
        cartViewModel.updateQuantity(product.id ?? '', quantity - 1);
        onQuantityChange(quantity - 1);
      }
    }
  }

  void onIncrease(
      int quantity, CartViewModel cartViewModel, ProductData product,) {
    if (quantity == 0) {
      cartViewModel.addItem(
        product.id ?? '',
        product.productName ?? '',
        product.productPrice?.toDouble() ?? 0.0,
        product.imagePath ?? '',
        product.currency ?? '',
        product.productCategory ?? '',
        0,
      );
      onQuantityChange(1);
    } else {
      cartViewModel.updateQuantity(product.id ?? '', quantity + 1);
      onQuantityChange(quantity + 1);
    }
  }

  Future<void> calculateDiscount(String value) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
      final cartItem = cartViewModel.findItem(widget.productData?.id ?? '');
      final quantity = cartItem?.quantity ?? 1;
      final unitPrice = widget.productData?.productPrice?.toDouble() ?? 0.0;
      final originalPrice = unitPrice * quantity;
      
      if (value.isEmpty) {
        discountAmount = 0.0;
        finalPrice = originalPrice;
        return;
      }
      
      final inputValue = double.tryParse(value) ?? 0.0;
      
      if (selectedDiscountType == 'Fixed') {
        // Fixed discount amount
        discountAmount = inputValue;
        finalPrice = originalPrice - discountAmount;
        
        // Ensure final price doesn't go below 0
        if (finalPrice < 0) {
          finalPrice = 0.0;
          discountAmount = originalPrice;
        }
      } else {
        // Percentage discount
        if (inputValue > 100) {
          // Cap percentage at 100%
          discountAmount = originalPrice;
          finalPrice = 0.0;
        } else {
          discountAmount = (inputValue / 100) * originalPrice;
          finalPrice = originalPrice - discountAmount;
        }
      }
      setState(() {});
    });
  }

  void onQuantityChange(int newQuantity) {
    final unitPrice = widget.productData?.productPrice?.toDouble() ?? 0.0;
    final originalPrice = unitPrice * newQuantity;
    
    if (discountController.text.isEmpty) {
      discountAmount = 0.0;
      finalPrice = originalPrice;
    } else {
      final inputValue = double.tryParse(discountController.text) ?? 0.0;
      
      if (selectedDiscountType == 'Fixed') {
        // Fixed discount stays the same amount
        discountAmount = inputValue;
        finalPrice = originalPrice - discountAmount;
        
        // Ensure final price doesn't go below 0
        if (finalPrice < 0) {
          finalPrice = 0.0;
          discountAmount = originalPrice;
        }
      } else {
        // Percentage discount recalculates based on new total
        if (inputValue > 100) {
          discountAmount = originalPrice;
          finalPrice = 0.0;
        } else {
          discountAmount = (inputValue / 100) * originalPrice;
          finalPrice = originalPrice - discountAmount;
        }
      }
    }
    
    setState(() {});
  }

  @override
  void dispose() {
    discountController.dispose();
    discountFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final cartViewModel = Provider.of<CartViewModel>(context);

    return BaseBottomSheet(
      title: 'Add Discount to Product',
      initialChildSize: 0.8,
      bodyContent: Column(
        children: [
          addProductHeader(),
          addCartCount(cartViewModel),
          listDiscountType(),
          buildSummary(),
          buttonsView(cartViewModel: cartViewModel),
        ],
      ),
    );
  }

  Widget buildSummary() {
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    final cartItem = cartViewModel.findItem(widget.productData?.id ?? '');
    final quantity = cartItem?.quantity ?? 1;
    final unitPrice = widget.productData?.productPrice?.toDouble() ?? 0.0;
    final originalPrice = unitPrice * quantity;
    final currency = widget.productData?.currency ?? 'KES';
    
    return Container(
      width: context.width(),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: lightGreenColor,
        border: Border.all(
          color: mintColors,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Original Price:',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: successTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
              ),
              Text('$currency ${originalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: successTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
              ),
            ],
          ),
          if (discountAmount > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Discount:',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: successTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                ),
                Text('- $currency ${discountAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: errorColors,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(color: mintColors, thickness: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Final Price:',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: successTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                ),
                Text('$currency ${finalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: successTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Final Price:',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: successTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                ),
                Text('$currency ${originalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: successTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                ),
              ],
            ),
          ],
        ],
      ),
    ).paddingSymmetric(vertical: 16);
  }
  
  Widget listDiscountType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Discount Type',
          style: TextStyle(
            color: Color(0xff2f3036),
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
        8.height,
        Row(
          children: discountType.map((type) {
            final isSelected = selectedDiscountType == type;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDiscountType = type;
                  // Recalculate discount when type changes
                  calculateDiscount(discountController.text);
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: type == discountType.first ? 8 : 0),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xfff2f4f5) : const Color(0xfffcfcfc),
                  border: Border.all(
                    color: isSelected ? const Color(0xff032541) : const Color(0xffc5c6cc),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    color: isSelected ? const Color(0xff032541) : const Color(0xff8f9098),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.normal,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList(),
        ),
        16.height,
        Text(selectedDiscountType == 'Fixed' ? 'Fixed Price' : 'Percentage',
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: textPrimaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          ),),
        8.height,
        StyledTextField(
          textFieldType: TextFieldType.NUMBER,
          hintText:selectedDiscountType == 'Fixed' ? 'Enter Price' : 'Enter Percentage',
          // prefixText: '${widget.productData?.currency ?? 'KES'}',
          focusNode: discountFocusNode,
          controller: discountController,
          onChanged: (value) {
            calculateDiscount(value);
          },
        ),
      ],
    );
  }

  Widget addCartCount(CartViewModel cartViewModel) {

    final cartItem = cartViewModel.findItem(widget.productData?.id ?? '');
    final quantity = cartItem?.quantity ?? 0;
    final discount = cartItem?.discount ?? 0;
    final isSelected = quantity > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Minus button
          InkWell(
            onTap:() =>  onDecrease(quantity, cartViewModel, widget.productData!),
            onLongPress:() => {
            cartViewModel.removeItem(widget.productData?.id ?? ''),
            },
            child: Container(
              width: 60,
              height: 60,
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
          const SizedBox(width: 16),
          // Quantity
          Container(
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: lightGreyColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              key: ValueKey('quantity_${widget.productData?.id}_$quantity'),
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
                      widget.productData?.id ?? '',
                      widget.productData?.productName ?? '',
                      widget.productData?.productPrice?.toDouble() ?? 0.0,
                      widget.productData?.imagePath ?? '',
                      widget.productData?.currency ?? '',
                      widget.productData?.productCategory ?? '',
                      0,
                      quantity: newQuantity,
                    );
                  } else {
                    // Update existing item
                    cartViewModel.updateQuantity(
                        widget.productData?.id ?? '', newQuantity,);
                  }
                } else if (value.isEmpty) {
                  // Don't remove item if field is just empty (user might be typing)
                  return;
                } else {
                  // Remove item if quantity is 0 or invalid
                  cartViewModel.removeItem(widget.productData?.id ?? '');
                }
                onQuantityChange(newQuantity);
              },
            ),
          ),
          const SizedBox(width: 16),
          // Plus button
          InkWell(
            onTap: () => onIncrease(quantity, cartViewModel, widget.productData!),
            onLongPress: () => onIncrease(quantity, cartViewModel, widget.productData!),
            child: Container(
              width: 60,
              height: 60,
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
    );
  }

  Widget addProductHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${widget.productData?.productName}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
              ),
              Row(
                children: [
                  Text('${widget.productData?.productCategory}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.12,

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
                  Text('Selling Price: ${widget.productData?.currency} ${widget.productData?.productPrice}',
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
              ),
            ],
          ),
        ),
        rfCommonCachedNetworkImage(
          widget.productData?.imagePath ?? '',
          fit: BoxFit.cover,
          height: 42,
          width: 42,
        ),
      ],
    );
  }

  Widget buttonsView({required CartViewModel cartViewModel}) {
    return Column(
      children: [
        16.height,
        Row(
          children: [
            Expanded(
              child: outlineButton(
                  text: 'Cancel',
                  onTap: () => Navigator.pop(context),
                  context: context,
                  borderColor: googleRed,
                  textColor: googleRed,),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: appButton(text: 'Add', onTap: () {
                final cartItem = cartViewModel.findItem(widget.productData?.id ?? '');
                final quantity = cartItem?.quantity ?? 1;

                if (quantity <= 0) {
                  showCustomToast('Please enter a valid quantity.');
                  return;
                }
                if (discountAmount <= 0) {
                  showCustomToast("Please enter a valid discount ${selectedDiscountType == 'Fixed' ? 'amount' : 'percentage'}.");
                  return;
                }
                cartViewModel.updateDiscount(widget.productData?.id, discountAmount, quantity);
                showCustomToast("A discount of ${selectedDiscountType == 'Fixed' ? '${widget.productData?.currency ?? 'KES'} $discountAmount' : '$discountAmount%'} has been applied to ${widget.productData?.productName ?? ''}.", isError: false);
                Navigator.pop(context);
              }, context: context,),
            ),
          ],
        ),
      ],
    );
  }
}
