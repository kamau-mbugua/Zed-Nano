import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/country_currency_picker.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';

class CreateBusinessPage extends StatefulWidget {
  final VoidCallback onNext;

  const CreateBusinessPage({Key? key, required this.onNext}) : super(key: key);

  @override
  State<CreateBusinessPage> createState() => _CreateBusinessPageState();
}

class _CreateBusinessPageState extends State<CreateBusinessPage> {
  String? selectedCountry;
  String? selectedCurrency;
  File? _logoImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        setState(() {
          _logoImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      toast('Error picking image: $e');
    }
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
            fontFamily: "Poppins",
            fontSize: 16.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Business Details',
                style: boldTextStyle(
                  size: 24,
                  fontFamily: "Poppins",
                )).paddingSymmetric(horizontal: 16),
            8.height,
            Text("Enter your business details to continue.",
                    style: secondaryTextStyle(
                        size: 12,
                        weight: FontWeight.w500,
                        color: getBodyColor(),
                        fontFamily: "Poppins"))
                .paddingSymmetric(horizontal: 16),
            16.height,
            Text(
                "Business Name",
                style: const TextStyle(
                    color:  const Color(0xff2f3036),
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    fontStyle:  FontStyle.normal,
                    fontSize: 12.0
                ),
                textAlign: TextAlign.left
            ).paddingSymmetric(horizontal: 16),
            5.height,
            StyledTextField(
              textFieldType: TextFieldType.EMAIL,
              hintText: "Business Name",
            ).paddingSymmetric(horizontal: 16),
            10.height,
            Text(
                "Phone Number",
                style: const TextStyle(
                    color:  const Color(0xff2f3036),
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    fontStyle:  FontStyle.normal,
                    fontSize: 12.0
                ),
                textAlign: TextAlign.left
            ).paddingSymmetric(horizontal: 16),
            5.height,
            PhoneInputField().paddingSymmetric(horizontal: 16),
            10.height,
            Text(
                "Email Address",
                style: const TextStyle(
                    color:  const Color(0xff2f3036),
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    fontStyle:  FontStyle.normal,
                    fontSize: 12.0
                ),
                textAlign: TextAlign.left
            ).paddingSymmetric(horizontal: 16),
            5.height,
            StyledTextField(
              textFieldType: TextFieldType.NAME,
              hintText: "Email Address",
            ).paddingSymmetric(horizontal: 16),
            10.height,
            Text(
                "Country & Currency",
                style: const TextStyle(
                    color:  const Color(0xff2f3036),
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    fontStyle:  FontStyle.normal,
                    fontSize: 12.0
                ),
                textAlign: TextAlign.left
            ).paddingSymmetric(horizontal: 16),
            5.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: selectedCurrency != null ? 3 : 1,
                  child: CountryCurrencyPicker(
                    hintText: "Select Country",
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
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade600),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            "",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            selectedCurrency!,
                            style: TextStyle(
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
                                : SvgPicture.asset(zedColoredIcon, fit: BoxFit.cover),
                          ),
                          Positioned(
                            right: 4,
                            bottom: 4,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: appThemePrimary.withOpacity(0.7),
                              child: Icon(
                                _logoImage != null ? Icons.edit : Icons.add_photo_alternate,
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
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Business Logo", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins")),
                      Text(
                        "Format: .png or .jpg\nMin. size: 350px by 180px\nMax. file size: 1MB",
                        style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: "Poppins"),
                      ),
                    ],
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
            25.height,
            appButton(
              text: "Next", 
              onTap: () {
                if (selectedCountry != null && selectedCurrency != null) {
                  widget.onNext();
                } else {
                  toast("Please select a country");
                }
              }, 
              context: context
            ).paddingSymmetric(horizontal: 16),
            16.height,
          ],
        ),
      ),
    );
  }
}
