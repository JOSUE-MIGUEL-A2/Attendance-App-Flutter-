import 'package:flutter/material.dart';
import 'package:thesis_attendance/data/notifiers.dart';
import 'package:thesis_attendance/views/pages/admin/admin_dashboard.dart';
import 'package:thesis_attendance/views/pages/admin/admin_events.dart';
import 'package:thesis_attendance/views/pages/admin/admin_monitoring.dart';
import 'package:thesis_attendance/views/pages/admin/admin_approvals.dart';
import 'package:thesis_attendance/views/pages/admin/admin_sanctions.dart';
import 'package:thesis_attendance/views/pages/admin/admin_students.dart';
import 'package:thesis_attendance/views/pages/settings.dart';
import 'package:thesis_attendance/views/pages/welcome.dart';

class AdminWidgetTree extends StatelessWidget {
  const AdminWidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const AdminDashboard(),
      const AdminEvents(),
      const AdminMonitoring(),
      const AdminApprovals(),
    ];

    return ValueListenableBuilder(
      valueListenable: isDarkNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Admin Control Panel'),
            backgroundColor: Colors.purple.shade700,
            foregroundColor: Colors.white,
            actions: [
              // Pending notifications indicator
              ValueListenableBuilder(
                valueListenable: attendanceRecordsNotifier,
                builder: (context, records, child) {
                  final pendingCount = records
                      .expand((r) => r.documents)
                      .where((d) => d.status == 'pending')
                      .length;

                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$pendingCount pending approval(s)'),
                              action: SnackBarAction(
                                label: 'View',
                                onPressed: () {
                                  selectedPageNotifier.value = 3; // Approvals page
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      if (pendingCount > 0)
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
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              '$pendingCount',
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
                icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                onPressed: () => isDarkNotifier.value = !isDarkNotifier.value,
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Settings(title: "Settings"),
                    ),
                  );
                },
              ),
            ],
          ),
          drawer: _buildDrawer(context),
          body: ValueListenableBuilder(
            valueListenable: selectedPageNotifier,
            builder: (context, selectedPage, child) {
              return pages[selectedPage];
            },
          ),
          bottomNavigationBar: _buildNavBar(),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final user = currentUserNotifier.value!;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Admin Header - Purple Power! 💜
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade700, Colors.purple.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 40,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '👑 ADMINISTRATOR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('View Students'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminStudents(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning),
              title: const Text('Manage Sanctions'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminSanctions(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('View Reports'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('📊 Reports feature - Export coming soon!'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Admin Help'),
                    content: const SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('📚 Quick Guide:', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('• Create events for attendance tracking'),
                          Text('• Monitor real-time attendance'),
                          Text('• Review and approve excuse documents'),
                          Text('• Issue sanctions when needed'),
                          Text('• View student records and reports'),
                          SizedBox(height: 16),
                          Text('💡 Pro Tips:', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('• All actions are audit-logged'),
                          Text('• Students can\'t edit after check-in'),
                          Text('• Approving docs changes status to "Excused"'),
                          Text('• Manual overrides require justification'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Got it!'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Spacer(),

            // Logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
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
                        onPressed: () {
                          currentUserNotifier.value = null;
                          selectedPageNotifier.value = 0;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Welcome(),
                            ),
                            (route) => false,
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
              },
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '🎮 Admin Mode Active',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: "Dashboard",
            ),
            NavigationDestination(
              icon: Icon(Icons.event_outlined),
              selectedIcon: Icon(Icons.event),
              label: "Events",
            ),
            NavigationDestination(
              icon: Icon(Icons.monitor_outlined),
              selectedIcon: Icon(Icons.monitor),
              label: "Monitor",
            ),
            NavigationDestination(
              icon: Icon(Icons.approval_outlined),
              selectedIcon: Icon(Icons.approval),
              label: "Approvals",
            ),
          ],
          onDestinationSelected: (int value) {
            selectedPageNotifier.value = value;
          },
          selectedIndex: selectedPage,
          animationDuration: const Duration(milliseconds: 400),
        );
      },
    );
  }
}