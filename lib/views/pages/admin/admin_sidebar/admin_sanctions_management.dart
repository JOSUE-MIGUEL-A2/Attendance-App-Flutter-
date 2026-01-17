import 'package:flutter/material.dart';

class AdminSanctionsManagement extends StatefulWidget {
  const AdminSanctionsManagement({super.key});

  @override
  State<AdminSanctionsManagement> createState() => _AdminSanctionsManagementState();
}

class _AdminSanctionsManagementState extends State<AdminSanctionsManagement> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Active', 'Resolved', 'Appealed'];
  String _selectedSeverity = 'All Severity';
  final List<String> _severities = ['All Severity', 'Minor', 'Major', 'Critical'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sanctions Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreateSanctionDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: 'Active',
                        count: 5,
                        icon: Icons.warning,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        title: 'Appealed',
                        count: 3,
                        icon: Icons.gavel,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        title: 'Resolved',
                        count: 12,
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Filters
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
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
                    ),
                    DropdownButton<String>(
                      value: _selectedSeverity,
                      underline: const SizedBox(),
                      items: _severities
                          .map((severity) => DropdownMenuItem(
                                value: severity,
                                child: Text(severity, style: const TextStyle(fontSize: 12)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSeverity = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Sanctions List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SanctionCard(
                  studentName: 'Maria Santos',
                  studentId: '2024-12346',
                  violationType: 'Repeated Absence',
                  description: 'Missed 3 consecutive flag ceremonies without excuse',
                  severity: 'Major',
                  dateIssued: 'Jan 14, 2026',
                  status: 'Active',
                  appealStatus: 'Pending Review',
                  eventsMissed: ['Flag Ceremony - Jan 13', 'Flag Ceremony - Jan 14', 'Flag Ceremony - Jan 15'],
                ),
                const SizedBox(height: 12),
                _SanctionCard(
                  studentName: 'Carlos Lopez',
                  studentId: '2024-12349',
                  violationType: 'Tardiness',
                  description: 'Late check-in to seminar by 15 minutes',
                  severity: 'Minor',
                  dateIssued: 'Jan 13, 2026',
                  status: 'Active',
                  eventsMissed: ['Professional Seminar - Jan 13'],
                ),
                const SizedBox(height: 12),
                _SanctionCard(
                  studentName: 'Lisa Mendoza',
                  studentId: '2024-12352',
                  violationType: 'Misconduct',
                  description: 'Disruptive behavior during assembly',
                  severity: 'Major',
                  dateIssued: 'Jan 12, 2026',
                  status: 'Appealed',
                  appealStatus: 'Under Review',
                  appealDate: 'Jan 13, 2026',
                  eventsMissed: ['Student Assembly - Jan 12'],
                ),
                const SizedBox(height: 12),
                _SanctionCard(
                  studentName: 'Miguel Torres',
                  studentId: '2024-12351',
                  violationType: 'Absence',
                  description: 'Absent without medical certificate',
                  severity: 'Minor',
                  dateIssued: 'Jan 10, 2026',
                  status: 'Resolved',
                  resolutionDate: 'Jan 11, 2026',
                  resolutionNote: 'Medical certificate submitted and verified',
                  eventsMissed: ['Workshop - Jan 10'],
                ),
                const SizedBox(height: 12),
                _SanctionCard(
                  studentName: 'Pedro Reyes',
                  studentId: '2024-12347',
                  violationType: 'Repeated Tardiness',
                  description: 'Late to 5 events in the past month',
                  severity: 'Major',
                  dateIssued: 'Jan 9, 2026',
                  status: 'Active',
                  eventsMissed: [
                    'Flag Ceremony - Jan 5 (Late by 8 min)',
                    'Seminar - Jan 7 (Late by 12 min)',
                    'Assembly - Jan 8 (Late by 5 min)',
                    'Flag Ceremony - Jan 9 (Late by 10 min)',
                    'Event - Jan 9 (Late by 7 min)',
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateSanctionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Issue Sanction'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Violation Type',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.warning),
                ),
                items: ['Absence', 'Tardiness', 'Repeated Absence', 'Repeated Tardiness', 'Misconduct']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Severity',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.priority_high),
                ),
                items: ['Minor', 'Major', 'Critical']
                    .map((severity) => DropdownMenuItem(value: severity, child: Text(severity)))
                    .toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 12),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sanction issued successfully'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Issue Sanction'),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _SanctionCard extends StatelessWidget {
  final String studentName;
  final String studentId;
  final String violationType;
  final String description;
  final String severity;
  final String dateIssued;
  final String status;
  final String? appealStatus;
  final String? appealDate;
  final String? resolutionDate;
  final String? resolutionNote;
  final List<String>? eventsMissed;

  const _SanctionCard({
    required this.studentName,
    required this.studentId,
    required this.violationType,
    required this.description,
    required this.severity,
    required this.dateIssued,
    required this.status,
    this.appealStatus,
    this.appealDate,
    this.resolutionDate,
    this.resolutionNote,
    this.eventsMissed,
  });

  @override
  Widget build(BuildContext context) {
    Color severityColor;
    switch (severity) {
      case 'Critical':
        severityColor = Colors.red.shade900;
        break;
      case 'Major':
        severityColor = Colors.red;
        break;
      default:
        severityColor = Colors.orange;
    }

    Color statusColor;
    switch (status) {
      case 'Active':
        statusColor = Colors.red;
        break;
      case 'Appealed':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.green;
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
                CircleAvatar(
                  radius: 24,
                  backgroundColor: severityColor.withOpacity(0.1),
                  child: Icon(Icons.warning, color: severityColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        studentName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'ID: $studentId',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            // Violation Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: severityColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: severityColor.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        violationType,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: severityColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          severity,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(description, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        'Issued: $dateIssued',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Events Missed
            if (eventsMissed != null && eventsMissed!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Events Involved:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 4),
              ...eventsMissed!.map((event) => Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4),
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 6, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(event, style: const TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  )),
            ],

            // Appeal Info
            if (appealStatus != null) ...[
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
                          'Appeal: $appealStatus',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    if (appealDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Filed on: $appealDate',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            // Resolution Info
            if (resolutionDate != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, size: 16, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Resolved on: $resolutionDate',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    if (resolutionNote != null) ...[
                      const SizedBox(height: 4),
                      Text(resolutionNote!, style: const TextStyle(fontSize: 12)),
                    ],
                  ],
                ),
              ),
            ],

            // Action Buttons
            if (status == 'Active' || status == 'Appealed') ...[
              const Divider(height: 24),
              Row(
                children: [
                  if (status == 'Appealed') ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showReviewAppealDialog(context);
                        },
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('Review Appeal'),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showSendWarningDialog(context);
                      },
                      icon: const Icon(Icons.email, size: 16),
                      label: const Text('Send Warning'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showResolveDialog(context);
                      },
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Resolve'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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

  void _showReviewAppealDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Review Appeal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Student: $studentName ($studentId)'),
            const SizedBox(height: 8),
            Text('Violation: $violationType'),
            const SizedBox(height: 16),
            const Text('Appeal Details:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Review Notes',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Appeal rejected'), backgroundColor: Colors.red),
              );
            },
            child: const Text('Reject Appeal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Appeal approved'), backgroundColor: Colors.green),
              );
            },
            child: const Text('Approve Appeal'),
          ),
        ],
      ),
    );
  }

  void _showSendWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Warning Letter'),
        content: TextField(
          maxLines: 5,
          decoration: InputDecoration(
            labelText: 'Warning Message',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
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
                const SnackBar(content: Text('Warning sent to student')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showResolveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resolve Sanction'),
        content: TextField(
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Resolution Notes',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
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
                  content: Text('Sanction resolved'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Resolve'),
          ),
        ],
      ),
    );
  }
}