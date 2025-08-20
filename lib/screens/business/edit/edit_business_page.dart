import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/contants/AppConstants.dart';
import 'package:zed_nano/models/get_business_info/BusinessInfoResponse.dart';
import 'package:zed_nano/models/listBusinessCategory/ListBusinessCategoryResponse.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/location_picker_field.dart';
import 'package:zed_nano/screens/widget/common/sub_category_picker.dart';
import 'package:zed_nano/screens/widget/country_currency_picker.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/utils/image_picker_util.dart';

class EditBusinessPage extends StatefulWidget {
  const EditBusinessPage({super.key});

  @override
  State<EditBusinessPage> createState() => _EditBusinessPageState();
}

class _EditBusinessPageState extends State<EditBusinessPage> {
  String? selectedCountry;
  String? selectedCurrency;
  String? selectedCategory;
  String? _selectedLocation;
  File? _logoImage;
  final ImagePicker _picker = ImagePicker();

  List<BusinessCategory>? businessCategory;

  //FUCUS NODES
  final FocusNode _businessNameFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _locationFocusNode = FocusNode();

  //CONTROLLERS
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessCategoriesController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController codeNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedImage = await ImagePickerUtil.pickImageSafely(
      context: context,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (pickedImage != null && mounted) {
      setState(() {
        _logoImage = pickedImage;
      });
    }
  }

  BusinessInfoData? businessInfoData;

