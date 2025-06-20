import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:country_code_picker/country_code_picker.dart';

/// A reusable styled text input field with consistent styling
class StyledTextField extends StatelessWidget {
  final TextFieldType textFieldType;
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool autofocus;
  final TextInputAction? textInputAction;

  const StyledTextField({
    Key? key,
    required this.textFieldType,
    required this.hintText,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48, // Fixed height for consistency
      decoration: BoxDecoration(
        border: Border.all(color: BodyWhite),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AppTextField(
        controller: controller,
        focus: focusNode,
        textFieldType: textFieldType,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        // autofocus: autofocus,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color(0xff8f9098),
            fontWeight: FontWeight.w400,
            fontFamily: "Poppins",
            fontSize: 14.0,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }
}

/// A reusable phone number input field with country code picker
class PhoneInputField extends StatefulWidget {
  final TextEditingController? controller;
  final Function(CountryCode)? onCountryChanged;
  final Function(String)? onPhoneChanged;
  final String initialCountryCode;
  final List<String> favoriteCountries;

  const PhoneInputField({
    Key? key,
    this.controller,
    this.onCountryChanged,
    this.onPhoneChanged,
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48, // Fixed height for consistency
      decoration: BoxDecoration(
        border: Border.all(color: BodyWhite),
        borderRadius: BorderRadius.circular(12),
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
              textFieldType: TextFieldType.PHONE,
              onChanged: widget.onPhoneChanged,
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
  final Function(String)? onFirstNameChanged;
  final Function(String)? onLastNameChanged;

  const NameFieldsRow({
    Key? key,
    this.firstNameController,
    this.lastNameController,
    this.onFirstNameChanged,
    this.onLastNameChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48, // Fixed height for consistency
              decoration: BoxDecoration(
                border: Border.all(color: BodyWhite),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AppTextField(
                controller: firstNameController,
                textFieldType: TextFieldType.NAME,
                onChanged: onFirstNameChanged,
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
              height: 48, // Fixed height for consistency
              decoration: BoxDecoration(
                border: Border.all(color: BodyWhite),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AppTextField(
                controller: lastNameController,
                textFieldType: TextFieldType.NAME,
                onChanged: onLastNameChanged,
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
