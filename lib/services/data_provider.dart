import 'package:flutter/foundation.dart';
import 'package:thesis_attendance/models/student_model.dart';


// Global Data Provider (simulates backend)
class DataProvider extends ChangeNotifier {
  // Current logged-in student
  Student? _currentStudent;
  
  // Collections
  final List<Student> _students = [];
  final List<Event> _events = [];
  final List<AttendanceRecord> _attendanceRecords = [];
  final List<StudentDocument> _documents = [];
  final List<Sanction> _sanctions = [];
  final List<ApprovalRequest> _approvalRequests = [];

  // Getters
  Student? get currentStudent => _currentStudent;
  List<Student> get students => _students;
  List<Event> get events => _events;
  List<AttendanceRecord> get attendanceRecords => _attendanceRecords;
  List<StudentDocument> get documents => _documents;
  List<Sanction> get sanctions => _sanctions;
  List<ApprovalRequest> get approvalRequests => _approvalRequests;

  // Initialize with sample data
  DataProvider() {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    // Create sample student
    _currentStudent = Student(
      id: '1',
      studentId: '2024-12345',
      name: 'Juan Dela Cruz',
      email: 'juan.delacruz@isatu.edu.ph',
      phone: '+63 912 345 6789',
      address: 'Iloilo City, Philippines',
      program: 'BSCS',
      yearLevel: '4th Year',
      section: 'A',
      department: 'College of Information and Communications Technology',
      status: 'Active',
      gpa: 1.75,
      totalUnits: 21,
      emergencyContactName: 'Maria Dela Cruz (Mother)',
      emergencyContactNumber: '+63 918 765 4321',
    );

    _students.add(_currentStudent!);

    // Add more students
    _students.addAll([
      Student(
        id: '2',
        studentId: '2024-12346',
        name: 'Maria Santos',
        email: 'maria.santos@isatu.edu.ph',
        phone: '+63 912 345 6790',
        address: 'Iloilo City, Philippines',
        program: 'BSIT',
        yearLevel: '3rd Year',
        section: 'B',
        department: 'College of Information and Communications Technology',
        status: 'Active',
        gpa: 1.85,
        totalUnits: 18,
        emergencyContactName: 'Pedro Santos (Father)',
        emergencyContactNumber: '+63 918 765 4322',
      ),
      Student(
        id: '3',
        studentId: '2024-12347',
        name: 'Pedro Reyes',
        email: 'pedro.reyes@isatu.edu.ph',
        phone: '+63 912 345 6791',
        address: 'Iloilo City, Philippines',
        program: 'BSCS',
        yearLevel: '4th Year',
        section: 'A',
        department: 'College of Information and Communications Technology',
        status: 'Active',
        gpa: 1.95,
        totalUnits: 21,
        emergencyContactName: 'Ana Reyes (Mother)',
        emergencyContactNumber: '+63 918 765 4323',
      ),
    ]);

    // Create sample events
    final now = DateTime.now();
    _events.addAll([
      Event(
        id: '1',
        title: 'Flag Ceremony',
        description: 'Daily morning assembly for all ISATU students',
        date: now,
        startTime: '7:00 AM',
        endTime: '8:00 AM',
        lateCutoff: '7:45 AM',
        status: 'active',
        totalStudents: 1234,
        checkedIn: 1180,
        late: 32,
        absent: 22,
      ),
      Event(
        id: '2',
        title: 'Seminar',
        description: 'Professional development seminar',
        date: now,
        startTime: '9:00 AM',
        endTime: '10:30 AM',
        lateCutoff: '9:10 AM',
        status: 'upcoming',
        totalStudents: 450,
      ),
      Event(
        id: '3',
        title: 'Student Assembly',
        description: 'Monthly student assembly and announcements',
        date: now.add(const Duration(days: 1)),
        startTime: '10:00 AM',
        endTime: '11:00 AM',
        lateCutoff: '10:10 AM',
        status: 'upcoming',
        totalStudents: 1234,
      ),
    ]);

    // Create sample attendance records
    _attendanceRecords.addAll([
      AttendanceRecord(
        id: '1',
        studentId: '2024-12345',
        eventId: '1',
        eventName: 'Flag Ceremony',
        eventDate: now.subtract(const Duration(days: 1)),
        eventTime: '7:00 AM',
        status: 'present',
        checkInTime: now.subtract(const Duration(days: 1, hours: 17, minutes: 5)),
        remarks: null,
      ),
      AttendanceRecord(
        id: '2',
        studentId: '2024-12345',
        eventId: '2',
        eventName: 'Workshop Session',
        eventDate: now.subtract(const Duration(days: 2)),
        eventTime: '2:00 PM',
        status: 'late',
        checkInTime: now.subtract(const Duration(days: 2, hours: 10, minutes: 8)),
        remarks: 'Checked in 8 minutes late',
      ),
    ]);

    // Create sample documents
    _documents.addAll([
      StudentDocument(
        id: '1',
        studentId: '2024-12345',
        fileName: 'Certificate of Enrollment - SY 2025-2026',
        fileType: 'PDF',
        fileSize: '245 KB',
        category: 'Academic',
        uploadDate: now.subtract(const Duration(days: 5)),
        status: 'Verified',
        verifiedBy: 'Admin Sarah Cruz',
        verifiedDate: now.subtract(const Duration(days: 4)),
      ),
      StudentDocument(
        id: '2',
        studentId: '2024-12345',
        fileName: 'Medical Certificate',
        fileType: 'PDF',
        fileSize: '189 KB',
        category: 'Medical',
        uploadDate: now.subtract(const Duration(days: 7)),
        status: 'Pending',
      ),
    ]);
  }

