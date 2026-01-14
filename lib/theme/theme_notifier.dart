import 'package:flutter/material.dart';

class ThemeSettings {
  final String colorTheme;
  final bool isDarkMode;
  final String fontFamily;
  final double fontSize;

  ThemeSettings({
    this.colorTheme = 'ISAT-U', // Default to ISAT-U colors
    this.isDarkMode = false,
    this.fontFamily = 'Roboto',
    this.fontSize = 14.0,
  });

  ThemeSettings copyWith({
    String? colorTheme,
    bool? isDarkMode,
    String? fontFamily,
    double? fontSize,
  }) {
    return ThemeSettings(
      colorTheme: colorTheme ?? this.colorTheme,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}

// Global notifier for theme settings
final ValueNotifier<ThemeSettings> themeSettingsNotifier = 
    ValueNotifier<ThemeSettings>(ThemeSettings());
