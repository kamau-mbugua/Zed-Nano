import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';

/// A reusable styled text input field with consistent styling
class StyledTextField extends StatelessWidget {

  const StyledTextField({
    required this.textFieldType, required this.hintText, super.key,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.isPassword = false,
    this.textInputAction,
    this.maxLength,
    this.showCounter = false,
    this.prefixText = '',
    this.isActive = true,
    this.keyboardType,
  });
  final TextFieldType textFieldType;
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool autofocus;
  final bool isPassword;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final bool showCounter;
  final String prefixText;
  final bool isActive;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    // Determine keyboard type - use number keyboard for password PIN fields
    TextInputType inputType;
    if (keyboardType != null) {
      inputType = keyboardType!;
    } else if (isPassword && textFieldType == TextFieldType.PASSWORD && maxLength == 4) {
      // For PIN fields (password with 4 character limit), use number keyboard
      inputType = TextInputType.number;
    } else {
      // Use default keyboard type based on textFieldType
      switch (textFieldType) {
        case TextFieldType.EMAIL:
          inputType = TextInputType.emailAddress;
        case TextFieldType.PHONE:
          inputType = TextInputType.phone;
        case TextFieldType.NUMBER:
          inputType = TextInputType.number;
        case TextFieldType.MULTILINE:
          inputType = TextInputType.multiline;
        default:
          inputType = TextInputType.text;
      }
    }

    return Container(
      // Only apply fixed height for single-line text fields
      height: textFieldType == TextFieldType.MULTILINE ? null : 50, // Fixed height as per user preference (56px)
      decoration: BoxDecoration(
        border: Border.all(color: isActive ? BodyWhite : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(13), // Border radius as per user preference (16px)
        color: isActive ? Colors.white : Colors.grey.shade100,
      ),
      child: AppTextField(
        key: prefixText.isNotEmpty ? ValueKey('textfield_$prefixText') : null,
        controller: controller,
        focus: focusNode,
        textFieldType: textFieldType,
        keyboardType: inputType, // Set the keyboard type
        onChanged: isActive ? onChanged : null,
        enabled: isActive,
        maxLines: textFieldType == TextFieldType.MULTILINE ? null : 1, // Use null for multiline to allow unlimited lines
        onFieldSubmitted: (value) {
          if (nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
          if (onSubmitted != null) {
            onSubmitted!(value);
          }
        },
        suffixIconColor: getBodyColor(),
        textInputAction: textFieldType == TextFieldType.MULTILINE 
            ? TextInputAction.newline 
            : (nextFocus != null ? TextInputAction.next : textInputAction),
        suffixPasswordInvisibleWidget: isPassword
            ? Image.asset(hideIcon, height: 16, width: 16, fit: BoxFit.fill)
            .paddingSymmetric(vertical: 16, horizontal: 14)
            : null,
        suffixPasswordVisibleWidget: isPassword
            ? Image.asset(showIcon, height: 16, width: 16, fit: BoxFit.fill)
            .paddingSymmetric(vertical: 16, horizontal: 14)
            : null,
        inputFormatters: maxLength != null 
            ? [LengthLimitingTextInputFormatter(maxLength)]
            : null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: isActive ? const Color(0xff8f9098) : Colors.grey.shade400,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins', // Poppins font as per user preference
            fontSize: 12,

          ),
          contentPadding: EdgeInsets.symmetric(vertical: isPassword ? 15 :0, horizontal: 16),
          counterText: showCounter ? null : '',
          prefix: prefixText.isEmpty ? null : Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
              key: ValueKey('prefix_$prefixText'),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: lightGreyColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child:Text('$prefixText ', style: boldTextStyle(size: 11)),
            ),
          ),
        ),
      ),
    );
  }
}

/// A reusable phone number input field with country code picker
class PhoneInputField extends StatefulWidget {

