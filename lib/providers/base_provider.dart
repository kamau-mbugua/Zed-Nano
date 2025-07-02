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
    // Get the context from the navigator key
    // final context = Get.context;
    
    // Only show/dismiss loading if context is available
        try{
      if (context != null) {
        if (loading) {
          context.showLoading();
        } else {
          context.dismissLoading();
        }
      } else if (loading) {
        logger.w('setLoading ⚠️ Context not available for loading overlay.');
      }
    }catch(e){
          logger.e('setLoading ⚠️ Exception caught: $e');
    }

    notifyListeners();
  }

  /// Reset error state
  void resetError() {
    _error = null;
    notifyListeners();
  }

  /// Set error state
  void setError(ErrorResponse error) {
    _error = error;
    notifyListeners();
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
