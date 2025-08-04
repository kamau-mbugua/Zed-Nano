# BusinessSetupService Documentation

## Overview

The `BusinessSetupService` is a comprehensive solution for managing business setup state throughout the Flutter app. It provides a centralized, reactive way to handle business configuration validation, state management, and UI consistency.

## Problem Solved

Previously, the app had inconsistent business setup logic:
- Mixed logic between `WorkflowViewModel.showBusinessSetup` and direct `businessNumber` checks
- Inconsistent SharedPreferences access across the app
- No centralized business setup state management
- Race conditions and unreliable business setup screen display

## Architecture

### Core Components

1. **BusinessSetupService** - Main singleton service
2. **BusinessSetupExtensions** - Convenience extensions for easy usage
3. **BusinessSetupExamples** - Implementation examples and widgets

### Service Structure

```dart
class BusinessSetupService extends ChangeNotifier {
  // Singleton pattern
  static final BusinessSetupService _instance = BusinessSetupService._internal();
  factory BusinessSetupService() => _instance;
  
  // Core state
  BusinessDetails? _businessDetails;
  bool _isInitialized = false;
  bool _isLoading = false;
  
  // Main API
  bool get requiresBusinessSetup;
  bool get isBusinessConfigured;
  Future<void> initialize();
  Future<void> updateBusinessDetails(BusinessDetails details);
  String getBusinessDisplayName();
}
```

## Key Features

### 1. Reactive State Management
- Extends `ChangeNotifier` for automatic UI updates
- Registered as a Provider for app-wide access
- Real-time updates when business details change

### 2. Robust Validation
- Multiple validation checks for business completeness
- Field-specific validation methods
- Completion percentage calculation
- Missing fields identification

### 3. Persistence
- Automatic SharedPreferences integration
- Error handling for storage operations
- State recovery on app restart

### 4. Developer Experience
- Extension methods for easy access
- Debug utilities and state inspection
- Comprehensive test coverage
- Clear API design

## Usage Examples

### Basic Usage

```dart
// Check if business setup is required
final businessSetup = Provider.of<BusinessSetupService>(context);
if (businessSetup.requiresBusinessSetup) {
  // Show setup screen
}

// Using extensions (recommended)
if (context.requiresBusinessSetup) {
  // Show setup screen
}
```

### Updating Business Details

```dart
final details = BusinessDetails(
  businessId: 'biz-123',
  businessNumber: 'BUS001',
  businessName: 'My Business',
  branchId: 'branch-1',
  localCurrency: 'USD',
  businessCategory: 'Retail',
  group: 'default',
);

await context.businessSetup.updateBusinessDetails(details);
```

### Reactive UI Components

```dart
Consumer<BusinessSetupService>(
  builder: (context, businessSetup, child) {
    if (!businessSetup.isInitialized) {
      return CircularProgressIndicator();
    }
    
    if (businessSetup.requiresBusinessSetup) {
      return BusinessSetupScreen();
    }
    
    return MainAppContent();
  },
)
```

### Progress Tracking

```dart
final completion = context.setupCompletionPercentage;
final missingFields = context.missingBusinessFields;

LinearProgressIndicator(value: completion);
Text('Missing: ${missingFields.join(', ')}');
```

## API Reference

### Core Properties

| Property | Type | Description |
|----------|------|-------------|
| `requiresBusinessSetup` | `bool` | True if business setup is required |
| `isBusinessConfigured` | `bool` | True if business is fully configured |
| `isInitialized` | `bool` | True if service has been initialized |
| `isLoading` | `bool` | True if service is currently loading |
| `businessDetails` | `BusinessDetails?` | Current business details |

### Core Methods

| Method | Return Type | Description |
|--------|-------------|-------------|
| `initialize()` | `Future<void>` | Initialize service from SharedPreferences |
| `updateBusinessDetails(details)` | `Future<void>` | Update and persist business details |
| `clearBusinessDetails()` | `Future<void>` | Clear business data (logout) |
| `refresh()` | `Future<void>` | Force reload from SharedPreferences |

### Utility Methods

| Method | Return Type | Description |
|--------|-------------|-------------|
| `getBusinessDisplayName()` | `String` | Get display name with fallbacks |
| `getBusinessCurrency()` | `String` | Get currency or default |
| `getBusinessCategory()` | `String` | Get category or default |
| `getSetupCompletionPercentage()` | `double` | Get completion percentage (0.0-1.0) |
| `getMissingFields()` | `List<String>` | Get list of missing required fields |
| `hasCompleteBusinessProfile()` | `bool` | Check if all fields are complete |

