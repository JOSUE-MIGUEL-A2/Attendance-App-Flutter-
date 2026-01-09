import 'package:flutter/material.dart';
import 'package:thesis_attendance/data/notifiers.dart';

class AdminSanctions extends StatelessWidget {
  const AdminSanctions({super.key});

  void _issueSanction(BuildContext context) {
    final reasonController = TextEditingController();
    final actionController = TextEditingController();
    String? selectedStudentId;
    String sanctionType = 'warning';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Text('Issue Sanction'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Select Student
                ValueListenableBuilder(
                  valueListenable: attendanceRecordsNotifier,
                  builder: (context, records, child) {
                    final students = records.map((r) => {
                          'id': r.studentId,
                          'name': r.studentName,
                        }).toSet().toList();

                    return DropdownButtonFormField<String>(
                      initialValue: selectedStudentId,
                      decoration: const InputDecoration(
                        labelText: 'Select Student',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      items: students.map((student) {
                        return DropdownMenuItem(
                          value: student['id'],
                          child: Text(student['name']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedStudentId = value);
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                
                // Sanction Type
                DropdownButtonFormField<String>(
                  initialValue: sanctionType,
                  decoration: const InputDecoration(
                    labelText: 'Sanction Type',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'warning', child: Text('⚠️ Warning')),
                    DropdownMenuItem(value: 'penalty', child: Text('🚫 Penalty')),
                  ],
                  onChanged: (value) {
                    setState(() => sanctionType = value!);
                  },
                ),
                const SizedBox(height: 16),
                
                TextField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Reason',
                    hintText: 'e.g., 3 consecutive absences without excuse',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                
                TextField(
                  controller: actionController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Required Action',
                    hintText: 'e.g., Submit excuse letter to dean',
                    border: OutlineInputBorder(),
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
                if (selectedStudentId == null ||
                    reasonController.text.isEmpty ||
                    actionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fill in all fields!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                final studentRecord = attendanceRecordsNotifier.value
                    .firstWhere((r) => r.studentId == selectedStudentId);

                final newSanction = Sanction(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  studentId: selectedStudentId!,
                  studentName: studentRecord.studentName,
                  type: sanctionType,
                  reason: reasonController.text,
                  requiredAction: actionController.text,
                  issuedDate: DateTime.now(),
                  status: 'active',
                );

                sanctionsNotifier.value = [...sanctionsNotifier.value, newSanction];

                // Notify student
                notificationsNotifier.value = [
                  ...notificationsNotifier.value,
                  AppNotification(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: '⚠️ Sanction Issued',
                    message: '${sanctionType == 'warning' ? 'Warning' : 'Penalty'}: ${reasonController.text}',
                    timestamp: DateTime.now(),
                    type: 'sanction',
                  ),
                ];

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sanction issued to ${studentRecord.studentName}'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              icon: const Icon(Icons.gavel),
              label: const Text('Issue Sanction'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resolveSanction(BuildContext context, Sanction sanction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Resolve Sanction'),
          ],
        ),
        content: Text('Mark this sanction as resolved for ${sanction.studentName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final sanctions = sanctionsNotifier.value;
              final index = sanctions.indexWhere((s) => s.id == sanction.id);
              if (index != -1) {
                sanctions[index].status = 'resolved';
                sanctions[index].resolvedDate = DateTime.now();
                sanctionsNotifier.value = [...sanctions];
              }

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Sanction resolved!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Resolve'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sanction Management'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: sanctionsNotifier,
        builder: (context, sanctions, child) {
          final activeSanctions = sanctions.where((s) => s.status == 'active').toList();
          final resolvedSanctions = sanctions.where((s) => s.status == 'resolved').toList();

          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Material(
                  color: Colors.purple.shade50,
                  child: TabBar(
                    labelColor: Colors.purple.shade700,
                    tabs: [
                      Tab(
                        text: 'Active (${activeSanctions.length})',
                        icon: const Icon(Icons.warning),
                      ),
                      Tab(
                        text: 'Resolved (${resolvedSanctions.length})',
                        icon: const Icon(Icons.check_circle),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildSanctionList(context, activeSanctions, true),
                      _buildSanctionList(context, resolvedSanctions, false),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _issueSanction(context),
        icon: const Icon(Icons.add),
        label: const Text('Issue Sanction'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSanctionList(BuildContext context, List<Sanction> sanctions, bool isActive) {
    if (sanctions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.check_circle : Icons.archive,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              isActive ? 'No active sanctions! 🎉' : 'No resolved sanctions yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    sanctions.sort((a, b) => b.issuedDate.compareTo(a.issuedDate));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sanctions.length,
      itemBuilder: (context, index) {
        final sanction = sanctions[index];
        final color = isActive ? Colors.red : Colors.grey;

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
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        sanction.type == 'warning' ? Icons.warning : Icons.block,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sanction.studentName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            sanction.type.toUpperCase(),
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'ACTIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'RESOLVED',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
                const Divider(height: 24),
                _buildInfoRow('Reason', sanction.reason),
                const SizedBox(height: 8),
                _buildInfoRow('Required Action', sanction.requiredAction),
                const SizedBox(height: 8),
                _buildInfoRow(
                  'Issued Date',
                  '${sanction.issuedDate.day}/${sanction.issuedDate.month}/${sanction.issuedDate.year}',
                ),
                if (!isActive && sanction.resolvedDate != null) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Resolved Date',
                    '${sanction.resolvedDate!.day}/${sanction.resolvedDate!.month}/${sanction.resolvedDate!.year}',
                  ),
                ],
                if (isActive) ...[
                  const Divider(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _resolveSanction(context, sanction),
                      icon: const Icon(Icons.check),
                      label: const Text('Mark as Resolved'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
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
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
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
    );
  }
}