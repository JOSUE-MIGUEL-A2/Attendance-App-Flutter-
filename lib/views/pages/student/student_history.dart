import 'package:flutter/material.dart';
import 'package:thesis_attendance/data/notifiers.dart';

class StudentHistory extends StatefulWidget {
  const StudentHistory({super.key});

  @override
  State<StudentHistory> createState() => _StudentHistoryState();
}

class _StudentHistoryState extends State<StudentHistory> {
  AttendanceStatus? filterStatus;

  @override
  Widget build(BuildContext context) {
    final user = currentUserNotifier.value!;

    return Column(
      children: [
        // Filter bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).primaryColor,
          child: Row(
            children: [
              const Icon(Icons.filter_list),
              const SizedBox(width: 12),
              const Text(
                'Filter:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', null),
                      _buildFilterChip('Present', AttendanceStatus.present),
                      _buildFilterChip('Late', AttendanceStatus.late),
                      _buildFilterChip('Absent', AttendanceStatus.absent),
                      _buildFilterChip('Excused', AttendanceStatus.excused),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // History list
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: attendanceRecordsNotifier,
            builder: (context, records, child) {
              var userRecords = records.where((r) => r.studentId == user.id).toList();
              
              if (filterStatus != null) {
                userRecords = userRecords.where((r) => r.status == filterStatus).toList();
              }

              // Sort by timestamp descending
              userRecords.sort((a, b) => b.timestamp.compareTo(a.timestamp));

              if (userRecords.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        filterStatus == null
                            ? 'No attendance history yet'
                            : 'No records found for this filter',
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
                itemCount: userRecords.length,
                itemBuilder: (context, index) {
                  final record = userRecords[index];
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
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _buildStatusIcon(record.status),
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
                                    const SizedBox(height: 4),
                                    Text(
                                      '${event.date.day}/${event.date.month}/${event.date.year}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildStatusBadge(record.status),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              Text(
                                'Logged at ${record.timestamp.hour}:${record.timestamp.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          if (record.remarks != null && record.remarks!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.note, size: 16, color: Colors.blue.shade700),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Remarks',
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    record.remarks!,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (record.documents.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: record.documents.map((doc) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getDocStatusColor(doc.status),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.attach_file,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        doc.status.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, AttendanceStatus? status) {
    final isSelected = filterStatus == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            filterStatus = selected ? status : null;
          });
        },
        selectedColor: Colors.blue.shade700,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildStatusIcon(AttendanceStatus status) {
    Color color;
    IconData icon;

    switch (status) {
      case AttendanceStatus.present:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case AttendanceStatus.late:
        color = Colors.orange;
        icon = Icons.schedule;
        break;
      case AttendanceStatus.absent:
        color = Colors.red;
        icon = Icons.cancel;
        break;
      case AttendanceStatus.excused:
        color = Colors.blue;
        icon = Icons.verified;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildStatusBadge(AttendanceStatus status) {
    Color color;
    String text;

    switch (status) {
      case AttendanceStatus.present:
        color = Colors.green;
        text = 'Present';
        break;
      case AttendanceStatus.late:
        color = Colors.orange;
        text = 'Late';
        break;
      case AttendanceStatus.absent:
        color = Colors.red;
        text = 'Absent';
        break;
      case AttendanceStatus.excused:
        color = Colors.blue;
        text = 'Excused';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getDocStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}