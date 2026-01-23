import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thesis_attendance/config/firebase_options.dart';
import 'package:thesis_attendance/theme/app_theme.dart';
import 'package:thesis_attendance/theme/theme_notifier.dart';
import 'package:thesis_attendance/views/welcome.dart';
import 'package:thesis_attendance/views/pages/student/student_dashboard.dart';
import 'package:thesis_attendance/views/pages/admin/admin_dashboard.dart';
import 'package:thesis_attendance/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
          title: 'ISATU Attendance',
          debugShowCheckedModeBanner: false,
          
          // Build theme based on settings
          theme: AppTheme.buildTheme(
            colorTheme: settings.colorTheme,
            isDarkMode: settings.isDarkMode,
            fontFamily: settings.fontFamily,
            fontSize: settings.fontSize,
          ),
          
          // Use StreamBuilder to handle auth state
          home: StreamBuilder(
            stream: FirebaseService.authStateChanges,
            builder: (context, snapshot) {
              // Show loading while checking auth state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // User is not logged in
              if (!snapshot.hasData || snapshot.data == null) {
                return const Welcome();
              }

              // User is logged in - determine role
              return FutureBuilder(
                future: _getUserRole(snapshot.data!.uid),
                builder: (context, roleSnapshot) {
                  if (roleSnapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final role = roleSnapshot.data ?? 'student';
                  
                  if (role == 'admin') {
                    return const AdminDashboard();
                  } else {
                    return const StudentDashboard();
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<String> _getUserRole(String uid) async {
    try {
      final doc = await FirebaseService.users.doc(uid).get();
      if (doc.exists) {
        //return doc.data() as Map<String, dynamic>?['role'] ?? 'student';
      }
      return 'student';
    } catch (e) {
      print('Error getting user role: $e');
      return 'student';
    }
  }
}