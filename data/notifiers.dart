import 'package:flutter/material.dart';

// Theme notifier
final ValueNotifier<bool> isDarkNotifier = ValueNotifier<bool>(false);

// Navigation notifier
final ValueNotifier<int> selectedPageNotifier = ValueNotifier<int>(0);

// User role enum
enum UserRole { student, admin }

// Current user data
class CurrentUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? section;
  final String? studentId;

  CurrentUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.section,
    this.studentId,
  });
}

// Authentication notifier
final ValueNotifier<CurrentUser?> currentUserNotifier = ValueNotifier<CurrentUser?>(null);

// App Settings
class AppSettings {
  double fontSize;
  String fontFamily;
  bool showAnimations;
  String language;

  AppSettings({
    this.fontSize = 14.0,
    this.fontFamily = 'Roboto',
    this.showAnimations = true,
    this.language = 'English',
  });
}

final ValueNotifier<AppSettings> appSettingsNotifier = ValueNotifier<AppSettings>(AppSettings());

// Event model
class AttendanceEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final TimeOfDay lateCutoff;
  final String createdBy;
  bool isActive;

  AttendanceEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.lateCutoff,
    required this.createdBy,
    this.isActive = true,
  });

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool get isUpcoming => date.isAfter(DateTime.now());
}

// Attendance status enum
enum AttendanceStatus { present, late, absent, excused }

// Document model
class AttendanceDocument {
  final String id;
  final String fileName;
  final String fileType;
  final DateTime uploadedAt;
  String status; // pending, approved, rejected
  String? adminComment;

  AttendanceDocument({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.uploadedAt,
    this.status = 'pending',
    this.adminComment,
  });
}

// Attendance record model
class AttendanceRecord {
  final String id;
  final String studentId;
  final String studentName;
  final String eventId;
  final AttendanceStatus status;
  final DateTime timestamp;
  String? remarks;
  List<AttendanceDocument> documents;
  bool canSubmitDocument;

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.eventId,
    required this.status,
    required this.timestamp,
    this.remarks,
    this.documents = const [],
    this.canSubmitDocument = false,
  });
}

// Sanction model
class Sanction {
  final String id;
  final String studentId;
  final String studentName;
  final String type; // warning, penalty
  final String reason;
  final String requiredAction;
  final DateTime issuedDate;
  String status; // active, resolved
  DateTime? resolvedDate;

  Sanction({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.type,
    required this.reason,
    required this.requiredAction,
    required this.issuedDate,
    this.status = 'active',
    this.resolvedDate,
  });
}

// Notification model
class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;
  final String type; // approval, reminder, sanction, announcement

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.type,
  });
}

// Data notifiers
final ValueNotifier<List<AttendanceEvent>> eventsNotifier = ValueNotifier<List<AttendanceEvent>>([]);
final ValueNotifier<List<AttendanceRecord>> attendanceRecordsNotifier = ValueNotifier<List<AttendanceRecord>>([]);
final ValueNotifier<List<Sanction>> sanctionsNotifier = ValueNotifier<List<Sanction>>([]);
final ValueNotifier<List<AppNotification>> notificationsNotifier = ValueNotifier<List<AppNotification>>([]);

// Initialize sample data
void initializeSampleData() {
  // Sample events
  final now = DateTime.now();
  eventsNotifier.value = [
    AttendanceEvent(
      id: '1',
      title: 'Morning Assembly',
      description: 'Daily morning assembly for all students',
      date: now,
      startTime: const TimeOfDay(hour: 7, minute: 30),
      endTime: const TimeOfDay(hour: 8, minute: 0),
      lateCutoff: const TimeOfDay(hour: 7, minute: 45),
      createdBy: 'admin1',
    ),
    AttendanceEvent(
      id: '2',
      title: 'Mathematics Class',
      description: 'Regular mathematics session',
      date: now,
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 10, minute: 30),
      lateCutoff: const TimeOfDay(hour: 9, minute: 10),
      createdBy: 'admin1',
    ),
    AttendanceEvent(
      id: '3',
      title: 'School Event',
      description: 'Upcoming school-wide event',
      date: now.add(const Duration(days: 3)),
      startTime: const TimeOfDay(hour: 14, minute: 0),
      endTime: const TimeOfDay(hour: 16, minute: 0),
      lateCutoff: const TimeOfDay(hour: 14, minute: 15),
      createdBy: 'admin1',
    ),
  ];

  // Sample attendance records
  attendanceRecordsNotifier.value = [
    AttendanceRecord(
      id: '1',
      studentId: 'student1',
      studentName: 'Juan Dela Cruz',
      eventId: '1',
      status: AttendanceStatus.present,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    AttendanceRecord(
      id: '2',
      studentId: 'student1',
      studentName: 'Juan Dela Cruz',
      eventId: '2',
      status: AttendanceStatus.late,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      remarks: 'Traffic delay',
      canSubmitDocument: true,
    ),
  ];

  // Sample sanctions
  sanctionsNotifier.value = [
    Sanction(
      id: '1',
      studentId: 'student1',
      studentName: 'Juan Dela Cruz',
      type: 'warning',
      reason: '3 consecutive absences',
      requiredAction: 'Submit excuse letter',
      issuedDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  // Sample notifications
  notificationsNotifier.value = [
    AppNotification(
      id: '1',
      title: 'Document Approved',
      message: 'Your excuse letter has been approved',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'approval',
    ),
    AppNotification(
      id: '2',
      title: 'Event Reminder',
      message: 'Morning Assembly starts in 1 hour',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      type: 'reminder',
    ),
  ];
}

// Helper functions
String getStatusColor(AttendanceStatus status) {
  switch (status) {
    case AttendanceStatus.present:
      return 'green';
    case AttendanceStatus.late:
      return 'orange';
    case AttendanceStatus.absent:
      return 'red';
    case AttendanceStatus.excused:
      return 'blue';
  }
}

String formatTime(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:$minute $period';
}