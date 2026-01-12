// lib/data/models/user_model.dart
import 'package:thesis_attendance/core/constants/app_constants.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'student' or 'admin'
  final String? studentId;
  final String? section;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.studentId,
    this.section,
    required this.createdAt,
    required this.updatedAt,
  });

  // Check if user is admin
  bool get isAdmin => role == AppConstants.roleAdmin;

  // Check if user is student
  bool get isStudent => role == AppConstants.roleStudent;

  // Copy with method for immutability
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? studentId,
    String? section,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      studentId: studentId ?? this.studentId,
      section: section ?? this.section,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert to JSON (for Firebase/API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'studentId': studentId,
      'section': section,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON (from Firebase/API)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      studentId: json['studentId'] as String?,
      section: json['section'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // For debugging
  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, role: $role)';
  }

  // Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.role == role &&
        other.studentId == studentId &&
        other.section == section;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        role.hashCode ^
        (studentId?.hashCode ?? 0) ^
        (section?.hashCode ?? 0);
  }
}