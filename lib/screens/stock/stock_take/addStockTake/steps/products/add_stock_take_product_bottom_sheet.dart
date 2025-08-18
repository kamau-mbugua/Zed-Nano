
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/listStockTake/GetActiveStockTakeResponse.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/base_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/viewmodels/add_stock_take_viewmodel.dart';

class AddStockTakeProductBottomSheet extends StatefulWidget {
  AddStockTakeProductBottomSheet({required this.product, super.key});
  StockTakeProduct product;

  @override
  _AddStockTakeProductBottomSheetState createState() =>
      _AddStockTakeProductBottomSheetState();
}

class _AddStockTakeProductBottomSheetState
    extends State<AddStockTakeProductBottomSheet> {
  late int totalStock;
  final FocusNode expectedValueFocusNode = FocusNode();
  final FocusNode newActualValueFocusNode = FocusNode();
  final TextEditingController newActualValueController = TextEditingController();
  late TextEditingController expectedValueController;

  @override
  void initState() {
    super.initState();
    expectedValueController = TextEditingController(text: widget.product.expectedQuantity.toString());
  }

  @override
  void dispose() {
    expectedValueFocusNode.dispose();
    newActualValueFocusNode.dispose();
    newActualValueController.dispose();
    expectedValueController.dispose();
    super.dispose();
  }
  void onAddStockTap(
      StockTakeProduct product,
      String newActualValue,
      ) {
   Provider.of<AddStockTakeViewModel>(context, listen: false)
    .addItem(
        quantity: double.parse(newActualValue),
        productId:product.id.toString(),
        productName: product.productName.toString(),
        expectedQuantity: double.parse(product.expectedQuantity.toString()),
        imagePath : product.imagePath.toString(),
    );
   Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return BaseBottomSheet(
      title: 'Update Stock',
      initialChildSize: 0.75,
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
              'Expected Value',
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
              focusNode: expectedValueFocusNode,
              nextFocus: newActualValueFocusNode,
              controller: expectedValueController,
              isActive: false, // Set to false to make the field read-only/disabled
            ),
            10.height,
            const Text(
              'New Actual Value',
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
              focusNode: newActualValueFocusNode,
              controller: newActualValueController,
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
                    text: 'Save',
                    onTap: () {
                      final newActualValue = newActualValueController.text;
                      if (!newActualValue.isValidInput) {
                        showCustomToast(
                          'Please enter valid New Actual Value',);
                        return;
                      }
                      onAddStockTap(product, newActualValue);
                    },
                    context: context,
                  ),
                ),
              ],
            ),
            16.height
          ],
        ),
      ),
    );
  }
}
