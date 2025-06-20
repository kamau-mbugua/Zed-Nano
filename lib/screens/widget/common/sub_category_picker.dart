import 'package:csc_picker_plus/dropdown_with_search.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart'; // Assuming your package is locally or pub.dev installed

class SubCategoryPicker extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String> onChanged;

  const SubCategoryPicker({
    Key? key,
    required this.label,
    required this.options,
    this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownWithSearch<String>(
      title: label,
      placeHolder: "Search $label",
      items: options,
      selected: selectedValue ?? label,
      label: label,
      onChanged: (value) {
        if (value != null && value is String) {
          onChanged(value);
        }
      },
    );
  }
}
