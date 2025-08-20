# App Auto-Update Testing Guide

This guide explains how to test the app auto-update functionality in different scenarios.

## Testing Overview

The app auto-update feature can be tested in several ways, from basic functionality testing to full Play Store integration testing.

## 1. Basic Functionality Testing (Development)

### Test the Service Initialization
```dart
// Add this temporary test in your app (remove after testing)
void testUpdateService() async {
  final updateService = AppUpdateService();
  
  // Test clearing preferences
  await updateService.clearUpdatePreferences();
  print('✅ Cleared update preferences');
  
  // Test force check (will show "no updates" on debug builds)
  await updateService.forceUpdateCheck(context);
  print('✅ Force check completed');
}
```

### Test Extension Methods
```dart
// Add this to any page for testing
FloatingActionButton(
  onPressed: () async {
    print('🔍 Testing update check...');
    await context.forceAppUpdateCheck();
    print('✅ Update check completed');
  },
  child: Icon(Icons.system_update),
)
```

### Check Logs
Look for these log messages in your debug console:
```
AppUpdate: iOS detected, skipping in-app update check (on iOS)
AppUpdate: Checking for app updates... (on Android)
AppUpdate: No updates available (normal for debug builds)
AppUpdate: Skipping update check (too recent)
```

## 2. Android Debug Testing

### Prerequisites
- Android device or emulator
- Debug build of your app
- Google Play Services installed

### Steps
1. **Run debug build** on Android device
2. **Open app** → Should see initialization logs
3. **Check logs** for "AppUpdate:" messages
4. **Force test** using temporary button

### Expected Behavior (Debug Build)
- ✅ Service initializes without errors
- ✅ Logs show "Checking for app updates..."
- ✅ Usually shows "No updates available" (normal for debug)
- ✅ No crashes or exceptions

## 3. Play Store Internal Testing

This is the most comprehensive way to test the update functionality.

### Setup Steps

#### Step 1: Prepare Current Version
1. **Build release APK/AAB**:
   ```bash
   flutter build appbundle --release
   ```

2. **Upload to Play Store** (Internal Testing track)
   - Version code: e.g., `1` (versionCode in build.gradle)
   - Version name: e.g., `1.0.0` (version in pubspec.yaml)

3. **Install from Play Store** on test device

#### Step 2: Prepare New Version
1. **Increment version** in `pubspec.yaml`:
   ```yaml
   version: 1.0.1+2  # +2 is the version code
   ```

2. **Update version code** in `android/app/build.gradle`:
   ```gradle
   versionCode 2
   versionName "1.0.1"
   ```

3. **Build and upload** new version to Play Store

#### Step 3: Test Update Flow
1. **Open app** with old version installed
2. **Wait 3 seconds** (initialization delay)
3. **Should see update dialog** automatically
4. **Test both options**:
   - "Later" → Should dismiss and not show again
   - "Update Now" → Should start download

### Expected Behavior (Play Store Testing)
- ✅ Update dialog appears automatically
- ✅ Shows correct version information
- ✅ Download progress works
- ✅ Installation completes successfully

## 4. Testing Different Update Types

### Flexible Updates (Normal Priority)
- Default behavior for most updates
- User can continue using app during download
- Prompts to restart after download

### Immediate Updates (High Priority)
To test immediate updates, you need to set update priority in Play Console:
1. Go to Play Console → Release management
2. Set update priority to 4 or 5
3. Upload new version
4. Should trigger immediate update flow

## 5. Testing Error Scenarios

### Network Error Testing
1. **Disable internet** during update check
2. **Should handle gracefully** without crashes
3. **Check logs** for error messages

### Play Store Unavailable
1. **Disable Google Play Store** app
2. **Open your app** → Should skip update check silently
3. **No crashes or error dialogs**

## 6. Testing User Preferences

### Dismissal Testing
1. **Show update dialog** → Tap "Later"
2. **Force check again** → Should not show same version
3. **Clear preferences** → Should show dialog again

```dart
// Clear dismissal for testing
await AppUpdateService().clearUpdatePreferences();
```

### Timing Testing
1. **Check for updates** → Should work
2. **Immediately check again** → Should skip (too recent)
3. **Wait or clear preferences** → Should work again

## 7. Debug Commands for Testing

### Add Temporary Test Functions
```dart
// Add to any page for testing
class _TestUpdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Testing')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await AppUpdateService().clearUpdatePreferences();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Preferences cleared')),
              );
            },
            child: Text('Clear Preferences'),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.forceAppUpdateCheck();
            },
            child: Text('Force Update Check'),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.checkForAppUpdates();
            },
            child: Text('Normal Update Check'),
          ),
        ],
      ),
    );
  }
}
```

### Check SharedPreferences
```dart
// Check what's stored
final prefs = await SharedPreferences.getInstance();
final lastCheck = prefs.getInt('last_update_check');
final dismissedVersion = prefs.getInt('update_dismissed_version');
print('Last check: $lastCheck');
print('Dismissed version: $dismissedVersion');
```

## 8. Production Testing Checklist

Before releasing to production:

### ✅ **Functionality Tests**
- [ ] Service initializes without errors
- [ ] Logs show proper messages
- [ ] Extension methods work correctly
- [ ] Progress widgets display properly

### ✅ **Play Store Integration**
- [ ] Update dialog appears for new versions
- [ ] Download process works
- [ ] Installation completes successfully
- [ ] Dismissal tracking works

### ✅ **Error Handling**
- [ ] Network errors handled gracefully
- [ ] Play Store unavailable handled
- [ ] No crashes in any scenario

### ✅ **User Experience**
- [ ] Dialog is user-friendly
- [ ] Progress indicators work
- [ ] Success/error messages clear
- [ ] Timing respects user preferences

## 9. Common Issues and Solutions

### Issue: "No updates available" in debug
**Solution**: This is normal. Debug builds don't get updates from Play Store.

### Issue: Update dialog not appearing
**Solutions**:
- Check if version was previously dismissed
- Clear preferences: `AppUpdateService().clearUpdatePreferences()`
- Verify new version is actually available in Play Store
- Check logs for error messages

### Issue: Download fails
**Solutions**:
- Check network connectivity
- Verify Google Play Services is updated
- Check device storage space
- Review error logs

### Issue: iOS showing errors
**Solution**: This is normal. iOS is automatically skipped.

## 10. Monitoring in Production

### Key Metrics to Track
- Update check frequency
- Update acceptance rate
- Download success rate
- Installation success rate
- Error rates by device/OS version

### Log Analysis
Search for these patterns in your logs:
```
AppUpdate: Checking for app updates...
AppUpdate: Update available
AppUpdate: User dismissed version
AppUpdate: Starting flexible update
AppUpdate: Update completed successfully
AppUpdate: Error
```

## Quick Test Commands

```dart
// 1. Clear all preferences
await AppUpdateService().clearUpdatePreferences();

// 2. Force immediate check
await context.forceAppUpdateCheck();

// 3. Check timing
await context.checkForAppUpdates(); // Respects 24h timing

// 4. Direct service access
await AppUpdateService().checkForUpdate(context);
```

## Summary

The most reliable way to test is:
1. **Development**: Test service initialization and error handling
2. **Internal Testing**: Upload to Play Store and test real update flow
3. **Production**: Monitor logs and user feedback

Remember: The update functionality only works with **release builds** installed from the **Google Play Store**. Debug builds and sideloaded APKs won't show real updates.
