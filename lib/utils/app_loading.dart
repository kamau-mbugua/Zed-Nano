import 'package:flutter/material.dart';
import 'package:zed_nano/screens/widget/common/fading_circular_progress.dart';

/// A utility class for showing loading animations across the app
class AppLoading {
  static Color? _backgroundColor;
  static Color? _loaderColor;
  static double? _loaderSize;
  static double? _strokeWidth;
  static bool _isInitialized = false;
  static OverlayEntry? _overlayEntry;
  
  /// Whether loading is currently being shown
  static bool get isShowing => _overlayEntry != null;

  /// Initialize the loading animation with custom settings
  static void initialize({
    Color? backgroundColor,
    Color loaderColor = const Color(0xff032541),
    double loaderSize = 60,
    double strokeWidth = 5,
  }) {
    _backgroundColor = backgroundColor ?? Colors.black.withOpacity(0.5);
    _loaderColor = loaderColor;
    _loaderSize = loaderSize;
    _strokeWidth = strokeWidth;
    _isInitialized = true;
  }

  /// Show the loading animation as an overlay
  static void show(BuildContext context) {
    if (!_isInitialized) {
      initialize(); // Use default values if not initialized
    }

    if (_overlayEntry != null) {
      // Already showing
      return;
    }

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: _backgroundColor,
        child: Center(
          child: Container(
            width: 120,
            height: 120,
            // decoration: BoxDecoration(
            //   color: Colors.transparent,
            //   borderRadius: BorderRadius.circular(12),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black.withOpacity(0.1),
            //       blurRadius: 10,
            //       spreadRadius: 2,
            //     ),
            //   ],
            // ),
            child: Center(
              child: FadingCircularProgress(
                width: _loaderSize ?? 60,
                height: _loaderSize ?? 60,
                color: _loaderColor ?? const Color(0xff032541),
                backgroundColor: Colors.grey.shade200,
                strokeWidth: _strokeWidth ?? 5,
                showShadow: false,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  /// Dismiss the loading animation
  static void dismiss() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