### Validation Methods

| Method | Return Type | Description |
|--------|-------------|-------------|
| `hasValidBusinessNumber()` | `bool` | Check if business number is valid |
| `hasValidBusinessName()` | `bool` | Check if business name is valid |
| `hasValidBusinessId()` | `bool` | Check if business ID is valid |
| `hasValidBranchId()` | `bool` | Check if branch ID is valid |

## Extension Methods

### Context Extensions

```dart
// Quick access methods
context.requiresBusinessSetup
context.isBusinessConfigured
context.businessDisplayName
context.businessCurrency
context.businessCategory
context.setupCompletionPercentage
context.missingBusinessFields
context.hasCompleteBusinessProfile

// Service access
context.businessSetup
context.businessSetupWith(listen: false)
```

### Service Extensions

```dart
// Debug utilities
businessSetup.showDebugDialog(context)
businessSetup.buildStatusWidget()
businessSetup.debugPrintState()
```

## Integration Guide

### 1. Provider Registration

Add to your app's provider list:

```dart
MultiProvider(
  providers: [
    // ... other providers
    ChangeNotifierProvider(create: (_) => BusinessSetupService()),
  ],
  child: MyApp(),
)
```

### 2. Home Page Integration

```dart
Consumer3<WorkflowViewModel, RefreshViewModel, BusinessSetupService>(
  builder: (context, workflow, refresh, businessSetup, _) {
    if (!businessSetup.isInitialized) {
      return LoadingScreen();
    }
    
    if (workflow.showBusinessSetup || businessSetup.requiresBusinessSetup) {
      return WelcomeSetupScreen();
    }
    
    return MainAppScreen();
  },
)
```

### 3. Initialization

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await context.businessSetup.initialize();
  });
}
```

## Testing

The service includes comprehensive test coverage:

```dart
flutter test test/services/business_setup_service_test.dart
```

Tests cover:
- Service initialization
- Business setup requirement detection
- Completion percentage calculation
- Missing fields identification
- Display name fallbacks
- Currency and category defaults
- Data persistence

## Best Practices

### 1. Always Check Initialization

```dart
if (!businessSetup.isInitialized) {
  return LoadingWidget();
}
```

### 2. Use Extensions for Cleaner Code

```dart
// Instead of
Provider.of<BusinessSetupService>(context).requiresBusinessSetup

// Use
context.requiresBusinessSetup
```

### 3. Handle Loading States

```dart
Consumer<BusinessSetupService>(
  builder: (context, businessSetup, child) {
    if (businessSetup.isLoading) {
      return CircularProgressIndicator();
    }
    // ... rest of UI
  },
)
```

### 4. Provide User Feedback

```dart
try {
  await businessSetup.updateBusinessDetails(details);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Business details updated')),
  );
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Update failed: $e')),
  );
}
```

## Migration Guide

### From Old Implementation

1. **Replace direct SharedPreferences access**:
   ```dart
   // Old
   final prefs = await SharedPreferences.getInstance();
   final businessData = prefs.getString('businessDetails');
   
   // New
   final businessSetup = context.businessSetup;
   final businessData = businessSetup.businessDetails;
   ```

2. **Replace manual validation**:
   ```dart
   // Old
   if (businessDetails?.businessNumber?.isEmpty ?? true) {
     // Show setup
   }
   
   // New
   if (context.requiresBusinessSetup) {
     // Show setup
   }
   ```

3. **Update UI components**:
   ```dart
   // Old
   title: getBusinessDetails(context)?.businessName ?? ''
   
   // New
   title: context.businessDisplayName
   ```

## Troubleshooting

### Common Issues

1. **Service not initialized**: Always call `initialize()` before using
2. **State not updating**: Ensure you're using `Consumer` or listening to changes
3. **Tests failing**: Use `resetForTesting()` in test setup
4. **Memory leaks**: Service is a singleton, no need to dispose manually

### Debug Tools

```dart
// Print current state
businessSetup.debugPrintState();

// Show debug dialog
businessSetup.showDebugDialog(context);

// Check specific validations
print('Valid business number: ${businessSetup.hasValidBusinessNumber()}');
print('Missing fields: ${businessSetup.getMissingFields()}');
```

## Future Enhancements

Potential improvements:
- Business setup wizard integration
- Field-level validation messages
- Business profile completeness scoring
- Integration with business API updates
- Offline/online state synchronization
- Business setup analytics

## Conclusion

The BusinessSetupService provides a robust, scalable solution for managing business setup state in Flutter applications. It eliminates inconsistencies, improves user experience, and provides a solid foundation for business-dependent features.
