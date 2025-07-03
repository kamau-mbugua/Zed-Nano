import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/auth/authenticated_app_providers.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/auth/forget_password_screen.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/auth/social_buttons.dart';
import 'package:zed_nano/screens/widget/common/common_widgets.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/services/firebase_service.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:zed_nano/utils/extensions.dart';

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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phonePasswordController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode phonePasswordFocus = FocusNode();

  final FocusNode phoneFocus = FocusNode();

  bool _rememberMe = false;

  @override
  void initState() {
    emailFocus.addListener(() {
      setState(() {});
    });
    passwordFocus.addListener(() {
      setState(() {});
    });
    phoneFocus.addListener(() {
      setState(() {});
    });
    phonePasswordFocus.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    codeController.dispose();
    phonePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AuthAppBar(
        title: 'Sign In',
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
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
                  if (isEmailLoginActive) {
                    _handleEmailLogin(context);
                  } else {
                    _handlePhoneLogin(context);
                  }
                },
                context: context,
              ).paddingSymmetric(horizontal: 16),
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
      ),
    );
  }

  Widget _buildEmailLoginForm() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: StyledTextField(
            controller: emailController,
            focusNode: emailFocus,
            nextFocus: passwordFocus,
            textFieldType: TextFieldType.EMAIL,
            hintText: "Email Address",
          ),
        ),
        16.height,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: StyledTextField(
            controller: passwordController,
            focusNode: passwordFocus,
            textFieldType: TextFieldType.PASSWORD,
            hintText: "Pin",
            isPassword: true,
          ),
        ),
        8.height,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
              Text(
                "Remember me",
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, AppRoutes.getForgetPinRoutePageRoute());
                },
                child: Text("Forgot Pin?",  style: boldTextStyle(
                  size: 14,
                  color: appThemePrimary,
                  fontFamily: "Poppins",
                )),
              ),
            ],
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
          child: PhoneInputField(
            controller: phoneController,
            codeController:codeController,
            focusNode: phoneFocus,
            nextFocus: phonePasswordFocus,
            maxLength: 10,
          ),
        ),
        16.height,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: StyledTextField(
            controller: phonePasswordController,
            focusNode: phonePasswordFocus,
            textFieldType: TextFieldType.PASSWORD,
            hintText: "Pin",
            isPassword: true,
            maxLength: 4,
          ),
        ),
        8.height,
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
              Text(
                "Remember me",
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, AppRoutes.getForgetPinRoutePageRoute());
                },
                child: Text("Forgot Pin?",  style: boldTextStyle(
                  size: 14,
                  color: appThemePrimary,
                  fontFamily: "Poppins",
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Login with email and password
  Future<void> _handleEmailLogin(BuildContext context) async {
    var email = emailController.text.trim();
    var pass = passwordController.text.trim();
    if ( !email.isValidEmail) {
      showCustomToast('Please enter phone number');
      return;
    }
    if (!pass.isValidPin) {
      showCustomToast('Please enter valid pin');
      return;
    }
    final Map<String, dynamic> loginData = {
      'email': email,
      'userPin': pass,
    };
    logger.d(loginData);

    _doUserLogin(loginData, context);

  }

  // Login with phone number and password
  Future<void> _handlePhoneLogin(BuildContext context) async {

    var phone = phoneController.text.trim();
    var phoneCode = codeController.text.trim();
    var pass = phonePasswordController.text.trim();
    // Extract phone number (remove formatting)
    String phoneNumber = "$phoneCode$phone";
    if (phone.isEmpty || !phoneNumber.isValidPhoneNumber) {
      showCustomToast('Please enter phone number');
      return;
    }
    if (!pass.isValidPin) {
      showCustomToast('Please enter valid pin');
      return;
    }
    final Map<String, dynamic> loginData = {
      'userPhone': phoneNumber,
      'userPin': pass,
    };
    logger.d(loginData);

    _doUserLogin(loginData, context);
  }

  Future<void> _doUserLogin(Map<String, dynamic> loginData, BuildContext context) async {
    final firebaseService = FirebaseService();
    final fcmToken = await firebaseService.getFcmToken();
    final deviceId = await firebaseService.getDeviceId();

    loginData['fcmToken'] = fcmToken;
    loginData['deviceId'] = deviceId;

    final authProvider = getAuthProvider(context);
    final response = await authProvider.login(requestData: loginData, context: context);
    if (response.isSuccess) {
      final userName = authProvider.userDetails?.name ??
          authProvider.loginResponse?.username ??
          "User";
      showCustomToast('Welcome back $userName!', isError: false);
      Navigator.of(context).pushReplacementNamed(AppRoutes.getHomeMainPageRoute());
    } else {
      logger.d(response.message);
      showCustomToast('${response.message}!');
    }
  }
}
