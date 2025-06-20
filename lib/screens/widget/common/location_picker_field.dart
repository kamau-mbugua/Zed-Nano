
import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/utils/logger.dart';

import '../../../utils/Common.dart';


class LocationPickerField extends StatelessWidget {
  final FocusNode? focusNode;
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
    this.label = 'Location',
    this.countries = const ['ke'],
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
      child: GooglePlacesAutoCompleteTextFormField(
        googleAPIKey: "AIzaSyA1i-fE9PcTl1dvC06vhpy7AR_C6c90lTU",
        focusNode: focusNode,
        textEditingController: controller,
        countries: countries,
        decoration: inputDecorationBorder(
          context,
          label: label,
          labelStyle: labelStyle ??
              secondaryTextStyle(
                weight: FontWeight.w400,
                color: getBodyColor(),
              ),
        ),
        style: textStyle ?? secondaryTextStyle(),
        debounceTime: debounceTime.toInt(),
        fetchCoordinates: true,
        minInputLength: minInputLength,
        onSuggestionClicked: (prediction) {
          controller.text = prediction.description!;
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description!.length),
          );
          onLocationSelected?.call(prediction.description!);
        },
        onPlaceDetailsWithCoordinatesReceived: (prediction) {
          loggerNoStack.e("Place details received: ${prediction.description}, Coordinates: ${prediction.lat} ${prediction.lng}");
        },
        maxLines: null,
      ),
    );
  }
}
