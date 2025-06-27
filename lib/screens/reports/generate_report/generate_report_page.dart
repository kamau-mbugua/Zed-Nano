import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/report_model.dart';
import '../providers/reports_provider.dart';
import 'widgets/report_type_selector_widget.dart';

/// Page for generating a new report
class GenerateReportPage extends StatefulWidget {
  /// Creates a new generate report page
  const GenerateReportPage({Key? key}) : super(key: key);

  @override
  State<GenerateReportPage> createState() => _GenerateReportPageState();
}

class _GenerateReportPageState extends State<GenerateReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  ReportType _selectedType = ReportType.sales;
  bool _isGenerating = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Report'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create a New Report',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              _buildTitleField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 16),
              _buildReportTypeSelector(),
              const SizedBox(height: 32),
              _buildGenerateButton(),
              if (_isGenerating) ...[
                const SizedBox(height: 16),
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the title input field
  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Report Title',
        hintText: 'Enter a title for your report',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a title';
        }
        if (value.length < 3) {
          return 'Title must be at least 3 characters';
        }
        return null;
      },
    );
  }

  /// Builds the description input field
  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Enter a description for your report',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a description';
        }
        if (value.length < 10) {
          return 'Description must be at least 10 characters';
        }
        return null;
      },
    );
  }

  /// Builds the report type selector
  Widget _buildReportTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Report Type',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ReportTypeSelectorWidget(
          selectedType: _selectedType,
          onTypeSelected: (type) {
            setState(() {
              _selectedType = type;
            });
          },
        ),
      ],
    );
  }

  /// Builds the generate button
  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isGenerating ? null : _generateReport,
        child: const Text('Generate Report'),
      ),
    );
  }

  /// Generates a new report
  void _generateReport() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isGenerating = true;
      });

      final provider = context.read<ReportsProvider>();
      provider.generateReport(
        title: _titleController.text,
        description: _descriptionController.text,
        type: _selectedType,
      ).then((_) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report generated successfully'),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate report: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }).whenComplete(() {
        if (mounted) {
          setState(() {
            _isGenerating = false;
          });
        }
      });
    }
  }
}