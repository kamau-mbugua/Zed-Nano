import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/viewmodels/DataRefreshViewModel.dart';

/// Extension methods to easily access DataRefreshViewModel from BuildContext
extension DataRefreshExtensions on BuildContext {
  /// Get the DataRefreshViewModel instance
  DataRefreshViewModel get dataRefresh => Provider.of<DataRefreshViewModel>(this, listen: false);
  
  /// Get the DataRefreshViewModel instance with listening
  DataRefreshViewModel get dataRefreshWithListen => Provider.of<DataRefreshViewModel>(this, listen: true);
}

/// Extension methods for common refresh operations
extension DataRefreshHelpers on DataRefreshViewModel {
  /// Refresh data after order operations (create, update, payment, etc.)
  void refreshAfterOrderOperation({String? operation}) {
    refreshOrderData(customEvent: operation != null ? 'order_$operation' : 'order_operation');
  }
  
  /// Refresh data after customer operations
  void refreshAfterCustomerOperation({String? operation}) {
    refreshCustomerData(customEvent: operation != null ? 'customer_$operation' : 'customer_operation');
  }
  
  /// Refresh data after payment operations
  void refreshAfterPaymentOperation({String? operation}) {
    refreshPaymentData(customEvent: operation != null ? 'payment_$operation' : 'payment_operation');
  }
  
  /// Refresh data after inventory operations
  void refreshAfterInventoryOperation({String? operation}) {
    refreshInventoryData(customEvent: operation != null ? 'inventory_$operation' : 'inventory_operation');
  }
  
  /// Refresh dashboard after any major operation
  void refreshAfterMajorOperation({String? operation}) {
    refreshDashboardData(customEvent: operation != null ? 'major_$operation' : 'major_operation');
  }

  void refreshStockAfterMajorOperation({String? operation}) {
    refreshStock(customEvent: operation != null ? 'major_$operation' : 'major_operation');
  }

  void refreshInventoryAfterMajorOperation({String? operation}) {
    refreshInventory(customEvent: operation != null ? 'major_$operation' : 'major_operation');
  }

  void refreshCustomersAfterMajorOperation({String? operation}) {
    refreshCustomers(customEvent: operation != null ? 'major_$operation' : 'major_operation');
  }
}
