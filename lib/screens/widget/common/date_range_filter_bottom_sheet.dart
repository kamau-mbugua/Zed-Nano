import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zed_nano/screens/widget/common/base_bottom_sheet.dart';
import 'package:zed_nano/utils/Colors.dart';

class DateRangeFilterBottomSheet extends StatelessWidget {
  final String selectedRangeLabel;
  final Function(String) onRangeSelected;

  const DateRangeFilterBottomSheet({
    Key? key,
    required this.selectedRangeLabel,
    required this.onRangeSelected,
  }) : super(key: key);

  final List<String> _dateRangeOptions = const [
    'today',
    'this_week',
    'this_month',
    'this_year',
  ];

  final Map<String, String> _dateRangeLabels = const {
    'today': 'Today',
    'this_week': 'This Week',
    'this_month': 'This Month',
    'this_year': 'This Year',
  };

  final Map<String, String> _dateRangeDescriptions = const {
    'today': 'View data for today only',
    'this_week': 'View data for the current week',
    'this_month': 'View data for the current month',
    'this_year': 'View data for the current year',
  };

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      title: 'Select Date Range',
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      headerContent: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Data',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Choose a time period to view your data.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              color: textSecondary,
            ),
          ),
        ],
      ),
      bodyContent: Column(
        children: [
          const SizedBox(height: 16),
          ..._dateRangeOptions.map((option) => _buildRangeOption(
            context,
            option,
            _dateRangeLabels[option] ?? '',
            _dateRangeDescriptions[option] ?? '',
            selectedRangeLabel == option,
          )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRangeOption(
    BuildContext context,
    String value,
    String title,
    String description,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          onRangeSelected(value);
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? appThemePrimary.withOpacity(0.1) : Colors.white,
            border: Border.all(
              color: isSelected ? appThemePrimary : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? appThemePrimary : Colors.grey.shade400,
                    width: 2,
                  ),
                  color: isSelected ? appThemePrimary : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: isSelected ? appThemePrimary : textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        color: isSelected ? appThemePrimary.withOpacity(0.8) : textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
