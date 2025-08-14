import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/routes/routes_helper.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/auth/social_buttons.dart';
import 'package:zed_nano/screens/widget/auth/saved_credentials_bottom_sheet.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/services/business_setup_extensions.dart';
import 'package:zed_nano/services/firebase_service.dart';
import 'package:zed_nano/services/saved_credentials_service.dart';
import 'package:zed_nano/services/social_auth_service.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';
import 'package:zed_nano/utils/extensions.dart';
import 'package:zed_nano/viewmodels/WorkflowViewModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isEmailLoginActive = false;

  // Colors for social buttons
  static const Color googleRed = Color(0xFFED3241);
  static const Color emailBlue = Color(0xFF032541);
  static const Color facebookBlue = Color(0xFF4676ED);
  static const Color twitterBlue = Color(0xFF009CDC);

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
    
    // Check for saved phone credentials on page load (default is phone login)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowSavedCredentials('phone');
    });
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
      appBar: const AuthAppBar(
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
                    fontFamily: 'Poppins',
                  ),).paddingSymmetric(horizontal: 16),
              8.height,
              Text('Sign in to continue to your account.',
                  style: secondaryTextStyle(
                      size: 12,
                      weight: FontWeight.w500,
                      color: getBodyColor(),
                      fontFamily: 'Poppins',),)
                  .paddingSymmetric(horizontal: 16),
              16.height,
              SocialButtonsRow(
                buttons: [
                  SocialButton(
                    icon: googleIcon,
                    label: 'Google',
                    backgroundColor: googleRed,
                    onTap: () async {
                      final socialAuthService = SocialAuthService();
                      await socialAuthService.signInWithGoogle(context);
                    },
                  ),
                  // Email/Phone Toggle Buttons
                  if (isEmailLoginActive)
                    SocialButton(
                      icon: phoneIconGray,
                      label: 'Phone',
                      backgroundColor: emailBlue,
                      onTap: () {
                        setState(() {
                          isEmailLoginActive = false;
                          _checkAndShowSavedCredentials('phone');
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
                          _checkAndShowSavedCredentials('email');
                        });
                      },
                    ),
                  Visibility(
                    visible: false,
                    child: CircularSocialButton(
                      icon: facebookIcon,
                      backgroundColor: facebookBlue,
                      onTap: () async {
                        final socialAuthService = SocialAuthService();
                        await socialAuthService.signInWithFacebook(context);
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
                        await socialAuthService.signInWithTwitter(context);
                      },
                    ),
                  ),
                ],
              ),
              24.height,
              Text(isEmailLoginActive ? 'Or Email' : 'Or Phone Number',
                  style: secondaryTextStyle(
                      size: 12,
                      weight: FontWeight.w500,
                      color: getBodyColor(),
                      fontFamily: 'Poppins',),)
                  .paddingSymmetric(horizontal: 16),
              16.height,
              // Show different input fields based on login method
              if (isEmailLoginActive)
                _buildEmailLoginForm()
              else
                _buildPhoneLoginForm(),
              16.height,
              appButton(
                text: 'Sign In',
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
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to login page
                      Navigator.pushNamed(
                          context, AppRoutes.getUserRegistrationPageRoute(),);
                    },
                    child: Text(
                      'Create Account',
                      style: boldTextStyle(
                        size: 14,
                        color: appThemePrimary,
                        fontFamily: 'Poppins',
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
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StyledTextField(
                  controller: emailController,
                  focusNode: emailFocus,
                  nextFocus: passwordFocus,
                  textFieldType: TextFieldType.EMAIL,
                  hintText: 'Email Address',
                ),
              ),
            ),
          ],
        ),
        16.height,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: StyledTextField(
            controller: passwordController,
            focusNode: passwordFocus,
            textFieldType: TextFieldType.PASSWORD,
            hintText: 'Pin',
            isPassword: true,
          ),
        ),
        8.height,
        Visibility(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                const Text(
                  "Remember me",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, AppRoutes.getForgetPinRoutePageRoute(),);
                  },
                  child: Text('Forgot Pin?',  style: boldTextStyle(
                    size: 14,
                    color: appThemePrimary,
                    fontFamily: 'Poppins',
                  ),),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneLoginForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PhoneInputField(
                  controller: phoneController,
                  codeController: codeController,
                  focusNode: phoneFocus,
                  nextFocus: phonePasswordFocus,
                  maxLength: 10,
                ),
              ),
            ),
          ],
        ),
        16.height,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: StyledTextField(
            controller: phonePasswordController,
            focusNode: phonePasswordFocus,
            textFieldType: TextFieldType.PASSWORD,
            hintText: 'Pin',
            isPassword: true,
            maxLength: 4,
          ),
        ),
        8.height,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, AppRoutes.getForgetPinRoutePageRoute(),);
                },
                child: Text('Forgot Pin?',  style: boldTextStyle(
                  size: 14,
                  color: appThemePrimary,
                  fontFamily: 'Poppins',
                ),),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Login with email and password
  Future<void> _handleEmailLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    if ( !email.isValidEmail) {
      showCustomToast('Please enter phone number');
      return;
    }
    if (!pass.isValidPin) {
      showCustomToast('Please enter valid pin');
      return;
    }
    final loginData = <String, dynamic>{
      'email': email,
      'userPin': pass,
      'isCreatedViaNano':true,
    };
    logger.d(loginData);

    _doUserLogin(loginData, context);

  }

  // Login with phone number and password
  Future<void> _handlePhoneLogin(BuildContext context) async {

    final phone = phoneController.text.trim();
    final phoneCode = codeController.text.trim();
    final pass = phonePasswordController.text.trim();
    // Extract phone number (remove formatting)
    final phoneNumber = '$phoneCode$phone';
    if (!phone.isValidPhoneNumber) {
      showCustomToast('Please enter phone number');
      return;
    }
    if (!pass.isValidPin) {
      showCustomToast('Please enter valid pin');
      return;
    }
    final loginData = <String, dynamic>{
      'userPhone': phoneNumber,
      'userPin': pass,
      'isCreatedViaNano':true,
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

      if (response.data?.state?.toLowerCase() != 'new') {
        final userName = authProvider.userDetails?.name ??
            authProvider.loginResponse?.username ??
            'User';
        showCustomToast('Welcome back $userName!', isError: false);

        // Save credentials if remember me is checked
        if (_rememberMe) {
          await _saveLoginCredentials(loginData, userName);
        }

        // Initialize business setup after successful login
        await _initializeBusinessSetupAfterLogin(context);

        await Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.getHomeMainPageRoute(),
          (route) => false, // This removes all previous routes
        );
      }else{
        showCustomToast('${response.message}');


        await RouterHelper.navigateTo(
          context,
          AppRoutes.setPinRoute,                 //  <-- note: use the actual route string
          arguments: {
            'oldPin': loginData['userPin'],
            'userEmail': response.data?.email ?? '',
          },
        ).then((value) {
          passwordController.clear();
          phonePasswordController.clear();
        });
      }



    } else {
      logger.d(response.message);
      showCustomToast('${response.message}!');
    }
  }

  /// Initialize business setup after successful login
  Future<void> _initializeBusinessSetupAfterLogin(BuildContext context) async {
    try {
      // Double-check authentication before initialization
      final authProvider = getAuthProvider(context);
      if (!authProvider.isLoggedIn) {
        logger.w('Attempted to initialize business setup for non-authenticated user');
        return;
      }

      // Initialize business setup service using extension
      await context.businessSetup.initialize();

      // Run workflow setup after initialization
      if (mounted) {
        await Provider.of<WorkflowViewModel>(context, listen: false).skipSetup(context);
      }
    } catch (e) {
      logger.e('Failed to initialize business setup after login: $e');
      // Don't rethrow - let the app continue to home page even if setup fails
    }
  }

  Future<void> _saveLoginCredentials(Map<String, dynamic> loginData, String userName) async {
    try {
      if (loginData.containsKey('email')) {
        await SavedCredentialsService.saveCredential(
          identifier: loginData['email'] as String,
          type: 'email',
          displayName: userName,
        );
      } else if (loginData.containsKey('userPhone')) {
        await SavedCredentialsService.saveCredential(
          identifier: loginData['userPhone'] as String,
          type: 'phone',
          displayName: userName,
        );
      }
    } catch (e) {
      logger.e('Failed to save login credentials: $e');
    }
  }

  Future<void> _checkAndShowSavedCredentials(String type) async {
    try {
      // Check if saved credentials exist for this type
      final credentials = await SavedCredentialsService.getSavedCredentialsByType(type);
      
      // Only show bottom sheet if credentials exist
      if (credentials.isNotEmpty) {
        if (mounted) {
          _showSavedCredentials(type);
        }
      }
    } catch (e) {
      logger.e('Error checking saved credentials: $e');
    }
  }

  void _showSavedCredentials(String type) {
    showSavedCredentialsBottomSheet(
      context: context,
      type: type,
      onCredentialSelected: (credential) {
        if (type == 'email') {
          emailController.text = credential.identifier;
        } else if (type == 'phone') {
          // Parse phone number to separate country code and number
          final phoneNumber = credential.identifier;
          if (phoneNumber.startsWith('+')) {
            // Try to extract country code and number
            // This is a simple implementation - you might want to use a phone number parsing library
            final parts = _parsePhoneNumber(phoneNumber);
            codeController.text = parts['code'] ?? '';
            phoneController.text = parts['number'] ?? phoneNumber;
          } else {
            phoneController.text = phoneNumber;
          }
        }
        // Update last used time
        SavedCredentialsService.updateLastUsed(credential.identifier);
      },
    );
  }

  Map<String, String> _parsePhoneNumber(String phoneNumber) {
    // Simple phone number parsing - you might want to use a proper library
    // This assumes format like +254712345678
    if (phoneNumber.startsWith('+254')) {
      return {
        'code': '+254',
        'number': phoneNumber.substring(4),
      };
    } else if (phoneNumber.startsWith('+')) {
      // Try to extract first 3-4 digits as country code
      final match = RegExp(r'^\+(\d{1,4})(.*)').firstMatch(phoneNumber);
      if (match != null) {
        return {
          'code': '+${match.group(1)}',
          'number': match.group(2) ?? '',
        };
      }
    }
    return {'code': '', 'number': phoneNumber};
  }
}
