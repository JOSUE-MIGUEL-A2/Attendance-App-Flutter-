// lib/core/utils/validators.dart
import 'package:thesis_attendance/core/constants/app_constants.dart';

class Validators {
  Validators._();
  
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    if (value.length > AppConstants.maxEmailLength) {
      return 'Email is too long';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }
  
  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    
    return null;
  }
  
  // Name validation
  static String? validateName(String? value, {String fieldName = 'Name'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (value.length > AppConstants.maxNameLength) {
      return '$fieldName is too long';
    }
    
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    
    return null;
  }
  
  // Required field validation
  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  // Description validation
  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }
    
    if (value.length > AppConstants.maxDescriptionLength) {
      return 'Description is too long (max ${AppConstants.maxDescriptionLength} characters)';
    }
    
    return null;
  }
  
  // Remarks validation (optional but with max length)
  static String? validateRemarks(String? value) {
    if (value != null && value.length > AppConstants.maxRemarksLength) {
      return 'Remarks is too long (max ${AppConstants.maxRemarksLength} characters)';
    }
    return null;
  }
  
  // Student ID validation
  static String? validateStudentId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Student ID is required';
    }
    
    if (value.length < 3) {
      return 'Student ID is too short';
    }
    
    return null;
  }
  
  // File size validation
  static String? validateFileSize(int fileSize) {
    if (fileSize > AppConstants.maxFileSize) {
      final maxSizeMB = (AppConstants.maxFileSize / (1024 * 1024)).toStringAsFixed(1);
      return 'File size exceeds maximum allowed size of ${maxSizeMB}MB';
    }
    return null;
  }
  
  // File type validation
  static String? validateFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    
    if (!AppConstants.allowedFileTypes.contains(extension)) {
      return 'Invalid file type. Allowed types: ${AppConstants.allowedFileTypes.join(', ')}';
    }
    
    return null;
  }
  
  // Phone number validation (optional)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    final phoneRegex = RegExp(r'^[0-9]{10,11}$');
    
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[^0-9]'), ''))) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }
  
  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
}