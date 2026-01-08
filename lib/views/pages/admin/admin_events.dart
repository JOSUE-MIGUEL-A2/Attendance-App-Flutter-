import 'package:flutter/material.dart';
import 'package:thesis_attendance/data/notifiers.dart';

class AdminEvents extends StatelessWidget {
  const AdminEvents({super.key});

  void _createEvent(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 10, minute: 0);
    TimeOfDay lateCutoff = const TimeOfDay(hour: 8, minute: 15);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.add_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Create New Event'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Event Title',
                    prefixIcon: Icon(Icons.title),
                    hintText: 'e.g., Morning Assembly',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                    hintText: 'What\'s this event about?',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Date'),
                  subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                  trailing: const Icon(Icons.edit, size: 20),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() => selectedDate = picked);
                    }
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text('Start Time'),
                  subtitle: Text(formatTime(startTime)),
                  trailing: const Icon(Icons.edit, size: 20),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: startTime,
                    );
                    if (picked != null) {
                      setState(() => startTime = picked);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: const Text('End Time'),
                  subtitle: Text(formatTime(endTime)),
                  trailing: const Icon(Icons.edit, size: 20),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: endTime,
                    );
                    if (picked != null) {
                      setState(() => endTime = picked);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.schedule, color: Colors.orange),
                  title: const Text('Late Cutoff'),
                  subtitle: Text(formatTime(lateCutoff)),
                  trailing: const Icon(Icons.edit, size: 20),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: lateCutoff,
                    );
                    if (picked != null) {
                      setState(() => lateCutoff = picked);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Event needs a name, captain!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                final newEvent = AttendanceEvent(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  description: descController.text,
                  date: selectedDate,
                  startTime: startTime,
                  endTime: endTime,
                  lateCutoff: lateCutoff,
                  createdBy: currentUserNotifier.value!.id,
                  isActive: true,
                );

                eventsNotifier.value = [...eventsNotifier.value, newEvent];

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ "${titleController.text}" created successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.check),
              label: const Text('Create Event'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editEvent(BuildContext context, AttendanceEvent event) {
    final titleController = TextEditingController(text: event.title);
    final descController = TextEditingController(text: event.description);
    DateTime selectedDate = event.date;
    TimeOfDay startTime = event.startTime;
    TimeOfDay endTime = event.endTime;
    TimeOfDay lateCutoff = event.lateCutoff;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.edit, color: Colors.blue),
              SizedBox(width: 8),
              Text('Edit Event'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Event Title',
                    prefixIcon: Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Date'),
                  subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                  trailing: const Icon(Icons.edit, size: 20),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) setState(() => selectedDate = picked);
                  },
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
                final events = eventsNotifier.value;
                final index = events.indexWhere((e) => e.id == event.id);
                if (index != -1) {
                  events[index] = AttendanceEvent(
                    id: event.id,
                    title: titleController.text,
                    description: descController.text,
                    date: selectedDate,
                    startTime: startTime,
                    endTime: endTime,
                    lateCutoff: lateCutoff,
                    createdBy: event.createdBy,
                    isActive: event.isActive,
                  );
                  eventsNotifier.value = [...events];
                }

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Event updated! ✏️'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteEvent(BuildContext context, AttendanceEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Event?'),
          ],
        ),
        content: Text('Are you sure you want to delete "${event.title}"? This action cannot be undone!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep It'),
          ),
          ElevatedButton(
            onPressed: () {
              eventsNotifier.value = eventsNotifier.value
                  .where((e) => e.id != event.id)
                  .toList();
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🗑️ "${event.title}" deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Management'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: eventsNotifier,
        builder: (context, events, child) {
          if (events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_note, size: 100, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'No events yet!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to create your first event',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }

          // Sort: Today first, then upcoming, then past
          final sortedEvents = events.toList()..sort((a, b) {
            if (a.isToday && !b.isToday) return -1;
            if (!a.isToday && b.isToday) return 1;
            return a.date.compareTo(b.date);
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedEvents.length,
            itemBuilder: (context, index) {
              final event = sortedEvents[index];
              final isPast = event.date.isBefore(DateTime.now()) && !event.isToday;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: !event.isActive ? Colors.grey.shade100 : null,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: event.isToday
                                  ? Colors.green.shade100
                                  : isPast
                                      ? Colors.grey.shade200
                                      : Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              event.isToday ? Icons.today : Icons.event,
                              color: event.isToday
                                  ? Colors.green.shade700
                                  : isPast
                                      ? Colors.grey.shade600
                                      : Colors.blue.shade700,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        event.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (event.isToday)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'TODAY',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    if (isPast && event.isActive)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'PAST',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    if (!event.isActive)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'CANCELLED',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  event.description,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '${event.date.day}/${event.date.month}/${event.date.year}',
                            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '${formatTime(event.startTime)} - ${formatTime(event.endTime)}',
                            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 16, color: Colors.orange.shade600),
                          const SizedBox(width: 4),
                          Text(
                            'Late after ${formatTime(event.lateCutoff)}',
                            style: TextStyle(color: Colors.orange.shade700, fontSize: 13),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _editEvent(context, event),
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('Edit'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              final events = eventsNotifier.value;
                              final index = events.indexWhere((e) => e.id == event.id);
                              if (index != -1) {
                                events[index].isActive = !events[index].isActive;
                                eventsNotifier.value = [...events];
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(events[index].isActive
                                        ? 'Event reactivated 🔄'
                                        : 'Event deactivated ⏸️'),
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                              event.isActive ? Icons.pause : Icons.play_arrow,
                              size: 18,
                            ),
                            label: Text(event.isActive ? 'Deactivate' : 'Activate'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: event.isActive ? Colors.orange : Colors.green,
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => _deleteEvent(context, event),
                            icon: const Icon(Icons.delete, size: 18),
                            label: const Text('Delete'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createEvent(context),
        icon: const Icon(Icons.add),
        label: const Text('Create Event'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }
}