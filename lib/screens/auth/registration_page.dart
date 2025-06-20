import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  CountryCode? selectedCountry = CountryCode(
    code: 'KE',
    dialCode: '+254',
    name: 'Kenya',
  );
  bool termsAccepted = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        title: Text('Get Started', style: boldTextStyle(size: 20)),
        centerTitle: false,
        backgroundColor: colorWhite,
        elevation: 5,
        iconTheme: IconThemeData(color: getBodyColor()),
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: getBodyColor()),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: context.width(),
        height: context.height(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Your Account', style: boldTextStyle(size: 24,
                fontFamily: "Poppins",
              )).paddingSymmetric(horizontal: 16),
              8.height,
              Text("Create your account to get started.",
                  style: secondaryTextStyle(size: 12, weight: FontWeight.w500, color: getBodyColor(), fontFamily: "Poppins")
              ).paddingSymmetric(horizontal: 16),
              24.height,
              Text('Continue With',
                  style: secondaryTextStyle(size: 12,
                    weight: FontWeight.w600,
                    color: getBodyColor(),
                    fontFamily: "Poppins")
              ).paddingSymmetric(horizontal: 16),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Google Button
                  _buildSocialButton(
                    icon: googleIcon,
                    label: 'Google',
                    backgroundColor: googleRed,
                    onTap: () {
                      // Handle Google login
                    },
                  ).paddingSymmetric(horizontal: 0),
                  
                  _buildCircularSocialButton(
                    icon: facebookIcon,
                    backgroundColor: facebookBlue,
                    onTap: () {
                    },
                  ).paddingSymmetric(horizontal: 8),

                  _buildCircularSocialButton(
                    icon: twitterIcon,
                    backgroundColor: twitterBlue,
                    onTap: () {
                      // Handle Twitter login
                    },
                  ).paddingSymmetric(horizontal: 0),

                ],
              ).paddingSymmetric(horizontal: 16),
              24.height,
              Text("Or Personal Details",
                  style: secondaryTextStyle(size: 12,
                      weight: FontWeight.w500,
                      color: getBodyColor(),
                      fontFamily: "Poppins")
              ).paddingSymmetric(horizontal: 16),
              10.height,
              _buildPersonalDetailsInput(),
              24.height,
              _buildTermsCheckbox(),
              24.height,
              appButton(text: "Create Account",
                  onTap: (){
                    if (termsAccepted) {
                      Navigator.pop(context);
                    } else {
                      showCustomSnackBar('Please accept the terms and conditions');
                    }
                  },
                  context: context).paddingSymmetric(horizontal: 16),
              10.height,
              _buildLoginOption(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalDetailsInput() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48, // Fixed height for consistency
                  decoration: BoxDecoration(
                    border: Border.all(color: BodyWhite),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AppTextField(
                    textFieldType: TextFieldType.NAME,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "First Name",
                      hintStyle: TextStyle(
                        color: Color(0xff8f9098),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        fontSize: 14.0,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                  ),
                ),
              ),
              16.width, // Space between fields
              Expanded(
                child: Container(
                  height: 48, // Fixed height for consistency
                  decoration: BoxDecoration(
                    border: Border.all(color: BodyWhite),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AppTextField(
                    textFieldType: TextFieldType.NAME,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Last Name",
                      hintStyle: TextStyle(
                        color: Color(0xff8f9098),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        fontSize: 14.0,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        16.height,
        Container(
          height: 48, // Fixed height for consistency
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: BodyWhite),
            borderRadius: BorderRadius.circular(12),
          ),
          child: AppTextField(
            textFieldType: TextFieldType.NAME,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "User Name",
              hintStyle: TextStyle(
                color: Color(0xff8f9098),
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins",
                fontSize: 14.0,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ),
        ),
        16.height,
        Container(
          height: 48, // Fixed height for consistency
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: BodyWhite),
            borderRadius: BorderRadius.circular(12),
          ),
          child: AppTextField(
            textFieldType: TextFieldType.EMAIL,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Email",
              hintStyle: TextStyle(
                color: Color(0xff8f9098),
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins",
                fontSize: 14.0,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ),
        ),
        16.height,
        Container(
          height: 48, // Fixed height for consistency
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: BodyWhite),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 70, // Fixed width for the country code
                decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: BodyWhite)),
                ),
                child: CountryCodePicker(
                  onChanged: (CountryCode code) {
                    setState(() {
                      selectedCountry = code;
                    });
                  },
                  initialSelection: 'KE',
                  favorite: ['+254', 'KE'],
                  showFlag: false, // Hide the flag
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: true,
                  hideMainText: false,
                  showFlagMain: false,
                  showFlagDialog: true,
                  hideSearch: false,
                  padding: EdgeInsets.zero,
                  textStyle: TextStyle(
                    color: Color(0xff1f2024),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                    fontSize: 14.0,
                  ),
                ),
              ),
              Expanded(
                child: AppTextField(
                  textFieldType: TextFieldType.PHONE,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Phone Number",
                    hintStyle: TextStyle(
                      color: Color(0xff8f9098),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      fontSize: 14.0,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  ),
                ),
              ),
            ],
          ),
        ),
        16.height,
      ],
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
    required Color backgroundColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              height: 18,
              width: 18,
              color: colorWhite,
            ),
            8.width,
            Text(
              label,
              style: boldTextStyle(
                size: 14,
                color: colorWhite,
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCircularSocialButton({
    required String icon,
    required VoidCallback onTap,
    required Color backgroundColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SvgPicture.asset(
          icon,
          height: 24,
          width: 24,
          color: colorWhite,
        ),
      ),
    );
  }
  
  Widget _buildLoginOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: secondaryTextStyle(
            size: 14,
            color: getBodyColor(),
            fontFamily: "Poppins",
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigate to login page
            Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.getLoggingPageRoute(), (route) => false);
          },
          child: Text(
            'Sign In',
            style: boldTextStyle(
              size: 14,
              color: appThemePrimary,
              fontFamily: "Poppins",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: termsAccepted, 
              onChanged: (bool? value) {
                setState(() {
                  termsAccepted = value ?? false;
                });
              },
              activeColor: appThemePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          12.width,
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    style: const TextStyle(
                      color: Color(0xff71727a),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0
                    ),
                    text: "I've read and agree with the "
                  ),
                  TextSpan(
                    style: const TextStyle(
                      color: Color(0xff032541),
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0
                    ),
                    text: "Terms and Conditions",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Handle Terms and Conditions tap
                        toast('Terms and Conditions tapped');
                      }
                  ),
                  TextSpan(
                    style: const TextStyle(
                      color: Color(0xff71727a),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0
                    ),
                    text: " and the "
                  ),
                  TextSpan(
                    style: const TextStyle(
                      color: Color(0xff032541),
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0
                    ),
                    text: "Privacy Policy",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Handle Privacy Policy tap
                        toast('Privacy Policy tapped');
                      }
                  ),
                  TextSpan(
                    style: const TextStyle(
                      color: Color(0xff71727a),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0
                    ),
                    text: "."
                  )
                ]
              )
            ),
          ),
        ],
      ),
    );
  }
}
