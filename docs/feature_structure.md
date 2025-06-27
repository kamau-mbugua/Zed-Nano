# Feature Structure Guidelines

This document outlines the recommended folder structure and organization principles for new features in the Zed Nano application. Following these guidelines ensures consistency across the codebase and makes it easier for developers to navigate and maintain the code.

## Overview

The Zed Nano application follows a feature-based organization, where code is organized by feature or functionality rather than by technical layer. This approach makes it easier to locate all files related to a specific feature and promotes better code cohesion.

## Folder Structure

### Top-Level Structure

```
lib/
├── app/                  # Application-level components
├── contants/             # Application constants
├── controllers/          # Controllers for business logic
├── l10n/                 # Localization files
├── networking/           # Network-related code
├── providers/            # State management providers
├── repositories/         # Data repositories
├── routes/               # Routing configuration
├── screens/              # UI screens organized by feature
├── shared/               # Shared components
└── utils/                # Utility functions and helpers
```

### Feature Structure

Each feature should be organized as follows:

```
screens/
└── feature_name/                     # Main feature directory
    ├── models/                       # Data models specific to the feature
    │   └── feature_model.dart
    ├── widgets/                      # Reusable widgets specific to the feature
    │   └── feature_specific_widget.dart
    ├── providers/                    # State management for the feature
    │   └── feature_provider.dart
    ├── sub_feature_1/                # Sub-feature directory
    │   ├── sub_feature_1_page.dart   # Main page for sub-feature
    │   └── widgets/                  # Widgets specific to sub-feature
    │       └── sub_feature_widget.dart
    ├── sub_feature_2/                # Another sub-feature directory
    │   └── sub_feature_2_page.dart
    └── feature_page.dart             # Main page for the feature
```

## Naming Conventions

### Directories

- Use `lowercase_with_underscores` for directory names
- Name directories after the feature or functionality they represent
- Use plural form for directories that contain multiple items (e.g., `widgets`, `models`)

### Files

- Use `lowercase_with_underscores` for file names
- End page files with `_page.dart`
- End widget files with `_widget.dart`
- End model files with `_model.dart`
- End provider files with `_provider.dart`

## Organization Principles

1. **Feature Isolation**: Each feature should be self-contained with minimal dependencies on other features.
2. **Hierarchical Organization**: Features can be broken down into sub-features as needed.
3. **Reusable Components**: Extract reusable widgets into the feature's `widgets` directory.
4. **Feature-Specific Models**: Keep data models specific to a feature in the feature's `models` directory.
5. **State Management**: Keep state management logic specific to a feature in the feature's `providers` directory.

## Example

Here's an example of how a new "orders" feature might be structured:

```
screens/
└── orders/
    ├── models/
    │   ├── order_item_model.dart
    │   └── order_model.dart
    ├── widgets/
    │   ├── order_item_card_widget.dart
    │   └── order_status_badge_widget.dart
    ├── providers/
    │   └── orders_provider.dart
    ├── create_order/
    │   ├── create_order_page.dart
    │   └── widgets/
    │       └── product_selector_widget.dart
    ├── order_details/
    │   └── order_details_page.dart
    └── orders_list_page.dart
```

## Conclusion

By following these guidelines, we ensure that new features are organized consistently, making the codebase more maintainable and easier to navigate. This structure promotes code reusability, separation of concerns, and feature isolation, which are all important principles in building a scalable and maintainable application.