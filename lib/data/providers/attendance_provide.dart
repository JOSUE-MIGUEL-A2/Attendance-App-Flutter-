// lib/data/providers/attendance_provider.dart
import 'package:flutter/foundation.dart';
import 'package:thesis_attendance/core/constants/app_constants.dart';
import 'package:thesis_attendance/data/models/attendance_model.dart';

class AttendanceProvider extends ChangeNotifier {
  List<AttendanceModel> _attendanceRecords = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<AttendanceModel> get attendanceRecords => List.unmodifiable(_attendanceRecords);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Initialize with sample data
  void initializeSampleData() {
    final now = DateTime.now();
    
    _attendanceRecords = [
      AttendanceModel(
        id: '1',
        studentId: 'student1',
        eventId: '1',
        status: AppConstants.statusPresent,
        timestamp: now.subtract(const Duration(hours: 1)),
        createdAt: now,
        updatedAt: now,
      ),
      AttendanceModel(
        id: '2',
        studentId: 'student1',
        eventId: '2',
        status: AppConstants.statusLate,
        timestamp: now.subtract(const Duration(days: 1)),
        remarks: 'Traffic delay',
        canSubmitDocument: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];
    
    notifyListeners();
  }

  /// Get attendance by ID
  AttendanceModel? getAttendanceById(String id) {
    try {
      return _attendanceRecords.firstWhere((record) => record.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get attendance records for a specific student
  List<AttendanceModel> getStudentAttendance(String studentId) {
    return _attendanceRecords
        .where((record) => record.studentId == studentId)
        .toList();
  }

  /// Get attendance records for a specific event
  List<AttendanceModel> getEventAttendance(String eventId) {
    return _attendanceRecords
        .where((record) => record.eventId == eventId)
        .toList();
  }

  /// Get student's attendance for specific event
  AttendanceModel? getStudentEventAttendance(String studentId, String eventId) {
    try {
      return _attendanceRecords.firstWhere(
        (record) => record.studentId == studentId && record.eventId == eventId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if student has checked in for event
  bool hasCheckedIn(String studentId, String eventId) {
    return getStudentEventAttendance(studentId, eventId) != null;
  }

  /// Mark attendance
  Future<bool> markAttendance(AttendanceModel attendance) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Check if already marked
      if (hasCheckedIn(attendance.studentId, attendance.eventId)) {
        _errorMessage = 'Attendance already marked for this event';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // TODO: Replace with Firebase add
      await Future.delayed(const Duration(milliseconds: 500));

      _attendanceRecords.add(attendance);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update attendance record
  Future<bool> updateAttendance(AttendanceModel attendance) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with Firebase update
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _attendanceRecords.indexWhere((r) => r.id == attendance.id);
      if (index != -1) {
        _attendanceRecords[index] = attendance.copyWith(
          updatedAt: DateTime.now(),
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update attendance status (for admin override)
  Future<bool> updateAttendanceStatus(String attendanceId, String newStatus) async {
    try {
      final attendance = getAttendanceById(attendanceId);
      if (attendance == null) return false;

      return await updateAttendance(
        attendance.copyWith(status: newStatus),
      );
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Get attendance statistics for a student
  Map<String, int> getStudentStats(String studentId) {
    final records = getStudentAttendance(studentId);
    
    return {
      'total': records.length,
      'present': records.where((r) => r.isPresent).length,
      'late': records.where((r) => r.isLate).length,
      'absent': records.where((r) => r.isAbsent).length,
      'excused': records.where((r) => r.isExcused).length,
    };
  }

  /// Calculate attendance rate for student
  double getAttendanceRate(String studentId) {
    final stats = getStudentStats(studentId);
    final total = stats['total'] ?? 0;
    if (total == 0) return 0.0;
    
    final present = stats['present'] ?? 0;
    final excused = stats['excused'] ?? 0;
    
    return ((present + excused) / total) * 100;
  }

  /// Get all unique students from attendance records
  List<String> getAllStudents() {
    return _attendanceRecords
        .map((r) => r.studentId)
        .toSet()
        .toList();
  }

  /// Load attendance records
  Future<void> loadAttendance() async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with Firebase fetch
      await Future.delayed(const Duration(seconds: 1));

      initializeSampleData();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}