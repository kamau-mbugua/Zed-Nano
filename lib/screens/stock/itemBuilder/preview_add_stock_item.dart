import 'package:flutter/material.dart';
import 'package:zed_nano/models/get_add_stock_products_batch/StockBatchDetail.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/viewmodels/add_stock_take_viewmodel.dart';
import 'package:zed_nano/viewmodels/add_stock_viewmodel.dart';

Widget previewAddStockItem({
  required AddStockCartItem item,
  required AddStockViewModel cartViewModel,

}) {
  return Container(
    margin: const EdgeInsets.only(),
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
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
                item.productName ?? '',
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
                    item.category ?? '',
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
                    '${item.oldStock}',
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
            Text('+${item.quantity} Items',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: successTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
            ),
            Text('${item.total} Items',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: textPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
            ),
          ],
        ),

        InkWell(
          onTap: () {
            cartViewModel.removeItem(item.productId);
          },
          child: const SizedBox(
            width: 24,
            height: 24,
            child: Center(
              child: Icon(
                Icons.remove,
                color: accentRed,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


Widget previewAddStockTakeItem({
  required AddStockTakeCartItem item,
  required AddStockTakeViewModel cartViewModel,

}) {
  return Container(
    margin: const EdgeInsets.only(),
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
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
                item.productName ?? '',
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
                    'Expected:${item.expectedQuantity}',
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
                    'Actual:${item.quantity}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      color: successTextColor,
                      fontWeight: FontWeight.w600,

                    ),
                  ),
                ],
              ),
              Text('Variance: ${item.variation}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,


                  ),
              ),
            ],
          ),
        ),

        InkWell(
          onTap: () {
            cartViewModel.removeItem(item.productId);
          },
          child: const SizedBox(
            width: 24,
            height: 24,
            child: Center(
              child: Icon(
                Icons.remove,
                color: accentRed,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


Widget viewBatchProductItem({
  required StockItem item,
}) {
  return Container(
    margin: const EdgeInsets.only(),
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Row(
          children: [
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
                    item.productName ?? '',
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
                        item.category ?? '',
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
                        '${item.inStockQuantity}',
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
                Text('+${item.newQuantity} Items',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: successTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                ),
                Text('${item.newQuantity} Items',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                ),
              ],
            ),
          ],
        ),
        Divider(
          height: 1,
          color: Colors.grey.shade300,
        ),
      ],
    ),
  );
}


Widget viewBatchStockTakeProductItem({
  required StockItem item,
}) {
  return Container(
    margin: const EdgeInsets.only(),
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Row(
          children: [
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
                    item.productName ?? '',
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
                        'Expected: ${item.expectedQuantity}' ?? 'N/A',
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
                        'Actual: ${item.newQuantity}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          color: successTextColor,
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
                const Text('',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: successTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                ),
                Text('Variance: ${item.variance}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: textPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                ),
              ],
            ),
          ],
        ),
        Divider(
          height: 1,
          color: Colors.grey.shade300,
        ),
      ],
    ),
  );
}


/*void _deleteCategory() {
  showCustomDialog(
    context: context,
    title: 'Delete Category',
    subtitle: 'Are you sure you want to delete this category? This action cannot be undone.',
    positiveButtonText: 'Delete',
    negativeButtonText: 'Cancel',
    positiveButtonColor: accentRed,
    onPositivePressed: () async {
      Navigator.pop(context); // Close dialog
      final businessId = getBusinessDetails(context)?.businessId;
      if (widget.categoryId.isNotEmpty) {
        final Map<String, dynamic> requestData = {
          'categoryState': 'Inactive',
          'categoryId': widget.categoryId,
        };

        try {
          final response = await context.read<BusinessProviders>().updateCategory(
            requestData: requestData,
            context: context,
          );
          if (response.isSuccess) {
            showCustomToast('Category deleted successfully', isError: false);
            Navigator.pop(context); // Go back to categories page
          } else {
            showCustomToast(response.message ?? 'Failed to delete category');
          }
        } catch (e) {
          showCustomToast('An error occurred while deleting category');
        }
      }
    },
  );
}*/
