# App Auto-Update Implementation Guide

This document provides a comprehensive guide to the app auto-update functionality implemented using Google Play's in-app update API.

## Overview

The app automatically checks for updates from the Google Play Store and prompts users to update when a new version is available. This ensures users always have the latest features, bug fixes, and security improvements.

## Features

### ✅ **Automatic Update Checking**
- Checks for updates every 24 hours automatically
- Non-intrusive background checking
- Respects user preferences and timing

### ✅ **Two Update Types**
- **Flexible Updates**: Users can continue using the app while update downloads
- **Immediate Updates**: Forces critical updates for high-priority releases

### ✅ **Smart User Experience**
- Beautiful update dialogs with app information
- Progress indicators during download
- User can dismiss updates (won't show same version again)
- Graceful error handling

### ✅ **Platform Support**
- **Android**: Full support via Google Play in-app updates
- **iOS**: Gracefully skipped (iOS uses App Store automatic updates)

## Implementation Components

### 1. **AppUpdateService** (`/lib/services/app_update_service.dart`)
- **Singleton service** that handles all update logic
- **Automatic checking** every 24 hours
- **User preference tracking** (dismissed versions)
- **Error handling** and logging

### 2. **Extension Methods** (`/lib/services/app_update_extensions.dart`)
- **Easy access** via `context.checkForAppUpdates()`
- **Force check** via `context.forceAppUpdateCheck()`
- **Safe initialization** methods

### 3. **Progress Widgets** (`/lib/screens/widget/common/app_update_progress_widget.dart`)
- **AppUpdateProgressWidget**: General progress indicator
- **UpdateDownloadProgressWidget**: Download progress with percentage
- **UpdateSuccessWidget**: Success confirmation
- **UpdateErrorWidget**: Error handling

### 4. **Integration** (`/lib/screens/main/home_main_page.dart`)
- **Automatic checking** when app starts
- **Non-blocking** initialization

## Usage Examples

### Basic Update Check
```dart
// Check for updates (respects 24-hour timing)
await context.checkForAppUpdates();

// Force immediate check (ignores timing)
await context.forceAppUpdateCheck();
```

### Manual Integration
```dart
import 'package:zed_nano/services/app_update_service.dart';

// Direct service usage
final updateService = AppUpdateService();
await updateService.checkForUpdate(context);

// Force check
await updateService.forceUpdateCheck(context);
```

### Settings Integration
```dart
// Add to settings page for manual checking
ElevatedButton(
  onPressed: () async {
    await context.forceAppUpdateCheck();
  },
  child: Text('Check for Updates'),
)
```

### Custom Progress Widgets
```dart
// Show custom download progress
showDialog(
  context: context,
  builder: (context) => UpdateDownloadProgressWidget(
    progress: 0.65,
    downloadedSize: '6.5 MB',
    totalSize: '10 MB',
    onCancel: () => Navigator.pop(context),
  ),
);
```

## Configuration

### Update Check Frequency
```dart
// Default: Check every 24 hours
static const Duration _updateCheckInterval = Duration(hours: 24);
```

### Update Priority Thresholds
```dart
// Immediate update for priority >= 4
if (updateInfo.immediateUpdateAllowed && updateInfo.updatePriority >= 4) {
  await _startImmediateUpdate();
}
```

## User Experience Flow

### 1. **Background Check**
- App checks for updates automatically on startup
- Respects 24-hour timing to avoid frequent checks
- Only runs on Android devices

### 2. **Update Available**
- Beautiful dialog shows with app icon and version info
- Clear messaging about benefits of updating
- Two options: "Later" or "Update Now"

### 3. **Download Process**
- Progress dialog shows download status
- User can cancel download if needed
- Handles network errors gracefully

### 4. **Installation**
- **Flexible**: Update installs on app restart
- **Immediate**: Update installs immediately (for critical updates)

## Testing

### Test Update Flow
```dart
// Clear preferences for testing
await AppUpdateService().clearUpdatePreferences();

// Force check for testing
await context.forceAppUpdateCheck();
```

### Debug Information
- All operations logged with `AppUpdate:` prefix
- Comprehensive error logging
- User action tracking

## Error Handling

### Graceful Failures
- **Silent errors**: Update failures don't disrupt user experience
- **Comprehensive logging**: All errors logged for debugging
- **Fallback behavior**: App continues normally if updates fail

### Common Scenarios
1. **Network errors**: Handled gracefully, retry on next check
2. **Play Store unavailable**: Silently skipped
3. **Update cancelled**: User preference respected
4. **Download failed**: Clear error message with retry option

## Security

### Safe Updates
- ✅ **Official source**: Only updates from Google Play Store
- ✅ **Signed updates**: Google Play verifies app signatures
- ✅ **User consent**: Users must approve all updates
- ✅ **No forced downloads**: Users can always dismiss

## Best Practices

### Implementation
- ✅ **Non-blocking**: Never block app startup for updates
- ✅ **User control**: Always allow users to dismiss updates
- ✅ **Timing respect**: Don't check too frequently
- ✅ **Error handling**: Graceful failure handling

### User Experience
- ✅ **Clear messaging**: Explain benefits of updating
- ✅ **Version info**: Show current and available versions
- ✅ **Choice**: Give users control over when to update
- ✅ **Progress**: Show download progress when possible

## Monitoring

### Key Metrics to Track
- Update check frequency
- Update acceptance rates
- Update dismissal rates
- Download success/failure rates
- Installation success rates

### Log Messages to Monitor
```
AppUpdate: Checking for app updates...
AppUpdate: Update available - Priority: High/Normal
AppUpdate: User dismissed version X
AppUpdate: Starting flexible/immediate update...
AppUpdate: Update completed successfully
```

## Troubleshooting

### Common Issues

**1. Updates not checking**
- Verify Android device (iOS is skipped)
- Check timing (24-hour interval)
- Clear preferences for testing

**2. Update dialog not showing**
- Verify update is available in Play Store
- Check if version was previously dismissed
- Ensure proper context is passed

**3. Download failures**
- Check network connectivity
- Verify Play Store access
- Review error logs

### Debug Commands
```dart
// Clear all update preferences
await AppUpdateService().clearUpdatePreferences();

// Force immediate check
await AppUpdateService().forceUpdateCheck(context);

// Check last update time
final prefs = await SharedPreferences.getInstance();
final lastCheck = prefs.getInt('last_update_check');
```

## Future Enhancements

### Potential Improvements
1. **Release notes**: Show what's new in updates
2. **Update notifications**: Push notifications for critical updates
3. **Staged rollouts**: Gradual rollout to user segments
4. **A/B testing**: Test different update messaging
5. **Analytics integration**: Track update metrics
6. **Custom update UI**: Replace default dialogs with branded design

### Advanced Features
1. **Update scheduling**: Allow users to schedule updates
2. **Bandwidth awareness**: Respect user data preferences
3. **Update history**: Track update history and rollbacks
4. **Delta updates**: Smaller incremental updates

## Dependencies

```yaml
dependencies:
  in_app_update: ^4.2.3  # Google Play in-app updates
  package_info_plus: ^8.3.0  # App version information
  shared_preferences: ^2.5.3  # User preferences storage
  logger: ^2.5.0  # Logging functionality
```

## File Structure

```
lib/
├── services/
│   ├── app_update_service.dart          # Main update service
│   └── app_update_extensions.dart       # Extension methods
├── screens/
│   ├── main/
│   │   └── home_main_page.dart          # Integration point
│   └── widget/
│       └── common/
│           └── app_update_progress_widget.dart  # Progress widgets
└── docs/
    └── app_update_implementation.md     # This documentation
```

## Conclusion

The app auto-update implementation provides a seamless, user-friendly way to keep the app updated with the latest features and security improvements. It balances automation with user control, ensuring updates happen smoothly without disrupting the user experience.

For any issues or questions, refer to the troubleshooting section or check the debug logs with the `AppUpdate:` prefix.
