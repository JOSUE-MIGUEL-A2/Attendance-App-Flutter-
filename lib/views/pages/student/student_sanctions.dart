import 'package:flutter/material.dart';
import 'package:thesis_attendance/data/notifiers.dart';

class StudentSanctions extends StatelessWidget {
  const StudentSanctions({super.key});

  @override
  Widget build(BuildContext context) {
    final user = currentUserNotifier.value!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sanctions'),
      ),
      body: ValueListenableBuilder(
        valueListenable: sanctionsNotifier,
        builder: (context, sanctions, child) {
          final userSanctions = sanctions.where((s) => s.studentId == user.id).toList();
          userSanctions.sort((a, b) => b.issuedDate.compareTo(a.issuedDate));

          final activeSanctions = userSanctions.where((s) => s.status == 'active').toList();
          final resolvedSanctions = userSanctions.where((s) => s.status == 'resolved').toList();

          if (userSanctions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 80, color: Colors.green.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'No sanctions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Keep up the good work!',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (activeSanctions.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Active Sanctions',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${activeSanctions.length} pending action${activeSanctions.length > 1 ? 's' : ''}',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Active Sanctions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...activeSanctions.map((sanction) => _buildSanctionCard(sanction, true)),
                  const SizedBox(height: 24),
                ],
                if (resolvedSanctions.isNotEmpty) ...[
                  const Text(
                    'Resolved Sanctions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...resolvedSanctions.map((sanction) => _buildSanctionCard(sanction, false)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSanctionCard(Sanction sanction, bool isActive) {
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
                    color: color.withOpacity(0.1),
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
                        sanction.type.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        'Issued: ${sanction.issuedDate.day}/${sanction.issuedDate.month}/${sanction.issuedDate.year}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isActive ? Colors.red : Colors.green),
                  ),
                  child: Text(
                    isActive ? 'ACTIVE' : 'RESOLVED',
                    style: TextStyle(
                      color: isActive ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(Icons.info, 'Reason', sanction.reason),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.task, 'Required Action', sanction.requiredAction),
            if (!isActive && sanction.resolvedDate != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.check_circle,
                'Resolved On',
                '${sanction.resolvedDate!.day}/${sanction.resolvedDate!.month}/${sanction.resolvedDate!.year}',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
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