  Future<void> _fetchBusinessProfile() async {
    final businessId = getBusinessDetails(context)?.businessId;

    final businessData = <String, dynamic>{
      'businessId': businessId,
    };
    await context
        .read<BusinessProviders>()
        .getBusinessInfo(requestData: businessData, context: context)
        .then((value) async {
      if (value.isSuccess) {
        final businessInfo = value.data?.data;
        setState(() {
          businessInfoData = businessInfo;

          // Pre-fill form fields with existing business data
          businessNameController.text = businessInfo?.businessName ?? '';
          phoneNumberController.text =
              businessInfo?.businessOwnerPhone?.substring(businessInfo.businessOwnerPhone!.length - 9) ??
                  '';
          codeNumberController.text =
              businessInfo?.businessOwnerPhone?.substring(0, businessInfo.businessOwnerPhone!.length - 9) ??
                  '';
          emailController.text = businessInfo?.businessOwnerEmail ?? '';
          locationController.text = businessInfo?.businessOwnerAddress ?? '';
          _selectedLocation = businessInfo?.businessOwnerAddress;
          selectedCountry = businessInfo?.country;
          selectedCurrency = businessInfo?.localCurrency;
          selectedCategory = businessInfo?.businessCategory;
          businessCategoriesController.text = businessInfo?.businessCategory ?? '';
        });

        logger.i('Business info fetched successfully: ${businessInfo?.businessName}');
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  Future<void> listBusinessCategory() async {
    await context
        .read<BusinessProviders>()
        .listBusinessCategory(context: context)
        .then((value) async {
      if (value.isSuccess) {
        setState(() {
          businessCategory = value.data?.categories;
        });
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  bool validateForm() {
    if (businessNameController.text.trim().isEmpty) {
      showCustomToast('Please enter business name');
      return false;
    }
    if (businessCategoriesController.text.trim().isEmpty) {
      showCustomToast('Please select business category');
      return false;
    }
    if (phoneNumberController.text.trim().isEmpty) {
      showCustomToast('Please enter phone number');
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      showCustomToast('Please enter email address');
      return false;
    }
    if (!emailController.text.trim().isValidEmail) {
      showCustomToast('Please enter valid email address');
      return false;
    }
    if (locationController.text.trim().isEmpty) {
      showCustomToast('Please enter business location');
      return false;
    }

    return true;
  }

  Future<void> updateBusiness() async {
    if (!validateForm()) {
      return;
    }
    final businessNumber = businessInfoData?.businessNumber;

    final businessData = <String, dynamic>{
      'businessName': businessNameController.text.trim(),
      'businessCategory': selectedCategory,
      'businessOwnerEmail': emailController.text.trim(),
      'businessOwnerPhone': '${codeNumberController.text.trim()}${phoneNumberController.text.trim()}',
      'businessOwnerAddress': locationController.text.trim(),
      'country': selectedCountry,
      'currency': selectedCurrency,
    };

    await context
        .read<BusinessProviders>()
        .updateBusinessInfo(requestData: businessData,businessNumber:businessNumber ?? '', context: context)
        .then((value) async {
      if (value.isSuccess) {
        showCustomToast('Business details updated successfully', isError: false);
        if (_logoImage != null) {
          await _uploadBusinessLogo();
        }else {
          Navigator.pop(context);
        }
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  Future<void> _uploadBusinessLogo() async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        _logoImage!.path,
        filename: p.basename(_logoImage!.path),
        contentType: MediaType('image', 'jpeg'), // or png
      ),
      'businessNumber': getBusinessDetails(context)?.businessNumber,
    });

    final urlPart = '?businessId=${getBusinessDetails(context)?.businessNumber}';

    await context
        .read<BusinessProviders>()
        .uploadProductCategoryImage(context: context, formData: formData, urlPart:urlPart)
        .then((value) async {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Business logo uploaded successfully',
            isError: false,);
        Navigator.pop(context);
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
        Navigator.pop(context);
      }
    });
  }

  //
  // Future<void> _uploadBusinessLogo() async {
  //   await context
  //       .read<BusinessProviders>()
  //       .uploadBusinessLogo(context: context, logo: _logoImage!)
  //       .then((value) async {
  //     if (value.isSuccess) {
  //       showCustomToast(
  //           value.message ?? 'Business logo uploaded successfully',
  //           isError: false);
  //       Navigator.pop(context);
  //     } else {
  //       showCustomToast(
  //           value.message ?? 'Something went wrong');
  //     }
  //   });
  // }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listBusinessCategory();
      _fetchBusinessProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AuthAppBar(
        title: 'Edit Business',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Business Name',
                style: TextStyle(
                    color: Color(0xff2f3036),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.normal,
                    fontSize: 12,),
                textAlign: TextAlign.left,)
                .paddingSymmetric(horizontal: 16),
            5.height,
            StyledTextField(
              textFieldType: TextFieldType.NAME,
              hintText: 'Business Name',
              controller: businessNameController,
              focusNode: _businessNameFocusNode,
              nextFocus: _phoneNumberFocusNode,
            ).paddingSymmetric(horizontal: 16),
            10.height,
            const Text('Business Category',
                style: TextStyle(
                    color: Color(0xff2f3036),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.normal,
                    fontSize: 12,),
                textAlign: TextAlign.left,)
                .paddingSymmetric(horizontal: 16),
            5.height,
            SubCategoryPicker(
              label: 'Select BusinessCategory',
              options:
              businessCategory?.map((e) => e.categoryName ?? '').toList() ??
                  [],
              selectedValue: selectedCategory,
              onChanged: (value) {
                final selectedCat = value;
                setState(() {
                  selectedCategory = selectedCat;
                });
              },
            ).paddingSymmetric(horizontal: 16),
            10.height,
            const Text('Phone Number',
                style: TextStyle(
                    color: Color(0xff2f3036),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.normal,
                    fontSize: 12,),
                textAlign: TextAlign.left,)
                .paddingSymmetric(horizontal: 16),
            5.height,
            PhoneInputField(
              controller: phoneNumberController,
              codeController: codeNumberController,
              focusNode: _phoneNumberFocusNode,
              nextFocus: _emailFocusNode,
            ).paddingSymmetric(horizontal: 16),
            10.height,
            const Text('Email Address',
                style: TextStyle(
                    color: Color(0xff2f3036),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.normal,
                    fontSize: 12,),
                textAlign: TextAlign.left,)
                .paddingSymmetric(horizontal: 16),
            5.height,
            StyledTextField(
              textFieldType: TextFieldType.EMAIL,
              hintText: 'Email Address',
              controller: emailController,
              focusNode: _emailFocusNode,
              nextFocus: _locationFocusNode,
            ).paddingSymmetric(horizontal: 16),
            10.height,
            const Text('Location',
                style: TextStyle(
                    color: Color(0xff2f3036),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.normal,
                    fontSize: 12,),
                textAlign: TextAlign.left,)
                .paddingSymmetric(horizontal: 16),
            5.height,
            LocationPickerField(
              controller: locationController,
              focusNode: _locationFocusNode,
              onLocationSelected: (location) {
                setState(() {
                  _selectedLocation = location;
                });
              },
            ).paddingSymmetric(horizontal: 16),
            10.height,
            const Text('Country & Currency',
                style: TextStyle(
                    color: Color(0xff2f3036),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.normal,
                    fontSize: 12,),
                textAlign: TextAlign.left,)
                .paddingSymmetric(horizontal: 16),
            5.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: selectedCurrency != null ? 3 : 1,
                  child: CountryCurrencyPicker(
                      initialCountry: selectedCountry,
                    onSelect: (countryName, currencyCode) {
                      setState(() {
                        selectedCountry = countryName;
                        selectedCurrency = currencyCode;
                      });
                    },
                  ),
                ),
                if (selectedCurrency != null) ...[
                  10.width,
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade600),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Text(
                            '',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            selectedCurrency!,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ).paddingSymmetric(horizontal: 16),
            15.height,
            Row(
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
                                : rfCommonCachedNetworkImage(
                              businessInfoData?.businessLogo != null && businessInfoData!.businessLogo!.isValidUrl ?  '${businessInfoData?.businessLogo}' : '',
                              fit: BoxFit.fitHeight,
                              height: 90,
                              width: 150,
                            ),
                          ),
                          Positioned(
                            right: 4,
                            bottom: 4,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: appThemePrimary.withOpacity(0.7),
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
                12.width,
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Business Logo',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',),),
                      Text(
                        'Format: .png or .jpg\nMin. size: 350px by 180px\nMax. file size: 1MB',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontFamily: 'Poppins',),
                      ),
                    ],
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
            25.height,
            appButton(
                text: 'Next',
                onTap: updateBusiness,
                context: context,)
                .paddingSymmetric(horizontal: 16),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // First dispose controllers
    businessNameController.dispose();
    businessCategoriesController.dispose();
    phoneNumberController.dispose();
    codeNumberController.dispose();
    emailController.dispose();
    locationController.dispose();
    
    // Then dispose focus nodes with null checks
    if (_businessNameFocusNode.hasFocus) {
      _businessNameFocusNode.unfocus();
    }
    if (_phoneNumberFocusNode.hasFocus) {
      _phoneNumberFocusNode.unfocus();
    }
    if (_emailFocusNode.hasFocus) {
      _emailFocusNode.unfocus();
    }
    if (_locationFocusNode.hasFocus) {
      _locationFocusNode.unfocus();
    }
    
    _businessNameFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _emailFocusNode.dispose();
    _locationFocusNode.dispose();
    
    super.dispose();
  }
}
