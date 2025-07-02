import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zed_nano/providers/authenticated_app_providers.dart';
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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phonePasswordController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();
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
            focusNode: phoneFocus,
            nextFocus: phonePasswordFocus,
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
    if (!formKey.currentState!.validate()) return;

    // Get the provider
    final authProvider = Provider.of<AuthenticatedAppProviders>(context, listen: false);

    // Prepare request data
    final Map<String, dynamic> loginData = {
      'email': emailController.text.trim(),
      'password': passwordController.text,
    };

    // Call login method
    final response = await authProvider.login(requestData: loginData);

    if (response.isSuccess) {
      // Get user name for welcome message
      final userName = authProvider.userDetails?.name ??
          authProvider.loginResponse?.username ??
          "User";

      // Show welcome toast
      Fluttertoast.showToast(
        msg: "Welcome back $userName!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Navigate to home screen
      Navigator.of(context).pushReplacementNamed(AppRoutes.getHomeMainPageRoute());
    } else {
      // Show error message
      Fluttertoast.showToast(
        msg: response.message ?? "Login failed",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Login with phone number and password
  Future<void> _handlePhoneLogin(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    // Get the provider
    final authProvider = Provider.of<AuthenticatedAppProviders>(context, listen: false);

    // Extract phone number (remove formatting)
    String phoneNumber = phoneController.text.trim();
    // Remove any non-digit characters if needed
    phoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    // Prepare request data
    final Map<String, dynamic> loginData = {
      'phoneNumber': phoneNumber,
      'password': phonePasswordController.text,
    };

    // Call login method
    final response = await authProvider.login(requestData: loginData);

    if (response.isSuccess) {
      // Get user name for welcome message
      final userName = authProvider.userDetails?.name ??
          authProvider.loginResponse?.username ??
          "User";

      // Show welcome toast
      Fluttertoast.showToast(
        msg: "Welcome back $userName!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Navigate to home screen
      Navigator.of(context).pushReplacementNamed(AppRoutes.getHomeMainPageRoute());
    } else {
      // Show error message
      Fluttertoast.showToast(
        msg: response.message ?? "Login failed",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
