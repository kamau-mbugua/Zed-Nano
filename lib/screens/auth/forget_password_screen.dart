import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/helpers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';

class ResetPinScreen extends StatefulWidget {
  @override
  _ResetPinScreenState createState() => _ResetPinScreenState();
}

class _ResetPinScreenState extends State<ResetPinScreen> {
  bool usePhone = true;
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  final emailController = TextEditingController();

  Future<void> _handleForgotPin(
      Map<String, dynamic> requestBody, BuildContext context) async {
    final authProvider = getAuthProvider(context);
    final response = await authProvider.forgotPin(
        requestData: requestBody, context: context);
    if (response.isSuccess) {
      showCustomToast('${response.message}!', isError: false);
      Navigator.of(context).pop();
    } else {
      logger.d(response.message);
      showCustomToast('${response.message}!');
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    codeController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AuthAppBar(
        title: 'Forgot PIN',
      ),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(16), children: [
          // Title
          const Text(
            'Reset your PIN',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 28,
              color: Color(0xff1f2024),
            ),
          ).paddingSymmetric(horizontal: 10),
          8.height,
          const Text(
            'Enter the details associated with your account.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color(0xff71727a),
            ),
          ).paddingSymmetric(horizontal: 10),
          24.height,
          // Toggle Button
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xfff1f2f4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => usePhone = true),
                    child: Container(
                      decoration: BoxDecoration(
                        color: usePhone ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Use Phone Number',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color:
                              usePhone ? const Color(0xff1f2024) : const Color(0xff71727a),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => usePhone = false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: !usePhone ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Use Email',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color:
                              !usePhone ? const Color(0xff1f2024) : const Color(0xff71727a),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          32.height,
          // Phone or Email Field
          if (usePhone) ...[
            const Text(
              'Phone Number',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xff2f3036),
              ),
            ).paddingSymmetric(horizontal: 10),
            8.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: PhoneInputField(
                  controller: phoneController, codeController: codeController),
            ),
          ] else ...[
            const Text(
              'Email Address',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xff2f3036),
              ),
            ).paddingSymmetric(horizontal: 10),
            8.height,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: StyledTextField(
                controller: emailController,
                textFieldType: TextFieldType.EMAIL,
                hintText: 'Email Address',
              ),
            ),
          ],
          40.height,
          appButton(
                  text: 'Forgot PIN',
                  onTap: () async {
                    Map<String, dynamic> requestBody;

                    if (usePhone) {
                      if (!phoneController.text.isValidPhoneNumber) {
                        showCustomToast('Please enter phone number');
                        return;
                      }

                      final phone = phoneController.text.trim();
                      final phoneCode = codeController.text.trim();
                      final phoneNumber = "$phoneCode$phone";
                      requestBody = {'phoneNumber': phoneNumber};
                    } else {
                      if (!emailController.text.isValidEmail) {
                        showCustomToast('Please enter valid email');
                        return;
                      }
                      requestBody = {'userEmail': emailController.text.trim()};
                    }

                    await _handleForgotPin(requestBody, context);
                  },
                  context: context)
              .paddingSymmetric(horizontal: 10),
        ]),
      ),
    );
  }
}
