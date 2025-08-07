import 'package:csc_picker_plus/dropdown_with_search.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart'; // Assuming your package is locally or pub.dev installed
import 'package:zed_nano/screens/widget/common/custom_dropdown_with_search.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/Common.dart';

class SubCategoryPicker extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String> onChanged;
  final bool disabled;

  const SubCategoryPicker({
    Key? key,
    required this.label,
    required this.options,
    this.selectedValue,
    required this.onChanged,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48, // Fixed height to match StyledTextField
      child: CustomDropdownWithSearch<String>(
        title: label,
        placeHolder: "Search $label",
        items: options,
        selected: selectedValue == null || selectedValue!.isEmpty ? label : selectedValue!, // Show label when nothing selected
        label: label,
        disabled: disabled,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Colors.white,
          border: Border.all(
            color: BodyWhite,
            width: 1,
          ),
        ),
        disabledDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Colors.grey.shade100,
          border: Border.all(
            color: BodyWhite,
            width: 1,
          ),
        ),
        selectedItemStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14.0,
          color: selectedValue == null || selectedValue!.isEmpty 
              ? Color(0xff8f9098) // Hint text color
              : Color(0xff2f3036), // Selected text color
        ),
        dropdownHeadingStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: Color(0xff2f3036),
        ),
        itemStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14.0,
          color: Color(0xff2f3036),
        ),
        selectedItemPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
        searchBarRadius: 13.0,
        dialogRadius: 12.0,
        onChanged: (value) {
          if (value != null && value is String && value != label) { // Don't trigger onChanged when selecting the label
            onChanged(value);
          }
        },
      ),
    );
  }
}
