import 'package:flutter/material.dart';
import 'package:thesis_attendance/data/notifiers.dart';

class AdminStudents extends StatelessWidget {
  const AdminStudents({super.key});

  void _viewStudentDetails(BuildContext context, String studentId, String studentName) {
    final studentRecords = attendanceRecordsNotifier.value
        .where((r) => r.studentId == studentId)
        .toList();
    
    studentRecords.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    final presentCount = studentRecords.where((r) => r.status == AttendanceStatus.present).length;
    final lateCount = studentRecords.where((r) => r.status == AttendanceStatus.late).length;
    final absentCount = studentRecords.where((r) => r.status == AttendanceStatus.absent).length;
    final excusedCount = studentRecords.where((r) => r.status == AttendanceStatus.excused).length;
    final totalCount = studentRecords.length;
    final attendanceRate = totalCount > 0 ? ((presentCount + excusedCount) / totalCount * 100).round() : 0;

    final studentSanctions = sanctionsNotifier.value
        .where((s) => s.studentId == studentId)
        .toList();
    final activeSanctions = studentSanctions.where((s) => s.status == 'active').length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                studentName[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                studentName,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Overview
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade100, Colors.blue.shade50],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _MiniStat('Rate', '$attendanceRate%', Colors.blue),
                          _MiniStat('Present', '$presentCount', Colors.green),
                          _MiniStat('Late', '$lateCount', Colors.orange),
                          _MiniStat('Absent', '$absentCount', Colors.red),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Sanctions
                if (activeSanctions > 0)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '$activeSanctions Active Sanction${activeSanctions > 1 ? 's' : ''}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Recent Records
                const Text(
                  'Recent Attendance',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                
                if (studentRecords.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No attendance records yet'),
                    ),
                  )
                else
                  ...studentRecords.take(5).map((record) {
                    final event = eventsNotifier.value.firstWhere(
                      (e) => e.id == record.eventId,
                      orElse: () => AttendanceEvent(
                        id: '',
                        title: 'Unknown',
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
                        dense: true,
                        leading: Icon(
                          _getStatusIcon(record.status),
                          color: _getStatusColor(record.status),
                          size: 20,
                        ),
                        title: Text(
                          event.title,
                          style: const TextStyle(fontSize: 13),
                        ),
                        subtitle: Text(
                          '${record.timestamp.day}/${record.timestamp.month}/${record.timestamp.year}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(record.status),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getStatusColor(record.status),
                            ),
                          ),
                          child: Text(
                            record.status.toString().split('.').last.toUpperCase(),
                            style: TextStyle(
                              color: _getStatusColor(record.status),
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              ],
            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Records'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: attendanceRecordsNotifier,
        builder: (context, records, child) {
          // Get unique students
          final studentMap = <String, String>{};
          for (var record in records) {
            studentMap[record.studentId] = record.studentName;
          }

          final students = studentMap.entries.toList();
          students.sort((a, b) => a.value.compareTo(b.value));

          if (students.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 100, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'No students yet',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Students will appear once they check in',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final studentRecords = records.where((r) => r.studentId == student.key).toList();
              
              final presentCount = studentRecords.where((r) => r.status == AttendanceStatus.present).length;
              final totalCount = studentRecords.length;
              final attendanceRate = totalCount > 0 ? (presentCount / totalCount * 100).round() : 0;

              final activeSanctions = sanctionsNotifier.value
                  .where((s) => s.studentId == student.key && s.status == 'active')
                  .length;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      student.value[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    student.value,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Attendance Rate: $attendanceRate%'),
                      Text('Total Events: $totalCount'),
                      if (activeSanctions > 0)
                        Text(
                          '⚠️ $activeSanctions Active Sanction${activeSanctions > 1 ? 's' : ''}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: attendanceRate >= 80
                              ? Colors.green
                              : attendanceRate >= 60
                                  ? Colors.orange
                                  : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: attendanceRate >= 80
                                ? Colors.green
                                : attendanceRate >= 60
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                        ),
                        child: Text(
                          '$attendanceRate%',
                          style: TextStyle(
                            color: attendanceRate >= 80
                                ? Colors.green
                                : attendanceRate >= 60
                                    ? Colors.orange
                                    : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () => _viewStudentDetails(context, student.key, student.value),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.late:
        return Colors.orange;
      case AttendanceStatus.absent:
        return Colors.red;
      case AttendanceStatus.excused:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Icons.check_circle;
      case AttendanceStatus.late:
        return Icons.schedule;
      case AttendanceStatus.absent:
        return Icons.cancel;
      case AttendanceStatus.excused:
        return Icons.verified;
    }
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}