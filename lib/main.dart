import 'package:flutter/material.dart';
import 'package:thesis_attendance/data/notifiers.dart';
import 'package:thesis_attendance/views/pages/welcome.dart';

void main() {
  initializeSampleData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkNotifier,
      builder: (context, isDark, child) {
        return ValueListenableBuilder(
          valueListenable: appSettingsNotifier,
          builder: (context, settings, child) {
            return MaterialApp(
              title: 'ISATU Attendance System',
              debugShowCheckedModeBanner: false,
              
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  brightness: Brightness.light,
                ),
                useMaterial3: true,
                textTheme: TextTheme(
                  bodyLarge: TextStyle(
                    fontSize: settings.fontSize,
                    fontFamily: settings.fontFamily,
                  ),
                  bodyMedium: TextStyle(
                    fontSize: settings.fontSize,
                    fontFamily: settings.fontFamily,
                  ),
                  bodySmall: TextStyle(
                    fontSize: settings.fontSize - 2,
                    fontFamily: settings.fontFamily,
                  ),
                  headlineLarge: TextStyle(
                    fontSize: settings.fontSize + 10,
                    fontFamily: settings.fontFamily,
                    fontWeight: FontWeight.bold,
                  ),
                  headlineMedium: TextStyle(
                    fontSize: settings.fontSize + 6,
                    fontFamily: settings.fontFamily,
                    fontWeight: FontWeight.bold,
                  ),
                  headlineSmall: TextStyle(
                    fontSize: settings.fontSize + 4,
                    fontFamily: settings.fontFamily,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                cardTheme: CardThemeData(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                appBarTheme: AppBarTheme(
                  elevation: 0,
                  centerTitle: false,
                  titleTextStyle: TextStyle(
                    fontSize: settings.fontSize + 6,
                    fontWeight: FontWeight.bold,
                    fontFamily: settings.fontFamily,
                  ),
                ),
              ),
              
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
                textTheme: TextTheme(
                  bodyLarge: TextStyle(
                    fontSize: settings.fontSize,
                    fontFamily: settings.fontFamily,
                  ),
                  bodyMedium: TextStyle(
                    fontSize: settings.fontSize,
                    fontFamily: settings.fontFamily,
                  ),
                  bodySmall: TextStyle(
                    fontSize: settings.fontSize - 2,
                    fontFamily: settings.fontFamily,
                  ),
                  headlineLarge: TextStyle(
                    fontSize: settings.fontSize + 10,
                    fontFamily: settings.fontFamily,
                    fontWeight: FontWeight.bold,
                  ),
                  headlineMedium: TextStyle(
                    fontSize: settings.fontSize + 6,
                    fontFamily: settings.fontFamily,
                    fontWeight: FontWeight.bold,
                  ),
                  headlineSmall: TextStyle(
                    fontSize: settings.fontSize + 4,
                    fontFamily: settings.fontFamily,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                cardTheme: CardThemeData(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                appBarTheme: AppBarTheme(
                  elevation: 0,
                  centerTitle: false,
                  titleTextStyle: TextStyle(
                    fontSize: settings.fontSize + 6,
                    fontWeight: FontWeight.bold,
                    fontFamily: settings.fontFamily,
                  ),
                ),
              ),
              
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              
              // Start at Welcome/Login screen
              home: const Welcome(),
            );
          },
        );
      },
    );
  }
}