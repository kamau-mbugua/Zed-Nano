import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:country_code_picker/country_code_picker.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  CountryCode? selectedCountry = CountryCode(
    code: 'KE',
    dialCode: '+254',
    name: 'Kenya',
  );
  
  // State to track which login method is active
  bool isEmailLoginActive = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        title: Text('Login', style: boldTextStyle(size: 20)),
        centerTitle: false,
        backgroundColor: colorWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: getBodyColor()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: getBodyColor()),
          onPressed: () {
            finish(context);
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
              Text('Hi, Welcome', style: boldTextStyle(size: 24,
                fontFamily: "Poppins",
              )).paddingSymmetric(horizontal: 16),
              8.height,
              Text("Let's get you going with your business.",
                  style: secondaryTextStyle(size: 12, weight: FontWeight.w500, color: getBodyColor(), fontFamily: "Poppins")
              ).paddingSymmetric(horizontal: 16),
              24.height,
              Text('Continue With',
                  style: secondaryTextStyle(size: 12,
                    weight: FontWeight.w500,
                    color: getBodyColor(),
                    fontFamily: "Poppins")
              ).paddingSymmetric(horizontal: 16),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Google Button
                  _buildSocialButton(
                    icon: googleIcon,
                    label: 'Google',
                    backgroundColor: googleRed,
                    onTap: () {
                      // Handle Google login
                      toast('Google login tapped');
                    },
                  ),
                  
                  // Email/Phone Toggle Buttons
                  if (isEmailLoginActive)
                    _buildSocialButton(
                      icon: phoneIcon,
                      label: 'Phone Number',
                      backgroundColor: emailBlue,
                      onTap: () {
                        setState(() {
                          isEmailLoginActive = false;
                        });
                        toast('Switched to phone login');
                      },
                    )
                  else
                    _buildSocialButton(
                      icon: emailIcon,
                      label: 'Email',
                      backgroundColor: emailBlue,
                      onTap: () {
                        setState(() {
                          isEmailLoginActive = true;
                        });
                        toast('Switched to email login');
                      },
                    ),
                  
                  _buildCircularSocialButton(
                    icon: facebookIcon,
                    backgroundColor: facebookBlue,
                    onTap: () {
                      // Handle Facebook login
                      toast('Facebook login tapped');
                    },
                  ),

                  _buildCircularSocialButton(
                    icon: twitterIcon,
                    backgroundColor: twitterBlue,
                    onTap: () {
                      // Handle Twitter login
                      toast('Twitter login tapped');
                    },
                  ),

                ],
              ),
              24.height,
              Text(isEmailLoginActive ? 'Or Email' : 'Or Phone Number',
                  style: secondaryTextStyle(size: 12,
                      weight: FontWeight.w500,
                      color: getBodyColor(),
                      fontFamily: "Poppins")
              ).paddingSymmetric(horizontal: 16),
              10.height,
              // Show either email or phone input based on active state
              isEmailLoginActive ? _buildEmailPasswordInput() : _buildPhoneNumberPasswordInput(),
              24.height,
              Text('Forgot Pin?',
                  style: secondaryTextStyle(size: 12,
                      weight: FontWeight.w500,
                      color: textPrimary,
                      fontFamily: "Poppins")
              ).paddingSymmetric(horizontal: 16),
              24.height,
              appButton(text: "Sign In",
                  onTap: (){},
                  context: context).paddingSymmetric(horizontal: 16),
              10.height,
              _buildSignUpOption(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailPasswordInput() {
    return Column(
      children: [
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
          child: AppTextField(
            textFieldType: TextFieldType.PASSWORD,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Pin",
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
      ],
    );
  }
  Widget _buildPhoneNumberPasswordInput() {
    return Column(
      children: [
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
        Container(
          height: 48, // Fixed height for consistency
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: BodyWhite),
            borderRadius: BorderRadius.circular(12),
          ),
          child: AppTextField(
            textFieldType: TextFieldType.PASSWORD,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Pin",
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
  
  Widget _buildEmailLoginButton() {
    return Container(
      width: context.width() - 32,
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: emailBlue,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: emailBlue.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/email_icon.svg',
            height: 18,
            width: 18,
            color: colorWhite,
          ),
          8.width,
          Text(
            'Continue with Email',
            style: boldTextStyle(
              size: 16,
              color: colorWhite,
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    ).center();
  }
  
  Widget _buildSignUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account? ',
          style: secondaryTextStyle(
            size: 14,
            color: getBodyColor(),
            fontFamily: "Poppins",
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigate to sign up page
            toast('Sign up tapped');
          },
          child: Text(
            'Create Account',
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
}
