import 'package:flutter/material.dart';
import 'package:zed_nano/utils/Colors.dart';

class CustomDatePickerField extends StatelessWidget {

  const CustomDatePickerField({
    required this.label, required this.onDateSelected, super.key,
    this.selectedDate,
    this.firstDate,
    this.lastDate,
    this.hintText,
    this.enabled = true,
    this.prefixIcon,
    this.borderColor,
    this.fillColor,
  });
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? hintText;
  final bool enabled;
  final IconData? prefixIcon;
  final Color? borderColor;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: enabled ? () => _selectDate(context) : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: enabled
                  ? (fillColor ?? Colors.white)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: borderColor ?? Colors.grey.shade300,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (prefixIcon != null) ...[
                      Icon(
                        prefixIcon,
                        size: 16,
                        color: enabled ? textPrimary : Colors.grey.shade500,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      selectedDate != null
                          ? _formatDate(selectedDate!)
                          : (hintText ?? label),
                      style: TextStyle(
                        color: selectedDate != null
                            ? (enabled ? textPrimary : Colors.grey.shade500)
                            : textSecondary,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: enabled ? Colors.grey.shade600 : Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: appThemePrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: appThemePrimary,
                textStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            textTheme: const TextTheme(
              headlineMedium: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              bodyLarge: TextStyle(
                fontFamily: 'Poppins',
              ),
              bodyMedium: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }
}

// Alternative compact version for inline use
class CompactDatePickerField extends StatelessWidget {

  const CompactDatePickerField({
    required this.onDateSelected, super.key,
    this.selectedDate,
    this.firstDate,
    this.lastDate,
    this.placeholder,
    this.enabled = true,
    this.width,
  });
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? placeholder;
  final bool enabled;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => _selectDate(context) : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: enabled ? textPrimary : Colors.grey.shade500,
            ),
            const SizedBox(width: 8),
            Text(
              selectedDate != null
                  ? _formatDate(selectedDate!)
                  : (placeholder ?? 'Select Date'),
              style: TextStyle(
                color: selectedDate != null
                    ? (enabled ? textPrimary : Colors.grey.shade500)
                    : textSecondary,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: appThemePrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: appThemePrimary,
                textStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }
}