  // Student Methods
  void setCurrentStudent(Student student) {
    _currentStudent = student;
    notifyListeners();
  }

  void updateStudentProfile(Student updatedStudent) {
    _currentStudent = updatedStudent;
    final index = _students.indexWhere((s) => s.id == updatedStudent.id);
    if (index != -1) {
      _students[index] = updatedStudent;
    }
    notifyListeners();
  }

  // Event Methods
  List<Event> getTodayEvents() {
    final now = DateTime.now();
    return _events.where((event) {
      return event.date.year == now.year &&
          event.date.month == now.month &&
          event.date.day == now.day;
    }).toList();
  }

  List<Event> getUpcomingEvents() {
    final now = DateTime.now();
    return _events.where((event) {
      return event.date.isAfter(now) && event.status == 'upcoming';
    }).toList();
  }

  Event? getEventById(String eventId) {
    try {
      return _events.firstWhere((event) => event.id == eventId);
    } catch (e) {
      return null;
    }
  }

  // Attendance Methods
  Future<bool> checkInToEvent(String studentId, String eventId) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    final event = getEventById(eventId);
    if (event == null) return false;

    final now = DateTime.now();
    final checkInTime = now;

    // Determine status based on check-in time
    String status = 'present';
    String? remarks;

    // Parse late cutoff time (simplified)
    final cutoffHour = int.parse(event.lateCutoff.split(':')[0]);
    final cutoffMinute = int.parse(event.lateCutoff.split(':')[1].split(' ')[0]);
    
    if (now.hour > cutoffHour || (now.hour == cutoffHour && now.minute > cutoffMinute)) {
      status = 'late';
      final minutesLate = (now.hour - cutoffHour) * 60 + (now.minute - cutoffMinute);
      remarks = 'Checked in $minutesLate minutes late';
    }

