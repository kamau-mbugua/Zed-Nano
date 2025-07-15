import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/product_model.dart';
import 'package:zed_nano/providers/cart/CartViewModel.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/searchview.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/GifsImages.dart';

class CartPreviewPage extends StatefulWidget {
  const CartPreviewPage({Key? key}) : super(key: key);

  @override
  State<CartPreviewPage> createState() => _CartPreviewPageState();
}

class _CartPreviewPageState extends State<CartPreviewPage> {
  final TextEditingController _narrationController = TextEditingController();

  @override
  void dispose() {
    _narrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);
    final cartItems = cartViewModel.items;
    final totalAmount = cartViewModel.totalAmount;
    final itemCount = cartViewModel.itemCount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(
        title: 'Preview Cart',
        actions: [
          TextButton(
            onPressed: () {
              // Add items action
            },
            child: const Text(
              'Add Items',
              style: TextStyle(
                color: accentRed,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          // Your Items section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Items',
                  style: TextStyle(
                    color: textPrimary,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: cartViewModel.clear,
                  child: const Text(
                    'Clear Cart',
                    style: TextStyle(
                      color: textSecondary,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          16.height,
          // Cart items list
          Expanded(
            child: cartItems.isEmpty
                ? const Center(
                    child: CompactGifDisplayWidget(
                      gifPath: emptyListGif,
                      title: "It's empty, over here.",
                      subtitle:
                      'No products in your cart yet! Add to view them here.',
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) => const Divider(height: 0.5, color: innactiveBorderCart,),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return _buildCartItem(
                        item: item,
                        cartViewModel: cartViewModel,
                        onDecrease: () {
                        if (item.quantity > 0) {
                          if (item.quantity == 1) {
                            cartViewModel.removeItem(item.id ?? '');
                          } else {
                            cartViewModel.updateQuantity(
                                item.id ?? '', item.quantity - 1);
                          }
                        }
                      },
                        onIncrease: () {
                          if (item.quantity == 0) {
                            cartViewModel.addItem(
                              item.id ?? '',
                              item.name ?? '',
                              item.price?.toDouble() ?? 0.0,
                              item.imagePath ?? '',
                              item.currency ?? '',
                              item.category ?? '',
                            );
                          } else {
                            cartViewModel.updateQuantity(
                                item.id ?? '', item.quantity + 1);
                          }
                        },);
                    },
                  ),
          ),
          
          // Narration section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Narration',
                      style: TextStyle(
                        color: textPrimary,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(Optional)',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _narrationController,
                  decoration: InputDecoration(
                    hintText: 'Enter narration...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: darkBlueColor),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          
          // Bottom section with total and checkout button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                // Total amount card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F9F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$itemCount Items',
                        style: const TextStyle(
                          color: textPrimary,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'KES ${totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: success,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Checkout button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: appButton(text: "Checkout", onTap: (){}, context: context)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem({
    required CartItem item,
    required CartViewModel cartViewModel,
    required VoidCallback onDecrease,
    required VoidCallback onIncrease,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          InkWell(
          onTap: () {
            cartViewModel.removeItem(item.id);
          },
          child: Container(
            width: 24,
            height: 24,
            child: const Center(
              child: Icon(
                Icons.remove,
                color: accentRed,
                size: 16,
              ),
            ),
          ),
        ),
          const SizedBox(width: 10),
          rfCommonCachedNetworkImage(
            item.imagePath ?? '',
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
                  item.name ?? '',
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
                      item?.category ?? '',
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
                      '${item.currency} ${item.price}',
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

          // Quantity controls
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  // Minus button
                  InkWell(
                    onTap: onDecrease,
                    child: Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: lightGreyColor,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: 8,
                        height: 1.5,
                        color: highlightMainDark,
                      ),
                    ),
                  ),

                  // Quantity
                  Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(
                      item.quantity.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        color: highlightMainDark,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  // Plus button
                  InkWell(
                    onTap: onIncrease,
                    child: Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
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
              const SizedBox(height: 8),

              // Total price
              Text(
                '${item.currency} ${item.total.round()}',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF323232),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
