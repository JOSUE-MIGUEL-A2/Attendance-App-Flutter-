
import 'package:flutter/material.dart';
import 'package:thesis_attendance/theme/app_theme.dart';
import 'package:thesis_attendance/theme/theme_notifier.dart';
import 'package:thesis_attendance/views/welcome.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to theme changes
    return ValueListenableBuilder<ThemeSettings>(
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
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    // Wait for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    
    // Navigate to Welcome page
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Welcome()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Icon(
              Icons.school,
              size: 120,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 24),
            
            // App Name
            Text(
              'ISATU',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 8),
            
            // Subtitle
            const Text(
              'Attendance Tracking System',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 48),
            
            // Loading Indicator
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}