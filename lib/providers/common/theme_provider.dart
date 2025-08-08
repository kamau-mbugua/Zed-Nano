import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider to manage app theme settings
class ThemeProvider extends ChangeNotifier {
  
  // Constructor - loads saved theme mode
  ThemeProvider() {
    _loadThemeMode();
  }
  // Theme mode key in shared preferences
  static const String _themeModeKey = 'theme_mode';
  
  // Default theme mode
  ThemeMode _themeMode = ThemeMode.system;
  
  // Getter for current theme mode
  ThemeMode get themeMode => _themeMode;
  
  // Load theme mode from shared preferences
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_themeModeKey);
    
    if (savedMode != null) {
      _themeMode = _getThemeModeFromString(savedMode);
      notifyListeners();
    }
  }
  
  // Save theme mode to shared preferences
  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.toString());
  }
  
  // Convert string to ThemeMode enum
  ThemeMode _getThemeModeFromString(String modeString) {
    switch (modeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
  
  // Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      await _saveThemeMode(mode);
      notifyListeners();
    }
  }
  
  // Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }
  
  // Check if dark mode is active
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      // Get system brightness
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}
