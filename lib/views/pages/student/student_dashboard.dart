// lib/views/pages/student/student_dashboard.dart
import 'package:flutter/material.dart';
import 'package:thesis_attendance/views/pages/student/student_home.dart';
import 'package:thesis_attendance/views/pages/student/student_events.dart';
import 'package:thesis_attendance/views/pages/student/student_history.dart';
import 'package:thesis_attendance/views/pages/student/student_analytics.dart';
import 'package:thesis_attendance/views/pages/student/student_sidebar/student_documents.dart';
import 'package:thesis_attendance/views/pages/student/student_sidebar/student_profile.dart';
import 'package:thesis_attendance/views/pages/student/student_sidebar/student_sanctions.dart';
import 'package:thesis_attendance/views/settings.dart';
import 'package:thesis_attendance/views/welcome.dart';
import 'package:thesis_attendance/services/auth_service.dart';
import 'package:thesis_attendance/services/firebase_service.dart';
import 'package:thesis_attendance/services/student_service.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final AuthService _authService = AuthService();
  final StudentService _studentService = StudentService();
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const StudentHome(),
    const StudentEvents(),
    const StudentHistory(),
    const StudentAnalytics(),
  ];

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseService.currentUserId;

    if (uid == null) {
      // User not logged in, redirect to welcome
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Welcome()),
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return StreamBuilder(
      stream: _studentService.getStudentProfile(uid),
      builder: (context, snapshot) {
        final student = snapshot.data;
        final studentName = student?.name ?? 'Student';
        final studentEmail = student?.email ?? '';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Student Portal'),
            actions: [
              // Notifications
              StreamBuilder<int>(
                stream: _getUnreadNotificationsCount(uid),
                builder: (context, countSnapshot) {
                  final count = countSnapshot.data ?? 0;
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () => _showNotifications(),
                      ),
                      if (count > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              count > 9 ? '9+' : count.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          drawer: _buildDrawer(studentName, studentEmail),
          body: _pages[_selectedIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.event),
                label: 'Events',
              ),
              NavigationDestination(
                icon: Icon(Icons.history),
                label: 'History',
              ),
              NavigationDestination(
                icon: Icon(Icons.analytics),
                label: 'Analytics',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawer(String studentName, String studentEmail) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    studentName.isNotEmpty ? studentName[0] : 'S',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  studentName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  studentEmail,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentProfile(),
                ),
              );
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('Documents'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentDocuments(),
                ),
              );
            },
          ),
          
          // Sanctions with counter
          StreamBuilder<int>(
            stream: _getSanctionsCount(),
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return ListTile(
                leading: const Icon(Icons.warning),
                title: const Text('Sanctions'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: count > 0 ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StudentSanctions(),
                    ),
                  );
                },
              );
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.qr_code_scanner),
            title: const Text('QR Scanner'),
            onTap: () {
              Navigator.pop(context);
              _showComingSoon('QR Scanner');
            },
          ),
          
          const Divider(),
          
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.pop(context);
              _showComingSoon('Help & Support');
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog();
            },
          ),
          
          const Divider(),
          
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  Stream<int> _getUnreadNotificationsCount(String uid) {
    // TODO: Implement notifications collection
    // For now, return 0
    return Stream.value(0);
  }

  Stream<int> _getSanctionsCount() async* {
    final uid = FirebaseService.currentUserId;
    if (uid == null) {
      yield 0;
      return;
    }

    final student = await _studentService.getStudentProfile(uid).first;
    if (student == null) {
      yield 0;
      return;
    }

    yield* _studentService.getSanctions(student.studentId).map((sanctions) {
      return sanctions.where((s) => s.status == 'Active').length;
    });
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Notifications',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text('No new notifications'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.school,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('About'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ISATU Attendance System',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Version 1.0.0'),
            const SizedBox(height: 16),
            Text(
              'An attendance tracking and management system for Iloilo Science and Technology University students.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Developed by: ISATU IT Department',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            const Text(
              '© 2026 All rights reserved',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _authService.signOut();
              if (!mounted) return;
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Welcome(),
                ),
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}