// lib/data/models/notification_model.dart
import 'package:thesis_attendance/core/constants/app_constants.dart';
import 'package:thesis_attendance/core/utils/date_formatter.dart';

class NotificationModel {
  final String id;
  final String userId; // User who receives this notification
  final String title;
  final String message;
  final String type; // 'approval', 'reminder', 'sanction', 'announcement'
  final bool isRead;
  final String? relatedId; // ID of related entity (eventId, sanctionId, etc.)
  final DateTime timestamp;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    this.relatedId,
    required this.timestamp,
    this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Check if notification is unread
  bool get isUnread => !isRead;

  // Check if notification is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  // Check notification type
  bool get isApprovalNotification => type == AppConstants.notifApproval;
  bool get isReminderNotification => type == AppConstants.notifReminder;
  bool get isSanctionNotification => type == AppConstants.notifSanction;
  bool get isAnnouncementNotification => type == AppConstants.notifAnnouncement;

  // Get formatted timestamp
  String get formattedTimestamp => DateFormatter.formatDateTimeFull(timestamp);

  // Get relative time
  String get relativeTime => DateFormatter.getRelativeTime(timestamp);

  // Copy with method
  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    String? relatedId,
    DateTime? timestamp,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      relatedId: relatedId ?? this.relatedId,
      timestamp: timestamp ?? this.timestamp,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Mark as read
  NotificationModel markAsRead() {
    return copyWith(
      isRead: true,
      updatedAt: DateTime.now(),
    );
  }

  // Mark as unread
  NotificationModel markAsUnread() {
    return copyWith(
      isRead: false,
      updatedAt: DateTime.now(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'relatedId': relatedId,
      'timestamp': timestamp.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      isRead: json['isRead'] as bool? ?? false,
      relatedId: json['relatedId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, type: $type, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationModel &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.type == type &&
        other.isRead == isRead &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        title.hashCode ^
        type.hashCode ^
        isRead.hashCode ^
        timestamp.hashCode;
  }
}