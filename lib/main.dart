import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'theme/theme_notifier.dart';
import 'views/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeSettings>(
      valueListenable: themeSettingsNotifier,
      builder: (context, settings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ISATU Attendance App',
          theme: AppTheme.buildTheme(
            colorTheme: settings.colorTheme,
            isDarkMode: settings.isDarkMode,
            fontFamily: settings.fontFamily,
            fontSize: settings.fontSize,
          ),
          home: const SettingsPage(), // Or your welcome page
        );
      },
    );
  }
}