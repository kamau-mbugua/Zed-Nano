import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http_parser/http_parser.dart';
import 'package:nb_utils/nb_utils.dart' hide lightGrey;
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/business/BusinessDetails.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/utils/image_picker_util.dart';
import 'package:zed_nano/utils/image_picker_state_manager.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';

class NewCategoryPage extends StatefulWidget {
  const NewCategoryPage({required this.doNotUpdate, super.key});
  final bool doNotUpdate;

  @override
  State<NewCategoryPage> createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
  bool isProduct = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final FocusNode categoryNameFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  BusinessDetails? businessDetails;

  File? _logoImage;

  @override
  void initState() {
    businessDetails = getBusinessDetails(context);
    super.initState();
    // Check for pending image after potential app restart
    _checkForPendingImage();
  }

  /// Check if there's a pending image from before app restart
  Future<void> _checkForPendingImage() async {
    final pendingImage = await ImagePickerStateManager.checkForPendingImage();
    if (pendingImage != null && mounted) {
      setState(() {
        _logoImage = pendingImage;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> refresh() async {
    try {
      final viewModel = Provider.of<WorkflowViewModel>(context, listen: false);
      await viewModel.skipSetup(context);

      if (mounted) {
        Navigator.pop(context);
        await Navigator.pushNamed(context, AppRoutes.getListCategoriesRoute());
      }

    } catch (e) {
      logger.e('Error in refresh: $e');
    }
  }

  Future<void> _createCategory() async {
    final requestData = <String, dynamic>{};
    requestData['createdBy'] = businessDetails?.group;
    requestData['businessID'] = businessDetails?.businessNumber;
    requestData['categoryName'] = nameController.text;
    requestData['categoryDescription'] = descriptionController.text;
    requestData['productService'] = isProduct ? 'Product' : 'Service';
    requestData['categoryState'] = 'Active';
    requestData['doNotUpdate'] = widget.doNotUpdate;
    await context
        .read<BusinessProviders>()
        .createCategory(requestData: requestData, context: context)
        .then((value) {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Category created successfully',
            isError: false,);
        if (_logoImage != null) {
          _uploadBusinessLogo(value.data?.data?.id);
        } else {
          refresh();
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
      'businessNumber': businessDetails?.businessNumber,
    });

    final urlPart = '?categoryId=$categoryId';

    await context
        .read<BusinessProviders>()
        .uploadProductCategoryImage(context: context, formData: formData, urlPart:urlPart)
        .then((value) async {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Business logo uploaded successfully',
            isError: false,);
        refresh();
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePickerStateManager.pickImageWithStateManagement(
      context: context,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 70,
    );

    if (pickedImage != null && mounted) {
      setState(() {
        _logoImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AuthAppBar(title: 'Create a Category'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headings(
                label: 'New Category',
                subLabel: 'Enter category details.',
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
                textFieldType: TextFieldType.NAME,
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
                                  : SvgPicture.asset(imagePlaceholder,
                                      fit: BoxFit.cover,),
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
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: appButton(
                text: 'Add Category',
                onTap: () async {
                  final categoryName = nameController.text.trim();
                  final categoryDescription = descriptionController.text.trim();
                  if (!categoryName.isValidInput) {
                    showCustomToast('Please enter category name');
                    return;
                  }

                  if (!categoryDescription.isValidInput) {
                    setState(() {
                      descriptionController.text = 'No Category Description';
                    });
                  }
                  await _createCategory();
                },
                context: context,),
          ),
        ),
      ),
    );
  }
}
