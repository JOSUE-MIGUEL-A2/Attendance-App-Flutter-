import 'package:flutter/material.dart';
import 'package:thesis_attendance/data/notifiers.dart';

class StudentAnalytics extends StatelessWidget {
  const StudentAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    final user = currentUserNotifier.value!;

    return ValueListenableBuilder(
      valueListenable: attendanceRecordsNotifier,
      builder: (context, records, child) {
        final userRecords = records.where((r) => r.studentId == user.id).toList();
        
        final presentCount = userRecords.where((r) => r.status == AttendanceStatus.present).length;
        final lateCount = userRecords.where((r) => r.status == AttendanceStatus.late).length;
        final absentCount = userRecords.where((r) => r.status == AttendanceStatus.absent).length;
        final excusedCount = userRecords.where((r) => r.status == AttendanceStatus.excused).length;
        
        final totalCount = userRecords.length;
        final attendancePercentage = totalCount > 0 
            ? ((presentCount + excusedCount) / totalCount * 100).round() 
            : 0;

        // Monthly breakdown
        final now = DateTime.now();
        final thisMonthRecords = userRecords.where((r) {
          return r.timestamp.year == now.year && r.timestamp.month == now.month;
        }).toList();

        final thisMonthPresent = thisMonthRecords.where((r) => r.status == AttendanceStatus.present).length;
        final thisMonthTotal = thisMonthRecords.length;
        final thisMonthPercentage = thisMonthTotal > 0 
            ? (thisMonthPresent / thisMonthTotal * 100).round() 
            : 0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Attendance Card
              Card(
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade700, Colors.blue.shade500],
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
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$attendancePercentage%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$totalCount Total Events',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Status breakdown
              const Text(
                'Attendance Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Present',
                      presentCount,
                      Icons.check_circle,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Late',
                      lateCount,
                      Icons.schedule,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Absent',
                      absentCount,
                      Icons.cancel,
                      Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Excused',
                      excusedCount,
                      Icons.verified,
                      Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // This Month
              const Text(
                'This Month Performance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Current Month',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$thisMonthPresent Present / $thisMonthTotal Events',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _getPerformanceColor(thisMonthPercentage),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$thisMonthPercentage%',
                              style: TextStyle(
                                color: _getPerformanceColor(thisMonthPercentage),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: thisMonthPercentage / 100,
                          minHeight: 12,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getPerformanceColor(thisMonthPercentage),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Performance indicator
              Card(
                color: _getPerformanceColor(attendancePercentage),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        _getPerformanceIcon(attendancePercentage),
                        size: 40,
                        color: _getPerformanceColor(attendancePercentage),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getPerformanceText(attendancePercentage),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _getPerformanceColor(attendancePercentage),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getPerformanceMessage(attendancePercentage),
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Quick insights
              const Text(
                'Quick Insights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _buildInsightCard(
                Icons.trending_up,
                'Consistency',
                lateCount == 0 && absentCount == 0 
                    ? 'Perfect! No late or absent records' 
                    : lateCount > 0 
                        ? '$lateCount late arrival${lateCount > 1 ? 's' : ''} this period'
                        : '$absentCount absence${absentCount > 1 ? 's' : ''} this period',
                lateCount == 0 && absentCount == 0 ? Colors.green : Colors.orange,
              ),

              const SizedBox(height: 12),

              ValueListenableBuilder(
                valueListenable: sanctionsNotifier,
                builder: (context, sanctions, child) {
                  final activeSanctions = sanctions.where(
                    (s) => s.studentId == user.id && s.status == 'active'
                  ).length;

                  return _buildInsightCard(
                    Icons.warning,
                    'Sanctions',
                    activeSanctions == 0 
                        ? 'No active sanctions' 
                        : '$activeSanctions active sanction${activeSanctions > 1 ? 's' : ''} - check sanctions page',
                    activeSanctions == 0 ? Colors.green : Colors.red,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(IconData icon, String title, String message, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPerformanceColor(int percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 75) return Colors.blue;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  IconData _getPerformanceIcon(int percentage) {
    if (percentage >= 90) return Icons.emoji_events;
    if (percentage >= 75) return Icons.thumb_up;
    if (percentage >= 60) return Icons.info;
    return Icons.warning;
  }

  String _getPerformanceText(int percentage) {
    if (percentage >= 90) return 'Excellent Performance!';
    if (percentage >= 75) return 'Good Performance';
    if (percentage >= 60) return 'Fair Performance';
    return 'Needs Improvement';
  }

  String _getPerformanceMessage(int percentage) {
    if (percentage >= 90) return 'Keep up the outstanding work!';
    if (percentage >= 75) return 'You\'re doing well, maintain consistency';
    if (percentage >= 60) return 'Try to improve your attendance rate';
    return 'Focus on attending events regularly';
  }
}