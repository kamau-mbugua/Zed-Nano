import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/logger.dart';

import '../../../utils/Common.dart';

class LocationPickerField extends StatelessWidget {
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextEditingController controller;
  final void Function(String)? onLocationSelected;
  final String label;
  final String apiKey;
  final List<String> countries;
  final double debounceTime;
  final int minInputLength;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;

  const LocationPickerField({
    Key? key,
    required this.controller,
    this.apiKey = 'AIzaSyA1i-fE9PcTl1dvC06vhpy7AR_C6c90lTU',
    this.focusNode,
    this.nextFocus,
    this.label = 'Location',
    this.countries = const ['ke', 'ug', 'tz'],
    this.debounceTime = 200,
    this.minInputLength = 2,
    this.onLocationSelected,
    this.textStyle,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48, // Fixed height to match StyledTextField
        decoration: BoxDecoration(
          border: Border.all(color: BodyWhite),
          borderRadius: BorderRadius.circular(13), // Border radius to match StyledTextField
        ),
        child: GooglePlacesAutoCompleteTextFormField(
          googleAPIKey: "AIzaSyA1i-fE9PcTl1dvC06vhpy7AR_C6c90lTU",
          focusNode: focusNode,
          textEditingController: controller,
          countries: countries,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: label,
            hintStyle: TextStyle(
              color: Color(0xff8f9098),
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins", // Poppins font as per user preference
              fontSize: 14.0,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          style: textStyle ?? TextStyle(
            color: Color(0xff2f3036),
            fontWeight: FontWeight.w400,
            fontFamily: "Poppins", // Poppins font as per user preference
            fontSize: 14.0,
          ),
          debounceTime: debounceTime.toInt(),
          fetchCoordinates: true,
          minInputLength: minInputLength,
          onSuggestionClicked: (prediction) {
            controller.text = prediction.description!;
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description!.length),
            );
            onLocationSelected?.call(prediction.description!);
            
            // Handle focus navigation
            if (nextFocus != null) {
              FocusScope.of(context).requestFocus(nextFocus);
            }
          },
          onPlaceDetailsWithCoordinatesReceived: (prediction) {
            loggerNoStack.e("Place details received: ${prediction.description}, Coordinates: ${prediction.lat} ${prediction.lng}");
          },
          maxLines: 1, // Single line to match other text fields
        ),
      ),
    );
  }
}
