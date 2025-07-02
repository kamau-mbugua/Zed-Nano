import 'package:flutter/material.dart';
import 'package:zed_nano/utils/app_loading.dart';

/// Extension on BuildContext to provide loading overlay functionality
extension LoadingExtension on BuildContext {
  /// Shows loading overlay
  void showLoading() {
    // If already showing loading, don't show it again
    if (isLoading) return;
    
    // Show loading using AppLoading utility
    AppLoading.show(this);
  }

  /// Dismisses loading overlay
  void dismissLoading() {
    // Only dismiss if actually showing
    if (isLoading) {
      AppLoading.dismiss();
    }
  }

  /// Whether loading overlay is currently visible
  bool get isLoading => AppLoading.isShowing;
}
