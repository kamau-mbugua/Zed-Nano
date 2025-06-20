import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/auth/social_buttons.dart';
import 'package:zed_nano/screens/widget/auth/terms_checkbox.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:country_code_picker/country_code_picker.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool termsAccepted = false;
  
  // Colors for social buttons
  final Color googleRed = Color(0xFFED3241);
  final Color emailBlue = Color(0xFF032541);
  final Color facebookBlue = Color(0xFF4676ED);
  final Color twitterBlue = Color(0xFF009CDC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AuthAppBar(
        title: 'Get Started',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create Your Account', style: boldTextStyle(size: 24,
              fontFamily: "Poppins",
            )).paddingSymmetric(horizontal: 16),
            8.height,
            Text("Create your account to get started.",
                style: secondaryTextStyle(size: 12, weight: FontWeight.w600, color: getBodyColor(), fontFamily: "Poppins")
            ).paddingSymmetric(horizontal: 16),
            24.height,
            Text("Continue With",
                style: secondaryTextStyle(size: 12,
                  weight: FontWeight.w600,
                  color: getBodyColor(),
                  fontFamily: "Poppins")
            ).paddingSymmetric(horizontal: 16),
            16.height,
            SocialButtonsRow(
              buttons: [
                SocialButton(
                  icon: googleIcon,
                  label: 'Google',
                  backgroundColor: googleRed,
                  onTap: () {
                    // Handle Google login
                  },
                ),
                
                CircularSocialButton(
                  icon: facebookIcon,
                  backgroundColor: facebookBlue,
                  onTap: () {
                  },
                ),

                CircularSocialButton(
                  icon: twitterIcon,
                  backgroundColor: twitterBlue,
                  onTap: () {
                    // Handle Twitter login
                  },
                ),
              ],
            ),
            24.height,
            Text("Or Personal Details",
                style: secondaryTextStyle(size: 12,
                  weight: FontWeight.w500,
                  color: getBodyColor(),
                  fontFamily: "Poppins")
            ).paddingSymmetric(horizontal: 16),
            16.height,
            _buildRegistrationForm(),
            24.height,
            TermsCheckbox(
              initialValue: termsAccepted,
              onChanged: (value) {
                setState(() {
                  termsAccepted = value;
                });
              },
            ),
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
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: secondaryTextStyle(
                    size: 14,
                    color: getBodyColor(),
                    fontFamily: "Poppins",
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.getLoggingPageRoute());
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Column(
      children: [
        NameFieldsRow(),
        16.height,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: StyledTextField(
            textFieldType: TextFieldType.NAME,
            hintText: "User Name",
          ),
        ),
        16.height,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: StyledTextField(
            textFieldType: TextFieldType.EMAIL,
            hintText: "Email Address",
          ),
        ),
        16.height,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: PhoneInputField(),
        ),
      ],
    );
  }
}
