import 'package:flutter/foundation.dart';
import 'package:zed_nano/app/app_initializer.dart';

/// A view model that manages refresh state across the app.
/// This can be used to listen for refresh events from any page.
class RefreshViewModel with ChangeNotifier {
  bool _isRefreshing = false;
  DateTime? _lastRefreshed;
  Map<String, bool> _pageRefreshStatus = {};

  /// Whether the app is currently refreshing data
  bool get isRefreshing => _isRefreshing;
  
  /// The last time any data was refreshed
  DateTime? get lastRefreshed => _lastRefreshed;
  
  /// Start refreshing data
  void startRefresh() {
    _isRefreshing = true;
    notifyListeners();
    logger.d('RefreshViewModel: Started refreshing');
  }

  /// Complete the refresh process
  void completeRefresh() {
    _isRefreshing = false;
    _lastRefreshed = DateTime.now();
    notifyListeners();
    logger.d('RefreshViewModel: Completed refreshing at $_lastRefreshed');
  }

  /// Mark a specific page as refreshed
  void refreshPage(String pageName) {
    _pageRefreshStatus[pageName] = true;
    _lastRefreshed = DateTime.now();
    notifyListeners();
    logger.d('RefreshViewModel: Page $pageName refreshed at $_lastRefreshed');
  }

  /// Check if a specific page has been refreshed
  bool isPageRefreshed(String pageName) {
    return _pageRefreshStatus[pageName] ?? false;
  }

  /// Reset the refresh status for a specific page
  void resetPageRefreshStatus(String pageName) {
    _pageRefreshStatus[pageName] = false;
    notifyListeners();
    logger.d('RefreshViewModel: Reset refresh status for $pageName');
  }

  /// Reset all page refresh statuses
  void resetAllPageRefreshStatus() {
    _pageRefreshStatus.clear();
    notifyListeners();
    logger.d('RefreshViewModel: Reset all page refresh statuses');
  }
}
