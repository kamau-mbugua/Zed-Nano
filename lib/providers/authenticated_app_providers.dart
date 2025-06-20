import 'package:flutter/material.dart';

/// Provider to manage authenticated app state
class AuthenticatedAppProviders extends ChangeNotifier {
  // User authentication state
  bool _isAuthenticated = false;
  
  // User profile data
  Map<String, dynamic>? _userData;
  
  // Getters
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userData => _userData;
  
  // Set authentication state
  void setAuthenticated(bool value, {Map<String, dynamic>? userData}) {
    _isAuthenticated = value;
    if (userData != null) {
      _userData = userData;
    }
    notifyListeners();
  }
  
  // Update user profile data
  void updateUserData(Map<String, dynamic> newData) {
    _userData = {...?_userData, ...newData};
    notifyListeners();
  }
  
  // Clear user data on logout
  void clearUserData() {
    _isAuthenticated = false;
    _userData = null;
    notifyListeners();
  }
  
  // Check if user has specific permission
  bool hasPermission(String permission) {
    final permissions = _userData?['permissions'] as List<String>?;
    return permissions?.contains(permission) ?? false;
  }
}
