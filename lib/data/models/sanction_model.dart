// lib/data/models/sanction_model.dart
import 'package:thesis_attendance/core/constants/app_constants.dart';
import 'package:thesis_attendance/core/utils/date_formatter.dart';

class SanctionModel {
  final String id;
  final String studentId;
  final String type; // 'warning' or 'penalty'
  final String reason;
  final String requiredAction;
  final String status; // 'active' or 'resolved'
  final String issuedBy; // Admin user ID
  final DateTime issuedDate;
  final DateTime? resolvedDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  SanctionModel({
    required this.id,
    required this.studentId,
    required this.type,
    required this.reason,
    required this.requiredAction,
    this.status = AppConstants.sanctionActive,
    required this.issuedBy,
    required this.issuedDate,
    this.resolvedDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // Check if sanction is a warning
  bool get isWarning => type == AppConstants.sanctionWarning;

  // Check if sanction is a penalty
  bool get isPenalty => type == AppConstants.sanctionPenalty;

  // Check if sanction is active
  bool get isActive => status == AppConstants.sanctionActive;

  // Check if sanction is resolved
  bool get isResolved => status == AppConstants.sanctionResolved;

  // Get formatted issue date
  String get formattedIssuedDate => DateFormatter.formatDateLong(issuedDate);

  // Get formatted resolved date
  String? get formattedResolvedDate {
    if (resolvedDate == null) return null;
    return DateFormatter.formatDateLong(resolvedDate!);
  }

  // Get relative issue time
  String get relativeIssueTime => DateFormatter.getRelativeTime(issuedDate);

  // Get days active (if not resolved)
  int get daysActive {
    if (isResolved && resolvedDate != null) {
      return resolvedDate!.difference(issuedDate).inDays;
    }
    return DateTime.now().difference(issuedDate).inDays;
  }

  // Copy with method
  SanctionModel copyWith({
    String? id,
    String? studentId,
    String? type,
    String? reason,
    String? requiredAction,
    String? status,
    String? issuedBy,
    DateTime? issuedDate,
    DateTime? resolvedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SanctionModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      type: type ?? this.type,
      reason: reason ?? this.reason,
      requiredAction: requiredAction ?? this.requiredAction,
      status: status ?? this.status,
      issuedBy: issuedBy ?? this.issuedBy,
      issuedDate: issuedDate ?? this.issuedDate,
      resolvedDate: resolvedDate ?? this.resolvedDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'type': type,
      'reason': reason,
      'requiredAction': requiredAction,
      'status': status,
      'issuedBy': issuedBy,
      'issuedDate': issuedDate.toIso8601String(),
      'resolvedDate': resolvedDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory SanctionModel.fromJson(Map<String, dynamic> json) {
    return SanctionModel(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      type: json['type'] as String,
      reason: json['reason'] as String,
      requiredAction: json['requiredAction'] as String,
      status: json['status'] as String? ?? AppConstants.sanctionActive,
      issuedBy: json['issuedBy'] as String,
      issuedDate: DateTime.parse(json['issuedDate'] as String),
      resolvedDate: json['resolvedDate'] != null
          ? DateTime.parse(json['resolvedDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'SanctionModel(id: $id, studentId: $studentId, type: $type, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SanctionModel &&
        other.id == id &&
        other.studentId == studentId &&
        other.type == type &&
        other.status == status &&
        other.issuedDate == issuedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        studentId.hashCode ^
        type.hashCode ^
        status.hashCode ^
        issuedDate.hashCode;
  }
}