   PhoneInputField({
    super.key,
    this.controller,
    this.codeController,
    this.focusNode,
    this.nextFocus,
    this.onChanged,
    this.onSubmitted,
    this.maxLength,
    this.onCountryChanged,
    this.initialCountryCode = 'KE',
    this.favoriteCountries = const ['+254', 'KE'],
  });
  final TextEditingController? controller;
  TextEditingController? codeController;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final int? maxLength;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function(CountryCode)? onCountryChanged;
  final String initialCountryCode;
  final List<String> favoriteCountries;

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late CountryCode selectedCountry;

  @override
  void initState() {
    super.initState();
    selectedCountry = CountryCode(
      code: widget.initialCountryCode,
      dialCode: widget.favoriteCountries.first,
      name: '',
    );
    
    // Initialize the country code controller with the default country code
    widget.codeController?.text = selectedCountry.dialCode ?? '+254';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56, // Fixed height for consistency
      decoration: BoxDecoration(
        border: Border.all(color: BodyWhite),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Container(
            width: 70, // Fixed width for the country code
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: BodyWhite)),
            ),
            child: CountryCodePicker(
              onChanged: (CountryCode code) {
                setState(() {
                  selectedCountry = code;
                  widget.codeController?.text = code.dialCode ?? '+254';
                });
                if (widget.onCountryChanged != null) {
                  widget.onCountryChanged!(code);
                }
              },
              initialSelection: widget.initialCountryCode,
              favorite: widget.favoriteCountries,
              showFlag: false, // Hide the flag
              alignLeft: true,
              showFlagMain: false,
              showFlagDialog: true,
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(
                color: Color(0xff1f2024),
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: AppTextField(
              controller: widget.controller,
              focus: widget.focusNode,
              textFieldType: TextFieldType.PHONE,
              onChanged: widget.onChanged,
              maxLength: widget.maxLength,
              onFieldSubmitted: (value) {
                if (widget.nextFocus != null) {
                  FocusScope.of(context).requestFocus(widget.nextFocus);
                }
                if (widget.onSubmitted != null) {
                  widget.onSubmitted!(value);
                }
              },
              textInputAction: widget.nextFocus != null ? TextInputAction.next : null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Phone Number',
                hintStyle: TextStyle(
                  color: Color(0xff8f9098),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                counterText: '',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A row with two equal-width text fields
class NameFieldsRow extends StatelessWidget {

  const NameFieldsRow({
    super.key,
    this.firstNameController,
    this.lastNameController,
    this.onFirstNameChanged,
    this.onLastNameChanged,
    this.firstNameFocusNode,
    this.lastNameFocusNode,
    this.focusNodeComplete,

    //FocusNode? focusNode,

  });
  final TextEditingController? firstNameController;
  final TextEditingController? lastNameController;

  final FocusNode? firstNameFocusNode;
  final FocusNode? lastNameFocusNode;
  final FocusNode? focusNodeComplete;
  final Function(String)? onFirstNameChanged;
  final Function(String)? onLastNameChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 56, // Fixed height for consistency
              decoration: BoxDecoration(
                border: Border.all(color: BodyWhite),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AppTextField(
                controller: firstNameController,
                textFieldType: TextFieldType.NAME,
                onChanged: onFirstNameChanged,
                focus: firstNameFocusNode,
                nextFocus: lastNameFocusNode,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'First Name',
                  hintStyle: TextStyle(
                    color: Color(0xff8f9098),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ),
              ),
            ),
          ),
          16.width, // Space between fields
          Expanded(
            child: Container(
              height: 56, // Fixed height for consistency
              decoration: BoxDecoration(
                border: Border.all(color: BodyWhite),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AppTextField(
                controller: lastNameController,
                textFieldType: TextFieldType.NAME,
                onChanged: onLastNameChanged,
                focus: lastNameFocusNode,
                nextFocus: focusNodeComplete,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Last Name',
                  hintStyle: TextStyle(
                    color: Color(0xff8f9098),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
