// lib/views/pages/student/student_home_firebase.dart
import 'package:flutter/material.dart';
import 'package:thesis_attendance/services/student_service.dart';
import 'package:thesis_attendance/services/firebase_service.dart';
import 'package:thesis_attendance/models/student_model.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final StudentService _studentService = StudentService();
  bool _isCheckingIn = false;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseService.currentUserId;

    if (uid == null) {
      return const Center(child: Text('Not logged in'));
    }

    return StreamBuilder<Student?>(
      stream: _studentService.getStudentProfile(uid),
      builder: (context, studentSnapshot) {
        if (studentSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!studentSnapshot.hasData || studentSnapshot.data == null) {
          return const Center(child: Text('Student data not found'));
        }

        final student = studentSnapshot.data!;

        return StreamBuilder<List<Event>>(
          stream: _studentService.getTodayEvents(),
          builder: (context, eventsSnapshot) {
            final todayEvents = eventsSnapshot.data ?? [];

            return StreamBuilder<List<Event>>(
              stream: _studentService.getUpcomingEvents(),
              builder: (context, upcomingSnapshot) {
                final upcomingEvents = (upcomingSnapshot.data ?? []).take(2).toList();

                return FutureBuilder<Map<String, int>>(
                  future: _studentService.getAttendanceStats(student.studentId),
                  builder: (context, statsSnapshot) {
                    final stats = statsSnapshot.data ?? {
                      'total': 0,
                      'present': 0,
                      'late': 0,
                      'absent': 0,
                      'rate': 0,
                    };

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome Card
                          _buildWelcomeCard(context, student),
                          const SizedBox(height: 24),

                          // Quick Stats
                          _buildQuickStats(context, stats, student),
                          const SizedBox(height: 24),

                          // Today's Events
                          _buildTodayEventsSection(context, todayEvents, student),
                          const SizedBox(height: 24),

                          // Upcoming Events
                          _buildUpcomingEventsSection(context, upcomingEvents),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildWelcomeCard(BuildContext context, Student student) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Text(
                student.name.isNotEmpty ? student.name[0] : 'S',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    student.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ID: ${student.studentId}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, Map<String, int> stats, Student student) {
    return FutureBuilder<List<Sanction>>(
      future: _studentService.getSanctions(student.studentId).first,
      builder: (context, sanctionsSnapshot) {
        final sanctionsCount = sanctionsSnapshot.data?.length ?? 0;

        return Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Attendance',
                value: '${stats['rate'] ?? 95}%',
                icon: Icons.check_circle,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'Sanctions',
                value: sanctionsCount.toString(),
                icon: Icons.warning,
                color: sanctionsCount > 0 ? Colors.red : Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTodayEventsSection(BuildContext context, List<Event> todayEvents, Student student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Events - Check In",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton.icon(
              onPressed: () {
                // Navigate to events tab
              },
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (todayEvents.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No events scheduled for today',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...todayEvents.map((event) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FutureBuilder<bool>(
              future: _studentService.isCheckedIn(student.studentId, event.id),
              builder: (context, checkedInSnapshot) {
                final isCheckedIn = checkedInSnapshot.data ?? false;

                return _TodayEventCard(
                  event: event,
                  studentId: student.studentId,
                  isCheckedIn: isCheckedIn,
                  onCheckIn: () => _handleCheckIn(event, student.studentId),
                  isCheckingIn: _isCheckingIn,
                );
              },
            ),
          )),
      ],
    );
  }

  Widget _buildUpcomingEventsSection(BuildContext context, List<Event> upcomingEvents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Week\'s Events',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        if (upcomingEvents.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'No upcoming events this week',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          )
        else
          ...upcomingEvents.map((event) {
            final daysUntil = event.date.difference(DateTime.now()).inDays;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _WeekEventCard(
                title: event.title,
                date: _formatDate(event.date),
                time: '${event.startTime} - ${event.endTime}',
                daysUntil: daysUntil,
              ),
            );
          }),
      ],
    );
  }

  Future<void> _handleCheckIn(Event event, String studentId) async {
    if (event.status != 'active') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This event is not active yet'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isCheckingIn = true;
    });

    try {
      final result = await _studentService.checkInToEvent(
        studentId: studentId,
        eventId: event.id,
      );

      if (!mounted) return;

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingIn = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}

// Stat Card Widget
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

// Today Event Card Widget
class _TodayEventCard extends StatelessWidget {
  final Event event;
  final String studentId;
  final bool isCheckedIn;
  final VoidCallback onCheckIn;
  final bool isCheckingIn;

  const _TodayEventCard({
    required this.event,
    required this.studentId,
    required this.isCheckedIn,
    required this.onCheckIn,
    required this.isCheckingIn,
  });

  @override
  Widget build(BuildContext context) {
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
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.event,
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
                        '${event.startTime} - ${event.endTime}',
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
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: Colors.orange.shade700),
                const SizedBox(width: 4),
                Text(
                  'Late after ${event.lateCutoff}',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (!isCheckedIn)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isCheckingIn ? null : onCheckIn,
                  icon: isCheckingIn
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle),
                  label: Text(isCheckingIn ? 'CHECKING IN...' : 'CHECK IN NOW'),
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
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Text(
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
  }
}

// Week Event Card Widget
class _WeekEventCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final int daysUntil;

  const _WeekEventCard({
    required this.title,
    required this.date,
    required this.time,
    required this.daysUntil,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          child: Icon(
            Icons.upcoming,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date),
            Text(
              time,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            daysUntil == 0 ? 'Today' : daysUntil == 1 ? 'Tomorrow' : 'In $daysUntil days',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}