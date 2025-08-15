import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart' hide navigatorKey;
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/approvals/add_stock/add_stock_approval_page.dart';
import 'package:zed_nano/screens/stock/itemBuilder/preview_add_stock_item.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/GifsImages.dart';
import 'package:zed_nano/viewmodels/add_stock_viewmodel.dart';

class AddStockPreviewPage extends StatefulWidget {
  const AddStockPreviewPage({required this.onNext, required this.onPrevious, super.key});
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  State<AddStockPreviewPage> createState() => _AddStockPreviewPageState();
}

class _AddStockPreviewPageState extends State<AddStockPreviewPage> {
  final TextEditingController _narrationController = TextEditingController();

  @override
  void dispose() {
    _narrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<AddStockViewModel>(context);
    final cartItems = cartViewModel.items;
    const totalAmount = 0.0;
    final itemCount = cartViewModel.itemCount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(
        title: 'Preview Batch',
        onBackPressed: widget.onPrevious,
        actions: [
          TextButton(
            onPressed: () {
              widget.onPrevious();
            },
            child: const Text(
              'Add Products',
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
          Container(
            width: context.width(),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Batch No: --|--',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                  ),

                ],
              ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$itemCount Products added',
                      style: const TextStyle(
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
                          color: textPrimary,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const Text('Tap on a product to edit.',
                    style: TextStyle(
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
                return previewAddStockItem(
                  item: item,
                  cartViewModel: cartViewModel,
                );
              },
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
                const SizedBox(height: 16),
                SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: appButton(text: 'Submit Batch', onTap: (){
                      final payload = {
                        'supplierId': '',
                        'warehouseId':'',
                        'products': cartViewModel.items.map((item) => item.toJson()).toList(),
                      };

                      logger.d(payload);

                      getBusinessProvider(context).addStockRequest(
                          requestData: payload,
                          context: context,
                      ).then((value) {
                        if(value.isSuccess){
                          cartViewModel.clear();
                          widget.onNext();
                          showCustomToast(value.message, isError: false, actionText: 'Approve', onPressed: (){
                            Future.delayed(const Duration(milliseconds: 500), () {
                              navigatorKey.currentState?.push(
                                MaterialPageRoute(builder: (context) => const AddStockApprovalPage()),
                              );
                            });
                          });
                        }else{
                          showCustomToast(value.message);
                        }
                      });

                    }, context: context,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
