import 'package:flutter/material.dart';
import 'package:thesis_attendance/data/notifiers.dart';

class StudentEvents extends StatelessWidget {
  const StudentEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final user = currentUserNotifier.value!;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Material(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: const TabBar(
              tabs: [
                Tab(text: 'Today', icon: Icon(Icons.today)),
                Tab(text: 'Upcoming', icon: Icon(Icons.upcoming)),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildTodayEvents(context, user),
                _buildUpcomingEvents(context, user),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayEvents(BuildContext context, CurrentUser user) {
    return ValueListenableBuilder(
      valueListenable: eventsNotifier,
      builder: (context, events, child) {
        final todayEvents = events.where((e) => e.isToday && e.isActive).toList();

        if (todayEvents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No events scheduled for today',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: todayEvents.length,
          itemBuilder: (context, index) {
            final event = todayEvents[index];
            final attendance = attendanceRecordsNotifier.value.firstWhere(
              (r) => r.studentId == user.id && r.eventId == event.id,
              orElse: () => AttendanceRecord(
                id: '',
                studentId: '',
                studentName: '',
                eventId: '',
                status: AttendanceStatus.absent,
                timestamp: DateTime.now(),
              ),
            );

            final hasAttendance = attendance.id.isNotEmpty;

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () => _showEventDetails(context, event, attendance, hasAttendance),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.event,
                              color: Colors.blue.shade700,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${formatTime(event.startTime)} - ${formatTime(event.endTime)}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.description,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                      const Divider(height: 24),
                      if (hasAttendance)
                        _buildAttendanceStatus(attendance.status, attendance.timestamp)
                      else
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.warning, color: Colors.orange, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Not Checked In',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUpcomingEvents(BuildContext context, CurrentUser user) {
    return ValueListenableBuilder(
      valueListenable: eventsNotifier,
      builder: (context, events, child) {
        final upcomingEvents = events.where((e) => e.isUpcoming && e.isActive).toList();
        upcomingEvents.sort((a, b) => a.date.compareTo(b.date));

        if (upcomingEvents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_available, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No upcoming events',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: upcomingEvents.length,
          itemBuilder: (context, index) {
            final event = upcomingEvents[index];
            final daysUntil = event.date.difference(DateTime.now()).inDays;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _showEventDetails(context, event, null, false),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.upcoming,
                          color: Colors.purple.shade700,
                        ),
                      ),
                      const SizedBox(width: 16),
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
                            const SizedBox(height: 4),
                            Text(
                              '${event.date.day}/${event.date.month}/${event.date.year}',
                              style: TextStyle(color: Colors.grey.shade600),
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          daysUntil == 0 ? 'Today' : 'In $daysUntil day${daysUntil > 1 ? 's' : ''}',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAttendanceStatus(AttendanceStatus status, DateTime timestamp) {
    Color color;
    IconData icon;
    String text;

    switch (status) {
      case AttendanceStatus.present:
        color = Colors.green;
        icon = Icons.check_circle;
        text = 'Present';
        break;
      case AttendanceStatus.late:
        color = Colors.orange;
        icon = Icons.schedule;
        text = 'Late';
        break;
      case AttendanceStatus.absent:
        color = Colors.red;
        icon = Icons.cancel;
        text = 'Absent';
        break;
      case AttendanceStatus.excused:
        color = Colors.blue;
        icon = Icons.verified;
        text = 'Excused';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Checked in at ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showEventDetails(BuildContext context, AttendanceEvent event, AttendanceRecord? attendance, bool hasAttendance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(Icons.description, 'Description', event.description),
              const Divider(height: 24),
              _buildDetailRow(Icons.calendar_today, 'Date', '${event.date.day}/${event.date.month}/${event.date.year}'),
              _buildDetailRow(Icons.access_time, 'Time', '${formatTime(event.startTime)} - ${formatTime(event.endTime)}'),
              _buildDetailRow(Icons.schedule, 'Late Cutoff', formatTime(event.lateCutoff)),
              if (hasAttendance) ...[
                const Divider(height: 24),
                const Text(
                  'Your Attendance',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                _buildAttendanceStatus(attendance!.status, attendance.timestamp),
              ],
            ],
          ),
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}