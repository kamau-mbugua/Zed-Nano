import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/business/BusinessDetails.dart';
import 'package:zed_nano/models/listCategories/ListCategoriesResponse.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/screens/widget/common/sub_category_picker.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/utils/image_picker_util.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';
import 'package:path/path.dart' as p;
import 'package:http_parser/http_parser.dart';


class AddProductScreen extends StatefulWidget {
  final bool doNotUpdate;
  const AddProductScreen({super.key, required this.doNotUpdate});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  FocusNode productNameFocusNode = FocusNode();
  FocusNode productAmountFocusNode = FocusNode();
  FocusNode productRestockFocusNode = FocusNode();
  FocusNode productDescriptionFocusNode = FocusNode();

  TextEditingController productNameController = TextEditingController();
  TextEditingController productAmountController = TextEditingController();
  TextEditingController productRestockController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  String? selectedCategory;
  List<ProductCategoryData>? productCategoryDataList;

  File? _logoImage;

  BusinessDetails? businessDetails;



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


  Future<void> refresh() async {
    try {
      final viewModel = Provider.of<WorkflowViewModel>(context, listen: false);
      await viewModel.skipSetup(context);

      if (mounted) {
        Navigator.pop(context); // Pop current screen
        await Navigator.pushNamed(context, AppRoutes.getListCategoriesRoute());
      }

    } catch (e) {
      logger.e('Error in refresh: $e');
    }
  }

  Future<void> _createCategory(Map<String, dynamic> requestData) async {
    requestData['doNotUpdate'] = widget.doNotUpdate;
    await context
        .read<BusinessProviders>()
        .createProduct(requestData: requestData, context: context)
        .then((value) {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Category created successfully',
            isError: false);
        if (_logoImage != null) {
          _uploadBusinessLogo(value.data?.productId);
        } else {
          refresh();
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

    final urlPart = '?serviceId=$serviceId';

    await context
        .read<BusinessProviders>()
        .uploadProductCategoryImage(context: context, formData: formData!, urlPart:urlPart)
        .then((value) async {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Business logo uploaded successfully',
            isError: false);
        refresh();
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }


  @override
  void initState() {
    businessDetails = getAuthProvider(context).businessDetails;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listBusinessCategory();
    });
    super.initState();
  }

  Future<void> listBusinessCategory() async {
    await context
        .read<BusinessProviders>()
        .getListCategories(context: context, page: 1, limit: 10000, searchValue: '', productService: '')
        .then((value) {
      if (value.isSuccess) {
        setState(() {
          productCategoryDataList = value.data!.data;
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
      appBar: const AuthAppBar(title: 'Add Product or Service'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            // Category Name
            headings(
              label: 'New Product',
              subLabel: 'Enter product details.',
            ),
            _formFields(),
            _uploadImage(),
            const SizedBox(height: 32),
            appButton(
              text: 'Add Product',
              context: context,
              onTap: () {
                var categoryId = selectedCategory;
                var prodctName = productNameController.text;
                var productAmount = productAmountController.text;
                var productRestock = productRestockController.text;
                var productDescription = productDescriptionController.text;
                var productService =  productCategoryDataList?.firstWhere((element) => element.categoryName == selectedCategory).productService;


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
                  showCustomToast('Please enter product amount', isError: true);
                  return;
                }

                var requestData = <String, dynamic>{};
                requestData['productCategory'] = categoryId;
                requestData['productName'] = prodctName;
                requestData['productPrice'] = productAmount;
                requestData['productRestock'] = productRestock;
                requestData['productDescription'] = productDescription;
                requestData['productService'] = productService;

                _createCategory(requestData);

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
          options:productCategoryDataList?.map((e) => e.categoryName ?? '').toList() ??
              [],
          selectedValue: selectedCategory,
          onChanged: (value) {
            final selectedCat = value;
            setState(() {
              selectedCategory = selectedCat;
            });
          },
        ),
        16.height,
        // Product Name
        const Text(
          'Product Name',
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
          hintText: 'Product Name',
          focusNode: productNameFocusNode,
          nextFocus: productAmountFocusNode,
          controller: productNameController,
        ),
        16.height,
        // Product Description
        const Text(
          'Product Amount',
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
          hintText: 'Product Amount',
          focusNode: productAmountFocusNode,
          nextFocus: productRestockFocusNode,
          controller: productAmountController,
        ),
        16.height,
        // Product Description
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
        // Description
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
          textFieldType: TextFieldType.MULTILINE,
          hintText: 'Description',
          focusNode: productDescriptionFocusNode,
          controller: productDescriptionController,
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
            child: const Icon(Icons.image,
                size: 28, color: Color(0xFF8A8D9F)),
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
