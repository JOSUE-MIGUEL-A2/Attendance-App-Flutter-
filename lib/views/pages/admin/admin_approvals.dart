import 'package:flutter/material.dart';
import 'package:thesis_attendance/data/notifiers.dart';

class AdminApprovals extends StatelessWidget {
  const AdminApprovals({super.key});

  void _handleApproval(
    BuildContext context,
    AttendanceRecord record,
    AttendanceDocument doc,
    bool approve,
  ) {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              approve ? Icons.check_circle : Icons.cancel,
              color: approve ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(approve ? 'Approve Document' : 'Reject Document'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Student', record.studentName),
              _buildInfoRow('File', doc.fileName),
              if (record.remarks != null && record.remarks!.isNotEmpty)
                _buildInfoRow('Student Remarks', record.remarks!),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: approve
                      ? 'Approval Note (Optional)'
                      : 'Reason for Rejection',
                  hintText: approve
                      ? 'e.g., Valid excuse accepted'
                      : 'e.g., Insufficient documentation',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (approve ? Colors.green : Colors.red),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: approve ? Colors.green : Colors.red,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: approve ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        approve
                            ? 'Student will be marked as excused'
                            : 'Student remains absent/late',
                        style: TextStyle(
                          fontSize: 12,
                          color: approve
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                    ),
                  ],
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
          ElevatedButton.icon(
            onPressed: () {
              if (!approve && commentController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide a reason for rejection'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              final records = attendanceRecordsNotifier.value;
              final recordIndex = records.indexWhere((r) => r.id == record.id);

              if (recordIndex != -1) {
                final docIndex = records[recordIndex].documents.indexWhere(
                  (d) => d.id == doc.id,
                );

                if (docIndex != -1) {
                  records[recordIndex].documents[docIndex].status = approve
                      ? 'approved'
                      : 'rejected';
                  records[recordIndex].documents[docIndex].adminComment =
                      commentController.text;

                  if (approve &&
                      (records[recordIndex].status == AttendanceStatus.absent ||
                          records[recordIndex].status ==
                              AttendanceStatus.late)) {
                    records[recordIndex].status = AttendanceStatus.excused;
                  }

                  attendanceRecordsNotifier.value = [...records];
                }
              }

              notificationsNotifier.value = [
                ...notificationsNotifier.value,
                AppNotification(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: approve ? ' Document Approved' : ' Document Rejected',
                  message: approve
                      ? 'Your excuse has been accepted${commentController.text.isNotEmpty ? ': ${commentController.text}' : ''}'
                      : 'Your excuse was rejected: ${commentController.text}',
                  timestamp: DateTime.now(),
                  type: 'approval',
                ),
              ];

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    approve ? ' Document approved!' : ' Document rejected',
                  ),
                  backgroundColor: approve ? Colors.green : Colors.red,
                ),
              );
            },
            icon: Icon(approve ? Icons.check : Icons.close),
            label: Text(approve ? 'Approve' : 'Reject'),
            style: ElevatedButton.styleFrom(
              backgroundColor: approve ? Colors.green : Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Approvals'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: attendanceRecordsNotifier,
        builder: (context, records, child) {
          final pendingRecords = records
              .where((r) => r.documents.any((d) => d.status == 'pending'))
              .toList();

          pendingRecords.sort((a, b) => b.timestamp.compareTo(a.timestamp));

          if (pendingRecords.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 100, color: Colors.green.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'All caught up! ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No pending approvals',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    ' Time for a coffee break!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pendingRecords.length,
            itemBuilder: (context, index) {
              final record = pendingRecords[index];
              final pendingDocs = record.documents
                  .where((d) => d.status == 'pending')
                  .toList();
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
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: Text(
                      record.studentName[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    record.studentName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Event: ${event.title}'),
                      Text(
                        '${pendingDocs.length} document(s) pending',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    const Divider(height: 1),
                    if (record.remarks != null && record.remarks!.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        color: Colors.blue.shade50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.note,
                                  size: 16,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Student Remarks',
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
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ...pendingDocs.map((doc) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.attach_file,
                                    color: Colors.purple.shade700,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doc.fileName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Uploaded: ${doc.uploadedAt.day}/${doc.uploadedAt.month}/${doc.uploadedAt.year} at ${doc.uploadedAt.hour}:${doc.uploadedAt.minute.toString().padLeft(2, '0')}',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () => _handleApproval(
                                    context,
                                    record,
                                    doc,
                                    false,
                                  ),
                                  icon: const Icon(Icons.close, size: 18),
                                  label: const Text('Reject'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: () => _handleApproval(
                                    context,
                                    record,
                                    doc,
                                    true,
                                  ),
                                  icon: const Icon(Icons.check, size: 18),
                                  label: const Text('Approve'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
