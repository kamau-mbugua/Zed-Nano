import 'package:flutter/material.dart';
import 'package:zed_nano/utils/Colors.dart';

class SelectionChipsWidget extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selectedOption;
  final Function(String) onSelectionChanged;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final double chipSpacing;
  final TextStyle? titleStyle;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;
  final EdgeInsets? chipPadding;
  final double? borderRadius;

  const SelectionChipsWidget({
    Key? key,
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onSelectionChanged,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.spacing = 8.0,
    this.chipSpacing = 8.0,
    this.titleStyle,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.chipPadding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          title,
          style: titleStyle ?? const TextStyle(
            color: Color(0xff2f3036),
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
            fontSize: 14.0,
          ),
        ),
        SizedBox(height: spacing),
        Wrap(
          spacing: chipSpacing,
          runSpacing: chipSpacing,
          children: options.map((option) {
            final isSelected = selectedOption == option;
            return GestureDetector(
              onTap: () => onSelectionChanged(option),
              child: Container(
                padding: chipPadding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? (selectedBackgroundColor ?? const Color(0xfff2f4f5))
                      : (unselectedBackgroundColor ?? const Color(0xfffcfcfc)),
                  border: Border.all(
                    color: isSelected 
                        ? (selectedBorderColor ?? const Color(0xff032541))
                        : (unselectedBorderColor ?? const Color(0xffc5c6cc)),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(borderRadius ?? 16),
                ),
                child: Text(
                  option,
                  style: isSelected 
                      ? (selectedTextStyle ?? const TextStyle(
                          color: Color(0xff032541),
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                          fontSize: 12.0,
                        ))
                      : (unselectedTextStyle ?? const TextStyle(
                          color: Color(0xff8f9098),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          fontSize: 12.0,
                        )),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Convenience factory constructors for common use cases
extension SelectionChipsWidgetExtensions on SelectionChipsWidget {
  /// Factory constructor for customer type selection
  static SelectionChipsWidget customerType({
    required List<String> customerTypes,
    required String selectedCustomerType,
    required Function(String) onSelectionChanged,
  }) {
    return SelectionChipsWidget(
      title: 'Customer Type',
      options: customerTypes,
      selectedOption: selectedCustomerType,
      onSelectionChanged: onSelectionChanged,
    );
  }

  /// Factory constructor for invoice type selection
  static SelectionChipsWidget invoiceType({
    required List<String> invoiceTypes,
    required String selectedInvoiceType,
    required Function(String) onSelectionChanged,
  }) {
    return SelectionChipsWidget(
      title: 'Invoice Type',
      options: invoiceTypes,
      selectedOption: selectedInvoiceType,
      onSelectionChanged: onSelectionChanged,
    );
  }

  /// Factory constructor for payment method selection
  static SelectionChipsWidget paymentMethod({
    required List<String> paymentMethods,
    required String selectedPaymentMethod,
    required Function(String) onSelectionChanged,
  }) {
    return SelectionChipsWidget(
      title: 'Payment Method',
      options: paymentMethods,
      selectedOption: selectedPaymentMethod,
      onSelectionChanged: onSelectionChanged,
    );
  }

  /// Factory constructor with project theme colors
  static SelectionChipsWidget withTheme({
    required String title,
    required List<String> options,
    required String selectedOption,
    required Function(String) onSelectionChanged,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    double spacing = 8.0,
    double chipSpacing = 8.0,
  }) {
    return SelectionChipsWidget(
      title: title,
      options: options,
      selectedOption: selectedOption,
      onSelectionChanged: onSelectionChanged,
      crossAxisAlignment: crossAxisAlignment,
      spacing: spacing,
      chipSpacing: chipSpacing,
      selectedBackgroundColor: const Color(0xfff2f4f5),
      unselectedBackgroundColor: Colors.white,
      selectedBorderColor: darkBlueColor, // Using project's primary color
      unselectedBorderColor: innactiveBorder, // Using project's inactive border color
      selectedTextStyle: const TextStyle(
        color: Color(0xff032541),
        fontWeight: FontWeight.w600,
        fontFamily: "Poppins",
        fontSize: 12.0,
      ),
      unselectedTextStyle: TextStyle(
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w400,
        fontFamily: "Poppins",
        fontSize: 12.0,
      ),
    );
  }
}
