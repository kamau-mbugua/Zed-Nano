import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/providers_helpers.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/auth/input_fields.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/extensions.dart';

class SetNewPinPage extends StatefulWidget {
  final String? oldPin;
  final String? userEmail;
  const SetNewPinPage({Key? key, this.oldPin, this.userEmail})
      : super(key: key);

  @override
  _SetNewPinPageState createState() => _SetNewPinPageState();
}

class _SetNewPinPageState extends State<SetNewPinPage> {
  final pinFocus = FocusNode();
  final confirmPinFocus = FocusNode();
  final pinController = TextEditingController();
  final confirmPinController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pinController.dispose();
    confirmPinController.dispose();
    pinFocus.dispose();
    confirmPinFocus.dispose();
    super.dispose();
  }

  Future<void> _handleSetNewPin(
      Map<String, dynamic> requestBody, BuildContext context) async {
    final authProvider = getAuthProvider(context);
    final response = await authProvider.resetPinVersion(
        requestData: requestBody, context: context);
    if (response.isSuccess) {
      showCustomToast('New Pin Set, Login with New Pin', isError: false);
      Navigator.of(context).pop();
    } else {
      logger.d(response.message);
      showCustomToast('${response.message}!');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthAppBar(
        title: 'Set Pin',
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          Text('Enter a New PIN',
              style: boldTextStyle(
                size: 24,
                fontFamily: 'Poppins',
              )).paddingSymmetric(horizontal: 16),
          8.height,
          Text('Secure your account with a new PIN.',
                  style: secondaryTextStyle(
                      size: 12,
                      weight: FontWeight.w500,
                      color: getBodyColor(),
                      fontFamily: 'Poppins'))
              .paddingSymmetric(horizontal: 16),
          16.height,
          Text('New Pin.',
                  style: secondaryTextStyle(
                      size: 12,
                      weight: FontWeight.w600,
                      color: textPrimary,
                      fontFamily: 'Poppins'))
              .paddingSymmetric(horizontal: 16),
          8.height,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: StyledTextField(
              controller: pinController,
              focusNode: pinFocus,
              nextFocus: confirmPinFocus,
              maxLength:4,
              textFieldType: TextFieldType.PASSWORD,
              hintText: 'Pin',
            ),
          ),
          16.height,
          Text('Confirm New PIN.',
                  style: secondaryTextStyle(
                      size: 12,
                      weight: FontWeight.w600,
                      color: textPrimary,
                      fontFamily: 'Poppins'))
              .paddingSymmetric(horizontal: 16),
          8.height,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: StyledTextField(
              controller: confirmPinController,
              focusNode: confirmPinFocus,
              maxLength:4,
              textFieldType: TextFieldType.PASSWORD,
              hintText: 'Pin',
            ),
          ),
          16.height,
          appButton(
                  text: 'Set Pin',
                  onTap: () async {
                    var pin = pinController.text.trim();
                    var confirmPin = confirmPinController.text.trim();
                    if (!pin.isValidPin) {
                      showCustomToast('Please enter valid pin');
                      return;
                    }
                    if (!confirmPin.isValidPin) {
                      showCustomToast('Please enter valid pin');
                      return;
                    }
                    if (pin != confirmPin) {
                      showCustomToast('Pin not matched');
                      return;
                    }

                    Map<String, dynamic> data = {
                      'userNewPin': pin,
                      'userEmail': widget.userEmail,
                      'userPin': widget.oldPin
                    };

                    await _handleSetNewPin(data, context);
                  },
                  context: context)
              .paddingSymmetric(horizontal: 16),
          16.height,
        ],
      )),
    );
  }
}
