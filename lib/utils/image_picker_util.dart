import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  /// Pick an image from gallery with specified constraints
  static Future<File?> pickImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    BuildContext? context,
    Function(String)? onError,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth ?? 800,
        maxHeight: maxHeight ?? 800,
        imageQuality: imageQuality ?? 80,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      if (onError != null) {
        onError('Error picking image: $e');
      } else if (context != null) {
        showCustomToast(
            'Error picking image: $e');
      }
    }
    return null;
  }

  /// Pick multiple images from gallery
  static Future<List<File>?> pickMultipleImages({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    BuildContext? context,
    Function(String)? onError,
  }) async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage(
        maxWidth: maxWidth ?? 800,
        maxHeight: maxHeight ?? 800,
        imageQuality: imageQuality ?? 80,
      );

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        return pickedFiles.map((file) => File(file.path)).toList();
      }
    } catch (e) {
      if (onError != null) {
        onError('Error picking images: $e');
      } else if (context != null) {
        showCustomToast(
            'Error picking image: $e');
      }
    }
    return null;
  }

  /// Pick an image from camera
  static Future<File?> pickImageFromCamera({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    BuildContext? context,
    Function(String)? onError,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth ?? 800,
        maxHeight: maxHeight ?? 800,
        imageQuality: imageQuality ?? 80,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      if (onError != null) {
        onError('Error taking photo: $e');
      } else if (context != null) {
        showCustomToast(
            'Error picking image: $e');
      }
    }
    return null;
  }
}