    final record = AttendanceRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: studentId,
      eventId: eventId,
      eventName: event.title,
      eventDate: event.date,
      eventTime: event.startTime,
      status: status,
      checkInTime: checkInTime,
      remarks: remarks,
    );

    _attendanceRecords.add(record);
    notifyListeners();
    return true;
  }

  bool isCheckedIn(String studentId, String eventId) {
    return _attendanceRecords.any(
      (record) => record.studentId == studentId && record.eventId == eventId,
    );
  }

  List<AttendanceRecord> getStudentAttendanceHistory(String studentId) {
    return _attendanceRecords
        .where((record) => record.studentId == studentId)
        .toList()
      ..sort((a, b) => b.eventDate.compareTo(a.eventDate));
  }

  Map<String, int> getAttendanceStats(String studentId) {
    final records = getStudentAttendanceHistory(studentId);
    final present = records.where((r) => r.status == 'present').length;
    final late = records.where((r) => r.status == 'late').length;
    final absent = records.where((r) => r.status == 'absent').length;
    final total = records.length;

    return {
      'total': total,
      'present': present,
      'late': late,
      'absent': absent,
      'rate': total > 0 ? ((present + late) / total * 100).round() : 0,
    };
  }

  // Document Methods
  Future<bool> uploadDocument(StudentDocument document) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));
    
    _documents.add(document);
    
    // Create approval request automatically
    final approvalRequest = ApprovalRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: document.studentId,
      studentName: _currentStudent?.name ?? '',
      type: 'Document Verification',
      category: document.fileName,
      reason: 'Document verification request',
      submittedDate: DateTime.now(),
      urgency: 'Medium',
      status: 'Pending',
      attachments: [document.id],
    );
    
    _approvalRequests.add(approvalRequest);
    notifyListeners();
    return true;
  }

  Future<bool> deleteDocument(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _documents.removeWhere((doc) => doc.id == documentId);
    notifyListeners();
    return true;
  }

  List<StudentDocument> getStudentDocuments(String studentId) {
    return _documents.where((doc) => doc.studentId == studentId).toList()
      ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
  }

  // Sanction Methods
  List<Sanction> getStudentSanctions(String studentId) {
    return _sanctions.where((s) => s.studentId == studentId).toList();
  }

  Future<bool> submitAppeal(String sanctionId, String reason, List<String>? attachments) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final sanctionIndex = _sanctions.indexWhere((s) => s.id == sanctionId);
    if (sanctionIndex == -1) return false;

    final sanction = _sanctions[sanctionIndex];
    final updatedSanction = Sanction(
      id: sanction.id,
      studentId: sanction.studentId,
      violationType: sanction.violationType,
      eventName: sanction.eventName,
      date: sanction.date,
      severity: sanction.severity,
      description: sanction.description,
      status: 'Appealed',
      resolution: sanction.resolution,
      appealReason: reason,
      appealDate: DateTime.now(),
      appealStatus: 'Pending',
    );

    _sanctions[sanctionIndex] = updatedSanction;

    // Create approval request
    final approvalRequest = ApprovalRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: sanction.studentId,
      studentName: _currentStudent?.name ?? '',
      type: 'Sanction Appeal',
      category: '${sanction.violationType} Appeal',
      reason: reason,
      submittedDate: DateTime.now(),
      urgency: sanction.severity == 'Major' ? 'High' : 'Medium',
      status: 'Pending',
      attachments: attachments,
    );

    _approvalRequests.add(approvalRequest);
    notifyListeners();
    return true;
  }

  // Approval Request Methods
  List<ApprovalRequest> getPendingApprovals() {
    return _approvalRequests.where((r) => r.status == 'Pending').toList();
  }

  List<ApprovalRequest> getStudentApprovalRequests(String studentId) {
    return _approvalRequests.where((r) => r.studentId == studentId).toList()
      ..sort((a, b) => b.submittedDate.compareTo(a.submittedDate));
  }

  Future<bool> approveRequest(String requestId, String adminName, String? notes) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final index = _approvalRequests.indexWhere((r) => r.id == requestId);
    if (index == -1) return false;

    final request = _approvalRequests[index];
    final updatedRequest = ApprovalRequest(
      id: request.id,
      studentId: request.studentId,
      studentName: request.studentName,
      type: request.type,
      category: request.category,
      reason: request.reason,
      submittedDate: request.submittedDate,
      urgency: request.urgency,
      status: 'Approved',
      attachments: request.attachments,
      approvedBy: adminName,
      approvedDate: DateTime.now(),
      notes: notes,
    );

    _approvalRequests[index] = updatedRequest;

    // If it's a document verification, update document status
    if (request.type == 'Document Verification' && request.attachments != null) {
      for (var docId in request.attachments!) {
        final docIndex = _documents.indexWhere((d) => d.id == docId);
        if (docIndex != -1) {
          final doc = _documents[docIndex];
          _documents[docIndex] = StudentDocument(
            id: doc.id,
            studentId: doc.studentId,
            fileName: doc.fileName,
            fileType: doc.fileType,
            fileSize: doc.fileSize,
            category: doc.category,
            uploadDate: doc.uploadDate,
            status: 'Verified',
            verifiedBy: adminName,
            verifiedDate: DateTime.now(),
          );
        }
      }
    }

    notifyListeners();
    return true;
  }

  Future<bool> rejectRequest(String requestId, String adminName, String reason) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final index = _approvalRequests.indexWhere((r) => r.id == requestId);
    if (index == -1) return false;

    final request = _approvalRequests[index];
    final updatedRequest = ApprovalRequest(
      id: request.id,
      studentId: request.studentId,
      studentName: request.studentName,
      type: request.type,
      category: request.category,
      reason: request.reason,
      submittedDate: request.submittedDate,
      urgency: request.urgency,
      status: 'Rejected',
      attachments: request.attachments,
      rejectedBy: adminName,
      rejectedDate: DateTime.now(),
      rejectionReason: reason,
    );

    _approvalRequests[index] = updatedRequest;

    // If it's a document verification, update document status
    if (request.type == 'Document Verification' && request.attachments != null) {
      for (var docId in request.attachments!) {
        final docIndex = _documents.indexWhere((d) => d.id == docId);
        if (docIndex != -1) {
          final doc = _documents[docIndex];
          _documents[docIndex] = StudentDocument(
            id: doc.id,
            studentId: doc.studentId,
            fileName: doc.fileName,
            fileType: doc.fileType,
            fileSize: doc.fileSize,
            category: doc.category,
            uploadDate: doc.uploadDate,
            status: 'Rejected',
            rejectionReason: reason,
          );
        }
      }
    }

    notifyListeners();
    return true;
  }
}

// Global instance
final dataProvider = DataProvider();