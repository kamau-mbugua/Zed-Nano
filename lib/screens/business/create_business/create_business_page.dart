import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/models/listBusinessCategory/ListBusinessCategoryResponse.dart';
import 'package:zed_nano/providers/auth/authenticated_app_providers.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/screens/widget/common/location_picker_field.dart';
import 'package:zed_nano/screens/widget/common/sub_category_picker.dart';
import 'package:zed_nano/screens/widget/country_currency_picker.dart';
import 'package:zed_nano/services/business_setup_extensions.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/utils/image_picker_util.dart';
import 'package:path/path.dart' as p;
import 'package:http_parser/http_parser.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';

class CreateBusinessPage extends StatefulWidget {
  final VoidCallback onNext;

  const CreateBusinessPage({Key? key, required this.onNext}) : super(key: key);

  @override
  State<CreateBusinessPage> createState() => _CreateBusinessPageState();
}

class _CreateBusinessPageState extends State<CreateBusinessPage> {
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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listBusinessCategory();
    });
    super.initState();
  }

  Future<void> listBusinessCategory() async {
    await context
        .read<BusinessProviders>()
        .listBusinessCategory(context: context)
        .then((value) {
      if (value.isSuccess) {
        setState(() {
          businessCategory = value.data!.categories;
        });
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  Future<void> _handleCreateBusiness(Map<String, dynamic> businessData, BuildContext context) async {
    await context
        .read<AuthenticatedAppProviders>()
        .createBusiness(
        requestData: businessData, context: context)
        .then((value) async {
      if (value.isSuccess) {
        showCustomToast(
            value.message ?? 'Business created successfully',
            isError: false,);

        await _initializeBusinessSetupAfterCreation(context);

        if (_logoImage != null) {
          await _uploadBusinessLogo(value.data!.businessNumber);
        } else {
          widget.onNext();
        }
      } else {
        showCustomToast(
            value.message ?? 'Something went wrong');
      }
    });
  }

  /// Initialize business setup after successful business creation
  Future<void> _initializeBusinessSetupAfterCreation(BuildContext context) async {
    try {
      await context.businessSetup.initialize();

      await Provider.of<WorkflowViewModel>(context, listen: false).skipSetup(context);
    } catch (e) {
      logger.e('Failed to initialize business setup after business creation: $e');
    }
  }

  // Future<void> _uploadBusinessLogo() async {
  //   await context
  //       .read<BusinessProviders>()
  //       .uploadBusinessLogo(context: context, logo: _logoImage!)
  //       .then((value) async {
  //     if (value.isSuccess) {
  //       showCustomToast(
  //           value.message ?? 'Business logo uploaded successfully',
  //           isError: false);
  //       await _fetchGetTokenAfterInvite();
  //     } else {
  //       showCustomToast(
  //           value.message ?? 'Something went wrong');
  //     }
  //   });
  // }

  Future<void> _uploadBusinessLogo(String? businessNumber) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        _logoImage!.path,
        filename: p.basename(_logoImage!.path),
        contentType: MediaType('image', 'jpeg'), // or png
      ),
      'businessNumber': businessNumber
    });

    final urlPart = '?businessId=${businessNumber}';

    await context
        .read<BusinessProviders>()
        .uploadProductCategoryImage(context: context, formData: formData!, urlPart:urlPart)
        .then((value) async {
      if (value.isSuccess) {
        showCustomToast(value.message ?? 'Business logo uploaded successfully',
            isError: false);
        widget.onNext();
        // await _fetchGetTokenAfterInvite();
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });
  }

  Future<void> _fetchGetTokenAfterInvite() async {
    final requestData = <String, dynamic>{};
    await context
        .read<AuthenticatedAppProviders>()
        .getTokenAfterInvite(requestData: requestData, context: context)
        .then((value) {
      if (value.isSuccess) {
        widget.onNext();
      } else {
        showCustomToast(
            value.message ?? 'Something went wrong');
      }
    });
  }

  @override
  void dispose() {
    _businessNameFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _emailFocusNode.dispose();
    _locationFocusNode.dispose();
    businessNameController.dispose();
    phoneNumberController.dispose();
    codeNumberController.dispose();
    emailController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Create Your Business',
          style: TextStyle(
            color: Color(0xff1f2024),
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            fontSize: 16.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headings(
              label: 'Business Details',
              subLabel: 'Enter your business details to continue.',
            ),
            const Text('Business Name',
                    style: const TextStyle(
                        color: const Color(0xff2f3036),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0),
                    textAlign: TextAlign.left)
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
                        fontSize: 12.0),
                    textAlign: TextAlign.left)
                .paddingSymmetric(horizontal: 16),
            5.height,
            SubCategoryPicker(
              label: 'Select BusinessCategory',
              options: businessCategory
                  ?.where((category) => ![
                        'SACCO(MICRO FINANCE)',
                        'FMCG',
                        'Rental',
                        'Transport',
                        'School/University/College',
                        'Events',
                        'Service station (Gas station)'
                      ].contains(category.categoryName))
                  .map((e) => e.categoryName ?? '')
                  .toList() ??
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
                        fontSize: 12.0),
                    textAlign: TextAlign.left)
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
                        fontSize: 12.0),
                    textAlign: TextAlign.left)
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
                        fontSize: 12.0),
                    textAlign: TextAlign.left)
                .paddingSymmetric(horizontal: 16),
            5.height,
            LocationPickerField(
              controller: locationController,
              focusNode: _locationFocusNode,
              label: 'Location',
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
                        fontSize: 12.0),
                    textAlign: TextAlign.left)
                .paddingSymmetric(horizontal: 16),
            5.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: selectedCurrency != null ? 3 : 1,
                  child: CountryCurrencyPicker(
                    hintText: 'Select Country',
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
                                : SvgPicture.asset(zedColoredIcon,
                                    fit: BoxFit.cover),
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
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Business Logo',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins')),
                      Text(
                        'Format: .png or .jpg\nMin. size: 350px by 180px\nMax. file size: 1MB',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
            25.height,
            appButton(
                    text: 'Next',
                    onTap: () async {
                      var businessName = businessNameController.text;
                      var businessCategory = selectedCategory;
                      var businessOwnerAddress = locationController.text;
                      var businessOwnerPhone = phoneNumberController.text;
                      var phoneCode = codeNumberController.text;
                      var businessOwnerEmail = emailController.text;
                      var country = selectedCountry;
                      var currency = selectedCurrency;

                      if (!businessName.isValidInput) {
                        showCustomToast('Please enter business name');
                        return;
                      }

                      if (businessCategory == null) {
                        showCustomToast('Please select business category');
                        return;
                      }
                      if (!businessOwnerAddress.isValidInput) {
                        showCustomToast('Please enter business address');
                        return;
                      }
                      if (!businessOwnerPhone.isValidPhoneNumber) {
                        showCustomToast('Please enter valid phone number');
                        return;
                      }
                      if (!businessOwnerEmail.isValidEmail) {
                        showCustomToast('Please enter valid email');
                        return;
                      }

                      if (country == null) {
                        showCustomToast('Please select business country');
                        return;
                      }

                      if (currency == null) {
                        showCustomToast('Please select business country');
                        return;
                      }

                      var phoneNumber = '$phoneCode$businessOwnerPhone';

                      var businessOwnerName = await getAuthProvider(context).userDetails?.name;

                      final businessData = <String, dynamic>{
                        'businessName': businessName,
                        'businessCategory': businessCategory,
                        'businessOwnerAddress': businessOwnerAddress,
                        'businessOwnerPhone': phoneNumber,
                        'businessOwnerEmail': businessOwnerEmail,
                        'country': country,
                        'currency': currency,
                        'businessOwnerName': businessOwnerName,
                        'isNanoBusiness': true
                      };
                      logger.d(businessData);

                      _handleCreateBusiness(businessData, context);

                    },
                    context: context)
                .paddingSymmetric(horizontal: 16),
            16.height,
          ],
        ),
      ),
    );
  }
}
