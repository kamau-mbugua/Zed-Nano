# Automatic Logout on 401 Errors - Implementation Guide

## Overview

This implementation automatically logs out users when any API endpoint returns a 401 (Unauthorized) error. This ensures that users with expired sessions are immediately redirected to the login screen without manual intervention.

## How It Works

### 1. AuthInterceptor
- **Location**: `lib/networking/datasource/remote/dio/auth_interceptor.dart`
- **Purpose**: Intercepts all HTTP responses and handles 401 errors
- **Functionality**:
  - Detects 401 Unauthorized responses
  - Shows user-friendly "session expired" message
  - Clears user authentication data
  - Clears business setup data
  - Redirects to login screen
  - Prevents multiple simultaneous logout attempts

### 2. DioClient Integration
- **Location**: `lib/networking/datasource/remote/dio/dio_client.dart`
- **Changes**: Added `AuthInterceptor()` to the interceptors list
- **Impact**: All API calls now automatically handle 401 errors

### 3. Global Navigation
- **Uses**: Global `navigatorKey` from `app_initializer.dart`
- **Benefit**: Can navigate without requiring BuildContext

## Files Modified

1. **Created**: `lib/networking/datasource/remote/dio/auth_interceptor.dart`
   - Main interceptor implementation
   
2. **Modified**: `lib/networking/datasource/remote/dio/dio_client.dart`
   - Added AuthInterceptor to interceptors
   
3. **Created**: `lib/utils/auth_test_utils.dart`
   - Testing utilities for development

## Usage

### Automatic Usage
The interceptor works automatically once integrated. No additional code changes are required in your API calls or UI components.

```dart
// This API call will automatically trigger logout if it returns 401
final response = await businessRepo.getBusinessInfo(requestData: data);
```

### Testing (Development Only)
```dart
import 'package:zed_nano/utils/auth_test_utils.dart';

// In debug mode only
if (kDebugMode) {
  AuthTestUtils.simulate401Error();
  AuthTestUtils.logAuthState();
}
```

## Flow Diagram

```
API Call → 401 Response → AuthInterceptor → Logout Process → Login Screen
    ↓
1. User makes API call
2. Server returns 401 Unauthorized
3. AuthInterceptor detects 401
4. Shows "Session expired" toast
5. Clears user data via AuthenticatedAppProviders.logout()
6. Clears business data via BusinessSetupService.logout()
7. Navigates to login screen
8. Clears navigation stack
```

## Error Handling

### Race Condition Prevention
- Uses static `_isLoggingOut` flag
- Prevents multiple simultaneous logout attempts
- Thread-safe implementation

### Graceful Degradation
- Continues with normal error handling if logout fails
- Fallback navigation to login screen
- Comprehensive logging for debugging

### Context Safety
- Uses global navigator key
- Checks for null context before operations
- Handles cases where context is unavailable

## Logging

The implementation provides detailed logging:

```
🔐 401 Unauthorized error detected - initiating automatic logout
✅ User automatically logged out and redirected to login screen
❌ Error during automatic logout process: [error details]
```

## Integration with Existing Code

### AuthenticatedAppProviders
- Uses existing `logout(context)` method
- Maintains consistency with manual logout flow
- Preserves all existing logout logic

### BusinessSetupService
- Uses existing `logout()` method
- Ensures business data is properly cleared
- Maintains data consistency

### Navigation
- Uses existing route constants from `AppRoutes`
- Follows established navigation patterns
- Clears navigation stack appropriately

## Benefits

1. **User Experience**: Immediate feedback when session expires
2. **Security**: Prevents unauthorized access with expired tokens
3. **Consistency**: Same logout flow for manual and automatic logout
4. **Maintainability**: Centralized 401 handling logic
5. **Reliability**: Thread-safe with comprehensive error handling

## Testing

### Manual Testing
1. Make an API call that returns 401
2. Verify toast message appears
3. Verify user is redirected to login screen
4. Verify user data is cleared
5. Verify business data is cleared

### Development Testing
Use the utilities in `auth_test_utils.dart` for controlled testing in debug mode.

## Troubleshooting

### Common Issues

1. **Multiple logout attempts**
   - Check `_isLoggingOut` flag logic
   - Verify interceptor is only added once

2. **Navigation fails**
   - Ensure `navigatorKey` is properly initialized
   - Check if context is available

3. **Data not cleared**
   - Verify AuthenticatedAppProviders.logout() is called
   - Check BusinessSetupService.logout() execution

### Debug Logging
Enable detailed logging to trace the logout process:
- Look for 🔐 401 detection logs
- Check ✅ success logs
- Monitor ❌ error logs

## Future Enhancements

1. **Retry Logic**: Add automatic token refresh before logout
2. **User Confirmation**: Optional confirmation dialog for logout
3. **Analytics**: Track 401 errors for monitoring
4. **Customization**: Configurable logout behavior per endpoint

## Security Considerations

- Immediately clears sensitive data on 401
- Prevents continued use of expired tokens
- Maintains secure session management
- Follows security best practices for authentication
