import 'package:flutter/material.dart';

class AdminReportsAnalytics extends StatefulWidget {
  const AdminReportsAnalytics({super.key});

  @override
  State<AdminReportsAnalytics> createState() => _AdminReportsAnalyticsState();
}

class _AdminReportsAnalyticsState extends State<AdminReportsAnalytics> {
  String _selectedPeriod = 'This Month';
  final List<String> _periods = ['Today', 'This Week', 'This Month', 'This Semester', 'This Year'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              _showExportDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            Row(
              children: [
                Text(
                  'Time Period:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedPeriod,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: _periods
                          .map((period) => DropdownMenuItem(
                                value: period,
                                child: Text(period),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPeriod = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Overall Statistics
            Text(
              'Overall Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Total Students',
                    value: '1,234',
                    icon: Icons.people,
                    color: Colors.blue,
                    trend: '+5.2%',
                    trendUp: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Total Events',
                    value: '24',
                    icon: Icons.event,
                    color: Colors.purple,
                    trend: '+12.5%',
                    trendUp: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Avg Attendance',
                    value: '92.8%',
                    icon: Icons.trending_up,
                    color: Colors.green,
                    trend: '+2.1%',
                    trendUp: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Active Sanctions',
                    value: '5',
                    icon: Icons.warning,
                    color: Colors.red,
                    trend: '-15.2%',
                    trendUp: false,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Attendance Analytics
            Text(
              'Attendance Analytics',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 12),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Attendance Breakdown',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    _AttendanceBar(
                      label: 'Present',
                      count: 1145,
                      total: 1234,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _AttendanceBar(
                      label: 'Late',
                      count: 67,
                      total: 1234,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    _AttendanceBar(
                      label: 'Absent',
                      count: 22,
                      total: 1234,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Program Performance
            Text(
              'Program Performance',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 12),

            _ProgramCard(
              program: 'BSCS',
              students: 450,
              attendanceRate: 94.5,
              color: Colors.blue,
            ),

            const SizedBox(height: 8),

            _ProgramCard(
              program: 'BSIT',
              students: 380,
              attendanceRate: 91.2,
              color: Colors.purple,
            ),

            const SizedBox(height: 8),

            _ProgramCard(
              program: 'BSIS',
              students: 404,
              attendanceRate: 92.8,
              color: Colors.teal,
            ),

            const SizedBox(height: 24),

            // Event Performance
            Text(
              'Event Performance',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 12),

            _EventPerformanceCard(
              eventName: 'Flag Ceremony',
              occurrences: 20,
              avgAttendance: 95.6,
              bestAttendance: 98.2,
              worstAttendance: 88.5,
            ),

            const SizedBox(height: 8),

            _EventPerformanceCard(
              eventName: 'Student Assembly',
              occurrences: 2,
              avgAttendance: 93.4,
              bestAttendance: 95.1,
              worstAttendance: 91.7,
            ),

            const SizedBox(height: 8),

            _EventPerformanceCard(
              eventName: 'Seminars',
              occurrences: 4,
              avgAttendance: 89.2,
              bestAttendance: 92.8,
              worstAttendance: 85.3,
            ),

            const SizedBox(height: 24),

            // Top Performers
            Text(
              'Top Performers',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 12),

            Card(
              child: Column(
                children: [
                  _TopPerformerTile(
                    rank: 1,
                    name: 'Ana Garcia',
                    studentId: '2024-12348',
                    attendanceRate: 100,
                    program: 'BSIS',
                  ),
                  const Divider(height: 1),
                  _TopPerformerTile(
                    rank: 2,
                    name: 'Juan Dela Cruz',
                    studentId: '2024-12345',
                    attendanceRate: 98.5,
                    program: 'BSCS',
                  ),
                  const Divider(height: 1),
                  _TopPerformerTile(
                    rank: 3,
                    name: 'Sofia Reyes',
                    studentId: '2024-12350',
                    attendanceRate: 97.8,
                    program: 'BSIT',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Students at Risk
            Text(
              'Students at Risk',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 12),

            Card(
              color: Colors.red.shade50,
              child: Column(
                children: [
                  _RiskStudentTile(
                    name: 'Carlos Lopez',
                    studentId: '2024-12349',
                    attendanceRate: 72.5,
                    absences: 8,
                    program: 'BSIT',
                  ),
                  const Divider(height: 1),
                  _RiskStudentTile(
                    name: 'Miguel Torres',
                    studentId: '2024-12351',
                    attendanceRate: 75.2,
                    absences: 6,
                    program: 'BSCS',
                  ),
                  const Divider(height: 1),
                  _RiskStudentTile(
                    name: 'Lisa Mendoza',
                    studentId: '2024-12352',
                    attendanceRate: 78.8,
                    absences: 5,
                    program: 'BSIS',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Generate Reports',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _ReportButton(
                    label: 'Attendance Report',
                    icon: Icons.assessment,
                    color: Colors.blue,
                    onTap: () => _generateReport('Attendance'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ReportButton(
                    label: 'Sanctions Report',
                    icon: Icons.warning,
                    color: Colors.red,
                    onTap: () => _generateReport('Sanctions'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _ReportButton(
                    label: 'Program Report',
                    icon: Icons.school,
                    color: Colors.purple,
                    onTap: () => _generateReport('Program'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ReportButton(
                    label: 'Custom Report',
                    icon: Icons.edit_document,
                    color: Colors.orange,
                    onTap: () => _showCustomReportDialog(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('Export as PDF'),
              onTap: () {
                Navigator.pop(context);
                _exportData('PDF');
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: const Text('Export as Excel'),
              onTap: () {
                Navigator.pop(context);
                _exportData('Excel');
              },
            ),
            ListTile(
              leading: const Icon(Icons.code, color: Colors.blue),
              title: const Text('Export as CSV'),
              onTap: () {
                Navigator.pop(context);
                _exportData('CSV');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _exportData(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting data as $format...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _generateReport(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating $type Report...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showCustomReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Report'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Report Type',
                  border: OutlineInputBorder(),
                ),
                items: ['Attendance', 'Sanctions', 'Students', 'Events']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Time Period',
                  border: OutlineInputBorder(),
                ),
                items: _periods.map((period) => DropdownMenuItem(value: period, child: Text(period))).toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Format',
                  border: OutlineInputBorder(),
                ),
                items: ['PDF', 'Excel', 'CSV']
                    .map((format) => DropdownMenuItem(value: format, child: Text(format)))
                    .toList(),
                onChanged: (value) {},
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
              _generateReport('Custom');
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  final bool trendUp;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
    required this.trendUp,
  });

  @override
  Widget build(BuildContext context) {
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
                Icon(icon, color: color, size: 28),
                Row(
                  children: [
                    Icon(
                      trendUp ? Icons.trending_up : Icons.trending_down,
                      size: 16,
                      color: trendUp ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trend,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: trendUp ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _AttendanceBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (count / total * 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(
              '$count (${percentage.toStringAsFixed(1)}%)',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: count / total,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final String program;
  final int students;
  final double attendanceRate;
  final Color color;

  const _ProgramCard({
    required this.program,
    required this.students,
    required this.attendanceRate,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(Icons.school, color: color),
        ),
        title: Text(program, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$students students'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${attendanceRate.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text('Attendance', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}

class _EventPerformanceCard extends StatelessWidget {
  final String eventName;
  final int occurrences;
  final double avgAttendance;
  final double bestAttendance;
  final double worstAttendance;

  const _EventPerformanceCard({
    required this.eventName,
    required this.occurrences,
    required this.avgAttendance,
    required this.bestAttendance,
    required this.worstAttendance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(eventName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('$occurrences events', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('${avgAttendance.toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                      Text('Average', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('${bestAttendance.toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                      Text('Best', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('${worstAttendance.toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
                      Text('Worst', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TopPerformerTile extends StatelessWidget {
  final int rank;
  final String name;
  final String studentId;
  final double attendanceRate;
  final String program;

  const _TopPerformerTile({
    required this.rank,
    required this.name,
    required this.studentId,
    required this.attendanceRate,
    required this.program,
  });

  @override
  Widget build(BuildContext context) {
    Color rankColor;
    switch (rank) {
      case 1:
        rankColor = Colors.amber;
        break;
      case 2:
        rankColor = Colors.grey;
        break;
      case 3:
        rankColor = Colors.brown;
        break;
      default:
        rankColor = Colors.blue;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: rankColor.withOpacity(0.2),
        child: Text(
          '#$rank',
          style: TextStyle(fontWeight: FontWeight.bold, color: rankColor),
        ),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('$studentId • $program', style: const TextStyle(fontSize: 12)),
      trailing: Text(
        '${attendanceRate.toStringAsFixed(1)}%',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
      ),
    );
  }
}

class _RiskStudentTile extends StatelessWidget {
  final String name;
  final String studentId;
  final double attendanceRate;
  final int absences;
  final String program;

  const _RiskStudentTile({
    required this.name,
    required this.studentId,
    required this.attendanceRate,
    required this.absences,
    required this.program,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.red.withOpacity(0.2),
        child: Icon(Icons.warning, color: Colors.red.shade700),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('$studentId • $program • $absences absences', style: const TextStyle(fontSize: 12)),
      trailing: Text(
        '${attendanceRate.toStringAsFixed(1)}%',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
      ),
    );
  }
}

class _ReportButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ReportButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}