
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/get_all_activeStock/GetAllActiveStockResponse.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/base_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/viewmodels/add_stock_viewmodel.dart';

class AddStockProductBottomSheet extends StatefulWidget {
  AddStockProductBottomSheet({required this.product, super.key});
  ActiveStockProduct product;

  @override
  _AddStockProductBottomSheetState createState() =>
      _AddStockProductBottomSheetState();
}

class _AddStockProductBottomSheetState
    extends State<AddStockProductBottomSheet> {
  late int totalStock;
  final FocusNode stockReceivedFocusNode = FocusNode();
  final FocusNode buyingPriceFocusNode = FocusNode();
  final FocusNode sellingPriceFocusNode = FocusNode();
  final TextEditingController stockReceivedController = TextEditingController();
  late TextEditingController buyingPriceController;
  late TextEditingController sellingPriceController;



  @override
  void initState() {
    super.initState();
    totalStock = widget.product.inStockQuantity ?? 0;
    buyingPriceController = TextEditingController(text: widget.product.buyingPrice.toString());
    sellingPriceController = TextEditingController(text: widget.product.sellingPrice.toString());
  }

  @override
  void dispose() {
    stockReceivedFocusNode.dispose();
    buyingPriceFocusNode.dispose();
    sellingPriceFocusNode.dispose();
    stockReceivedController.dispose();
    buyingPriceController.dispose();
    sellingPriceController.dispose();
    super.dispose();
  }

  void onStockReceivedChanged(String value) {
    if (value.isNotEmpty) {
      final newStockReceived = int.tryParse(value) ?? 0;
      setState(() {
        totalStock = newStockReceived + (widget.product.inStockQuantity ?? 0);
      });
    } else {
      setState(() {
        totalStock = widget.product.inStockQuantity ?? 0;
      });
    }
  }

  void onAddStockTap(
      ActiveStockProduct product,
      String receivedStock,
      String buyingPrice,
      String sellingPrice,
      ) {
   Provider.of<AddStockViewModel>(context, listen: false)
    .addItem(
        quantity: double.parse(receivedStock),
        productId:product.id.toString(),
        productName: product.productName.toString(),
        buyingPrice: double.parse(buyingPrice),
        oldStock: product.inStockQuantity?.toDouble() ?? 0.0,
        sellingPrice : double.parse(sellingPrice),
        imagePath : product.imagePath.toString(),
        currency : product.currency.toString(),
        category : product.productCategory.toString(),
    );

   Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    const subtitle = 'Add a product to your inventory';

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

    return BaseBottomSheet(
      title: 'Add Stock',
      initialChildSize: 0.8,
      headerContent: subtitle != null
          ? const Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
          color: Color(0xff71727a),
        ),
      )
          : null,
      bodyContent: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(product.productName ?? '',
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
                          Text(
                            '${product.productCategory}',
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
                rfCommonCachedNetworkImage(
                  product.imagePath ?? '',
                  fit: BoxFit.cover,
                  height: 42,
                  width: 42,
                ),
              ],
            ),
            16.height,
            const Text(
              'Stock Received',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Color(0xFF484848),
              ),
            ),
            const SizedBox(height: 8),
            StyledTextField(
              textFieldType: TextFieldType.NUMBER,
              hintText: '0',
              focusNode: stockReceivedFocusNode,
              nextFocus: buyingPriceFocusNode,
              controller: stockReceivedController,
              onChanged: onStockReceivedChanged,
            ),
            10.height,
            const Text(
              'Buying Price',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Color(0xFF484848),
              ),
            ),
            const SizedBox(height: 8),
            StyledTextField(
              textFieldType: TextFieldType.NUMBER,
              hintText: '',
              prefixText: product.currency ?? 'KES',
              focusNode: buyingPriceFocusNode,
              nextFocus: sellingPriceFocusNode,
              controller: buyingPriceController,
            ),
            10.height,
            const Text(
              'Selling Price',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Color(0xFF484848),
              ),
            ),
            const SizedBox(height: 8),
            StyledTextField(
              textFieldType: TextFieldType.NUMBER,
              hintText: '',
              prefixText: product.currency ?? 'KES',
              focusNode: sellingPriceFocusNode,
              controller: sellingPriceController,
            ),
            16.height,
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightGreenColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:successTextColor,
                ),
              ),
              child: Text('New Stock: $totalStock',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: successTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
              ),
            ),
            16.height,
            Row(
              children: [
                Expanded(
                  child: outlineButton(
                    text: 'Cancel',
                    onTap: () => Navigator.pop(context),
                    context: context,
                    borderColor: googleRed,
                    textColor: googleRed,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: appButton(
                    text: 'Add',
                    onTap: () {
                      final receivedStock = stockReceivedController.text;
                      if (!receivedStock.isValidInput) {
                        showCustomToast(
                          'Please enter valid Stock Received',);
                        return;
                      }


                      final buyingPrice = buyingPriceController.text;
                      if (!buyingPrice.isValidInput) {
                        showCustomToast(
                          'Please enter valid Buying Price',);
                        return;
                      }

                      final sellingPrice = sellingPriceController.text;
                      if (!sellingPrice.isValidInput) {
                        showCustomToast(
                          'Please enter valid Selling Price',);
                        return;
                      }

                      onAddStockTap(product, receivedStock, buyingPrice, sellingPrice);
                    },
                    context: context,
                  ),
                ),
              ],
            ),
            20.height
          ],
        ),
      ),
    );
  }
}
