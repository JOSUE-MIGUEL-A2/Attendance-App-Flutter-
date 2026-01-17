import 'package:flutter/material.dart';

class StudentSanctions extends StatefulWidget {
  const StudentSanctions({super.key});

  @override
  State<StudentSanctions> createState() => _StudentSanctionsState();
}

class _StudentSanctionsState extends State<StudentSanctions> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Active', 'Resolved', 'Appealed'];

  @override
  Widget build(BuildContext context) {
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
            Card(
              elevation: 3,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade600,
                      Colors.green.shade400,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Clean Record!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You have no active violations',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _SummaryItem(
                          label: 'Total',
                          value: '0',
                          icon: Icons.list_alt,
                        ),
                        _SummaryItem(
                          label: 'Active',
                          value: '0',
                          icon: Icons.warning,
                        ),
                        _SummaryItem(
                          label: 'Resolved',
                          value: '0',
                          icon: Icons.check_circle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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

            const SizedBox(height: 24),

            // Information Card (No Violations)
            Card(
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
            ),

            const SizedBox(height: 24),

            // Violation Types Information
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

            const SizedBox(height: 24),

            // Appeal Process Card
            Card(
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.article, color: Colors.purple.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'How to Appeal a Violation',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.purple.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _AppealStep(
                      number: '1',
                      text: 'Submit a written appeal within 3 days',
                    ),
                    const SizedBox(height: 8),
                    _AppealStep(
                      number: '2',
                      text: 'Provide supporting documents or evidence',
                    ),
                    const SizedBox(height: 8),
                    _AppealStep(
                      number: '3',
                      text: 'Wait for review by student affairs',
                    ),
                    const SizedBox(height: 8),
                    _AppealStep(
                      number: '4',
                      text: 'Receive decision within 5 working days',
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showAppealDialog();
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Submit an Appeal'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.purple.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Example Sanctions (Commented Out)
            // Uncomment this section when you want to show actual violations
            /*
            Text(
              'Violation History',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 12),

            _SanctionCard(
              violationType: 'Absence',
              eventName: 'Flag Ceremony',
              date: 'Jan 10, 2026',
              status: 'Resolved',
              severity: 'Minor',
              description: 'Did not attend the morning flag ceremony',
              resolution: 'Provided medical certificate',
            ),
            */
          ],
        ),
      ),
    );
  }

  void _showAppealDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Appeal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Violation Reference',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.numbers),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Reason for Appeal',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                print('Attach supporting documents');
              },
              icon: const Icon(Icons.attach_file),
              label: const Text('Attach Documents'),
            ),
          ],
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
                  content: Text('Appeal submitted successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Submit Appeal'),
          ),
        ],
      ),
    );
  }
}

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

class _AppealStep extends StatelessWidget {
  final String number;
  final String text;

  const _AppealStep({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: Colors.purple.shade700,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }
}

/* Uncomment this widget when you want to display actual violations
class _SanctionCard extends StatelessWidget {
  final String violationType;
  final String eventName;
  final String date;
  final String status;
  final String severity;
  final String description;
  final String? resolution;

  const _SanctionCard({
    required this.violationType,
    required this.eventName,
    required this.date,
    required this.status,
    required this.severity,
    required this.description,
    this.resolution,
  });

  @override
  Widget build(BuildContext context) {
    final isResolved = status == 'Resolved';
    final statusColor = isResolved ? Colors.green : Colors.orange;

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
                    violationType,
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
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.event, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  eventName,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade800,
              ),
            ),
            if (resolution != null) ...[
              const SizedBox(height: 8),
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
                        'Resolution: $resolution',
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
          ],
        ),
      ),
    );
  }
}*/