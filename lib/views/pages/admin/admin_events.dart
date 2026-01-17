import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesis_attendance/models/student_model.dart';
import 'package:thesis_attendance/services/data_provider.dart';

class AdminEvents extends StatefulWidget {
  const AdminEvents({super.key});

  @override
  State<AdminEvents> createState() => _AdminEventsState();
}

class _AdminEventsState extends State<AdminEvents> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Active', 'Upcoming', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, provider, child) {
        // Filter events
        List<Event> filteredEvents;
        if (_selectedFilter == 'All') {
          filteredEvents = provider.events;
        } else {
          filteredEvents = provider.events
              .where((e) => e.status.toLowerCase() == _selectedFilter.toLowerCase())
              .toList();
        }

        return Column(
          children: [
            // Header with Create Button
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Event Management',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showCreateEventDialog(),
                        icon: const Icon(Icons.add),
                        label: const Text('Create Event'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Filters
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            selectedColor: Theme.of(context).colorScheme.primary,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : null,
                              fontWeight: isSelected ? FontWeight.bold : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Events List
            Expanded(
              child: filteredEvents.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No ${_selectedFilter.toLowerCase()} events',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _showCreateEventDialog(),
                            icon: const Icon(Icons.add),
                            label: const Text('Create New Event'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _EventManagementCard(
                            event: event,
                            onViewAttendance: () => _showAttendanceDialog(event),
                            onEdit: () => _showEditEventDialog(event),
                            onDelete: () => _handleDeleteEvent(event),
                            onStart: () => _handleStartEvent(event),
                            onEnd: () => _handleEndEvent(event),
                            onSendReminder: () => _handleSendReminder(event),
                            onViewReport: () => _showEventReport(event),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  void _showCreateEventDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final startTimeController = TextEditingController(text: '7:00 AM');
    final endTimeController = TextEditingController(text: '8:00 AM');
    final lateCutoffController = TextEditingController(text: '7:45 AM');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Event Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: startTimeController,
                decoration: InputDecoration(
                  labelText: 'Start Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: endTimeController,
                decoration: InputDecoration(
                  labelText: 'End Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lateCutoffController,
                decoration: InputDecoration(
                  labelText: 'Late Cutoff Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.schedule),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter event title'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Event "${titleController.text}" created successfully'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Create Event'),
          ),
        ],
      ),
    );
  }

  void _showAttendanceDialog(Event event) {
    final provider = Provider.of<DataProvider>(context, listen: false);
    final attendanceRecords = provider.attendanceRecords
        .where((r) => r.eventId == event.id)
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${event.title} - Attendance'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _AttendanceStat('Present', attendanceRecords.where((r) => r.status == 'present').length, Colors.green),
                  _AttendanceStat('Late', attendanceRecords.where((r) => r.status == 'late').length, Colors.orange),
                  _AttendanceStat('Absent', event.totalStudents - attendanceRecords.length, Colors.red),
                ],
              ),
              const Divider(height: 24),
              // List
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: attendanceRecords.length,
                  itemBuilder: (context, index) {
                    final record = attendanceRecords[index];
                    final student = provider.students.firstWhere(
                      (s) => s.studentId == record.studentId,
                      orElse: () => Student(
                        id: '',
                        studentId: record.studentId,
                        name: 'Unknown Student',
                        email: '',
                        phone: '',
                        address: '',
                        program: '',
                        yearLevel: '',
                        section: '',
                        department: '',
                        status: '',
                        gpa: 0,
                        totalUnits: 0,
                        emergencyContactName: '',
                        emergencyContactNumber: '',
                      ),
                    );

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: record.status == 'present' 
                            ? Colors.green.withOpacity(0.2) 
                            : Colors.orange.withOpacity(0.2),
                        child: Icon(
                          record.status == 'present' ? Icons.check : Icons.schedule,
                          color: record.status == 'present' ? Colors.green : Colors.orange,
                          size: 20,
                        ),
                      ),
                      title: Text(student.name),
                      subtitle: Text(record.studentId),
                      trailing: Text(
                        record.checkInTime != null
                            ? '${record.checkInTime!.hour}:${record.checkInTime!.minute.toString().padLeft(2, '0')}'
                            : '-',
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exporting attendance data...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showEditEventDialog(Event event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit event: ${event.title}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleDeleteEvent(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
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
                  content: Text('Event "${event.title}" deleted'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleStartEvent(Event event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting event: ${event.title}'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleEndEvent(Event event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ending event: ${event.title}'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleSendReminder(Event event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sending reminder for: ${event.title}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showEventReport(Event event) {
    final provider = Provider.of<DataProvider>(context, listen: false);
    final attendanceRecords = provider.attendanceRecords
        .where((r) => r.eventId == event.id)
        .toList();

    final present = attendanceRecords.where((r) => r.status == 'present').length;
    final late = attendanceRecords.where((r) => r.status == 'late').length;
    final absent = event.totalStudents - attendanceRecords.length;
    final rate = attendanceRecords.isNotEmpty 
        ? (attendanceRecords.length / event.totalStudents * 100).toStringAsFixed(1)
        : '0.0';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${event.title} - Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ReportRow('Event:', event.title),
            _ReportRow('Date:', _formatDate(event.date)),
            _ReportRow('Time:', '${event.startTime} - ${event.endTime}'),
            const Divider(height: 24),
            _ReportRow('Total Students:', event.totalStudents.toString()),
            _ReportRow('Present:', '$present (${present > 0 ? (present / event.totalStudents * 100).toStringAsFixed(1) : '0.0'}%)'),
            _ReportRow('Late:', '$late (${late > 0 ? (late / event.totalStudents * 100).toStringAsFixed(1) : '0.0'}%)'),
            _ReportRow('Absent:', '$absent (${absent > 0 ? (absent / event.totalStudents * 100).toStringAsFixed(1) : '0.0'}%)'),
            const Divider(height: 24),
            _ReportRow('Attendance Rate:', '$rate%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Downloading report...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Download'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _AttendanceStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _AttendanceStat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _ReportRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReportRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

// Keep the _EventManagementCard from the original file...
class _EventManagementCard extends StatelessWidget {
  final Event event;
  final VoidCallback onViewAttendance;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onStart;
  final VoidCallback onEnd;
  final VoidCallback onSendReminder;
  final VoidCallback onViewReport;

  const _EventManagementCard({
    required this.event,
    required this.onViewAttendance,
    required this.onEdit,
    required this.onDelete,
    required this.onStart,
    required this.onEnd,
    required this.onSendReminder,
    required this.onViewReport,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (event.status) {
      case 'active':
        statusColor = Colors.green;
        statusText = 'ACTIVE';
        statusIcon = Icons.play_circle;
        break;
      case 'upcoming':
        statusColor = Colors.blue;
        statusText = 'UPCOMING';
        statusIcon = Icons.upcoming;
        break;
      case 'completed':
        statusColor = Colors.grey;
        statusText = 'COMPLETED';
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'UNKNOWN';
        statusIcon = Icons.help;
    }

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.event,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatDate(event.date),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
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
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              event.description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 12),

            // Time Info
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  '${event.startTime} - ${event.endTime}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.schedule, size: 16, color: Colors.orange.shade700),
                const SizedBox(width: 4),
                Text(
                  'Late after ${event.lateCutoff}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            // Statistics
            if (event.status == 'active' || event.status == 'completed') ...[
              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      label: 'Present',
                      value: event.checkedIn ?? 0,
                      total: event.totalStudents,
                      color: Colors.green,
                      icon: Icons.check_circle,
                    ),
                  ),
                  Expanded(
                    child: _StatItem(
                      label: 'Late',
                      value: event.late ?? 0,
                      total: event.totalStudents,
                      color: Colors.orange,
                      icon: Icons.schedule,
                    ),
                  ),
                  Expanded(
                    child: _StatItem(
                      label: 'Absent',
                      value: event.absent ?? 0,
                      total: event.totalStudents,
                      color: Colors.red,
                      icon: Icons.cancel,
                    ),
                  ),
                ],
              ),
            ],

            const Divider(height: 24),

            // Action Buttons
            if (event.status == 'active') ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onViewAttendance,
                      icon: const Icon(Icons.people, size: 16),
                      label: const Text('Attendance'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onEnd,
                      icon: const Icon(Icons.stop, size: 16),
                      label: const Text('End Event'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (event.status == 'upcoming') ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onSendReminder,
                      icon: const Icon(Icons.notifications, size: 16),
                      label: const Text('Remind'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onStart,
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: const Text('Start'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onViewReport,
                      icon: const Icon(Icons.assessment, size: 16),
                      label: const Text('Report'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onViewAttendance,
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('Export'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.total,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (value / total * 100).toStringAsFixed(0) : '0';

    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 20,
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
        Text(
          '$percentage%',
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}