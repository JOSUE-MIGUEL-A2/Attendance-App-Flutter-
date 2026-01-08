import 'package:flutter/material.dart';
import 'package:thesis_attendance/data/notifiers.dart';

class AdminMonitoring extends StatefulWidget {
  const AdminMonitoring({super.key});

  @override
  State<AdminMonitoring> createState() => _AdminMonitoringState();
}

class _AdminMonitoringState extends State<AdminMonitoring> {
  String? filterEventId;
  AttendanceStatus? filterStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Monitoring'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter Bar - Like a detective's toolkit 🕵️
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.purple.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.filter_list, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Filters',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Event Filter
                ValueListenableBuilder(
                  valueListenable: eventsNotifier,
                  builder: (context, events, child) {
                    return DropdownButtonFormField<String>(
                      value: filterEventId,
                      decoration: const InputDecoration(
                        labelText: 'Filter by Event',
                        prefixIcon: Icon(Icons.event),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('All Events'),
                        ),
                        ...events.map((event) => DropdownMenuItem(
                              value: event.id,
                              child: Text(event.title),
                            )),
                      ],
                      onChanged: (value) {
                        setState(() => filterEventId = value);
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                // Status Filter
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: filterStatus == null,
                      onSelected: (selected) {
                        setState(() => filterStatus = null);
                      },
                    ),
                    FilterChip(
                      label: const Text('Present'),
                      selected: filterStatus == AttendanceStatus.present,
                      selectedColor: Colors.green.shade100,
                      onSelected: (selected) {
                        setState(() => filterStatus = selected ? AttendanceStatus.present : null);
                      },
                    ),
                    FilterChip(
                      label: const Text('Late'),
                      selected: filterStatus == AttendanceStatus.late,
                      selectedColor: Colors.orange.shade100,
                      onSelected: (selected) {
                        setState(() => filterStatus = selected ? AttendanceStatus.late : null);
                      },
                    ),
                    FilterChip(
                      label: const Text('Absent'),
                      selected: filterStatus == AttendanceStatus.absent,
                      selectedColor: Colors.red.shade100,
                      onSelected: (selected) {
                        setState(() => filterStatus = selected ? AttendanceStatus.absent : null);
                      },
                    ),
                    FilterChip(
                      label: const Text('Excused'),
                      selected: filterStatus == AttendanceStatus.excused,
                      selectedColor: Colors.blue.shade100,
                      onSelected: (selected) {
                        setState(() => filterStatus = selected ? AttendanceStatus.excused : null);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Results
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: attendanceRecordsNotifier,
              builder: (context, records, child) {
                var filteredRecords = records;

                // Apply filters
                if (filterEventId != null) {
                  filteredRecords = filteredRecords.where((r) => r.eventId == filterEventId).toList();
                }
                if (filterStatus != null) {
                  filteredRecords = filteredRecords.where((r) => r.status == filterStatus).toList();
                }

                filteredRecords.sort((a, b) => b.timestamp.compareTo(a.timestamp));

                if (filteredRecords.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'No records found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          filterEventId != null || filterStatus != null
                              ? 'Try different filters'
                              : 'Students haven\'t checked in yet',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredRecords.length,
                  itemBuilder: (context, index) {
                    final record = filteredRecords[index];
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
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getStatusColor(record.status).withOpacity(0.2),
                          child: Icon(
                            _getStatusIcon(record.status),
                            color: _getStatusColor(record.status),
                          ),
                        ),
                        title: Text(
                          record.studentName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.title),
                            Text(
                              'Logged: ${record.timestamp.hour}:${record.timestamp.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(record.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _getStatusColor(record.status),
                            ),
                          ),
                          child: Text(
                            record.status.toString().split('.').last.toUpperCase(),
                            style: TextStyle(
                              color: _getStatusColor(record.status),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        onTap: () => _showRecordDetails(context, record, event),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showManualOverride(context),
        icon: const Icon(Icons.edit),
        label: const Text('Manual Override'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showRecordDetails(BuildContext context, AttendanceRecord record, AttendanceEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(record.studentName),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Event', event.title),
              _buildDetailRow('Status', record.status.toString().split('.').last.toUpperCase()),
              _buildDetailRow('Time', '${record.timestamp.hour}:${record.timestamp.minute.toString().padLeft(2, '0')}'),
              _buildDetailRow('Date', '${record.timestamp.day}/${record.timestamp.month}/${record.timestamp.year}'),
              if (record.remarks != null && record.remarks!.isNotEmpty) ...[
                const Divider(),
                _buildDetailRow('Remarks', record.remarks!),
              ],
              if (record.documents.isNotEmpty) ...[
                const Divider(),
                const Text('Documents:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...record.documents.map((doc) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Icon(Icons.attach_file, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Expanded(child: Text(doc.fileName, style: const TextStyle(fontSize: 13))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getDocStatusColor(doc.status),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              doc.status.toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    )),
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

  void _showManualOverride(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('⚠️ Manual override logs all changes for audit trail'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Manual Override'),
          ],
        ),
        content: const Text(
          'This feature allows you to manually adjust attendance records.\n\n'
          'Note: All overrides are logged for audit purposes.\n\n'
          'Select a student and event to modify their attendance.',
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
                const SnackBar(
                  content: Text('Feature coming soon! 🔧'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
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