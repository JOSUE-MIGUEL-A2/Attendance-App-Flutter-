import 'package:flutter/material.dart';
import 'package:thesis_attendance/data/notifiers.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  void _markAttendance(BuildContext context, AttendanceEvent event) {
    final now = DateTime.now();
    final lateTime = DateTime(
      event.date.year,
      event.date.month,
      event.date.day,
      event.lateCutoff.hour,
      event.lateCutoff.minute,
    );

    AttendanceStatus status;
    if (now.isBefore(lateTime)) {
      status = AttendanceStatus.present;
    } else {
      status = AttendanceStatus.late;
    }

    final user = currentUserNotifier.value!;
    final newRecord = AttendanceRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: user.id,
      studentName: user.name,
      eventId: event.id,
      status: status,
      timestamp: now,
      canSubmitDocument: status == AttendanceStatus.late,
    );

    attendanceRecordsNotifier.value = [
      ...attendanceRecordsNotifier.value,
      newRecord,
    ];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status == AttendanceStatus.present
              ? 'Attendance marked: Present'
              : 'Attendance marked: Late',
        ),
        backgroundColor: status == AttendanceStatus.present
            ? Colors.green
            : Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = currentUserNotifier.value!;
    
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
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'ID: ${user.studentId}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Quick Stats
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: attendanceRecordsNotifier,
                  builder: (context, records, child) {
                    final userRecords = records.where((r) => r.studentId == user.id).toList();
                    final presentCount = userRecords.where((r) => r.status == AttendanceStatus.present).length;
                    final percentage = userRecords.isEmpty ? 0 : (presentCount / userRecords.length * 100).round();
                    
                    return _StatCard(
                      title: 'Attendance',
                      value: '$percentage%',
                      icon: Icons.check_circle,
                      color: Colors.green,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: sanctionsNotifier,
                  builder: (context, sanctions, child) {
                    final userSanctions = sanctions.where(
                      (s) => s.studentId == user.id && s.status == 'active'
                    ).length;
                    
                    return _StatCard(
                      title: 'Sanctions',
                      value: '$userSanctions',
                      icon: Icons.warning,
                      color: userSanctions > 0 ? Colors.red : Colors.grey,
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Today's Events - Check-In
          const Text(
            'Today\'s Events - Check In',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ValueListenableBuilder(
            valueListenable: eventsNotifier,
            builder: (context, events, child) {
              final todayEvents = events.where((e) => e.isToday && e.isActive).toList();
              
              if (todayEvents.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.event_busy, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          Text(
                            'No events today',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: todayEvents.map((event) {
                  // Check if already checked in
                  final hasCheckedIn = attendanceRecordsNotifier.value.any(
                    (r) => r.studentId == user.id && r.eventId == event.id
                  );

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.event, color: Colors.blue.shade700),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${formatTime(event.startTime)} - ${formatTime(event.endTime)}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            event.description,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const Divider(height: 24),
                          if (!hasCheckedIn)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => _markAttendance(context, event),
                                icon: const Icon(Icons.check_circle),
                                label: const Text('CHECK IN NOW'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Already Checked In',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 24),

          // Upcoming Events
          const Text(
            'Upcoming Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ValueListenableBuilder(
            valueListenable: eventsNotifier,
            builder: (context, events, child) {
              final upcomingEvents = events.where((e) => e.isUpcoming && e.isActive).take(3).toList();
              
              if (upcomingEvents.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                children: upcomingEvents.map((event) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.upcoming, color: Colors.blue.shade700),
                      ),
                      title: Text(event.title),
                      subtitle: Text(
                        '${event.date.day}/${event.date.month}/${event.date.year} at ${formatTime(event.startTime)}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  );
                }).toList(),
              );
            },
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

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
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
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}