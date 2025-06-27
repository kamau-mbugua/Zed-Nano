import 'package:flutter/material.dart';
import '../../models/report_model.dart';

/// Widget for selecting a report type
class ReportTypeSelectorWidget extends StatelessWidget {
  /// The currently selected report type
  final ReportType selectedType;
  
  /// Callback when a type is selected
  final ValueChanged<ReportType> onTypeSelected;
  
  /// Creates a new report type selector widget
  const ReportTypeSelectorWidget({
    Key? key,
    required this.selectedType,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTypeOption(
              context,
              ReportType.sales,
              'Sales Report',
              'Summary of sales transactions',
              Icons.trending_up,
              Colors.blue,
            ),
            const Divider(),
            _buildTypeOption(
              context,
              ReportType.inventory,
              'Inventory Report',
              'Current stock levels and movements',
              Icons.inventory_2,
              Colors.green,
            ),
            const Divider(),
            _buildTypeOption(
              context,
              ReportType.customers,
              'Customer Report',
              'Customer analytics and insights',
              Icons.people,
              Colors.orange,
            ),
            const Divider(),
            _buildTypeOption(
              context,
              ReportType.financial,
              'Financial Report',
              'Financial statements and analysis',
              Icons.account_balance,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a single report type option
  Widget _buildTypeOption(
    BuildContext context,
    ReportType type,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    final isSelected = selectedType == type;
    
    return InkWell(
      onTap: () => onTypeSelected(type),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Radio<ReportType>(
              value: type,
              groupValue: selectedType,
              onChanged: (value) {
                if (value != null) {
                  onTypeSelected(value);
                }
              },
              activeColor: color,
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}