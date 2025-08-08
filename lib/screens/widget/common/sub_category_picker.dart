import 'package:flutter/material.dart';
import 'package:zed_nano/screens/widget/common/custom_dropdown_with_search.dart';
import 'package:zed_nano/utils/Colors.dart';

class SubCategoryPicker extends StatelessWidget {

  const SubCategoryPicker({
    required this.label, required this.options, required this.onChanged, super.key,
    this.selectedValue,
    this.disabled = false,
  });
  final String label;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String> onChanged;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48, // Fixed height to match StyledTextField
      child: CustomDropdownWithSearch<String>(
        title: label,
        placeHolder: 'Search $label',
        items: options,
        selected: selectedValue == null || selectedValue!.isEmpty ? label : selectedValue!, // Show label when nothing selected
        label: label,
        disabled: disabled,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Colors.white,
          border: Border.all(
            color: BodyWhite,
          ),
        ),
        disabledDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Colors.grey.shade100,
          border: Border.all(
            color: BodyWhite,
          ),
        ),
        selectedItemStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: selectedValue == null || selectedValue!.isEmpty 
              ? const Color(0xff8f9098) // Hint text color
              : const Color(0xff2f3036), // Selected text color
        ),
        dropdownHeadingStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xff2f3036),
        ),
        itemStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: Color(0xff2f3036),
        ),
        selectedItemPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
        searchBarRadius: 13,
        dialogRadius: 12,
        onChanged: (value) {
          if (value != null && value is String && value != label) { // Don't trigger onChanged when selecting the label
            onChanged(value);
          }
        },
      ),
    );
  }
}
