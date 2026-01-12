// lib/core/utils/date_formatter.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thesis_attendance/core/constants/app_constants.dart';

class DateFormatter {
  DateFormatter._();
  
  // Format TimeOfDay to string (12-hour format)
  static String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
  
  // Format DateTime to time string
  static String formatDateTime(DateTime dateTime, {bool use24Hour = false}) {
    if (use24Hour) {
      return DateFormat(AppConstants.timeFormat24Hour).format(dateTime);
    }
    return DateFormat(AppConstants.timeFormat12Hour).format(dateTime);
  }
  
  // Format date to short format (dd/MM/yyyy)
  static String formatDateShort(DateTime date) {
    return DateFormat(AppConstants.dateFormatShort).format(date);
  }
  
  // Format date to long format (MMMM dd, yyyy)
  static String formatDateLong(DateTime date) {
    return DateFormat(AppConstants.dateFormatLong).format(date);
  }
  
  // Format full date and time
  static String formatDateTimeFull(DateTime dateTime) {
    return DateFormat(AppConstants.dateTimeFormat).format(dateTime);
  }
  
  // Get relative time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
  
  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
  
  // Check if date is in the past
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }
  
  // Check if date is in the future
  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }
  
  // Get start of day
  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  
  // Get end of day
  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
  
  // Get days until date
  static int daysUntil(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(DateTime(now.year, now.month, now.day));
    return difference.inDays;
  }
  
  // Convert TimeOfDay to DateTime
  static DateTime timeOfDayToDateTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
}

// ================================================================
// lib/core/utils/validators.dart
// ================================================================

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

// ================================================================
// lib/core/utils/string_extensions.dart
// ================================================================

extension StringExtensions on String {
  // Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
  
  // Title case
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }
  
  // Truncate string
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }
  
  // Check if string is valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }
  
  // Remove whitespace
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }
}