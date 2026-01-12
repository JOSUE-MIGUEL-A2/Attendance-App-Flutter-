// lib/core/theme/theme_provider.dart
import 'package:flutter/material.dart';

/// Theme provider that manages theme-related state
/// This is separate from AppSettingsProvider to keep concerns separated
/// Settings = user preferences (font, language)
/// Theme = Material theme generation based on those preferences
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    notifyListeners();
  }
  
  void setLightMode() {
    setThemeMode(ThemeMode.light);
  }
  
  void setDarkMode() {
    setThemeMode(ThemeMode.dark);
  }
  
  void setSystemMode() {
    setThemeMode(ThemeMode.system);
  }
}