// lib/core/constants/route_names.dart

class RouteNames {
  // Private constructor to prevent instantiation
  RouteNames._();
  
  // Auth routes
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  
  // Student routes
  static const String studentMain = '/student';
  static const String studentHome = '/student/home';
  static const String studentEvents = '/student/events';
  static const String studentHistory = '/student/history';
  static const String studentAnalytics = '/student/analytics';
  static const String studentDocuments = '/student/documents';
  static const String studentSanctions = '/student/sanctions';
  static const String studentNotifications = '/student/notifications';
  static const String studentProfile = '/student/profile';
  
  // Admin routes
  static const String adminMain = '/admin';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminEvents = '/admin/events';
  static const String adminMonitoring = '/admin/monitoring';
  static const String adminApprovals = '/admin/approvals';
  static const String adminSanctions = '/admin/sanctions';
  static const String adminStudents = '/admin/students';
  
  // Common routes
  static const String settings = '/settings';
  
  // Navigation helpers
  static String getInitialRouteForRole(String role) {
    switch (role) {
      case 'admin':
        return adminMain;
      case 'student':
        return studentMain;
      default:
        return welcome;
    }
  }
}