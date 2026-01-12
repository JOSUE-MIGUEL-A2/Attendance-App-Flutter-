// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesis_attendance/app.dart';
import 'package:thesis_attendance/data/providers/settings_provider.dart';
import 'package:thesis_attendance/data/providers/auth_provider.dart';
import 'package:thesis_attendance/data/providers/event_provider.dart';
import 'package:thesis_attendance/data/providers/attendance_provider.dart';
import 'package:thesis_attendance/data/providers/notification_provider.dart';
import 'package:thesis_attendance/data/providers/sanction_provider.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    // MultiProvider: Provides all app-wide state management
    MultiProvider(
      providers: [
        // Settings Provider - Theme, font, language preferences
        ChangeNotifierProvider(
          create: (_) => AppSettingsProvider(),
        ),
        
        // Auth Provider - User authentication and current user
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        
        // Event Provider - Manages events
        ChangeNotifierProvider(
          create: (_) => EventProvider(),
        ),
        
        // Attendance Provider - Manages attendance records
        ChangeNotifierProvider(
          create: (_) => AttendanceProvider(),
        ),
        
        // Notification Provider - Manages notifications
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
        ),
        
        // Sanction Provider - Manages sanctions
        ChangeNotifierProvider(
          create: (_) => SanctionProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}