import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/business/BusinessDetails.dart';
import 'package:zed_nano/models/getVariablePriceStatus/GetVariablePriceStatusResponse.dart';
import 'package:zed_nano/models/listCategories/ListCategoriesResponse.dart';
import 'package:zed_nano/models/listProducts/ListProductsResponse.dart';
import 'package:zed_nano/models/unitofmeasure/UnitOfMeasureResponse.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/screens/widget/common/sub_category_picker.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/utils/image_picker_util.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';
import 'package:path/path.dart' as p;
import 'package:http_parser/http_parser.dart';


class EditProductPage extends StatefulWidget {
  final String? productId;

  const EditProductPage({
    super.key,
    required this.productId,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  FocusNode productNameFocusNode = FocusNode();
  FocusNode productAmountFocusNode = FocusNode();
  FocusNode productRestockFocusNode = FocusNode();
  FocusNode productDescriptionFocusNode = FocusNode();
  FocusNode buyingPriceFocusNode = FocusNode();

  TextEditingController productNameController = TextEditingController();
  TextEditingController buyingPriceController = TextEditingController();
  TextEditingController productAmountController = TextEditingController();
  TextEditingController productRestockController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  String? selectedCategory;
  String? productService;
  String? selectedUnitOfMeasure;
  String? selectedPriceStatus;
  bool isWeightedProduct = false;
  List<ProductCategoryData>? productCategoryDataList;
  List<String>? unitOfMeasureResponse;
  List<VariablePriceStatus>? variablePriceStatus;

  File? _logoImage;

  BusinessDetails? businessDetails;

  ProductData? _productData;

  String? selectedProductService;




  Future<void> _pickImage() async {
    final pickedImage = await ImagePickerUtil.pickImage(
      context: context,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (pickedImage != null) {
      setState(() {
        _logoImage = pickedImage;
      });
    }
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
          productNameController.text = _productData?.productName ?? '';
          productDescriptionController.text = _productData?.productDescription ?? '';
          productAmountController.text = _productData?.productPrice?.toString() ?? '0';
          buyingPriceController.text = _productData?.buyingPrice?.toString() ?? '0';
          productRestockController.text = _productData?.reorderLevel?.toString() ?? '0';
          selectedPriceStatus = _productData?.priceStatus;
          selectedUnitOfMeasure = _productData?.unitOfMeasure;
          isWeightedProduct = _productData?.isWeightedProduct ?? false;
          selectedCategory = _productData?.productCategory;
          productService = _productData?.productService; // Use passed productService if available
          selectedProductService = _productData?.productService;

        });
      } else {
        showCustomToast(response.message ?? 'Failed to load product details');
      }
    } catch (e) {
      showCustomToast('Failed to load product details');
    }
  }

  Future<void> _updateProduct(Map<String, dynamic> requestData) async {
    requestData['productId'] = widget.productId;
    await context
        .read<BusinessProviders>()
        .updateProduct(requestData: requestData, context: context)
        .then((value) {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Product updated successfully',
            isError: false);
        if (_logoImage != null) {
          _uploadBusinessLogo(widget.productId);
        } else {
          Navigator.pop(context, true);
        }
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  Future<void> _uploadBusinessLogo(String? serviceId) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        _logoImage!.path,
        filename: p.basename(_logoImage!.path),
        contentType: MediaType('image', 'jpeg'), // or png
      ),
      'businessNumber': businessDetails?.businessNumber
    });

    final urlPart = '?serviceId=${_productData?.productId}';

    await context
        .read<BusinessProviders>()
        .uploadProductCategoryImage(context: context, formData: formData!, urlPart:urlPart)
        .then((value) async {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Image uploaded successfully',
            isError: false);
        Navigator.pop(context, true); // Pass true to indicate successful creation

      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }


  @override
  void initState() {
    businessDetails = getBusinessDetails(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await listBusinessCategory();
      await getUnitOfMeasure();
      await getVariablePriceStatus();
      await _fetchProductDetails();
    });
    super.initState();
  }

  Future<void> listBusinessCategory() async {

    await context
        .read<BusinessProviders>()
        .getListCategories(
        context: context,
        page: 1,
        limit: 10000,
        searchValue: '',
        productService: productService ?? '')
        .then((value) async {
      if (value.isSuccess) {
        setState(() {
          productCategoryDataList = value.data!.data;

          // If we have a selectedCategory from the arguments, validate it exists in the loaded categories
          if (selectedCategory != null) {
            final categoryExists = productCategoryDataList?.any(
                    (category) => category.categoryName == selectedCategory) ?? false;

            if (categoryExists) {
              selectedCategory = selectedCategory;
            }
          }
        });
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  Future<void> getUnitOfMeasure() async {
    await context
        .read<BusinessProviders>()
        .getUnitOfMeasure(context: context)
        .then((value) {
      if (value.isSuccess) {
        setState(() {
          unitOfMeasureResponse = value.data!.data;
        });
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  Future<void> getVariablePriceStatus() async {
    await context
        .read<BusinessProviders>()
        .getVariablePriceStatus(context: context)
        .then((value) {
      if (value.isSuccess) {
        setState(() {
          variablePriceStatus = value.data!.data;
        });
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  @override
  void dispose() {
    productNameController.dispose();
    productAmountController.dispose();
    productRestockController.dispose();
    productDescriptionController.dispose();

    productNameFocusNode.dispose();
    productAmountFocusNode.dispose();
    productRestockFocusNode.dispose();
    productDescriptionFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AuthAppBar(title: 'Edit Product or Service'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            // Category Name
            headings(
              label: 'Edit ${selectedProductService?.toLowerCase() != 'service' ? 'Product' : 'Service'}',
              subLabel: 'Enter ${selectedProductService?.toLowerCase() != 'service' ? 'Product' : 'Service'} details.',
            ),
            _formFields(),
            _uploadImage(),
            const SizedBox(height: 32),
            appButton(
              text: 'Save Changes',
              context: context,
              onTap: () {
                var categoryId = selectedCategory;
                var prodctName = productNameController.text;
                var productAmount = productAmountController.text;
                var productRestock = productRestockController.text;
                var productDescription = productDescriptionController.text;

                // Safely find productService or use the existing one
                String? productService;
                if (productCategoryDataList != null && selectedCategory != null) {
                  try {
                    final matchingCategory = productCategoryDataList!.firstWhere(
                          (element) => element.categoryName == selectedCategory,
                      orElse: () => ProductCategoryData(),
                    );
                    productService = matchingCategory.productService;
                  } catch (e) {
                    // If there's still an error, use the existing product service
                    productService = this.productService;
                  }
                } else {
                  // If no categories or selection, keep existing service
                  productService = this.productService;
                }

                var unitOfMeasure =  selectedUnitOfMeasure;
                var priceStatus =  selectedPriceStatus;
                var buyingPrice =  buyingPriceController.text;

                if(categoryId == null){
                  showCustomToast('Please select category', isError: true);
                  return;
                }
                if(productService == null){
                  showCustomToast('Please select category', isError: true);
                  return;
                }
                if(!prodctName.isValidInput){
                  showCustomToast('Please enter product name', isError: true);
                  return;
                }
                if(!productAmount.isValidInput){
                  showCustomToast('Please enter product selling price amount', isError: true);
                  return;
                }
                if(!buyingPrice.isValidInput){
                  showCustomToast('Please enter product buying price amount', isError: true);
                  return;
                }
                if(unitOfMeasure == null && selectedProductService?.toLowerCase() != 'service'){
                  showCustomToast('Select unit of measure', isError: true);
                  return;
                }
                if(priceStatus == null){
                  showCustomToast('Select price status', isError: true);
                  return;
                }

                Map<String, dynamic> requestData = {
                  'categoryId': categoryId,
                  'productName': prodctName,
                  'productPrice': productAmount,
                  'reorderLevel': productRestock,
                  'productDescription': productDescription,
                  'businessId': businessDetails?.businessId,
                  'productService': productService,
                  'unitOfMeasure': unitOfMeasure,
                  'priceStatus': priceStatus,
                  'buyingPrice': buyingPrice,
                  'productStatus': 'Active',
                };

                requestData['isWeightedProduct'] = isWeightedProduct;
                requestData['consumable'] = false;

                _updateProduct(requestData);

              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _formFields() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xFF484848),
            ),
          ),
          const SizedBox(height: 8),
          SubCategoryPicker(
            label: 'Select Category',
            options: productCategoryDataList?.map((e) => e.categoryName ?? '').toList() ?? [],
            selectedValue: selectedCategory,
            onChanged: (value) {
              final selectedCat = value;
              setState(() {
                selectedCategory = selectedCat;
                productService = productCategoryDataList?.firstWhere((element) => element.categoryName == selectedCategory).productService;
                selectedProductService = productCategoryDataList?.firstWhere((element) => element.categoryName == selectedCategory).productService;
              });
            },
          ),
          16.height,
          // Product Name
           Text(
            '${selectedProductService?.toLowerCase() != 'service' ? 'Product' : 'Service'} Name',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xFF484848),
            ),
          ),
          const SizedBox(height: 8),
          StyledTextField(
            textFieldType: TextFieldType.NAME,
            hintText: '${selectedProductService?.toLowerCase() != 'service' ? 'Product' : 'Service'} Name',
            focusNode: productNameFocusNode,
            nextFocus: productDescriptionFocusNode,
            controller: productNameController,
          ),
          16.height,
          const Row(
            children: [
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xFF1F2024),
                ),
              ),
              SizedBox(width: 8),
              Text(
                '(Optional)',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF8F90A6),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          StyledTextField(
            textFieldType: TextFieldType.NAME,
            hintText: 'Description',
            focusNode: productDescriptionFocusNode,
            controller: productDescriptionController,
            nextFocus: productAmountFocusNode,
          ),
          16.height,
           Text(
            '${selectedProductService?.toLowerCase() != 'service' ? 'Product' : 'Service'} Price Type',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Color(0xFF484848),
            ),
          ),
          const SizedBox(height: 8),
          SubCategoryPicker(
            label: 'Select Price Type',
            options:variablePriceStatus?.map((e) => e.priceStatusName ?? '').toList() ??
                [],
            selectedValue: selectedPriceStatus,
            onChanged: (value) {
              final selectedCat = value;
              setState(() {
                selectedPriceStatus = selectedCat;
                selectedProductService = productCategoryDataList?.firstWhere((element) => element.categoryName == selectedCategory).productService;
              });
            },
          ),
          // Show weighted product controls only when price type contains 'variable'
          if ((selectedPriceStatus?.toLowerCase().contains('variable') ?? false) && selectedProductService?.toLowerCase() != 'service') ...[
            16.height,
            const Text(
              'Weighted product',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Color(0xFF484848),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: isWeightedProduct,
                  onChanged: (checked) {
                    setState(() {
                      isWeightedProduct = checked ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("This is weighted product."),
                      Text(
                        "Product price will adjust based on weight when sold.",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
          selectedProductService?.toLowerCase() != 'service' ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Unit of Measure',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xFF484848),
                ),
              ),
              const SizedBox(height: 8),
              SubCategoryPicker(
                label: 'Select Unit of Measure',
                options:unitOfMeasureResponse?.map((e) => e ?? '').toList() ?? [],
                selectedValue: selectedUnitOfMeasure,
                onChanged: (value) {
                  final selectedCat = value;
                  setState(() {
                    selectedUnitOfMeasure = selectedCat;
                  });
                },
              ),

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
                textFieldType: TextFieldType.NAME,
                hintText: 'Selling Price',
                focusNode: productAmountFocusNode,
                nextFocus: buyingPriceFocusNode,
                controller: productAmountController,
              ),
              16.height,

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
                textFieldType: TextFieldType.NAME,
                hintText: 'Buying Price',
                focusNode: buyingPriceFocusNode,
                nextFocus: productRestockFocusNode,
                controller: buyingPriceController,
              ),
              16.height,
              const Row(
                children: [
                  Text(
                    'Restock Level',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Color(0xFF1F2024),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '(Optional)',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF8F90A6),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              StyledTextField(
                textFieldType: TextFieldType.NAME,
                hintText: 'Restock Level',
                focusNode: productRestockFocusNode,
                nextFocus: productDescriptionFocusNode,
                controller: productRestockController,
              ),
              4.height,
              const Text(
                'Get notified when stock is below this value.',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  color: Color(0xFFB5B7C0),
                ),
              ),
            ],
          ):
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Price',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xFF484848),
                ),
              ),
              const SizedBox(height: 8),
              StyledTextField(
                textFieldType: TextFieldType.NAME,
                hintText: 'Price',
                focusNode: productAmountFocusNode,
                nextFocus: buyingPriceFocusNode,
                controller: productAmountController,
              ),
              16.height,
            ],
          ),

          const SizedBox(height: 24),
        ]);
  }
  Widget _uploadImage() {
    return GestureDetector(
      onTap: _pickImage,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(16),
            ),
            child:_logoImage != null ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                _logoImage!,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ) :  rfCommonCachedNetworkImage(
              _productData?.imagePath ?? '',
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
              radius: 12,
              usePlaceholderIfUrlEmpty: false,
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Add Image',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Color(0xFF1F2024),
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '(Optional)',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      color: Color(0xFF1F2024),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Select an image from your gallery or take a photo.',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: Color(0xFF8A8D9F),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
