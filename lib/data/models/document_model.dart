// lib/data/models/document_model.dart
import 'package:thesis_attendance/core/constants/app_constants.dart';
import 'package:thesis_attendance/core/utils/date_formatter.dart';

class DocumentModel {
  final String id;
  final String attendanceId; // Reference to attendance record
  final String studentId;
  final String fileName;
  final String fileUrl; // Firebase Storage URL or local path
  final String fileType; // 'pdf', 'jpg', 'png'
  final String status; // 'pending', 'approved', 'rejected'
  final String? adminComment;
  final DateTime uploadedAt;
  final DateTime? reviewedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DocumentModel({
    required this.id,
    required this.attendanceId,
    required this.studentId,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    this.status = AppConstants.docStatusPending,
    this.adminComment,
    required this.uploadedAt,
    this.reviewedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Check if document is pending
  bool get isPending => status == AppConstants.docStatusPending;

  // Check if document is approved
  bool get isApproved => status == AppConstants.docStatusApproved;

  // Check if document is rejected
  bool get isRejected => status == AppConstants.docStatusRejected;

  // Get formatted upload date
  String get formattedUploadDate => DateFormatter.formatDateTimeFull(uploadedAt);

  // Get relative upload time
  String get relativeUploadTime => DateFormatter.getRelativeTime(uploadedAt);

  // Get formatted review date
  String? get formattedReviewDate {
    if (reviewedAt == null) return null;
    return DateFormatter.formatDateTimeFull(reviewedAt!);
  }

  // Copy with method
  DocumentModel copyWith({
    String? id,
    String? attendanceId,
    String? studentId,
    String? fileName,
    String? fileUrl,
    String? fileType,
    String? status,
    String? adminComment,
    DateTime? uploadedAt,
    DateTime? reviewedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      attendanceId: attendanceId ?? this.attendanceId,
      studentId: studentId ?? this.studentId,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      fileType: fileType ?? this.fileType,
      status: status ?? this.status,
      adminComment: adminComment ?? this.adminComment,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attendanceId': attendanceId,
      'studentId': studentId,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'status': status,
      'adminComment': adminComment,
      'uploadedAt': uploadedAt.toIso8601String(),
      'reviewedAt': reviewedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as String,
      attendanceId: json['attendanceId'] as String,
      studentId: json['studentId'] as String,
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      fileType: json['fileType'] as String,
      status: json['status'] as String? ?? AppConstants.docStatusPending,
      adminComment: json['adminComment'] as String?,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      reviewedAt: json['reviewedAt'] != null 
          ? DateTime.parse(json['reviewedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'DocumentModel(id: $id, fileName: $fileName, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DocumentModel &&
        other.id == id &&
        other.attendanceId == attendanceId &&
        other.fileName == fileName &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        attendanceId.hashCode ^
        fileName.hashCode ^
        status.hashCode;
  }
}