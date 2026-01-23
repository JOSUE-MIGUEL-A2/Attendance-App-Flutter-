// lib/views/pages/student/student_analytics.dart
import 'package:flutter/material.dart';
import 'package:thesis_attendance/services/student_service.dart';
import 'package:thesis_attendance/services/firebase_service.dart';
import 'package:thesis_attendance/models/student_model.dart';

class StudentAnalytics extends StatefulWidget {
  const StudentAnalytics({super.key});

  @override
  State<StudentAnalytics> createState() => _StudentAnalyticsState();
}

class _StudentAnalyticsState extends State<StudentAnalytics> {
  final StudentService _service = StudentService();
  String _selectedPeriod = 'All Time';
  final List<String> _periods = [
    'This Week',
    'This Month',
    'This Semester',
    'All Time',
  ];

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseService.currentUserId;

    if (uid == null) {
      return const Center(child: Text('Not logged in'));
    }

    return StreamBuilder<Student?>(
      stream: _service.getStudentProfile(uid),
      builder: (context, studentSnapshot) {
        if (studentSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (studentSnapshot.hasError) {
          return Center(child: Text('Error: ${studentSnapshot.error}'));
        }

        if (!studentSnapshot.hasData || studentSnapshot.data == null) {
          return const Center(child: Text('Profile not found'));
        }

        final student = studentSnapshot.data!;

        return StreamBuilder<List<AttendanceRecord>>(
          stream: _service.getAttendanceHistory(student.studentId),
          builder: (context, attendanceSnapshot) {
            if (attendanceSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (attendanceSnapshot.hasError) {
              return Center(child: Text('Error: ${attendanceSnapshot.error}'));
            }

            final allRecords = attendanceSnapshot.data ?? [];

            // Filter records based on period
            final now = DateTime.now();
            final filteredRecords = allRecords.where((record) {
              switch (_selectedPeriod) {
                case 'This Week':
                  final weekStart = now.subtract(Duration(days: now.weekday - 1));
                  return record.eventDate.isAfter(weekStart);
                case 'This Month':
                  return record.eventDate.month == now.month &&
                      record.eventDate.year == now.year;
                case 'This Semester':
                  final semesterStart = now.subtract(const Duration(days: 180));
                  return record.eventDate.isAfter(semesterStart);
                default:
                  return true;
              }
            }).toList();

            final filteredPresent =
                filteredRecords.where((r) => r.status == 'present').length;
            final filteredLate =
                filteredRecords.where((r) => r.status == 'late').length;
            final filteredAbsent =
                filteredRecords.where((r) => r.status == 'absent').length;
            final filteredTotal = filteredRecords.length;
            final filteredRate = filteredTotal > 0
                ? ((filteredPresent + filteredLate) / filteredTotal * 100).round()
                : 0;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Period Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Analytics Overview',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedPeriod,
                          underline: const SizedBox(),
                          isDense: true,
                          items: _periods
                              .map((period) => DropdownMenuItem(
                                    value: period,
                                    child: Text(
                                      period,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedPeriod = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Attendance Rate Card
                  _buildAttendanceRateCard(
                    context,
                    filteredRate,
                    filteredPresent,
                    filteredLate,
                    filteredAbsent,
                    filteredTotal,
                  ),

                  const SizedBox(height: 24),

                  // Statistics Grid
                  Text(
                    'Detailed Statistics',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 12),

                  _buildStatisticsGrid(
                    allRecords,
                    filteredRecords,
                    filteredPresent,
                    filteredLate,
                    student.studentId,
                  ),

                  const SizedBox(height: 24),

                  // Monthly Breakdown
                  _buildMonthlyBreakdown(context, allRecords),

                  const SizedBox(height: 24),

                  // Download Report Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _generateReport(filteredRecords),
                      icon: const Icon(Icons.download),
                      label: const Text('Download Detailed Report'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAttendanceRateCard(
    BuildContext context,
    int rate,
    int present,
    int late,
    int absent,
    int total,
  ) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: () => _showAttendanceBreakdown(present, late, absent, total),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text(
                'Overall Attendance Rate',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: rate / 100,
                      strokeWidth: 12,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '$rate%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${present + late}/$total Events',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MiniStat(
                    label: 'On Time',
                    value: present.toString(),
                    icon: Icons.check_circle,
                  ),
                  _MiniStat(
                    label: 'Late',
                    value: late.toString(),
                    icon: Icons.schedule,
                  ),
                  _MiniStat(
                    label: 'Absent',
                    value: absent.toString(),
                    icon: Icons.cancel,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid(
    List<AttendanceRecord> allRecords,
    List<AttendanceRecord> filteredRecords,
    int present,
    int late,
    String studentId,
  ) {
    final perfectMonths = _calculatePerfectMonths(allRecords);
    final avgCheckIn = _calculateAverageCheckIn(filteredRecords);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Perfect Attendance',
                value: perfectMonths.toString(),
                subtitle: 'Months',
                icon: Icons.stars,
                color: Colors.amber,
                onTap: () => _showPerfectMonths(allRecords),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StreamBuilder<List<Sanction>>(
                stream: _service.getSanctions(studentId),
                builder: (context, snapshot) {
                  final sanctionsCount = snapshot.data?.length ?? 0;
                  return _StatCard(
                    title: 'Total Sanctions',
                    value: sanctionsCount.toString(),
                    subtitle: 'Violations',
                    icon: Icons.warning,
                    color: sanctionsCount == 0 ? Colors.green : Colors.red,
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Events Attended',
                value: (present + late).toString(),
                subtitle: _selectedPeriod,
                icon: Icons.event_available,
                color: Colors.blue,
                onTap: () => _showAttendedEvents(filteredRecords),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'Avg Check-in Time',
                value: avgCheckIn,
                subtitle: 'Before Start',
                icon: Icons.timer,
                color: Colors.purple,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMonthlyBreakdown(
    BuildContext context,
    List<AttendanceRecord> allRecords,
  ) {
    final breakdown = _generateMonthlyBreakdown(allRecords);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Monthly Breakdown',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => _showFullBreakdown(allRecords),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...breakdown.take(3).map((data) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _MonthlyBreakdownCard(
              month: data['month'] as String,
              totalEvents: data['total'] as int,
              present: data['present'] as int,
              late: data['late'] as int,
              absent: data['absent'] as int,
              rate: data['rate'] as int,
              onTap: () => _showMonthDetails(data),
            ),
          );
        }),
      ],
    );
  }

  int _calculatePerfectMonths(List<AttendanceRecord> records) {
    final monthlyRecords = <String, List<AttendanceRecord>>{};
    for (var record in records) {
      final key = '${record.eventDate.year}-${record.eventDate.month}';
      monthlyRecords.putIfAbsent(key, () => []).add(record);
    }

    int perfectMonths = 0;
    monthlyRecords.forEach((month, records) {
      final hasAbsence = records.any((r) => r.status == 'absent');
      if (!hasAbsence && records.isNotEmpty) {
        perfectMonths++;
      }
    });

    return perfectMonths;
  }

  String _calculateAverageCheckIn(List<AttendanceRecord> records) {
    if (records.isEmpty) return '0 min';

    int totalMinutes = 0;
    int count = 0;

    for (var record in records) {
      if (record.checkInTime != null) {
        try {
          final eventHour = int.parse(record.eventTime.split(':')[0]);
          final eventMinutes = eventHour * 60;
          final checkInMinutes =
              record.checkInTime!.hour * 60 + record.checkInTime!.minute;
          final minutesDiff = eventMinutes - checkInMinutes;

          if (minutesDiff > 0) {
            totalMinutes += minutesDiff;
            count++;
          }
        } catch (e) {
          continue;
        }
      }
    }

    return count > 0 ? '${(totalMinutes / count).round()} min' : '0 min';
  }

  List<Map<String, dynamic>> _generateMonthlyBreakdown(
    List<AttendanceRecord> records,
  ) {
    final monthlyData = <String, Map<String, dynamic>>{};

    for (var record in records) {
      final key = '${record.eventDate.year}-${record.eventDate.month}';
      final monthName = _getMonthName(record.eventDate.month);
      final year = record.eventDate.year;

      monthlyData.putIfAbsent(key, () => {
        'month': '$monthName $year',
        'total': 0,
        'present': 0,
        'late': 0,
        'absent': 0,
      });

      monthlyData[key]!['total'] = (monthlyData[key]!['total'] as int) + 1;
      if (record.status == 'present') {
        monthlyData[key]!['present'] = (monthlyData[key]!['present'] as int) + 1;
      } else if (record.status == 'late') {
        monthlyData[key]!['late'] = (monthlyData[key]!['late'] as int) + 1;
      } else if (record.status == 'absent') {
        monthlyData[key]!['absent'] = (monthlyData[key]!['absent'] as int) + 1;
      }
    }

    final breakdown = monthlyData.values.map((data) {
      final total = data['total'] as int;
      final attended = (data['present'] as int) + (data['late'] as int);
      data['rate'] = total > 0 ? ((attended / total) * 100).round() : 0;
      return data;
    }).toList();

    breakdown.sort((a, b) =>
        (b['month'] as String).compareTo(a['month'] as String));

    return breakdown;
  }

  String _getMonthName(int month) {
    const months = [
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
    return months[month - 1];
  }

  void _showAttendanceBreakdown(int present, int late, int absent, int total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Attendance Breakdown'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BreakdownRow('Present (On Time)', present, total, Colors.green),
            _BreakdownRow('Present (Late)', late, total, Colors.orange),
            _BreakdownRow('Absent', absent, total, Colors.red),
            const Divider(height: 24),
            _BreakdownRow('Total Events', total, total, Colors.blue),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPerfectMonths(List<AttendanceRecord> records) {
    final monthlyRecords = <String, List<AttendanceRecord>>{};
    for (var record in records) {
      final key =
          '${_getMonthName(record.eventDate.month)} ${record.eventDate.year}';
      monthlyRecords.putIfAbsent(key, () => []).add(record);
    }

    final perfectMonths = <String>[];
    monthlyRecords.forEach((month, records) {
      final hasAbsence = records.any((r) => r.status == 'absent');
      if (!hasAbsence && records.isNotEmpty) {
        perfectMonths.add(month);
      }
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Perfect Attendance Months'),
        content: perfectMonths.isEmpty
            ? const Text('No perfect attendance months yet. Keep it up!')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: perfectMonths.map((month) {
                  return ListTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: Text(month),
                    subtitle: const Text('100% Attendance'),
                  );
                }).toList(),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAttendedEvents(List<AttendanceRecord> records) {
    final attended = records
        .where((r) => r.status == 'present' || r.status == 'late')
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Events Attended ($_selectedPeriod)'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: attended.length,
            itemBuilder: (context, index) {
              final record = attended[index];
              return ListTile(
                leading: Icon(
                  record.status == 'present'
                      ? Icons.check_circle
                      : Icons.schedule,
                  color:
                      record.status == 'present' ? Colors.green : Colors.orange,
                ),
                title: Text(record.eventName),
                subtitle: Text(_formatDate(record.eventDate)),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFullBreakdown(List<AttendanceRecord> records) {
    final breakdown = _generateMonthlyBreakdown(records);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Monthly Breakdown'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: breakdown.length,
            itemBuilder: (context, index) {
              final data = breakdown[index];
              return _MonthlyBreakdownCard(
                month: data['month'] as String,
                totalEvents: data['total'] as int,
                present: data['present'] as int,
                late: data['late'] as int,
                absent: data['absent'] as int,
                rate: data['rate'] as int,
                onTap: () {},
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showMonthDetails(Map<String, dynamic> breakdown) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(breakdown['month'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow('Total Events:', '${breakdown['total']}'),
            _DetailRow('Present:', '${breakdown['present']}'),
            _DetailRow('Late:', '${breakdown['late']}'),
            _DetailRow('Absent:', '${breakdown['absent']}'),
            _DetailRow('Attendance Rate:', '${breakdown['rate']}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _generateReport(List<AttendanceRecord> records) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Generate detailed analytics report for $_selectedPeriod?'),
            const SizedBox(height: 16),
            const Text(
              'Report will include:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Attendance statistics'),
            const Text('• Monthly breakdown'),
            const Text('• Check-in analysis'),
            const Text('• Performance trends'),
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
                  content: Text('Generating report...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }
}

// ==================== WIDGET CLASSES ====================

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthlyBreakdownCard extends StatelessWidget {
  final String month;
  final int totalEvents;
  final int present;
  final int late;
  final int absent;
  final int rate;
  final VoidCallback onTap;

  const _MonthlyBreakdownCard({
    required this.month,
    required this.totalEvents,
    required this.present,
    required this.late,
    required this.absent,
    required this.rate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        month,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$totalEvents Total Events',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: rate == 100 ? Colors.green : Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$rate%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _BreakdownItem(
                    label: 'Present',
                    value: present,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 16),
                  _BreakdownItem(
                    label: 'Late',
                    value: late,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 16),
                  _BreakdownItem(
                    label: 'Absent',
                    value: absent,
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BreakdownItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _BreakdownItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $value',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;

  const _BreakdownRow(this.label, this.value, this.total, this.color);

  @override
  Widget build(BuildContext context) {
    final percentage =
        total > 0 ? (value / total * 100).toStringAsFixed(1) : '0.0';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: total > 0 ? value / total : 0,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: color,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}