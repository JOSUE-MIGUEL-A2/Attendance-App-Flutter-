import 'package:flutter/material.dart';
import 'package:thesis_attendance/data/notifiers.dart';
import 'package:thesis_attendance/views/pages/admin/admin_events.dart';
import 'package:thesis_attendance/views/pages/admin/admin_approvals.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade700, Colors.purple.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 40),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin Control Center',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'With great power comes .... plus 5 sa present',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'System Stats (Live via firebas , if possible)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 12),
          
          ValueListenableBuilder(
            valueListenable: attendanceRecordsNotifier,
            builder: (context, records, child) {
              // Calculate stats 
              final uniqueStudents = records.map((r) => r.studentId).toSet().length;
              final totalRecords = records.length;
              final presentCount = records.where((r) => r.status == AttendanceStatus.present).length;
              final attendanceRate = totalRecords > 0 ? (presentCount / totalRecords * 100).round() : 0;
              
              // Today's attendance
              final now = DateTime.now();
              final todayRecords = records.where((r) {
                return r.timestamp.day == now.day &&
                       r.timestamp.month == now.month &&
                       r.timestamp.year == now.year;
              }).length;

              final absentToday = todayRecords > 0 ? uniqueStudents - todayRecords : 0;

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Total Students',
                          value: '$uniqueStudents',
                          icon: Icons.people,
                          color: Colors.blue,
                          subtitle: uniqueStudents > 10 ? 'Popular!' : 'Growing',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Attendance Rate',
                          value: '$attendanceRate%',
                          icon: Icons.trending_up,
                          color: attendanceRate >= 80 ? Colors.green : Colors.orange,
                          subtitle: attendanceRate >= 80 ? 'Excellent!' : 'Needs work',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: eventsNotifier,
                          builder: (context, events, child) {
                            final activeEvents = events.where((e) => e.isActive).length;
                            return _StatCard(
                              title: 'Active Events',
                              value: '$activeEvents',
                              icon: Icons.event,
                              color: Colors.purple,
                              subtitle: activeEvents > 0 ? 'Happening!' : 'Create one!',
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Absent Today',
                          value: '$absentToday',
                          icon: Icons.warning,
                          color: absentToday > 0 ? Colors.red : Colors.green,
                          subtitle: absentToday == 0 ? 'Perfect!' : 'Oh no!',
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // Pending Approvals - The "To-Do" List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pending Approvals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ValueListenableBuilder(
                valueListenable: attendanceRecordsNotifier,
                builder: (context, records, child) {
                  final pendingCount = records
                      .expand((r) => r.documents)
                      .where((d) => d.status == 'pending')
                      .length;
                  
                  if (pendingCount == 0) return const SizedBox.shrink();
                  
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.pending_actions, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '$pendingCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          ValueListenableBuilder(
            valueListenable: attendanceRecordsNotifier,
            builder: (context, records, child) {
              final pendingRecords = records
                  .where((r) => r.documents.any((d) => d.status == 'pending'))
                  .take(5)
                  .toList();
              
              if (pendingRecords.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.check_circle, size: 48, color: Colors.green.shade400),
                          const SizedBox(height: 8),
                          const Text(
                            'All caught up!',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'No pending approvals',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              
              return Column(
                children: pendingRecords.map((record) {
                  final pendingDocs = record.documents.where((d) => d.status == 'pending').length;
                  final event = eventsNotifier.value.firstWhere(
                    (e) => e.id == record.eventId,
                    orElse: () => AttendanceEvent(
                      id: '',
                      title: 'Unknown Event',
                      description: '',
                      date: DateTime.now(),
                      startTime: const TimeOfDay(hour: 0, minute: 0),
                      endTime: const TimeOfDay(hour: 0, minute: 0),
                      lateCutoff: const TimeOfDay(hour: 0, minute: 0),
                      createdBy: '',
                    ),
                  );

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange.shade100,
                        child: Icon(Icons.pending, color: Colors.orange.shade700),
                      ),
                      title: Text(record.studentName),
                      subtitle: Text('$pendingDocs doc(s) for ${event.title}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminApprovals(),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 12),
          
          _QuickActionCard(
            icon: Icons.add_circle,
            title: 'Create New Event',
            subtitle: 'Schedule attendance tracking',
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminEvents()),
              );
            },
          ),
          
          _QuickActionCard(
            icon: Icons.approval,
            title: 'Review Documents',
            subtitle: 'Approve or reject excuse letters',
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminApprovals()),
              );
            },
          ),
          
          _QuickActionCard(
            icon: Icons.send,
            title: 'Send Announcement',
            subtitle: 'Broadcast to all students',
            color: Colors.purple,
            onTap: () {
              _showAnnouncementDialog(context);
            },
          ),
          
          const SizedBox(height: 16),
        
          Center(
            child: Text(
              'IDK what I am doing really',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAnnouncementDialog(BuildContext context) {
    final titleController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📢 Send Announcement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Message',
                prefixIcon: Icon(Icons.message),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isEmpty || messageController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fill in all fields, boss!'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              // Broadcast to all students
              notificationsNotifier.value = [
                ...notificationsNotifier.value,
                AppNotification(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  message: messageController.text,
                  timestamp: DateTime.now(),
                  type: 'announcement',
                ),
              ];

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(' Announcement sent to all students!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Send to All'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: color.withOpacity(0.7),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}