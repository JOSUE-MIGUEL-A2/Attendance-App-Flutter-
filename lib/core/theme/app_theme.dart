// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Private constructor
  AppTheme._();

  // Base colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFFFF9800);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);

  // Status colors (reusable across app)
  static const Color presentColor = Color(0xFF4CAF50);
  static const Color lateColor = Color(0xFFFF9800);
  static const Color absentColor = Color(0xFFF44336);
  static const Color excusedColor = Color(0xFF2196F3);

  // Generate theme with custom settings
  static ThemeData lightTheme({
    double fontSize = 14.0,
    String fontFamily = 'Roboto',
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      
      // Typography with dynamic font size
      textTheme: _buildTextTheme(fontSize, fontFamily, Brightness.light),
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: fontSize + 6,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily,
          color: Colors.white,
        ),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: fontSize,
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: fontSize,
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static ThemeData darkTheme({
    double fontSize = 14.0,
    String fontFamily = 'Roboto',
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      
      textTheme: _buildTextTheme(fontSize, fontFamily, Brightness.dark),
      
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: fontSize + 6,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily,
          color: Colors.white,
        ),
      ),
      
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: fontSize,
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: fontSize,
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Build text theme with custom size and family
  static TextTheme _buildTextTheme(
    double baseFontSize,
    String fontFamily,
    Brightness brightness,
  ) {
    final Color textColor = brightness == Brightness.light
        ? Colors.black87
        : Colors.white;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: baseFontSize + 42,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        color: textColor,
      ),
      displayMedium: TextStyle(
        fontSize: baseFontSize + 34,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        color: textColor,
      ),
      displaySmall: TextStyle(
        fontSize: baseFontSize + 26,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        color: textColor,
      ),
      headlineLarge: TextStyle(
        fontSize: baseFontSize + 18,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontSize: baseFontSize + 14,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontSize: baseFontSize + 10,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: baseFontSize + 8,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontSize: baseFontSize + 4,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        color: textColor,
      ),
      titleSmall: TextStyle(
        fontSize: baseFontSize + 2,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: baseFontSize + 2,
        fontFamily: fontFamily,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: baseFontSize,
        fontFamily: fontFamily,
        color: textColor,
      ),
      bodySmall: TextStyle(
        fontSize: baseFontSize - 2,
        fontFamily: fontFamily,
        color: textColor,
      ),
      labelLarge: TextStyle(
        fontSize: baseFontSize + 2,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
        color: textColor,
      ),
      labelMedium: TextStyle(
        fontSize: baseFontSize,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
        color: textColor,
      ),
      labelSmall: TextStyle(
        fontSize: baseFontSize - 2,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
        color: textColor,
      ),
    );
  }

  // Status color helper
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return presentColor;
      case 'late':
        return lateColor;
      case 'absent':
        return absentColor;
      case 'excused':
        return excusedColor;
      default:
        return Colors.grey;
    }
  }

  // Status icon helper
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Icons.check_circle;
      case 'late':
        return Icons.schedule;
      case 'absent':
        return Icons.cancel;
      case 'excused':
        return Icons.verified;
      default:
        return Icons.help;
    }
  }
}