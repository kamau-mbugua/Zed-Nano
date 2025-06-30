import 'package:csc_picker_plus/dropdown_with_search.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart'; // Assuming your package is locally or pub.dev installed
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
    return DropdownWithSearch<String>(
      title: label,
      placeHolder: "Search $label",
      items: options,
      selected: selectedValue ?? label,
      label: label,
      disabled: disabled,
      decoration: getStyledDropdownDecoration(disabled: disabled),
      disabledDecoration: getStyledDropdownDecoration(disabled: true),
      selectedItemStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14.0,
        color: Color(0xff2f3036),
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
      dialogRadius: 16.0,
      onChanged: (value) {
        if (value != null && value is String) {
          onChanged(value);
        }
      },
    );
  }
}
