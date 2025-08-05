import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/screens/reports/sales_by_day/sales_by_day_summary_page.dart';
import 'package:zed_nano/screens/widget/auth/auth_app_bar.dart';
import 'package:zed_nano/screens/widget/common/custom_date_picker_field.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/utils/Colors.dart';
import 'package:zed_nano/utils/date_range_util.dart';

class SalesReportByDayPage extends StatefulWidget {
  const SalesReportByDayPage({Key? key}) : super(key: key);

  @override
  State<SalesReportByDayPage> createState() => _SalesReportByDayPageState();
}

class _SalesReportByDayPageState extends State<SalesReportByDayPage> {
  String _selectedDuration = 'this_week';
  DateTime? _fromDate;
  DateTime? _toDate;


  final List<String> _durationOptions = [
    'this_week',
    'this_month',
    'this_year',
    'custom_date',
  ];

  final Map<String, String> _durationLabels = {
    'this_week': 'This Week',
    'this_month': 'This Month',
    'this_year': 'This Year',
    'custom_date': 'Custom Date',
  };

  @override
  void initState() {
    super.initState();
    // Set default dates for custom date
    _fromDate = DateTime.now().subtract(const Duration(days: 7));
    _toDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar:AuthAppBar(title: 'Reports'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildDurationSelection(),
                  const SizedBox(height: 100), // Space for fixed button
                ],
              ),
            ),
          ),
          _buildDownloadButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sales Report By Day',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
            fontSize: 28,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Generate daily breakdown of sales by day.',
          style: TextStyle(
            color: textSecondary,
            fontWeight: FontWeight.w400,
            fontFamily: "Poppins",
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Duration',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        ..._durationOptions.map((option) => _buildDurationOption(option)),
        if (_selectedDuration == 'custom_date') ...[
          const SizedBox(height: 24),
          _buildCustomDateFields(),
        ],
      ],
    );
  }

  Widget _buildDurationOption(String option) {
    final isSelected = _selectedDuration == option;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedDuration = option;
            if (option != 'custom_date') {
              // Set dates based on predefined ranges
              final dateRange = DateRangeUtil.getDateRange(option);
              _fromDate = DateTime.parse(dateRange.values.first);
              _toDate = DateTime.parse(dateRange.values.last);
            }
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: isSelected ? lightGreyColor : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:  Colors.grey.shade300,
              width:  1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _durationLabels[option] ?? '',
                style: TextStyle(
                  color: isSelected ? appThemePrimary : textPrimary,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                  fontSize: 14,
                ),
              ),
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
                        Icons.circle,
                        size: 10,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomDateFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomDatePickerField(
                label: 'From',
                selectedDate: _fromDate,
                onDateSelected: (date) {
                  setState(() {
                    _fromDate = date;
                    // Ensure from date is not after to date
                    if (_toDate != null && date.isAfter(_toDate!)) {
                      _toDate = date;
                    }
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomDatePickerField(
                label: 'To',
                selectedDate: _toDate,
                onDateSelected: (date) {
                  setState(() {
                    _toDate = date;
                    // Ensure to date is not before from date
                    if (_fromDate != null && date.isBefore(_fromDate!)) {
                      _fromDate = date;
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDownloadButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: !_selectedDuration.isEmptyOrNull ? appThemePrimary : Colors.grey, width: 0.2),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _downloadReport,
            style: ElevatedButton.styleFrom(
              backgroundColor:!_selectedDuration.isEmptyOrNull ? appThemePrimary : Colors.grey.shade300,
              foregroundColor: textSecondary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Download Report',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _downloadReport() async{
    var startDate = _fromDate != null ? '${_fromDate!.day.toString().padLeft(2, '0')}-${_fromDate!.month.toString().padLeft(2, '0')}-${_fromDate!.year}' : '';
    var endDate = _toDate != null ? '${_toDate!.day.toString().padLeft(2, '0')}-${_toDate!.month.toString().padLeft(2, '0')}-${_toDate!.year}' : '';
    final Map<String, dynamic> requestData = {
      'StartDate':startDate,
      'EndDate':endDate,
    };
    await context
        .read<BusinessProviders>()
        .getSalesByDay(context: context, requestData:requestData)
        .then((value) async {
      if (value.isSuccess) {
        await SalesByDaySummaryPage(
          startDate: startDate,
          endDate: endDate,
        ).launch(context).then((value) {
          finish(context);
        });
      } else {
        showCustomToast(value.message ?? 'Something went wrong');
      }
    });

  }
}
