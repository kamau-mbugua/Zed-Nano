import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// A utility class for showing loading animations across the app
class AppLoading {
  static String? _lottieAssetName;
  static Color? _backgroundColor;
  static bool _isInitialized = false;
  static OverlayEntry? _overlayEntry;

  /// Initialize the loading animation with custom settings
  static void initialize({
    required String lottieAssetName,
    Color? backgroundColor,
  }) {
    _lottieAssetName = lottieAssetName;
    _backgroundColor = backgroundColor ?? Colors.black.withOpacity(0.5);
    _isInitialized = true;
  }

  /// Show the loading animation as an overlay
  static void show(BuildContext context) {
    if (!_isInitialized) {
      throw Exception('AppLoading not initialized. Call AppLoading.initialize() first.');
    }

    if (_overlayEntry != null) {
      // Already showing
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: _backgroundColor,
        child: Center(
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Lottie.asset(
              _lottieAssetName!,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Hide the loading animation
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
