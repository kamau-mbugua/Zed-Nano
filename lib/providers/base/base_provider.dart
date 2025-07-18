import 'package:flutter/material.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/networking/base/error_response.dart';
import 'package:zed_nano/utils/loading_extensions.dart';

/// Base provider class with common functionality for all providers
/// 
/// Provides loading state management and API call handling
class BaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  ErrorResponse? _error;

  bool get isLoading => _isLoading;
  ErrorResponse? get error => _error;

  /// Set loading state and show/hide loading overlay
  void setLoading(bool loading, BuildContext context) {
    _isLoading = loading;
    
    // Use Future.microtask to avoid setState during build
    Future.microtask(() {
      try {
        // Check if the context is still valid and mounted
        if (context is StatefulElement && context.state.mounted) {
          if (loading) {
            context.showLoading();
          } else {
            context.dismissLoading();
          }
        } else if (loading) {
          logger.w('setLoading ⚠️ Context not available or not mounted for loading overlay.');
        }
      } catch(e) {
        logger.e('setLoading ⚠️ Exception caught: $e');
      }
      
      // Only notify listeners after the current build phase is complete
      if (!_disposed) {
        notifyListeners();
      }
    });
  }

  /// Reset error state
  void resetError() {
    _error = null;
    
    // Use Future.microtask to avoid setState during build
    Future.microtask(() {
      if (!_disposed) {
        notifyListeners();
      }
    });
  }

  /// Set error state
  void setError(ErrorResponse error) {
    _error = error;
    
    // Use Future.microtask to avoid setState during build
    Future.microtask(() {
      if (!_disposed) {
        notifyListeners();
      }
    });
  }

  // Track disposed state
  bool _disposed = false;
  
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// Perform an API call with automatic loading state management
  /// 
  /// Shows loading indicator, executes the API call, and handles errors
  Future<T?> performApiCall<T>(Future<T> Function() apiFunction, BuildContext context) async {
    try {
      setLoading(true, context);
      resetError();
      
      final result = await apiFunction();
      return result;
    } catch (e) {
      // If error is already an ErrorResponse, use it directly
      if (e is ErrorResponse) {
        logger.e('performApiCall API Error: ${e.statusMessage}');
        setError(e);
      } else {
        // Otherwise wrap it in a generic error response
        logger.e('performApiCall API Error: $e');
        setError(ErrorResponse(
          statusCode: 0,
          statusMessage: e.toString(),
          errorType: ErrorType.unknown,
        ));
      }
      return null;
    } finally {
      setLoading(false, context);
    }
  }
}
