// lib/data/models/attendance_model.dart
import 'package:thesis_attendance/core/constants/app_constants.dart';
import 'package:thesis_attendance/core/utils/date_formatter.dart';

class AttendanceModel {
  final String id;
  final String studentId;
  final String eventId;
  final String status; // 'present', 'late', 'absent', 'excused'
  final DateTime timestamp;
  final String? remarks;
  final bool canSubmitDocument;
  final DateTime createdAt;
  final DateTime updatedAt;

  AttendanceModel({
    required this.id,
    required this.studentId,
    required this.eventId,
    required this.status,
    required this.timestamp,
    this.remarks,
    this.canSubmitDocument = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Check if status is present
  bool get isPresent => status == AppConstants.statusPresent;

  // Check if status is late
  bool get isLate => status == AppConstants.statusLate;

  // Check if status is absent
  bool get isAbsent => status == AppConstants.statusAbsent;

  // Check if status is excused
  bool get isExcused => status == AppConstants.statusExcused;

  // Get formatted timestamp
  String get formattedTimestamp => DateFormatter.formatDateTimeFull(timestamp);

  // Get relative time
  String get relativeTime => DateFormatter.getRelativeTime(timestamp);

  // Copy with method
  AttendanceModel copyWith({
    String? id,
    String? studentId,
    String? eventId,
    String? status,
    DateTime? timestamp,
    String? remarks,
    bool? canSubmitDocument,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      eventId: eventId ?? this.eventId,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      remarks: remarks ?? this.remarks,
      canSubmitDocument: canSubmitDocument ?? this.canSubmitDocument,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'eventId': eventId,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'remarks': remarks,
      'canSubmitDocument': canSubmitDocument,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      eventId: json['eventId'] as String,
      status: json['status'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      remarks: json['remarks'] as String?,
      canSubmitDocument: json['canSubmitDocument'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'AttendanceModel(id: $id, studentId: $studentId, eventId: $eventId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttendanceModel &&
        other.id == id &&
        other.studentId == studentId &&
        other.eventId == eventId &&
        other.status == status &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        studentId.hashCode ^
        eventId.hashCode ^
        status.hashCode ^
        timestamp.hashCode;
  }
}