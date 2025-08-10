import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zed_nano/utils/image_picker_util.dart';

/// State manager for image picker to handle activity restarts
class ImagePickerStateManager {
  static const String _pendingImageKey = 'pending_image_path';
  static const String _isPickingImageKey = 'is_picking_image';

  /// Save state before image picking
  static Future<void> savePickingState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isPickingImageKey, true);
  }

  /// Clear picking state
  static Future<void> clearPickingState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isPickingImageKey);
    await prefs.remove(_pendingImageKey);
  }

  /// Check if we were picking an image before restart
  static Future<bool> wasPickingImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isPickingImageKey) ?? false;
  }

  /// Save pending image path
  static Future<void> savePendingImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pendingImageKey, path);
  }

  /// Get pending image path
  static Future<String?> getPendingImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pendingImageKey);
  }

  /// Pick image with state management
  static Future<File?> pickImageWithStateManagement({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    BuildContext? context,
    void Function(String)? onError,
  }) async {
    try {
      // Save state before picking
      await savePickingState();

      // Use the ultra-safe picker
      final pickedImage = await ImagePickerUtil.pickImageUltraSafe(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        context: context,
        onError: onError,
      );

      if (pickedImage != null) {
        // Save the picked image path
        await savePendingImagePath(pickedImage.path);
      }

      // Clear picking state
      await clearPickingState();

      return pickedImage;
    } catch (e) {
      // Clear picking state on error
      await clearPickingState();
      rethrow;
    }
  }

  /// Check for pending image after app restart
  static Future<File?> checkForPendingImage() async {
    try {
      final wasPickingBefore = await wasPickingImage();
      if (wasPickingBefore) {
        final pendingPath = await getPendingImagePath();
        if (pendingPath != null) {
          final file = File(pendingPath);
          if (await file.exists()) {
            await clearPickingState();
            return file;
          }
        }
        await clearPickingState();
      }
    } catch (e) {
      await clearPickingState();
    }
    return null;
  }
}
