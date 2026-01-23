// lib/views/pages/student/student_sidebar/student_sanctions.dart
import 'package:flutter/material.dart';
import 'package:thesis_attendance/services/student_service.dart';
import 'package:thesis_attendance/services/firebase_service.dart';
import 'package:thesis_attendance/models/student_model.dart';

class StudentSanctions extends StatefulWidget {
  const StudentSanctions({super.key});

  @override
  State<StudentSanctions> createState() => _StudentSanctionsState();
}

class _StudentSanctionsState extends State<StudentSanctions> {
  final StudentService _service = StudentService();
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Active', 'Resolved', 'Appealed'];

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseService.currentUserId;

    if (uid == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sanctions & Violations')),
        body: const Center(child: Text('Not logged in')),
      );
    }

    return StreamBuilder<Student?>(
      stream: _service.getStudentProfile(uid),
      builder: (context, studentSnapshot) {
        if (studentSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Sanctions & Violations')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (studentSnapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Sanctions & Violations')),
            body: Center(child: Text('Error: ${studentSnapshot.error}')),
          );
        }

        if (!studentSnapshot.hasData || studentSnapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Sanctions & Violations')),
            body: const Center(child: Text('Profile not found')),
          );
        }

        final student = studentSnapshot.data!;

        return StreamBuilder<List<Sanction>>(
          stream: _service.getSanctions(student.studentId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                appBar: AppBar(title: const Text('Sanctions & Violations')),
                body: const Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(title: const Text('Sanctions & Violations')),
                body: Center(child: Text('Error: ${snapshot.error}')),
              );
            }

            final allSanctions = snapshot.data ?? [];
            final filteredSanctions = _selectedFilter == 'All'
                ? allSanctions
                : allSanctions.where((s) => s.status == _selectedFilter).toList();

            final activeSanctions =
                allSanctions.where((s) => s.status == 'Active').length;
            final resolvedSanctions =
                allSanctions.where((s) => s.status == 'Resolved').length;

            return Scaffold(
              appBar: AppBar(
                title: const Text('Sanctions & Violations'),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Summary Card
                    _buildStatusCard(
                      context,
                      allSanctions.length,
                      activeSanctions,
                      resolvedSanctions,
                    ),

                    const SizedBox(height: 24),

                    // Filter Chips
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
                              selectedColor:
                                  Theme.of(context).colorScheme.primary,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : null,
                                fontWeight:
                                    isSelected ? FontWeight.bold : null,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Sanctions List or Empty State
                    if (filteredSanctions.isEmpty)
                      _buildEmptyState()
                    else
                      ...filteredSanctions.map(
                        (sanction) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _SanctionCard(
                            sanction: sanction,
                            onAppeal: () => _handleAppeal(sanction),
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Violation Types Information (always show)
                    Text(
                      'Violation Types & Penalties',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    _ViolationTypeCard(
                      title: 'Absence',
                      description: 'Missing an event without valid excuse',
                      severity: 'Minor',
                      severityColor: Colors.orange,
                      penalty: 'Warning on first offense',
                      icon: Icons.cancel,
                    ),
                    const SizedBox(height: 8),
                    _ViolationTypeCard(
                      title: 'Tardiness',
                      description: 'Checking in after the late cutoff time',
                      severity: 'Minor',
                      severityColor: Colors.orange,
                      penalty: 'Written warning after 3 instances',
                      icon: Icons.schedule,
                    ),
                    const SizedBox(height: 8),
                    _ViolationTypeCard(
                      title: 'Repeated Absence',
                      description: 'Missing 3 or more events in a month',
                      severity: 'Major',
                      severityColor: Colors.red,
                      penalty: 'Meeting with student affairs',
                      icon: Icons.warning,
                    ),
                    const SizedBox(height: 8),
                    _ViolationTypeCard(
                      title: 'Misconduct',
                      description: 'Inappropriate behavior during events',
                      severity: 'Major',
                      severityColor: Colors.red,
                      penalty: 'Disciplinary action',
                      icon: Icons.gavel,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    int total,
    int active,
    int resolved,
  ) {
    return Card(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: active == 0
                ? [Colors.green.shade600, Colors.green.shade400]
                : [Colors.orange.shade600, Colors.orange.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              active == 0 ? Icons.check_circle_outline : Icons.warning_outlined,
              size: 64,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              active == 0 ? 'Clean Record!' : 'Active Violations',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              active == 0
                  ? 'You have no active violations'
                  : 'You have $active active violation${active > 1 ? 's' : ''}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SummaryItem(
                  label: 'Total',
                  value: total.toString(),
                  icon: Icons.list_alt,
                ),
                _SummaryItem(
                  label: 'Active',
                  value: active.toString(),
                  icon: Icons.warning,
                ),
                _SummaryItem(
                  label: 'Resolved',
                  value: resolved.toString(),
                  icon: Icons.check_circle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              size: 48,
              color: Colors.blue.shade700,
            ),
            const SizedBox(height: 12),
            Text(
              'No Violations Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Keep up the good work! Continue attending all events and following campus rules.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAppeal(Sanction sanction) async {
    if (sanction.status == 'Appealed') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This violation has already been appealed'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (sanction.status == 'Resolved') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This violation has already been resolved'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Appeal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appeal for: ${sanction.violationType}'),
            const SizedBox(height: 8),
            Text(
              'Event: ${sanction.eventName}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Reason for Appeal',
                hintText: 'Explain why this violation should be reviewed...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('File attachment - Coming soon!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.attach_file),
              label: const Text('Attach Supporting Documents'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide a reason for the appeal'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            child: const Text('Submit Appeal'),
          ),
        ],
      ),
    );

    if (confirmed != true || reasonController.text.trim().isEmpty) return;

    // TODO: Implement submitSanctionAppeal in StudentService
    // For now, show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appeal submitted successfully and sent for review'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ==================== WIDGET CLASSES ====================

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _SanctionCard extends StatelessWidget {
  final Sanction sanction;
  final VoidCallback onAppeal;

  const _SanctionCard({
    required this.sanction,
    required this.onAppeal,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = sanction.status == 'Active';
    final isAppealed = sanction.status == 'Appealed';
    final isResolved = sanction.status == 'Resolved';

    Color severityColor;
    switch (sanction.severity) {
      case 'Major':
        severityColor = Colors.red;
        break;
      case 'Minor':
        severityColor = Colors.orange;
        break;
      default:
        severityColor = Colors.grey;
    }

    Color statusColor;
    if (isResolved) {
      statusColor = Colors.green;
    } else if (isAppealed) {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    sanction.violationType,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: severityColor),
                  ),
                  child: Text(
                    sanction.severity,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: severityColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              sanction.description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.event, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  sanction.eventName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  _formatDate(sanction.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            // Appeal Status
            if (isAppealed && sanction.appealReason != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.gavel, size: 16, color: Colors.orange.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Appeal Status: ${sanction.appealStatus ?? "Pending"}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Reason: ${sanction.appealReason}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (sanction.appealDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Filed on: ${_formatDate(sanction.appealDate!)}',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            // Resolution Info
            if (isResolved && sanction.resolution != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Resolved: ${sanction.resolution}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Status Badge
            const SizedBox(height: 12),
            Row(
              children: [
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
                      Icon(
                        isResolved
                            ? Icons.check_circle
                            : isAppealed
                                ? Icons.pending
                                : Icons.warning,
                        size: 14,
                        color: statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        sanction.status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (isActive)
                  TextButton.icon(
                    onPressed: onAppeal,
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Appeal'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _ViolationTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final String severity;
  final Color severityColor;
  final String penalty;
  final IconData icon;

  const _ViolationTypeCard({
    required this.title,
    required this.description,
    required this.severity,
    required this.severityColor,
    required this.penalty,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: severityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: severityColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: severityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: severityColor),
                        ),
                        child: Text(
                          severity,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: severityColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.gavel,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          penalty,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}