import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/models/listProducts/ListProductsResponse.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_dialog.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';

class ProductDetailPage extends StatefulWidget {

  const ProductDetailPage({super.key, this.productId});
  final String? productId;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ProductData? _productData;

  @override
  void initState() {
    super.initState();
    // Schedule API call for after the current build phase completes
    Future.microtask(_fetchProductDetails);
  }

  Future<void> _fetchProductDetails() async {
    try {
      final requestData = <String, dynamic>{
        'productId': widget.productId,
      };

      final response =
          await Provider.of<BusinessProviders>(context, listen: false)
              .getProductById(requestData: requestData, context: context);

      if (response.isSuccess) {
        setState(() {
          _productData = response.data!.data;
        });
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load product details');
    }
  }



  void _deleteCategory() {
    showCustomDialog(
      context: context,
      title: 'Delete ${_productData?.productService?.toLowerCase() != 'service' ? 'Product' : 'Service'}',
      subtitle: 'Are you sure you want to delete this ${_productData?.productService?.toLowerCase() != 'service' ? 'Product' : 'Service'}? This action cannot be undone.',
      positiveButtonText: 'Delete',
      negativeButtonText: 'Cancel',
      positiveButtonColor: accentRed,
      onPositivePressed: () async {
        Navigator.pop(context); // Close dialog
        final requestData = <String, dynamic>{
          'productState': 'Inactive',
          'productId': widget.productId,
        };

        try {
          final response = await context.read<BusinessProviders>().updateProduct(
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
      },
    );
  }

  void _navigateToEditProduct() {
    Navigator.pushNamed(context, AppRoutes.getEditProductRoute(widget.productId ?? '')).then((_) async {
      await _fetchProductDetails();
    });  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(
        title: 'View ${_productData?.productService?.toLowerCase() != 'service' ? 'Product' : 'Service'}',
        actions: [
          TextButton(
            onPressed: _deleteCategory,
            child: const Text('Delete', style: TextStyle(color: accentRed)),
          ),
        ],
      ),
      body: _buildProductDetailContent(),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildProductDetailContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildProductHeader(),
            const SizedBox(height: 24),
            _buildDescriptionSection(
              topTitleString: 'Description',
              bottomSubtitle: _productData?.productDescription ??
                  'Description not available',
            ),
            const SizedBox(height: 24),
            _buildTwoColumnSection(
              leftTitle: 'Price Type',
              leftSubtitle: _productData?.priceStatus ?? 'N/A',
              rightTitle: _productData?.productService?.toLowerCase() != 'service' ? 'Unit of Measure' : 'Price',
              rightSubtitle: _productData?.productService?.toLowerCase() != 'service' ? _productData?.unitOfMeasure ?? 'Kilogram (kg)' : '${_productData?.currency ?? 'KES'} ${_productData?.productPrice?.formatCurrency() ?? '0'}',
            ),
            const SizedBox(height: 24),
            Visibility(
              visible: _productData?.productService?.toLowerCase() != 'service',
              child: _buildTwoColumnSection(
                leftTitle: 'Selling Price',
                leftSubtitle:
                    '${_productData?.currency ?? 'KES'} ${_productData?.productPrice ?? '0'}',
                rightTitle: 'Buying Price',
                rightSubtitle:
                    '${_productData?.currency ?? 'KES'} ${_productData?.buyingPrice ?? '200'}',
              ),
            ),
            const SizedBox(height: 24),
            Visibility(
              visible: _productData?.productService?.toLowerCase() != 'service',
              child: _buildTwoColumnSection(
                leftTitle: 'Weighted Product',
                leftSubtitle:
                    _productData?.isWeightedProduct == true ? 'Yes' : 'No',
                rightTitle: 'Restock Level',
                rightSubtitle: _productData?.reorderLevel != null
                    ? 'Notify below ${_productData?.reorderLevel}'
                    : 'Not set',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image holder with border
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: rfCommonCachedNetworkImage(
              _productData?.imagePath,
              fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        // Product name and category
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _productData?.productName ?? '${_productData?.productService?.toLowerCase() != 'service' ? 'Product' : 'Service'} Name',
              style: const TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _productData?.productCategory ?? 'N/A',
              style: const TextStyle(
                color: textSecondary,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection({
    required String topTitleString,
    required String bottomSubtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cardBackgroundColor,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topTitleString,
            style: const TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            bottomSubtitle,
            style: const TextStyle(
              color: textSecondary,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTwoColumnSection({
    required String leftTitle,
    required String leftSubtitle,
    required String rightTitle,
    required String rightSubtitle,
  }) {
    return Row(
      children: [
        // Left column
        Expanded(
          child: _buildDescriptionSection(
            topTitleString: rightTitle,
            bottomSubtitle: rightSubtitle,
          ),
        ),
        const SizedBox(width: 15),
        // Right column
        Expanded(
          child: _buildDescriptionSection(
            topTitleString: leftTitle,
            bottomSubtitle: leftSubtitle,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: outlineButton(
          text: 'Edit ${_productData?.productService?.toLowerCase() != 'service' ? 'Product' : 'Service'}',
          onTap: _navigateToEditProduct,
          context: context,),
    );
  }
}
