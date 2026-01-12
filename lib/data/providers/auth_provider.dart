// lib/data/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:thesis_attendance/core/constants/app_constants.dart';
import 'package:thesis_attendance/data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Check if current user is admin
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  // Check if current user is student
  bool get isStudent => _currentUser?.isStudent ?? false;

  /// Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // TODO: Replace with actual Firebase authentication
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock user data - replace with actual Firebase auth
      // For now, check if email contains "admin" for demo
      final isAdminUser = email.toLowerCase().contains('admin');
      
      _currentUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: isAdminUser ? 'Admin User' : 'Student User',
        email: email,
        role: isAdminUser ? AppConstants.roleAdmin : AppConstants.roleStudent,
        studentId: isAdminUser ? null : 'STU-2024-001',
        section: isAdminUser ? null : 'Section A',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

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

  /// Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? studentId,
    String? section,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // TODO: Replace with actual Firebase authentication
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        role: role,
        studentId: studentId,
        section: section,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

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

  /// Logout user
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with actual Firebase sign out
      await Future.delayed(const Duration(milliseconds: 500));

      _currentUser = null;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? studentId,
    String? section,
  }) async {
    if (_currentUser == null) return false;

    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with actual Firebase update
      await Future.delayed(const Duration(milliseconds: 500));

      _currentUser = _currentUser!.copyWith(
        name: name,
        email: email,
        studentId: studentId,
        section: section,
        updatedAt: DateTime.now(),
      );

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

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Check if user session is valid
  Future<bool> checkAuthStatus() async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with actual Firebase auth state check
      await Future.delayed(const Duration(milliseconds: 500));

      // For now, return false (not logged in)
      // In real implementation, check Firebase auth state
      _isLoading = false;
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}