# Style Guidelines

This document outlines the coding style guidelines for the Zed Nano application. Following these guidelines ensures consistency across the codebase and makes it easier for developers to understand and maintain the code.

## Dart Style Guidelines

### Formatting

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use 2 spaces for indentation
- Maximum line length of 80 characters
- Use trailing commas for multi-line parameter lists
- Run `flutter format .` before committing code

### Naming Conventions

- Use `lowerCamelCase` for variables, functions, and method names
- Use `UpperCamelCase` for class, enum, typedef, and extension names
- Use `lowercase_with_underscores` for file names
- Prefix private variables and methods with underscore (_)
- Be descriptive with names; avoid abbreviations

### Code Organization

- Group related functionality in the same file
- Keep files under 300 lines; split larger files into smaller ones
- Order class members: constructors, properties, methods
- Organize imports in the following order:
  1. Dart SDK imports
  2. Flutter imports
  3. Third-party package imports
  4. Project imports (relative)

## Flutter-Specific Guidelines

### Widget Structure

- Prefer composition over inheritance
- Extract reusable widgets into separate files
- Use `const` constructors whenever possible
- Keep widget methods small and focused on a single responsibility

### State Management

- Use providers for application-wide state
- Use `StatefulWidget` only when necessary
- Keep business logic separate from UI code
- Avoid using global state when possible

### Performance

- Minimize rebuilds by using `const` widgets
- Use `ListView.builder` for long lists
- Avoid expensive operations in the build method
- Use caching for network resources

## Documentation

- Document all public APIs
- Use `///` for documentation comments
- Include examples in documentation for complex functionality
- Document non-obvious code with inline comments

## Testing

- Write tests for all new features
- Maintain at least 70% code coverage
- Test edge cases and error scenarios
- Mock external dependencies in unit tests

## Commit Guidelines

- Write clear, concise commit messages
- Use present tense ("Add feature" not "Added feature")
- Reference issue numbers in commit messages when applicable
- Keep commits focused on a single change