import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';

/// Image picker utility that complies with Google Play's Photo and Video Permissions policy.
/// 
/// For Android 13+ (API 33+), this uses the Android photo picker which doesn't require
/// any permissions. For older Android versions and iOS, it uses the traditional gallery
/// picker with limited scope.
/// 
/// This implementation is designed for occasional image picking use cases, not
/// persistent access to media files. Camera functionality has been removed to ensure
/// full compliance with Google Play policies.
class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  /// Pick an image from gallery with specified constraints.
  /// 
  /// On Android 13+, this automatically uses the Android photo picker which
  /// doesn't require any permissions, complying with Google Play policy.
  /// 
  /// Parameters:
  /// - [maxWidth], [maxHeight]: Image size constraints (default: 800px)
  /// - [imageQuality]: Compression quality 0-100 (default: 80)
  /// - [context]: BuildContext for error display
  /// - [onError]: Custom error handler
  static Future<File?> pickImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    BuildContext? context,
    void Function(String)? onError,
  }) async {
    try {
      // Add a small delay to ensure the UI is stable before opening picker
      await Future.delayed(const Duration(milliseconds: 100));
      
      // The image_picker plugin automatically uses Android photo picker
      // on Android 13+ when no media permissions are declared
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth ?? 800,
        maxHeight: maxHeight ?? 800,
        imageQuality: imageQuality ?? 80,
        requestFullMetadata: false, // Reduces memory usage and potential crashes
      );

      if (pickedFile != null) {
        // Verify the file exists and is readable
        final file = File(pickedFile.path);
        if (await file.exists()) {
          return file;
        } else {
          throw Exception('Selected image file not found');
        }
      }
    } on PlatformException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'photo_access_denied':
          errorMessage = 'Photo access was denied. Please allow access to photos in your device settings.';
          break;
        case 'camera_access_denied':
          errorMessage = 'Camera access was denied. Please use gallery to select images.';
          break;
        case 'invalid_image':
          errorMessage = 'The selected file is not a valid image.';
          break;
        default:
          errorMessage = 'Error accessing photos: ${e.message ?? 'Unknown error'}';
      }
      
      if (onError != null) {
        onError(errorMessage);
      } else if (context != null && context.mounted) {
        showCustomToast(errorMessage);
      }
    } catch (e) {
      final errorMessage = 'Error picking image: ${e.toString()}';
      if (onError != null) {
        onError(errorMessage);
      } else if (context != null && context.mounted) {
        showCustomToast(errorMessage);
      }
    }
    return null;
  }

  /// Safer image picking method that handles activity lifecycle issues.
  /// This method should be used instead of pickImage() if you're experiencing crashes.
  static Future<File?> pickImageSafely({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    BuildContext? context,
    void Function(String)? onError,
  }) async {
    if (context != null && !context.mounted) {
      return null;
    }

    try {
      // Ensure we're on the main thread and UI is stable
      await Future.delayed(const Duration(milliseconds: 200));
      
      if (context != null && !context.mounted) {
        return null;
      }

      // Use a more conservative approach for image picking
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth ?? 800,
        maxHeight: maxHeight ?? 800,
        imageQuality: imageQuality ?? 80,
        requestFullMetadata: false,
      ).timeout(
        const Duration(seconds: 30), // Add timeout to prevent hanging
        onTimeout: () {
          throw Exception('Image selection timed out. Please try again.');
        },
      );

      if (pickedFile != null) {
        // Double-check the file exists and is valid
        final file = File(pickedFile.path);
        if (await file.exists()) {
          final fileSize = await file.length();
          if (fileSize > 0) {
            return file;
          } else {
            throw Exception('Selected image file is empty');
          }
        } else {
          throw Exception('Selected image file not found');
        }
      }
    } on PlatformException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'photo_access_denied':
          errorMessage = 'Photo access was denied. Please allow access to photos in your device settings.';
          break;
        case 'camera_access_denied':
          errorMessage = 'Camera access was denied. Please use gallery to select images.';
          break;
        case 'invalid_image':
          errorMessage = 'The selected file is not a valid image.';
          break;
        default:
          errorMessage = 'Error accessing photos: ${e.message ?? 'Unknown error'}';
      }
      
      if (onError != null) {
        onError(errorMessage);
      } else if (context != null && context.mounted) {
        showCustomToast(errorMessage);
      }
    } catch (e) {
      final errorMessage = 'Error picking image: ${e.toString()}';
      if (onError != null) {
        onError(errorMessage);
      } else if (context != null && context.mounted) {
        showCustomToast(errorMessage);
      }
    }
    return null;
  }

  /// Ultra-safe image picking method specifically designed to handle activity restarts.
  /// This method uses the most conservative approach possible to prevent crashes.
  static Future<File?> pickImageUltraSafe({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    BuildContext? context,
    void Function(String)? onError,
  }) async {
    if (context != null && !context.mounted) {
      return null;
    }

    try {
      // Wait longer to ensure complete UI stability
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (context != null && !context.mounted) {
        return null;
      }

      // Use the most conservative settings possible
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth ?? 600, // Reduced from 800 to prevent memory issues
        maxHeight: maxHeight ?? 600,
        imageQuality: imageQuality ?? 70, // Reduced from 80 to prevent memory issues
        requestFullMetadata: false,
        preferredCameraDevice: CameraDevice.rear, // Explicit camera device
      ).timeout(
        const Duration(seconds: 45), // Increased timeout
        onTimeout: () {
          throw Exception('Image selection timed out. Please try again.');
        },
      );

      if (pickedFile != null) {
        // Triple-check the file exists and is valid
        final file = File(pickedFile.path);
        
        // Add multiple validation checks
        if (await file.exists()) {
          final fileSize = await file.length();
          if (fileSize > 0 && fileSize < 10 * 1024 * 1024) { // Max 10MB
            // Verify it's actually an image by checking file extension
            final extension = pickedFile.path.toLowerCase();
            if (extension.endsWith('.jpg') || 
                extension.endsWith('.jpeg') || 
                extension.endsWith('.png') || 
                extension.endsWith('.gif') || 
                extension.endsWith('.bmp') || 
                extension.endsWith('.webp')) {
              return file;
            } else {
              throw Exception('Selected file is not a supported image format');
            }
          } else if (fileSize == 0) {
            throw Exception('Selected image file is empty');
          } else {
            throw Exception('Selected image file is too large (max 10MB)');
          }
        } else {
          throw Exception('Selected image file not found');
        }
      }
    } on PlatformException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'photo_access_denied':
          errorMessage = 'Photo access denied. Please check your device settings.';
          break;
        case 'camera_access_denied':
          errorMessage = 'Camera access denied. Please use gallery selection.';
          break;
        case 'invalid_image':
          errorMessage = 'Invalid image selected. Please try another image.';
          break;
        case 'already_active':
          errorMessage = 'Image picker is already active. Please wait.';
          break;
        default:
          errorMessage = 'Error selecting image: ${e.message ?? 'Unknown error'}';
      }
      
      if (onError != null) {
        onError(errorMessage);
      } else if (context != null && context.mounted) {
        showCustomToast(errorMessage);
      }
    } catch (e) {
      final errorMessage = 'Failed to select image: ${e.toString()}';
      if (onError != null) {
        onError(errorMessage);
      } else if (context != null && context.mounted) {
        showCustomToast(errorMessage);
      }
    }
    return null;
  }

  /// Pick multiple images from gallery.
  /// 
  /// On Android 13+, this automatically uses the Android photo picker which
  /// doesn't require any permissions, complying with Google Play policy.
  /// 
  /// Note: Multiple image selection is limited on some older Android versions.
  static Future<List<File>?> pickMultipleImages({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    BuildContext? context,
    void Function(String)? onError,
  }) async {
    try {
      // Add a small delay to ensure the UI is stable before opening picker
      await Future.delayed(const Duration(milliseconds: 100));
      
      // The image_picker plugin automatically uses Android photo picker
      // on Android 13+ when no media permissions are declared
      final pickedFiles = await _picker.pickMultiImage(
        maxWidth: maxWidth ?? 800,
        maxHeight: maxHeight ?? 800,
        imageQuality: imageQuality ?? 80,
        requestFullMetadata: false, // Reduces memory usage and potential crashes
      );

      if (pickedFiles.isNotEmpty) {
        final files = <File>[];
        for (final pickedFile in pickedFiles) {
          final file = File(pickedFile.path);
          if (await file.exists()) {
            files.add(file);
          }
        }
        return files.isNotEmpty ? files : null;
      }
    } on PlatformException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'photo_access_denied':
          errorMessage = 'Photo access was denied. Please allow access to photos in your device settings.';
          break;
        case 'camera_access_denied':
          errorMessage = 'Camera access was denied. Please use gallery to select images.';
          break;
        case 'invalid_image':
          errorMessage = 'One or more selected files are not valid images.';
          break;
        default:
          errorMessage = 'Error accessing photos: ${e.message ?? 'Unknown error'}';
      }
      
      if (onError != null) {
        onError(errorMessage);
      } else if (context != null && context.mounted) {
        showCustomToast(errorMessage);
      }
    } catch (e) {
      final errorMessage = 'Error picking images: ${e.toString()}';
      if (onError != null) {
        onError(errorMessage);
      } else if (context != null && context.mounted) {
        showCustomToast(errorMessage);
      }
    }
    return null;
  }

  /// Show a dialog to inform users that camera functionality has been removed
  /// for Google Play compliance.
  static Future<void> showCameraRemovedDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Camera Not Available',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          content: const Text(
            'Camera functionality has been removed to comply with app store policies. You can still select images from your gallery.',
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Show a bottom sheet to let user select images from gallery only.
  /// 
  /// Camera option has been removed for Google Play compliance.
  static Future<File?> showImageSourceBottomSheet({
    required BuildContext context,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    return showModalBottomSheet<File?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Image',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  subtitle: const Text('Select from your photos'),
                  onTap: () async {
                    Navigator.pop(context);
                    final image = await pickImage(
                      context: context,
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                      imageQuality: imageQuality,
                    );
                    if (context.mounted) {
                      Navigator.pop(context, image);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.grey),
                  title: const Text(
                    'Camera',
                    style: TextStyle(color: Colors.grey, fontFamily: 'Poppins',),
                  ),
                  subtitle: const Text(
                    'Not available (compliance)',
                    style: TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Poppins',),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    showCameraRemovedDialog(context);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
