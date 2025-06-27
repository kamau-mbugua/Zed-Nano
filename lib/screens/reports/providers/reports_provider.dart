import 'package:flutter/foundation.dart';
import '../models/report_model.dart';

/// Provider for managing reports state
class ReportsProvider extends ChangeNotifier {
  /// List of all reports
  List<ReportModel> _reports = [];
  
  /// Currently selected report
  ReportModel? _selectedReport;
  
  /// Loading state
  bool _isLoading = false;
  
  /// Error message if any
  String? _errorMessage;
  
  /// Get all reports
  List<ReportModel> get reports => _reports;
  
  /// Get currently selected report
  ReportModel? get selectedReport => _selectedReport;
  
  /// Get loading state
  bool get isLoading => _isLoading;
  
  /// Get error message
  String? get errorMessage => _errorMessage;
  
  /// Fetch all reports from the backend
  Future<void> fetchReports() async {
    _setLoading(true);
    _clearError();
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      _reports = [
        ReportModel(
          id: '1',
          title: 'Monthly Sales Report',
          description: 'Summary of all sales for the current month',
          generatedDate: DateTime.now().subtract(const Duration(days: 2)),
          type: ReportType.sales,
          filePath: '/reports/sales_report_june.pdf',
        ),
        ReportModel(
          id: '2',
          title: 'Inventory Status',
          description: 'Current inventory levels and stock alerts',
          generatedDate: DateTime.now().subtract(const Duration(days: 5)),
          type: ReportType.inventory,
          filePath: '/reports/inventory_june.pdf',
        ),
        ReportModel(
          id: '3',
          title: 'Customer Analytics',
          description: 'Customer behavior and purchasing patterns',
          generatedDate: DateTime.now().subtract(const Duration(days: 10)),
          type: ReportType.customers,
          filePath: '/reports/customers_q2.pdf',
        ),
      ];
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch reports: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Select a report by ID
  void selectReport(String reportId) {
    _selectedReport = _reports.firstWhere(
      (report) => report.id == reportId,
      orElse: () => throw Exception('Report not found'),
    );
    notifyListeners();
  }
  
  /// Clear selected report
  void clearSelectedReport() {
    _selectedReport = null;
    notifyListeners();
  }
  
  /// Generate a new report
  Future<void> generateReport({
    required String title,
    required String description,
    required ReportType type,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Create new report
      final newReport = ReportModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        generatedDate: DateTime.now(),
        type: type,
        filePath: '/reports/${type.toString().split('.').last}_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      
      // Add to list
      _reports.add(newReport);
      
      // Select the new report
      _selectedReport = newReport;
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to generate report: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Delete a report by ID
  Future<void> deleteReport(String reportId) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Remove from list
      _reports.removeWhere((report) => report.id == reportId);
      
      // Clear selected report if it was deleted
      if (_selectedReport?.id == reportId) {
        _selectedReport = null;
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete report: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  /// Set error message
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  
  /// Clear error message
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}