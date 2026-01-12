// lib/data/providers/notification_provider.dart
import 'package:flutter/foundation.dart';
import 'package:thesis_attendance/core/constants/app_constants.dart';
import 'package:thesis_attendance/data/models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<NotificationModel> get notifications => List.unmodifiable(_notifications);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get unread notifications
  List<NotificationModel> get unreadNotifications {
    return _notifications.where((n) => n.isUnread).toList();
  }

  // Get unread count
  int get unreadCount => unreadNotifications.length;

  // Get notifications by type
  List<NotificationModel> getNotificationsByType(String type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  /// Initialize with sample data
  void initializeSampleData(String userId) {
    final now = DateTime.now();
    
    _notifications = [
      NotificationModel(
        id: '1',
        userId: userId,
        title: 'Document Approved',
        message: 'Your excuse letter has been approved',
        type: AppConstants.notifApproval,
        timestamp: now.subtract(const Duration(hours: 2)),
        createdAt: now,
        updatedAt: now,
      ),
      NotificationModel(
        id: '2',
        userId: userId,
        title: 'Event Reminder',
        message: 'Morning Assembly starts in 1 hour',
        type: AppConstants.notifReminder,
        timestamp: now.subtract(const Duration(minutes: 30)),
        createdAt: now,
        updatedAt: now,
      ),
    ];
    
    notifyListeners();
  }

  /// Get notification by ID
  NotificationModel? getNotificationById(String id) {
    try {
      return _notifications.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get notifications for specific user
  List<NotificationModel> getUserNotifications(String userId) {
    return _notifications.where((n) => n.userId == userId).toList();
  }

  /// Add notification
  Future<bool> addNotification(NotificationModel notification) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with Firebase add
      await Future.delayed(const Duration(milliseconds: 300));

      _notifications.insert(0, notification); // Add to beginning
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

  /// Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final notification = getNotificationById(notificationId);
      if (notification == null) return false;

      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = notification.markAsRead();
        notifyListeners();
      }

      // TODO: Update in Firebase
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with Firebase batch update
      await Future.delayed(const Duration(milliseconds: 500));

      for (int i = 0; i < _notifications.length; i++) {
        if (_notifications[i].userId == userId && _notifications[i].isUnread) {
          _notifications[i] = _notifications[i].markAsRead();
        }
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

  /// Delete notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with Firebase delete
      await Future.delayed(const Duration(milliseconds: 300));

      _notifications.removeWhere((n) => n.id == notificationId);

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

  /// Send notification to user
  Future<bool> sendNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    String? relatedId,
  }) async {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      title: title,
      message: message,
      type: type,
      relatedId: relatedId,
      timestamp: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await addNotification(notification);
  }

  /// Send announcement to all users
  Future<bool> sendAnnouncement({
    required List<String> userIds,
    required String title,
    required String message,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with Firebase batch add
      await Future.delayed(const Duration(milliseconds: 500));

      for (final userId in userIds) {
        await sendNotification(
          userId: userId,
          title: title,
          message: message,
          type: AppConstants.notifAnnouncement,
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

  /// Load notifications
  Future<void> loadNotifications(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with Firebase fetch
      await Future.delayed(const Duration(seconds: 1));

      initializeSampleData(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear all notifications for user
  Future<void> clearAllNotifications(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with Firebase batch delete
      await Future.delayed(const Duration(milliseconds: 500));

      _notifications.removeWhere((n) => n.userId == userId);

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