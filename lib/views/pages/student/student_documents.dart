import 'package:flutter/material.dart';
import 'package:thesis_attendance/data/notifiers.dart';

class StudentDocuments extends StatelessWidget {
  const StudentDocuments({super.key});

  void _submitDocument(BuildContext context, AttendanceRecord record) {
    final TextEditingController remarksController = TextEditingController(
      text: record.remarks ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Excuse Document'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Event: ${eventsNotifier.value.firstWhere((e) => e.id == record.eventId, orElse: () => AttendanceEvent(id: '', title: 'Unknown', description: '', date: DateTime.now(), startTime: const TimeOfDay(hour: 0, minute: 0), endTime: const TimeOfDay(hour: 0, minute: 0), lateCutoff: const TimeOfDay(hour: 0, minute: 0), createdBy: '')).title}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: remarksController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Remarks/Reason',
                  hintText: 'Explain your absence or tardiness...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  // Simulate file picker
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('File picker would open here (add file_picker package)'),
                    ),
                  );
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Attach Document (PDF/Image)'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Accepted formats: PDF, JPG, PNG',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
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
              if (remarksController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide remarks'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              // Create document
              final newDoc = AttendanceDocument(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                fileName: 'excuse_letter_${DateTime.now().millisecondsSinceEpoch}.pdf',
                fileType: 'pdf',
                uploadedAt: DateTime.now(),
                status: 'pending',
              );

              // Update record
              final records = attendanceRecordsNotifier.value;
              final index = records.indexWhere((r) => r.id == record.id);
              if (index != -1) {
                records[index].remarks = remarksController.text;
                records[index].documents = [...records[index].documents, newDoc];
                attendanceRecordsNotifier.value = [...records];
              }

              // Add notification
              notificationsNotifier.value = [
                ...notificationsNotifier.value,
                AppNotification(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: 'Document Submitted',
                  message: 'Your excuse document has been submitted for review',
                  timestamp: DateTime.now(),
                  type: 'approval',
                ),
              ];

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Document submitted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = currentUserNotifier.value!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents & Remarks'),
      ),
      body: ValueListenableBuilder(
        valueListenable: attendanceRecordsNotifier,
        builder: (context, records, child) {
          final userRecords = records.where((r) => 
            r.studentId == user.id && 
            (r.status == AttendanceStatus.late || 
             r.status == AttendanceStatus.absent ||
             r.documents.isNotEmpty)
          ).toList();

          userRecords.sort((a, b) => b.timestamp.compareTo(a.timestamp));

          if (userRecords.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No documents to submit',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Documents are required for late or absent attendance',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
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

              final canSubmit = record.canSubmitDocument && record.documents.isEmpty;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
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
                              color: _getStatusColor(record.status).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getStatusIcon(record.status),
                              color: _getStatusColor(record.status),
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
                      
                      if (record.remarks != null && record.remarks!.isNotEmpty) ...[
                        const Divider(height: 24),
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
                                    'Your Remarks',
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
                        const Divider(height: 24),
                        const Text(
                          'Submitted Documents',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...record.documents.map((doc) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getDocStatusColor(doc.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _getDocStatusColor(doc.status)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.attach_file,
                                  color: _getDocStatusColor(doc.status),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doc.fileName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        'Uploaded: ${doc.uploadedAt.day}/${doc.uploadedAt.month}/${doc.uploadedAt.year}',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getDocStatusColor(doc.status),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    doc.status.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        if (record.documents.any((d) => d.adminComment != null))
                          ...record.documents
                              .where((d) => d.adminComment != null)
                              .map((doc) {
                            return Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.admin_panel_settings, 
                                          size: 16, color: Colors.grey.shade700),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Admin Comment',
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    doc.adminComment!,
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],

                      if (canSubmit) ...[
                        const Divider(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _submitDocument(context, record),
                            icon: const Icon(Icons.upload_file),
                            label: const Text('SUBMIT EXCUSE DOCUMENT'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
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

  Widget _buildStatusBadge(AttendanceStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getStatusColor(status)),
      ),
      child: Text(
        status.toString().split('.').last.toUpperCase(),
        style: TextStyle(
          color: _getStatusColor(status),
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