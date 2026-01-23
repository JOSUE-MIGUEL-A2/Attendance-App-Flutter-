// lib/views/pages/student/student_history.dart
import 'package:flutter/material.dart';
import 'package:thesis_attendance/services/student_service.dart';
import 'package:thesis_attendance/services/firebase_service.dart';
import 'package:thesis_attendance/models/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentHistory extends StatefulWidget {
  const StudentHistory({super.key});

  @override
  State<StudentHistory> createState() => _StudentHistoryState();
}

class _StudentHistoryState extends State<StudentHistory> {
  final StudentService _studentService = StudentService();
  String _selectedMonth = 'All Time';
  final List<String> _months = [
    'All Time',
    'January 2026',
    'December 2025',
    'November 2025',
    'October 2025',
  ];

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseService.currentUserId;

    if (uid == null) {
      return const Center(child: Text('Not logged in'));
    }

    return StreamBuilder<Student?>(
      stream: _studentService.getStudentProfile(uid),
      builder: (context, studentSnapshot) {
        if (!studentSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final student = studentSnapshot.data!;

        return StreamBuilder<List<AttendanceRecord>>(
          stream: _getFilteredAttendance(student.studentId),
          builder: (context, recordsSnapshot) {
            if (recordsSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final allRecords = recordsSnapshot.data ?? [];
            
            // Calculate stats
            final filteredPresent = allRecords.where((r) => r.status == 'present').length;
            final filteredLate = allRecords.where((r) => r.status == 'late').length;
            final filteredAbsent = allRecords.where((r) => r.status == 'absent').length;
            final filteredTotal = allRecords.length;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Total Events',
                          value: filteredTotal.toString(),
                          icon: Icons.event,
                          color: Colors.blue,
                          onTap: () => _showFilteredRecords(allRecords, 'All Events'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Attended',
                          value: (filteredPresent + filteredLate).toString(),
                          icon: Icons.check_circle,
                          color: Colors.green,
                          onTap: () => _showFilteredRecords(
                            allRecords.where((r) => r.status == 'present' || r.status == 'late').toList(),
                            'Attended Events',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Late',
                          value: filteredLate.toString(),
                          icon: Icons.schedule,
                          color: Colors.orange,
                          onTap: () => _showFilteredRecords(
                            allRecords.where((r) => r.status == 'late').toList(),
                            'Late Arrivals',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Absent',
                          value: filteredAbsent.toString(),
                          icon: Icons.cancel,
                          color: Colors.red,
                          onTap: () => _showFilteredRecords(
                            allRecords.where((r) => r.status == 'absent').toList(),
                            'Absences',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Month Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Attendance History',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedMonth,
                          underline: const SizedBox(),
                          isDense: true,
                          items: _months
                              .map((month) => DropdownMenuItem(
                                    value: month,
                                    child: Text(
                                      month,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedMonth = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // History List
                  if (allRecords.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.history,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No attendance records found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...allRecords.map((record) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _HistoryItem(
                        record: record,
                        onTap: () => _showRecordDetails(record),
                      ),
                    )),

                  const SizedBox(height: 24),

                  // Export Button
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: allRecords.isEmpty ? null : () => _handleExport(allRecords),
                      icon: const Icon(Icons.download),
                      label: Text('Export ${_selectedMonth} History'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Stream<List<AttendanceRecord>> _getFilteredAttendance(String studentId) {
    Query query = FirebaseService.firestore
        .collection('attendance')
        .where('studentId', isEqualTo: studentId);

    if (_selectedMonth != 'All Time') {
      final parts = _selectedMonth.split(' ');
      if (parts.length == 2) {
        final monthNames = ['January', 'February', 'March', 'April', 'May', 'June',
                           'July', 'August', 'September', 'October', 'November', 'December'];
        final monthIndex = monthNames.indexOf(parts[0]) + 1;
        final year = int.parse(parts[1]);
        
        final startDate = DateTime(year, monthIndex, 1);
        final endDate = DateTime(year, monthIndex + 1, 0, 23, 59, 59);
        
        query = query
            .where('eventDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('eventDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }
    }

    return query
        .orderBy('eventDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AttendanceRecord(
          id: doc.id,
          studentId: data['studentId'] ?? '',
          eventId: data['eventId'] ?? '',
          eventName: data['eventName'] ?? '',
          eventDate: (data['eventDate'] as Timestamp).toDate(),
          eventTime: data['eventTime'] ?? '',
          status: data['status'] ?? '',
          checkInTime: data['checkInTime'] != null
              ? (data['checkInTime'] as Timestamp).toDate()
              : null,
          remarks: data['remarks'],
        );
      }).toList();
    });
  }

  void _showFilteredRecords(List<AttendanceRecord> records, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: records.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('No records found'),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return ListTile(
                      leading: _getStatusIcon(record.status),
                      title: Text(record.eventName),
                      subtitle: Text(_formatDate(record.eventDate)),
                      trailing: record.checkInTime != null
                          ? Text(
                              '${record.checkInTime!.hour}:${record.checkInTime!.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 12),
                            )
                          : const Text('-'),
                    );
                  },
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

  void _showRecordDetails(AttendanceRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(record.eventName),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _DetailRow('Date:', _formatDate(record.eventDate)),
            _DetailRow('Time:', record.eventTime),
            _DetailRow('Status:', record.status.toUpperCase()),
            if (record.checkInTime != null)
              _DetailRow(
                'Check-in Time:',
                '${record.checkInTime!.hour}:${record.checkInTime!.minute.toString().padLeft(2, '0')}',
              ),
            if (record.remarks != null) ...[
              const SizedBox(height: 12),
              const Text(
                'Remarks:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                record.remarks!,
                style: TextStyle(
                  color: record.status == 'late' ? Colors.orange : Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getStatusColor(record.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getStatusColor(record.status)),
              ),
              child: Row(
                children: [
                  _getStatusIcon(record.status),
                  const SizedBox(width: 8),
                  Text(
                    _getStatusText(record.status),
                    style: TextStyle(
                      color: _getStatusColor(record.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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

  void _handleExport(List<AttendanceRecord> records) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Attendance History'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Export ${records.length} attendance records for $_selectedMonth?'),
            const SizedBox(height: 16),
            const Text(
              'Export format:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _ExportOption(Icons.picture_as_pdf, 'PDF'),
                _ExportOption(Icons.table_chart, 'Excel'),
                _ExportOption(Icons.description, 'CSV'),
              ],
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Exporting ${records.length} records...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              // TODO: Implement actual export functionality
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Widget _getStatusIcon(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'present':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'late':
        color = Colors.orange;
        icon = Icons.schedule;
        break;
      case 'absent':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: color.withOpacity(0.1),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'present':
        return Colors.green;
      case 'late':
        return Colors.orange;
      case 'absent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'present':
        return 'Present - On Time';
      case 'late':
        return 'Present - Late Arrival';
      case 'absent':
        return 'Absent';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportOption extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ExportOption(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 28, color: color),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final AttendanceRecord record;
  final VoidCallback onTap;

  const _HistoryItem({
    required this.record,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (record.status) {
      case 'present':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Present';
        break;
      case 'late':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        statusText = 'Late';
        break;
      case 'absent':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'Absent';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = 'Unknown';
    }

    return Card(
      elevation: 1,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(statusIcon, color: statusColor, size: 24),
        ),
        title: Text(
          record.eventName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  _formatDate(record.eventDate),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 12),
                Icon(Icons.access_time, size: 12, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  record.eventTime,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            if (record.checkInTime != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.login, size: 12, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Checked in at ${record.checkInTime!.hour}:${record.checkInTime!.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ],
            if (record.remarks != null) ...[
              const SizedBox(height: 4),
              Text(
                record.remarks!,
                style: TextStyle(
                  fontSize: 11,
                  color: statusColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusColor, width: 1.5),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}