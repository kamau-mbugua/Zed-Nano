import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:zed_nano/app/app_initializer.dart';
import 'package:zed_nano/providers/auth/authenticated_app_providers.dart';
import 'package:zed_nano/routes/routes.dart';
import 'package:zed_nano/screens/widget/common/custom_snackbar.dart';
import 'package:zed_nano/services/business_setup_service.dart';

/// **AuthInterceptor - Automatic Logout on 401 Errors**
/// 
/// This interceptor automatically handles authentication failures by logging out
/// users when any API endpoint returns a 401 (Unauthorized) status code.
/// 
/// **How it works:**
/// 1. Intercepts all HTTP responses from Dio
/// 2. Detects 401 Unauthorized errors
/// 3. Automatically triggers logout process:
///    - Shows user-friendly session expired message
///    - Clears user authentication data
///    - Clears business setup data
///    - Redirects to login screen
/// 
/// **Features:**
/// - Prevents multiple simultaneous logout attempts with a flag
/// - Uses global navigator key for navigation without context dependency
/// - Graceful error handling with fallback navigation
/// - Comprehensive logging for debugging
/// 
/// **Usage:**
/// This interceptor is automatically added to the DioClient and will handle
/// 401 errors from any API endpoint without requiring additional code changes.
/// 
/// **Thread Safety:**
/// Uses a static flag `_isLoggingOut` to prevent race conditions when multiple
/// API calls fail simultaneously with 401 errors.
class AuthInterceptor extends InterceptorsWrapper {
  
  /// Flag to prevent multiple simultaneous logout attempts
  static bool _isLoggingOut = false;
  
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if this is a 401 Unauthorized error
    if (err.response?.statusCode == 401 && !_isLoggingOut) {
      logger.w('🔐 401 Unauthorized error detected - initiating automatic logout');
      
      // Set flag to prevent multiple logout attempts
      _isLoggingOut = true;
      
      try {
        await _performAutomaticLogout();
      } catch (e) {
        logger.e('❌ Error during automatic logout: $e');
      } finally {
        // Reset flag after logout attempt
        _isLoggingOut = false;
      }
    }
    
    // Continue with normal error handling
    return super.onError(err, handler);
  }
  
  /// Performs automatic logout when 401 error is detected
  Future<void> _performAutomaticLogout() async {
    try {
      final context = navigatorKey.currentContext;
      
      if (context == null) {
        logger.e('❌ Cannot perform logout - no context available');
        return;
      }
      
      // Show user-friendly message
      showCustomToast(
        'Your session has expired. Please log in again.',
        isError: true,
      );
      
      // Get the authenticated provider
      final authProvider = Provider.of<AuthenticatedAppProviders>(
        context, 
        listen: false,
      );
      
      // Clear user data
      await authProvider.logout(context);
      
      // Clear business setup service data
      try {
        final businessSetupService = BusinessSetupService();
        await businessSetupService.logout();
        logger.i('✅ BusinessSetupService logout completed during 401 handling');
      } catch (e) {
        logger.e('❌ Failed to logout BusinessSetupService during 401 handling: $e');
        // Continue with logout even if BusinessSetupService fails
      }

      await navigatorKey.currentState!.pushNamedAndRemoveUntil(
        AppRoutes.getSplashPageRoute(),
            (route) => false,
      );

      logger.i('✅ User automatically logged out and redirected to login screen');
      
    } catch (e) {
      logger.e('❌ Error during automatic logout process: $e');
      
      // Fallback: try to navigate to login screen anyway
      try {
        await navigatorKey.currentState!.pushNamedAndRemoveUntil(
          AppRoutes.getSplashPageRoute(),
              (route) => false,
        );
      } catch (navError) {
        logger.e('❌ Failed to navigate to login screen: $navError');
      }
    }
  }
}
