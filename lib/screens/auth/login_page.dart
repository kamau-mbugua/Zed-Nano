import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/auth/forget_password_screen.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/auth/social_buttons.dart';
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
  bool isEmailLoginActive = false;

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
        title: 'Sign In',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Back',
                style: boldTextStyle(
                  size: 24,
                  fontFamily: "Poppins",
                )).paddingSymmetric(horizontal: 16),
            8.height,
            Text("Sign in to continue to your account.",
                    style: secondaryTextStyle(
                        size: 12,
                        weight: FontWeight.w500,
                        color: getBodyColor(),
                        fontFamily: "Poppins"))
                .paddingSymmetric(horizontal: 16),
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

                // Email/Phone Toggle Buttons
                if (isEmailLoginActive)
                  SocialButton(
                    icon: phoneIcon,
                    label: 'Phone',
                    backgroundColor: emailBlue,
                    onTap: () {
                      setState(() {
                        isEmailLoginActive = false;
                      });
                    },
                  )
                else
                  SocialButton(
                    icon: emailIcon,
                    label: 'Email',
                    backgroundColor: emailBlue,
                    onTap: () {
                      setState(() {
                        isEmailLoginActive = true;
                      });
                    },
                  ),

                CircularSocialButton(
                  icon: facebookIcon,
                  backgroundColor: facebookBlue,
                  onTap: () {},
                ),

                CircularSocialButton(
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
                    style: secondaryTextStyle(
                        size: 12,
                        weight: FontWeight.w500,
                        color: getBodyColor(),
                        fontFamily: "Poppins"))
                .paddingSymmetric(horizontal: 16),
            16.height,

            // Show different input fields based on login method
            if (isEmailLoginActive)
              _buildEmailLoginForm()
            else
              _buildPhoneLoginForm(),

            16.height,
            appButton(
                    text: "Sign In",
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context,
                          AppRoutes.getHomeMainPageRoute(), (route) => false);
                    },
                    context: context)
                .paddingSymmetric(horizontal: 16),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: secondaryTextStyle(
                    size: 14,
                    color: getBodyColor(),
                    fontFamily: "Poppins",
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to login page
                    Navigator.pushNamed(
                        context, AppRoutes.getUserRegistrationPageRoute());
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailLoginForm() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: StyledTextField(
            textFieldType: TextFieldType.EMAIL,
            hintText: "Email Address",
          ),
        ),
        16.height,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: StyledTextField(
            textFieldType: TextFieldType.PASSWORD,
            hintText: "Pin",
            isPassword: true,
          ),
        ),
        8.height,
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(
                  context, AppRoutes.getForgetPinRoutePageRoute());
            },
            child: Text(
              'Forgot Pin?',
              style: secondaryTextStyle(
                size: 12,
                color: appThemePrimary,
                fontFamily: "Poppins",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneLoginForm() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: PhoneInputField(),
        ),
        16.height,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: StyledTextField(
            textFieldType: TextFieldType.PASSWORD,
            hintText: "Pin",
            isPassword: true,
          ),
        ),
        8.height,
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(
                  context, AppRoutes.getForgetPinRoutePageRoute());
            },
            child: Text(
              'Forgot Pin?',
              style: secondaryTextStyle(
                size: 12,
                color: appThemePrimary,
                fontFamily: "Poppins",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
