import 'package:flutter/foundation.dart';
import 'package:zed_nano/app/app_initializer.dart';

/// Enum for different types of data that can be refreshed
enum DataRefreshType {
  orders,
  customers,
  products,
  invoices,
  dashboard,
  transactions,
  payments,
  inventory,
  reports,
  all,
}

/// A comprehensive view model for managing data refresh events across the app.
/// This allows any page to trigger refresh events and other pages to listen and respond.
class DataRefreshViewModel with ChangeNotifier {
  final Map<DataRefreshType, DateTime> _lastRefreshed = {};
  final Map<DataRefreshType, bool> _isRefreshing = {};
  final Map<String, DateTime> _customRefreshEvents = {};

  /// Get the last refresh time for a specific data type
  DateTime? getLastRefreshed(DataRefreshType type) => _lastRefreshed[type];

  /// Check if a specific data type is currently being refreshed
  bool isRefreshing(DataRefreshType type) => _isRefreshing[type] ?? false;

  /// Check if any data is currently being refreshed
  bool get isAnyRefreshing => _isRefreshing.values.any((refreshing) => refreshing);

  /// Trigger a refresh for a specific data type
  void triggerRefresh(DataRefreshType type, {String? customEvent}) {
    _isRefreshing[type] = true;
    _lastRefreshed[type] = DateTime.now();
    
    if (customEvent != null) {
      _customRefreshEvents[customEvent] = DateTime.now();
    }
    
    notifyListeners();
    logger.d('DataRefreshViewModel: Triggered refresh for $type${customEvent != null ? ' with custom event: $customEvent' : ''}');
  }

  /// Complete a refresh for a specific data type
  void completeRefresh(DataRefreshType type) {
    _isRefreshing[type] = false;
    notifyListeners();
    logger.d('DataRefreshViewModel: Completed refresh for $type');
  }

  /// Trigger refresh for multiple data types
  void triggerMultipleRefresh(List<DataRefreshType> types, {String? customEvent}) {
    for (final type in types) {
      _isRefreshing[type] = true;
      _lastRefreshed[type] = DateTime.now();
    }
    
    if (customEvent != null) {
      _customRefreshEvents[customEvent] = DateTime.now();
    }
    
    notifyListeners();
    logger.d('DataRefreshViewModel: Triggered refresh for multiple types: $types${customEvent != null ? ' with custom event: $customEvent' : ''}');
  }

  /// Complete refresh for multiple data types
  void completeMultipleRefresh(List<DataRefreshType> types) {
    for (final type in types) {
      _isRefreshing[type] = false;
    }
    notifyListeners();
    logger.d('DataRefreshViewModel: Completed refresh for multiple types: $types');
  }

  /// Trigger a refresh for all data types
  void triggerRefreshAll({String? customEvent}) {
    for (final type in DataRefreshType.values) {
      if (type != DataRefreshType.all) {
        _isRefreshing[type] = true;
        _lastRefreshed[type] = DateTime.now();
      }
    }
    
    if (customEvent != null) {
      _customRefreshEvents[customEvent] = DateTime.now();
    }
    
    notifyListeners();
    logger.d('DataRefreshViewModel: Triggered refresh for ALL data types${customEvent != null ? ' with custom event: $customEvent' : ''}');
  }

  /// Complete refresh for all data types
  void completeRefreshAll() {
    for (final type in DataRefreshType.values) {
      if (type != DataRefreshType.all) {
        _isRefreshing[type] = false;
      }
    }
    notifyListeners();
    logger.d('DataRefreshViewModel: Completed refresh for ALL data types');
  }

  /// Get the last time a custom event was triggered
  DateTime? getCustomEventTime(String eventName) => _customRefreshEvents[eventName];

  /// Check if a custom event has been triggered recently (within specified duration)
  bool wasCustomEventTriggeredRecently(String eventName, Duration within) {
    final eventTime = _customRefreshEvents[eventName];
    if (eventTime == null) return false;
    return DateTime.now().difference(eventTime) <= within;
  }

  /// Clear all refresh states
  void clearAllRefreshStates() {
    _isRefreshing.clear();
    _lastRefreshed.clear();
    _customRefreshEvents.clear();
    notifyListeners();
    logger.d('DataRefreshViewModel: Cleared all refresh states');
  }

  /// Get a summary of refresh states for debugging
  Map<String, dynamic> getRefreshSummary() {
    return {
      'isRefreshing': Map.fromEntries(
        _isRefreshing.entries.map((e) => MapEntry(e.key.toString(), e.value))
      ),
      'lastRefreshed': Map.fromEntries(
        _lastRefreshed.entries.map((e) => MapEntry(e.key.toString(), e.value.toIso8601String()))
      ),
      'customEvents': Map.fromEntries(
        _customRefreshEvents.entries.map((e) => MapEntry(e.key, e.value.toIso8601String()))
      ),
    };
  }

  // Convenience methods for common refresh scenarios

  /// Trigger order-related refresh (orders, dashboard, transactions)
  void refreshOrderData({String? customEvent}) {
    triggerMultipleRefresh([
      DataRefreshType.orders,
      DataRefreshType.dashboard,
      DataRefreshType.transactions,
    ], customEvent: customEvent);
  }

  /// Trigger customer-related refresh (customers, orders, transactions)
  void refreshCustomerData({String? customEvent}) {
    triggerMultipleRefresh([
      DataRefreshType.customers,
      DataRefreshType.orders,
      DataRefreshType.transactions,
    ], customEvent: customEvent);
  }

  /// Trigger payment-related refresh (payments, orders, dashboard)
  void refreshPaymentData({String? customEvent}) {
    triggerMultipleRefresh([
      DataRefreshType.payments,
      DataRefreshType.orders,
      DataRefreshType.dashboard,
      DataRefreshType.transactions,
    ], customEvent: customEvent);
  }

  /// Trigger inventory-related refresh (products, inventory, dashboard)
  void refreshInventoryData({String? customEvent}) {
    triggerMultipleRefresh([
      DataRefreshType.products,
      DataRefreshType.inventory,
      DataRefreshType.dashboard,
    ], customEvent: customEvent);
  }

  /// Trigger dashboard refresh (dashboard, orders, customers, products)
  void refreshDashboardData({String? customEvent}) {
    triggerMultipleRefresh([
      DataRefreshType.dashboard,
      DataRefreshType.orders,
      DataRefreshType.customers,
      DataRefreshType.products,
      DataRefreshType.transactions,
    ], customEvent: customEvent);
  }
}
