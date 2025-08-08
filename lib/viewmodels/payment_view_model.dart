import 'package:flutter/material.dart';

class PaymentViewModel extends ChangeNotifier {
  
  factory PaymentViewModel() {
    return _instance;
  }
  
  PaymentViewModel._internal();
  // Singleton instance
  static final PaymentViewModel _instance = PaymentViewModel._internal();
  
  // Flag to indicate payment methods have been updated and need refresh
  bool _needsRefresh = false;
  
  bool get needsRefresh => _needsRefresh;
  
  // Mark that payment methods need refresh
  void setNeedsRefresh(bool value) {
    _needsRefresh = value;
    notifyListeners();
  }
}
