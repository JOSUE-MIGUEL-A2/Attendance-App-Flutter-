import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesis_attendance/theme/app_theme.dart';
import 'package:thesis_attendance/theme/theme_notifier.dart';
import 'package:thesis_attendance/services/data_provider.dart';
import 'package:thesis_attendance/views/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap with ChangeNotifierProvider for data management
    return ChangeNotifierProvider.value(
      value: dataProvider,
      child: ValueListenableBuilder<ThemeSettings>(
        valueListenable: themeSettingsNotifier,
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'ISATU Attendance',
            debugShowCheckedModeBanner: false,
            
            // Build theme based on settings
            theme: AppTheme.buildTheme(
              colorTheme: settings.colorTheme,
              isDarkMode: settings.isDarkMode,
              fontFamily: settings.fontFamily,
              fontSize: settings.fontSize,
            ),
            
            // Set initial route
            home: const Welcome(),
          );
        },
      ),
    );
  }
}