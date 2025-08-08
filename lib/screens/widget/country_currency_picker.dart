import 'package:currency_country_picker/currency_country_picker.dart';
import 'package:flutter/material.dart';

class CountryCurrencyPicker extends StatefulWidget {
  
  const CountryCurrencyPicker({
    required this.onSelect, super.key,
    this.initialCountry,
    this.hintText = 'Select Country',
    this.showFlag = true,
  });
  final Function(String countryName, String currencyCode) onSelect;
  final String? initialCountry;
  final String hintText;
  final bool showFlag;

  @override
  State<CountryCurrencyPicker> createState() => _CountryCurrencyPickerState();
}

class _CountryCurrencyPickerState extends State<CountryCurrencyPicker> {
  String? selectedCountry;
  String? selectedCurrency;

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.initialCountry;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48, // Fixed height of 56px as per user preference
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade600), // Outlined border like StyledTextField
        borderRadius: BorderRadius.circular(10), // 16px border radius as per user preference
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          showCountryPickerFullScreen(
            context: context,
            showFlag: widget.showFlag,
            // Add favorite countries to prioritize them at the top of the list
            favorites: <String>['254', '256', '255'], // Kenya, Uganda, Tanzania phone codes
            theme: CountryPickerThemeData(
              countryCodeTextStyle: const TextStyle(
                fontFamily: 'Poppins', // Poppins font as per user preference
                fontSize: 14,
                color: Colors.black87,
              ),
              titleTextStyle: const TextStyle(
                fontFamily: 'Poppins', // Poppins font as per user preference
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              flagSize: 24,
              backgroundColor: Colors.white, // Changed from black to white
              searchTextStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            onSelect: (Country country) {
              setState(() {
                selectedCountry = country.name;
                selectedCurrency = country.currencyCode;
              });
              widget.onSelect(country.name, country.currencyCode);
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedCountry != null ? '$selectedCountry' : widget.hintText,
                style: TextStyle(
                  fontFamily: 'Poppins', // Poppins font as per user preference
                  fontSize: 14,
                  color: selectedCountry != null ? Colors.black : Colors.grey,
                ),
              ),
              // if (selectedCurrency != null)
              //   Container(
              //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //     decoration: BoxDecoration(
              //       color: Colors.grey.shade200,
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: Text(
              //       "",
              //       style: TextStyle(
              //         fontFamily: 'Poppins', // Poppins font as per user preference
              //         fontSize: 12,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
