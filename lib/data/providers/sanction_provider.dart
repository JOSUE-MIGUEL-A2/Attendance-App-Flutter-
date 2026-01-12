// lib/data/providers/sanction_provider.dart
import 'package:flutter/foundation.dart';
import 'package:thesis_attendance/core/constants/app_constants.dart';
import 'package:thesis_attendance/data/models/sanction_model.dart';

class SanctionProvider extends ChangeNotifier {
  List<SanctionModel> _sanctions = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<SanctionModel> get sanctions => List.unmodifiable(_sanctions);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get active sanctions
  List<SanctionModel> get activeSanctions {
    return _sanctions.where((s) => s.isActive).toList();
  }

  // Get resolved sanctions
  List<SanctionModel> get resolvedSanctions {
    return _sanctions.where((s) => s.isResolved).toList();
  }

  /// Initialize with sample data
  void initializeSampleData() {
    final now = DateTime.now();
    
    _sanctions = [
      SanctionModel(
        id: '1',
        studentId: 'student1',
        type: AppConstants.sanctionWarning,
        reason: '3 consecutive absences',
        requiredAction: 'Submit excuse letter',
        status: AppConstants.sanctionActive,
        issuedBy: 'admin1',
        issuedDate: now.subtract(const Duration(days: 5)),
        createdAt: now,
        updatedAt: now,
      ),
    ];
    
    notifyListeners();
  }

  /// Get sanction by ID
  SanctionModel? getSanctionById(String id) {
    try {
      return _sanctions.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get sanctions for specific student
  List<SanctionModel> getStudentSanctions(String studentId) {
    return _sanctions.where((s) => s.studentId == studentId).toList();
  }

  /// Get active sanctions for student
  List<SanctionModel> getStudentActiveSanctions(String studentId) {
    return _sanctions
        .where((s) => s.studentId == studentId && s.isActive)
        .toList();
  }

  /// Count active sanctions for student
  int getActiveSanctionCount(String studentId) {
    return getStudentActiveSanctions(studentId).length;
  }

  /// Issue sanction
  Future<bool> issueSanction(SanctionModel sanction) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with Firebase add
      await Future.delayed(const Duration(milliseconds: 500));

      _sanctions.add(sanction);
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

  /// Resolve sanction
  Future<bool> resolveSanction(String sanctionId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final sanction = getSanctionById(sanctionId);
      if (sanction == null) {
        _errorMessage = 'Sanction not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // TODO: Replace with Firebase update
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _sanctions.indexWhere((s) => s.id == sanctionId);
      if (index != -1) {
        _sanctions[index] = sanction.copyWith(
          status: AppConstants.sanctionResolved,
          resolvedDate: DateTime.now(),
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

  /// Update sanction
  Future<bool> updateSanction(SanctionModel sanction) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with Firebase update
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _sanctions.indexWhere((s) => s.id == sanction.id);
      if (index != -1) {
        _sanctions[index] = sanction.copyWith(
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

  /// Delete sanction
  Future<bool> deleteSanction(String sanctionId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with Firebase delete
      await Future.delayed(const Duration(milliseconds: 500));

      _sanctions.removeWhere((s) => s.id == sanctionId);

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

  /// Get sanction statistics
  Map<String, int> getSanctionStats() {
    return {
      'total': _sanctions.length,
      'active': activeSanctions.length,
      'resolved': resolvedSanctions.length,
      'warnings': _sanctions.where((s) => s.isWarning).length,
      'penalties': _sanctions.where((s) => s.isPenalty).length,
    };
  }

  /// Get student sanction statistics
  Map<String, int> getStudentSanctionStats(String studentId) {
    final studentSanctions = getStudentSanctions(studentId);
    
    return {
      'total': studentSanctions.length,
      'active': studentSanctions.where((s) => s.isActive).length,
      'resolved': studentSanctions.where((s) => s.isResolved).length,
      'warnings': studentSanctions.where((s) => s.isWarning).length,
      'penalties': studentSanctions.where((s) => s.isPenalty).length,
    };
  }

  /// Load sanctions
  Future<void> loadSanctions() async {
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