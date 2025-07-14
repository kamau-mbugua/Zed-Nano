import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart' hide lightGrey;
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/business/BusinessDetails.dart';
import 'package:zed_nano/models/listCategories/ListCategoriesResponse.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/utils/image_picker_util.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';
import 'package:path/path.dart' as p;
import 'package:http_parser/http_parser.dart';

class EditCategoryPage extends StatefulWidget {
  String? categoryId;

  EditCategoryPage({Key? key, this.categoryId}) : super(key: key);
  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  bool isProduct = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final FocusNode categoryNameFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  BusinessDetails? businessDetails;

  File? _logoImage;

  ProductCategoryData? categoryData;


  @override
  void initState() {
    businessDetails = getAuthProvider(context).businessDetails;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCategoryDetails();
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategoryDetails() async {
    final Map<String, dynamic> requestData = {
      'categoryId': widget.categoryId,
    };

    try {
      final response = await context.read<BusinessProviders>().getCategoryById(
        requestData: requestData,
        context: context,
      );

      if (response.isSuccess && response.data?.data != null) {
        setState(() {
          categoryData = response.data?.data;
          nameController.text = categoryData?.categoryName ?? '';
          descriptionController.text = categoryData?.categoryDescription ?? '';
          isProduct = (categoryData?.productService ?? 'Product') == 'Product';
        });
      } else {
        showCustomToast(response.message ?? 'Failed to load category details');
      }
    } catch (e) {
      showCustomToast('An error occurred while loading category details');
    }
  }
  Future<void> _createCategory() async {
    final requestData = <String, dynamic>{};
    requestData['categoryName'] = nameController.text;
    requestData['categoryDescription'] = descriptionController.text;
    requestData['productService'] = isProduct ? 'Product' : 'Service';
    requestData['categoryId'] = '${widget.categoryId}';
    await context
        .read<BusinessProviders>()
        .updateCategory(requestData: requestData, context: context)
        .then((value) {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Category created successfully',
            isError: false);
        if (_logoImage != null) {
          _uploadBusinessLogo(widget.categoryId);
        } else {
          Navigator.pop(context, true);
        }
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  Future<void> _uploadBusinessLogo(String? categoryId) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        _logoImage!.path,
        filename: p.basename(_logoImage!.path),
        contentType: MediaType('image', 'jpeg'), // or png
      ),
      'businessNumber': businessDetails?.businessNumber
    });

    final urlPart = '?categoryId=$categoryId';

    await context
        .read<BusinessProviders>()
        .uploadProductCategoryImage(context: context, formData: formData!, urlPart:urlPart)
        .then((value) async {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Business logo uploaded successfully',
            isError: false);
        Navigator.pop(context, true);
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(title: 'Edit a Category'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headings(
                label: 'Edit Category',
                subLabel: 'Modify category details.',
              ),

              // Category Name
              const Text(
                'Category Name',
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
                hintText: 'Category Name',
                controller: nameController,
                focusNode: categoryNameFocusNode,
                nextFocus: descriptionFocusNode,
              ),
              const SizedBox(height: 24),

              // Category Type
              const Text(
                'Category Type',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xFF484848),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => isProduct = true),
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isProduct
                              ? const Color(0xFF00296B)
                              : const Color(0xFFE0E0E0),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: !isProduct ?Colors.white : lightGrey,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Product',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: isProduct
                              ? const Color(0xFF00296B)
                              : const Color(0xFFB0B0B0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => setState(() => isProduct = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: !isProduct
                              ? const Color(0xFF00296B)
                              : const Color(0xFFE0E0E0),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isProduct ?Colors.white : lightGrey,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Service',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: !isProduct
                              ? const Color(0xFF00296B)
                              : const Color(0xFFB0B0B0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

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
                controller: descriptionController,
                focusNode: descriptionFocusNode,
              ),
              const SizedBox(height: 24),

              // Image Picker Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: _pickImage,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: _logoImage != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _logoImage!,
                                  height: 80,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : rfCommonCachedNetworkImage(
                                '${categoryData?.imagePath ?? ''}',
                                fit: BoxFit.cover,
                                height: 80,
                                width: double.infinity,
                    ),
                            ),
                            Positioned(
                              right: 4,
                              bottom: 4,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor:
                                appThemePrimary.withOpacity(0.7),
                                child: Icon(
                                  _logoImage != null
                                      ? Icons.edit
                                      : Icons.add_photo_alternate,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
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
                        SizedBox(height: 6),
                        Text(
                          'Select an image from your gallery or take a photo.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8F90A6),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: appButton(
            text: 'Edit Category',
            onTap: () async {
              final categoryName = nameController.text.trim();
              final categoryDescription = descriptionController.text.trim();
              if (!categoryName.isValidInput) {
                showCustomToast('Please enter category name');
                return;
              }
              await _createCategory();
            },
            context: context),
      ),
    );
  }
}
