// ==================== theme/app_theme.dart ====================
import 'package:flutter/material.dart';

class AppTheme {
  // Color Schemes
  static const Map<String, ColorScheme> colorSchemes = {
    'ISAT-U': ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF0D47A1), // Deep Blue (Dominant)
      onPrimary: Colors.white,
      secondary: Color(0xFFFFD700), // Gold
      onSecondary: Color(0xFF212121),
      tertiary: Color(0xFF1565C0), // Lighter Blue
      onTertiary: Colors.white,
      error: Color(0xFFD32F2F),
      onError: Colors.white,
      background: Color(0xFFF8F9FA),
      onBackground: Color(0xFF212121),
      surface: Colors.white,
      onSurface: Color(0xFF212121),
      surfaceVariant: Color(0xFFE3F2FD), // Light blue tint
      onSurfaceVariant: Color(0xFF0D47A1),
    ),
    'blue': ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF1976D2),
      onPrimary: Colors.white,
      secondary: Color(0xFF2196F3),
      onSecondary: Colors.white,
      error: Color(0xFFD32F2F),
      onError: Colors.white,
      background: Color(0xFFF5F5F5),
      onBackground: Color(0xFF212121),
      surface: Colors.white,
      onSurface: Color(0xFF212121),
    ),
    'purple': ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF7B1FA2),
      onPrimary: Colors.white,
      secondary: Color(0xFF9C27B0),
      onSecondary: Colors.white,
      error: Color(0xFFD32F2F),
      onError: Colors.white,
      background: Color(0xFFF5F5F5),
      onBackground: Color(0xFF212121),
      surface: Colors.white,
      onSurface: Color(0xFF212121),
    ),
    'green': ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF388E3C),
      onPrimary: Colors.white,
      secondary: Color(0xFF4CAF50),
      onSecondary: Colors.white,
      error: Color(0xFFD32F2F),
      onError: Colors.white,
      background: Color(0xFFF5F5F5),
      onBackground: Color(0xFF212121),
      surface: Colors.white,
      onSurface: Color(0xFF212121),
    ),
    'orange': ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFE65100),
      onPrimary: Colors.white,
      secondary: Color(0xFFFF9800),
      onSecondary: Colors.white,
      error: Color(0xFFD32F2F),
      onError: Colors.white,
      background: Color(0xFFF5F5F5),
      onBackground: Color(0xFF212121),
      surface: Colors.white,
      onSurface: Color(0xFF212121),
    ),
    'teal': ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF00796B),
      onPrimary: Colors.white,
      secondary: Color(0xFF009688),
      onSecondary: Colors.white,
      error: Color(0xFFD32F2F),
      onError: Colors.white,
      background: Color(0xFFF5F5F5),
      onBackground: Color(0xFF212121),
      surface: Colors.white,
      onSurface: Color(0xFF212121),
    ),
  };

  // Dark Color Schemes
  static const Map<String, ColorScheme> darkColorSchemes = {
    'ISAT-U': ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF42A5F5), // Lighter Blue for dark mode
      onPrimary: Color(0xFF212121),
      secondary: Color(0xFFFFD700), // Gold (same)
      onSecondary: Color(0xFF212121),
      tertiary: Color(0xFF64B5F6), // Even lighter blue accent
      onTertiary: Color(0xFF212121),
      error: Color(0xFFEF5350),
      onError: Color(0xFF212121),
      background: Color(0xFF0A1929), // Dark blue-tinted background
      onBackground: Color(0xFFE3F2FD),
      surface: Color(0xFF132F4C), // Dark blue surface
      onSurface: Color(0xFFE3F2FD),
      surfaceVariant: Color(0xFF1A3A52), // Darker blue variant
      onSurfaceVariant: Color(0xFFFFD700),
    ),
    'blue': ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF64B5F6),
      onPrimary: Color(0xFF212121),
      secondary: Color(0xFF90CAF9),
      onSecondary: Color(0xFF212121),
      error: Color(0xFFEF5350),
      onError: Color(0xFF212121),
      background: Color(0xFF121212),
      onBackground: Color(0xFFE0E0E0),
      surface: Color(0xFF1E1E1E),
      onSurface: Color(0xFFE0E0E0),
    ),
    'purple': ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFCE93D8),
      onPrimary: Color(0xFF212121),
      secondary: Color(0xFFE1BEE7),
      onSecondary: Color(0xFF212121),
      error: Color(0xFFEF5350),
      onError: Color(0xFF212121),
      background: Color(0xFF121212),
      onBackground: Color(0xFFE0E0E0),
      surface: Color(0xFF1E1E1E),
      onSurface: Color(0xFFE0E0E0),
    ),
    'green': ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF81C784),
      onPrimary: Color(0xFF212121),
      secondary: Color(0xFFA5D6A7),
      onSecondary: Color(0xFF212121),
      error: Color(0xFFEF5350),
      onError: Color(0xFF212121),
      background: Color(0xFF121212),
      onBackground: Color(0xFFE0E0E0),
      surface: Color(0xFF1E1E1E),
      onSurface: Color(0xFFE0E0E0),
    ),
    'orange': ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFB74D),
      onPrimary: Color(0xFF212121),
      secondary: Color(0xFFFFCC80),
      onSecondary: Color(0xFF212121),
      error: Color(0xFFEF5350),
      onError: Color(0xFF212121),
      background: Color(0xFF121212),
      onBackground: Color(0xFFE0E0E0),
      surface: Color(0xFF1E1E1E),
      onSurface: Color(0xFFE0E0E0),
    ),
    'teal': ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF4DB6AC),
      onPrimary: Color(0xFF212121),
      secondary: Color(0xFF80CBC4),
      onSecondary: Color(0xFF212121),
      error: Color(0xFFEF5350),
      onError: Color(0xFF212121),
      background: Color(0xFF121212),
      onBackground: Color(0xFFE0E0E0),
      surface: Color(0xFF1E1E1E),
      onSurface: Color(0xFFE0E0E0),
    ),
  };

  // Font Families
  static const List<String> fontFamilies = [
    'Roboto',
    'Poppins',
    'Montserrat',
    'Open Sans',
    'Lato',
  ];

  // Build theme based on settings
  static ThemeData buildTheme({
    required String colorTheme,
    required bool isDarkMode,
    required String fontFamily,
    required double fontSize,
  }) {
    final colorScheme = isDarkMode
        ? darkColorSchemes[colorTheme] ?? darkColorSchemes['blue']!
        : colorSchemes[colorTheme] ?? colorSchemes['blue']!;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      
      // Text Theme with custom font size
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: fontSize + 42, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: fontSize + 36, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: fontSize + 30, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(fontSize: fontSize + 18, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: fontSize + 14, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontSize: fontSize + 10, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: fontSize + 8, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: fontSize + 4, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(fontSize: fontSize + 2, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: fontSize + 2),
        bodyMedium: TextStyle(fontSize: fontSize),
        bodySmall: TextStyle(fontSize: fontSize - 2),
        labelLarge: TextStyle(fontSize: fontSize + 2, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontSize: fontSize - 2, fontWeight: FontWeight.w500),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: colorScheme.primary,
        size: 24,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: colorScheme.surface,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }
}
