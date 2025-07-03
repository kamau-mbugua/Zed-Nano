import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
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
import 'package:zed_nano/utils/extensions.dart';

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

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();

  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneNumberFocus = FocusNode();

  Future<void> _doUserSignup(
      Map<String, dynamic> loginData, BuildContext context) async {
    final authProvider = getAuthProvider(context);
    final response =
        await authProvider.register(requestData: loginData, context: context);
    if (response.isSuccess) {
      showCustomToast(response.message, isError: false);
      Navigator.of(context).pop();
    } else {
      logger.d(response.message);
      showCustomToast('${response.message}!');
    }
  }

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
            Text('Create Your Account',
                style: boldTextStyle(
                  size: 24,
                  fontFamily: "Poppins",
                )).paddingSymmetric(horizontal: 16),
            8.height,
            Text("Create your account to get started.",
                    style: secondaryTextStyle(
                        size: 12,
                        weight: FontWeight.w600,
                        color: getBodyColor(),
                        fontFamily: "Poppins"))
                .paddingSymmetric(horizontal: 16),
            24.height,
            Text("Continue With",
                    style: secondaryTextStyle(
                        size: 12,
                        weight: FontWeight.w600,
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
                  },
                ),
              ],
            ),
            24.height,
            Text("Or Personal Details",
                    style: secondaryTextStyle(
                        size: 12,
                        weight: FontWeight.w500,
                        color: getBodyColor(),
                        fontFamily: "Poppins"))
                .paddingSymmetric(horizontal: 16),
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
            appButton(
                    text: "Create Account",
                    onTap: () async {
                      if (termsAccepted) {
                        // Navigator.pop(context);
                        var firstName = firstNameController.text;
                        var lastName = lastNameController.text;
                        var name = nameController.text;
                        var email = emailController.text;
                        var phoneNumber = phoneNumberController.text;
                        var countryCode = countryCodeController.text;

                        if (!firstName.isValidInput) {
                          showCustomToast('Please enter first name');
                          return;
                        }

                        if (!lastName.isValidInput) {
                          showCustomToast('Please enter last name');
                          return;
                        }

                        if (!name.isValidInput) {
                          showCustomToast('Please enter name');
                          return;
                        }

                        if (!email.isValidEmail) {
                          showCustomToast('Please enter valid email');
                          return;
                        }

                        if (!phoneNumber.isValidPhoneNumber) {
                          showCustomToast('Please enter valid phone number');
                          return;
                        }

                        var phoneNumberWithCode = "$countryCode$phoneNumber";

                        Map<String, dynamic> data = {
                          'firstName': firstName,
                          'secondName': lastName,
                          'userName': name,
                          'userEmail': email,
                          'userPhone': phoneNumberWithCode,
                          'isCreatedViaNano':true
                        };

                        await _doUserSignup(data, context);
                      } else {
                        showCustomToast(
                            'Please accept the terms and conditions');
                      }
                    },
                    context: context)
                .paddingSymmetric(horizontal: 16),
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
                    Navigator.pushNamed(
                        context, AppRoutes.getLoggingPageRoute());
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
        NameFieldsRow(
          firstNameController: firstNameController,
          lastNameController: lastNameController,
          firstNameFocusNode: firstNameFocus,
          lastNameFocusNode: lastNameFocus,
          focusNodeComplete: nameFocus,
        ),
        16.height,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: StyledTextField(
            controller: nameController,
            focusNode: nameFocus,
            nextFocus: emailFocus,
            textFieldType: TextFieldType.NAME,
            hintText: "User Name",
          ),
        ),
        16.height,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: StyledTextField(
            controller: emailController,
            focusNode: emailFocus,
            nextFocus: phoneNumberFocus,
            textFieldType: TextFieldType.EMAIL,
            hintText: "Email Address",
          ),
        ),
        16.height,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: PhoneInputField(
            controller: phoneNumberController,
            focusNode: phoneNumberFocus,
            codeController: countryCodeController,
            maxLength: 10,
          ),
        ),
      ],
    );
  }
}
