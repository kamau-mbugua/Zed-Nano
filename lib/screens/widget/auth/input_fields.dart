import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:zed_nano/utils/Common.dart';
import 'package:zed_nano/utils/Images.dart';

/// A reusable styled text input field with consistent styling
class StyledTextField extends StatelessWidget {
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


  const StyledTextField({
    Key? key,
    required this.textFieldType,
    required this.hintText,
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
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56, // Fixed height as per user preference (56px)
      decoration: BoxDecoration(
        border: Border.all(color: BodyWhite),
        borderRadius: BorderRadius.circular(13), // Border radius as per user preference (16px)
      ),
      child: AppTextField(
        controller: controller,
        focus: focusNode,
        textFieldType: textFieldType,
        onChanged: onChanged,
        onFieldSubmitted: (value) {
          if (nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
          if (onSubmitted != null) {
            onSubmitted!(value);
          }
        },
        suffixIconColor: getBodyColor(),
        textInputAction: nextFocus != null ? TextInputAction.next : textInputAction,
        suffixPasswordInvisibleWidget: isPassword
            ? Image.asset(hideIcon, height: 16, width: 16, fit: BoxFit.fill)
            .paddingSymmetric(vertical: 16, horizontal: 14)
            : null,
        suffixPasswordVisibleWidget: isPassword
            ? robotoText(text: 'Show', color: appThemePrimary).paddingOnly(top: 20)
            : null,
        inputFormatters: maxLength != null 
            ? [LengthLimitingTextInputFormatter(maxLength)]
            : null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color(0xff8f9098),
            fontWeight: FontWeight.w400,
            fontFamily: "Poppins", // Poppins font as per user preference
            fontSize: 14.0,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          counterText: showCounter ? null : '',
        ),
      ),
    );
  }
}

/// A reusable phone number input field with country code picker
class PhoneInputField extends StatefulWidget {
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

   PhoneInputField({
    Key? key,
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
  }) : super(key: key);

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
            decoration: BoxDecoration(
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
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              alignLeft: true,
              hideMainText: false,
              showFlagMain: false,
              showFlagDialog: true,
              hideSearch: false,
              padding: EdgeInsets.zero,
              textStyle: TextStyle(
                color: Color(0xff1f2024),
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins",
                fontSize: 14.0,
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
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Phone Number",
                hintStyle: TextStyle(
                  color: Color(0xff8f9098),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                  fontSize: 14.0,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
  final TextEditingController? firstNameController;
  final TextEditingController? lastNameController;

  final FocusNode? firstNameFocusNode;
  final FocusNode? lastNameFocusNode;
  final FocusNode? focusNodeComplete;
  final Function(String)? onFirstNameChanged;
  final Function(String)? onLastNameChanged;

  const NameFieldsRow({
    Key? key,
    this.firstNameController,
    this.lastNameController,
    this.onFirstNameChanged,
    this.onLastNameChanged,
    this.firstNameFocusNode,
    this.lastNameFocusNode,
    this.focusNodeComplete,

    //FocusNode? focusNode,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
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
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "First Name",
                  hintStyle: TextStyle(
                    color: Color(0xff8f9098),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                    fontSize: 14.0,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Last Name",
                  hintStyle: TextStyle(
                    color: Color(0xff8f9098),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                    fontSize: 14.0,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
