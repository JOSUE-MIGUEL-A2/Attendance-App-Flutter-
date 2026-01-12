// lib/data/providers/event_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thesis_attendance/data/models/event_model.dart';

class EventProvider extends ChangeNotifier {
  List<EventModel> _events = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<EventModel> get events => List.unmodifiable(_events);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get active events only
  List<EventModel> get activeEvents {
    return _events.where((event) => event.isActive).toList();
  }

  // Get today's events
  List<EventModel> get todayEvents {
    return _events.where((event) => event.isToday && event.isActive).toList();
  }

  // Get upcoming events
  List<EventModel> get upcomingEvents {
    final events = _events.where((event) => event.isUpcoming && event.isActive).toList();
    events.sort((a, b) => a.date.compareTo(b.date));
    return events;
  }

  // Get past events
  List<EventModel> get pastEvents {
    final events = _events.where((event) => event.isPast).toList();
    events.sort((a, b) => b.date.compareTo(a.date)); // Most recent first
    return events;
  }

  /// Initialize with sample data (for testing)
  void initializeSampleData() {
    final now = DateTime.now();
    
    _events = [
      EventModel(
        id: '1',
        title: 'Flag Ceremony',
        description: 'Daily morning assembly for all ISATU students',
        date: now,
        startTime: const TimeOfDay(hour: 7, minute: 30),
        endTime: const TimeOfDay(hour: 8, minute: 0),
        lateCutoff: const TimeOfDay(hour: 7, minute: 45),
        createdBy: 'admin1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      EventModel(
        id: '2',
        title: 'Seminar',
        description: 'Kay maSeminaryo ta',
        date: now,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 30),
        lateCutoff: const TimeOfDay(hour: 9, minute: 10),
        createdBy: 'admin1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      EventModel(
        id: '3',
        title: 'School Event',
        description: 'Upcoming school-wide event',
        date: now.add(const Duration(days: 3)),
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 16, minute: 0),
        lateCutoff: const TimeOfDay(hour: 14, minute: 15),
        createdBy: 'admin1',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];
    
    notifyListeners();
  }

  /// Get event by ID
  EventModel? getEventById(String id) {
    try {
      return _events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add new event
  Future<bool> addEvent(EventModel event) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with Firebase add
      await Future.delayed(const Duration(milliseconds: 500));

      _events.add(event);
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

  /// Update event
  Future<bool> updateEvent(EventModel event) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with Firebase update
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        _events[index] = event.copyWith(updatedAt: DateTime.now());
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

  /// Delete event
  Future<bool> deleteEvent(String eventId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with Firebase delete
      await Future.delayed(const Duration(milliseconds: 500));

      _events.removeWhere((event) => event.id == eventId);

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

  /// Toggle event active status
  Future<bool> toggleEventStatus(String eventId) async {
    try {
      final event = getEventById(eventId);
      if (event == null) return false;

      return await updateEvent(event.copyWith(isActive: !event.isActive));
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Load events from repository
  Future<void> loadEvents() async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with Firebase fetch
      await Future.delayed(const Duration(seconds: 1));

      // For now, initialize with sample data
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