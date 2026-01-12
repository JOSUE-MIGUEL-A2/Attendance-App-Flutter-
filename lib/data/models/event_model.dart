// lib/data/models/event_model.dart
import 'package:flutter/material.dart';
import 'package:thesis_attendance/core/utils/date_formatter.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final TimeOfDay lateCutoff;
  final String createdBy; // User ID of admin who created it
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.lateCutoff,
    required this.createdBy,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  // Check if event is today
  bool get isToday => DateFormatter.isToday(date);

  // Check if event is upcoming
  bool get isUpcoming => date.isAfter(DateTime.now()) && !isToday;

  // Check if event is past
  bool get isPast => DateFormatter.isPast(date) && !isToday;

  // Get days until event
  int get daysUntil => DateFormatter.daysUntil(date);

  // Get formatted date
  String get formattedDate => DateFormatter.formatDateShort(date);

  // Get formatted time range
  String get formattedTimeRange {
    return '${DateFormatter.formatTime(startTime)} - ${DateFormatter.formatTime(endTime)}';
  }

  // Copy with method
  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    TimeOfDay? lateCutoff,
    String? createdBy,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      lateCutoff: lateCutoff ?? this.lateCutoff,
      createdBy: createdBy ?? this.createdBy,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'lateCutoff': '${lateCutoff.hour}:${lateCutoff.minute}',
      'createdBy': createdBy,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: _parseTimeOfDay(json['startTime'] as String),
      endTime: _parseTimeOfDay(json['endTime'] as String),
      lateCutoff: _parseTimeOfDay(json['lateCutoff'] as String),
      createdBy: json['createdBy'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Helper to parse TimeOfDay from string "HH:MM"
  static TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, date: $formattedDate, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.date == date &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        date.hashCode ^
        isActive.hashCode;
  }
}