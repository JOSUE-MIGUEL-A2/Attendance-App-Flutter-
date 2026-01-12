// lib/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesis_attendance/core/theme/app_theme.dart';
import 'package:thesis_attendance/core/theme/theme_provider.dart';
import 'package:thesis_attendance/core/constants/route_names.dart';
import 'package:thesis_attendance/data/providers/settings_provider.dart';
import 'package:thesis_attendance/data/providers/auth_provider.dart';
import 'package:thesis_attendance/presentation/routes/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppSettingsProvider, ThemeProvider, AuthProvider>(
      builder: (context, settings, theme, auth, child) {
        return MaterialApp(
          title: 'ISATU Attendance System',
          debugShowCheckedModeBanner: false,
          
          // Light theme with current settings
          theme: AppTheme.lightTheme(
            fontSize: settings.fontSize,
            fontFamily: settings.fontFamily,
          ),
          
          // Dark theme with current settings
          darkTheme: AppTheme.darkTheme(
            fontSize: settings.fontSize,
            fontFamily: settings.fontFamily,
          ),
          
          // Use theme provider's theme mode
          themeMode: theme.themeMode,
          
          // Use AppRouter for route generation
          onGenerateRoute: AppRouter.onGenerateRoute,
          
          // Initial route depends on auth state
          initialRoute: auth.isAuthenticated 
              ? RouteNames.getInitialRouteForRole(auth.currentUser!.role)
              : RouteNames.welcome,
        );
      },
    );
  }
}