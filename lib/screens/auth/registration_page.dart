import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/common/common_webview_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/auth/social_buttons.dart';
import 'package:zed_nano/screens/widget/auth/terms_checkbox.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/screens/widget/common/heading.dart';
import 'package:zed_nano/services/social_auth_service.dart';
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
  Map<String, dynamic> signUpUserData = {};

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

  void _showPhoneNumberDialog(BuildContext context, Map<String, dynamic> userData) {
    final TextEditingController phoneController = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Phone Number'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Welcome ${userData['firstName'] ?? 'User'}!'),
              const SizedBox(height: 16),
              const Text('Please enter your phone number to complete registration:'),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+254XXXXXXXXX',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final phoneNumber = phoneController.text.trim();
                if (phoneNumber.isNotEmpty) {
                  Navigator.of(context).pop();
                  
                  // Set the signUpUserData and populate form fields
                  setState(() {
                    signUpUserData = userData;
                    signUpUserData['phoneNumber'] = phoneNumber;
                  });
                  
                  // Populate the form controllers
                  _populateControllersFromSignUpData();
                  phoneNumberController.text = phoneNumber;
                  
                } else {
                  // Show error for empty phone number
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a phone number')),
                  );
                }
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _populateControllersFromSignUpData();
  }

  void _populateControllersFromSignUpData() {
    if (signUpUserData.isNotEmpty) {
      firstNameController.text = signUpUserData['firstName'] as String? ?? '';
      lastNameController.text = signUpUserData['otherName'] as String? ?? '';
      nameController.text = '${signUpUserData['firstName'] ?? ''} ${signUpUserData['otherName'] ?? ''}'.trim();
      emailController.text = signUpUserData['email'] as String? ?? '';
      
      logger.d('Populated form fields:');
      logger.d('First Name: ${firstNameController.text}');
      logger.d('Last Name: ${lastNameController.text}');
      logger.d('Full Name: ${nameController.text}');
      logger.d('Email: ${emailController.text}');
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
            headings(
              label: 'Create Your Account',
              subLabel: 'Create your account to get started.',
            ).paddingSymmetric(horizontal: 16),
            24.height,
            _signUpOptions(),
            24.height,
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

                      if (signUpUserData.isEmpty) {
                        await emailSignUp();
                      }else{
                       await emailSignUp();
                      }

                    },
                    context: context)
                .paddingSymmetric(horizontal: 16),
            16.height,
            _signInRow(),
          ],
        ),
      ),
    );
  }

  Future<void> emailSignUp() async {
    if (termsAccepted) {


      // Regular email registration flow
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
  }

  Widget _signInRow() {
    return Row(
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
    );
  }

  Widget _signUpOptions() {
    return Visibility(
      visible: signUpUserData.isEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Continue With",
              style: secondaryTextStyle(
                  size: 12,
                  weight: FontWeight.w600,
                  color: getBodyColor(),
                  fontFamily: "Poppins"))
              .paddingSymmetric(horizontal: 16),
          16.height,
          Visibility(
            visible: signUpUserData.isEmpty,
            child: SocialButtonsRow(
              buttons: [
                SocialButton(
                  icon: googleIcon,
                  label: 'Google',
                  backgroundColor: googleRed,
                  onTap: () async {
                    final userData = await SocialAuthService.signUpWithGoogle(context);
                    logger.d('User data: $userData');
                    if (userData != null) {

                      setState(() {
                        signUpUserData = userData;
                      });

                      // Add small delay to ensure Google dialog closes completely
                      await Future.delayed(const Duration(milliseconds: 300));
                      
                      // Call populate after setState completes and dialog closes
                      _populateControllersFromSignUpData();
                      
                      // Show success message
                      showCustomToast('Google account linked! Please complete your details.', isError: false);

                      // _showPhoneNumberDialog(context, userData);
                    }
                  },
                ),
                Visibility(
                  visible: false,
                  child: CircularSocialButton(
                    icon: facebookIcon,
                    backgroundColor: facebookBlue,
                    onTap: () async {
                      final socialAuthService = SocialAuthService();
                      await socialAuthService.signUpWithFacebook(context);
                    },
                  ),
                ),
                Visibility(
                  visible: false,
                  child: CircularSocialButton(
                    icon: twitterIcon,
                    backgroundColor: twitterBlue,
                    onTap: () async {
                      final socialAuthService = SocialAuthService();
                      await socialAuthService.signUpWithTwitter(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(signUpUserData.isNotEmpty ? "Provide More Details" : "Or Personal Details",
            style: secondaryTextStyle(
                size: 12,
                weight: FontWeight.w500,
                color: getBodyColor(),
                fontFamily: "Poppins"))
            .paddingSymmetric(horizontal: 16),
        16.height,
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
            isActive: signUpUserData.isEmpty, // Make non-editable when data from Google Sign-In
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
