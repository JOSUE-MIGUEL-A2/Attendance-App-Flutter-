// lib/core/constants/app_constants.dart

class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();
  
  // App Information
  static const String appName = 'ISATU Attendance System';
  static const String appVersion = '1.0.0';
  
  // Font Settings
  static const double minFontSize = 10.0;
  static const double maxFontSize = 24.0;
  static const double defaultFontSize = 14.0;
  static const String defaultFontFamily = 'Roboto';
  
  static const List<String> availableFonts = [
    'Roboto',
    'OpenSans',
    'Lato',
    'Poppins',
    'Montserrat',
  ];
  
  // Language Settings
  static const String defaultLanguage = 'English';
  static const List<String> availableLanguages = [
    'English',
    'Filipino',
    'Spanish',
    'Chinese',
  ];
  
  // User Roles
  static const String roleStudent = 'student';
  static const String roleAdmin = 'admin';
  
  // Attendance Status
  static const String statusPresent = 'present';
  static const String statusLate = 'late';
  static const String statusAbsent = 'absent';
  static const String statusExcused = 'excused';
  
  // Document Status
  static const String docStatusPending = 'pending';
  static const String docStatusApproved = 'approved';
  static const String docStatusRejected = 'rejected';
  
  // Sanction Types
  static const String sanctionWarning = 'warning';
  static const String sanctionPenalty = 'penalty';
  
  // Sanction Status
  static const String sanctionActive = 'active';
  static const String sanctionResolved = 'resolved';
  
  // Notification Types
  static const String notifApproval = 'approval';
  static const String notifReminder = 'reminder';
  static const String notifSanction = 'sanction';
  static const String notifAnnouncement = 'announcement';
  
  // Time Formats
  static const String timeFormat12Hour = 'hh:mm a';
  static const String timeFormat24Hour = 'HH:mm';
  static const String dateFormatShort = 'dd/MM/yyyy';
  static const String dateFormatLong = 'MMMM dd, yyyy';
  static const String dateTimeFormat = 'MMM dd, yyyy hh:mm a';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxEmailLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxRemarksLength = 1000;
  
  // File Upload
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedFileTypes = ['pdf', 'jpg', 'jpeg', 'png'];
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Cache Duration
  static const Duration cacheDuration = Duration(minutes: 5);
  
  // Animation Duration
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // SharedPreferences Keys
  static const String prefKeyFontSize = 'fontSize';
  static const String prefKeyFontFamily = 'fontFamily';
  static const String prefKeyShowAnimations = 'showAnimations';
  static const String prefKeyLanguage = 'language';
  static const String prefKeyIsDarkMode = 'isDarkMode';
  static const String prefKeyUserId = 'userId';
  static const String prefKeyUserToken = 'userToken';
  
  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorAuth = 'Authentication failed. Please login again.';
  static const String errorPermission = 'You do not have permission to perform this action.';
  static const String errorNotFound = 'Resource not found.';
  static const String errorInvalidInput = 'Invalid input. Please check your data.';
  
  // Success Messages
  static const String successLogin = 'Login successful!';
  static const String successLogout = 'Logged out successfully.';
  static const String successSave = 'Saved successfully!';
  static const String successDelete = 'Deleted successfully!';
  static const String successUpdate = 'Updated successfully!';
  
  // Firebase Collections (for future use)
  static const String collectionUsers = 'users';
  static const String collectionEvents = 'events';
  static const String collectionAttendance = 'attendance';
  static const String collectionDocuments = 'documents';
  static const String collectionSanctions = 'sanctions';
  static const String collectionNotifications = 'notifications';
  static const String collectionSettings = 'app_settings';
  
  // Asset Paths
  static const String assetLottieLogin = 'assets/login_animation.json';
  static const String assetLottieHome = 'assets/home.json';
  static const String assetLottieEvents = 'assets/events.json';
  static const String assetLottieHistory = 'assets/history.json';
  static const String assetLottieAnalytics = 'assets/analytics.json';
  static const String assetLottieMonitor = 'assets/monitor.json';
  static const String assetLottieApprovals = 'assets/approvals.json';
}