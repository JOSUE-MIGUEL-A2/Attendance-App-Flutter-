// lib/services/student_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thesis_attendance/services/firebase_service.dart';
import 'package:thesis_attendance/models/student_model.dart';

class StudentService {
  final FirebaseFirestore _firestore = FirebaseService.firestore;

  // Get Student Profile
  Stream<Student?> getStudentProfile(String uid) {
    return _firestore.collection('students').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      final data = doc.data()!;
      return Student(
        id: doc.id,
        studentId: data['studentId'] ?? '',
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'] ?? '',
        address: data['address'] ?? '',
        program: data['program'] ?? '',
        yearLevel: data['yearLevel'] ?? '',
        section: data['section'] ?? '',
        department: data['department'] ?? '',
        status: data['status'] ?? '',
        gpa: (data['gpa'] ?? 0).toDouble(),
        totalUnits: data['totalUnits'] ?? 0,
        emergencyContactName: data['emergencyContactName'] ?? '',
        emergencyContactNumber: data['emergencyContactNumber'] ?? '',
      );
    });
  }

  // Update Student Profile
  Future<bool> updateProfile({
    required String uid,
    String? name,
    String? phone,
    String? address,
    String? emergencyContactName,
    String? emergencyContactNumber,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (address != null) updates['address'] = address;
      if (emergencyContactName != null) {
        updates['emergencyContactName'] = emergencyContactName;
      }
      if (emergencyContactNumber != null) {
        updates['emergencyContactNumber'] = emergencyContactNumber;
      }

      if (updates.isNotEmpty) {
        updates['updatedAt'] = FieldValue.serverTimestamp();
        await _firestore.collection('students').doc(uid).update(updates);
      }

      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  // Get Today's Events
  Stream<List<Event>> getTodayEvents() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return _firestore
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Event(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          date: (data['date'] as Timestamp).toDate(),
          startTime: data['startTime'] ?? '',
          endTime: data['endTime'] ?? '',
          lateCutoff: data['lateCutoff'] ?? '',
          status: data['status'] ?? 'upcoming',
          totalStudents: data['totalStudents'] ?? 0,
          checkedIn: data['checkedIn'],
          late: data['late'],
          absent: data['absent'],
        );
      }).toList();
    });
  }

  // Get Upcoming Events
  Stream<List<Event>> getUpcomingEvents() {
    final now = DateTime.now();
    
    return _firestore
        .collection('events')
        .where('date', isGreaterThan: Timestamp.fromDate(now))
        .where('status', isEqualTo: 'upcoming')
        .orderBy('date', descending: false)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Event(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          date: (data['date'] as Timestamp).toDate(),
          startTime: data['startTime'] ?? '',
          endTime: data['endTime'] ?? '',
          lateCutoff: data['lateCutoff'] ?? '',
          status: data['status'] ?? 'upcoming',
          totalStudents: data['totalStudents'] ?? 0,
          checkedIn: data['checkedIn'],
          late: data['late'],
          absent: data['absent'],
        );
      }).toList();
    });
  }

  // Check if student is checked in
  Future<bool> isCheckedIn(String studentId, String eventId) async {
    try {
      final query = await _firestore
          .collection('attendance')
          .where('studentId', isEqualTo: studentId)
          .where('eventId', isEqualTo: eventId)
          .limit(1)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      print('Error checking attendance: $e');
      return false;
    }
  }

  // Check In to Event
  Future<Map<String, dynamic>> checkInToEvent({
    required String studentId,
    required String eventId,
  }) async {
    try {
      // Get event details
      final eventDoc = await _firestore.collection('events').doc(eventId).get();
      if (!eventDoc.exists) {
        return {'success': false, 'message': 'Event not found'};
      }

      final eventData = eventDoc.data()!;
      final now = DateTime.now();

      // Check if already checked in
      final existingAttendance = await _firestore
          .collection('attendance')
          .where('studentId', isEqualTo: studentId)
          .where('eventId', isEqualTo: eventId)
          .limit(1)
          .get();

      if (existingAttendance.docs.isNotEmpty) {
        return {'success': false, 'message': 'Already checked in'};
      }

      // Determine status (present or late)
      String status = 'present';
      String? remarks;

      // Simple time comparison
      final lateCutoff = eventData['lateCutoff'] ?? '';
      if (lateCutoff.isNotEmpty) {
        // This is simplified - you should parse the time properly
        status = 'late';
        remarks = 'Checked in late';
      }

      // Create attendance record
      final attendanceData = {
        'studentId': studentId,
        'eventId': eventId,
        'eventName': eventData['title'],
        'eventDate': eventData['date'],
        'eventTime': eventData['startTime'],
        'status': status,
        'checkInTime': Timestamp.fromDate(now),
        'remarks': remarks,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('attendance').add(attendanceData);

      // Update event counters
      await _firestore.collection('events').doc(eventId).update({
        if (status == 'present') 'checkedIn': FieldValue.increment(1),
        if (status == 'late') 'late': FieldValue.increment(1),
      });

      return {
        'success': true,
        'message': 'Successfully checked in',
        'status': status,
      };
    } catch (e) {
      print('Error checking in: $e');
      return {'success': false, 'message': 'Failed to check in'};
    }
  }

  // Get Attendance History
  Stream<List<AttendanceRecord>> getAttendanceHistory(String studentId) {
    return _firestore
        .collection('attendance')
        .where('studentId', isEqualTo: studentId)
        .orderBy('eventDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AttendanceRecord(
          id: doc.id,
          studentId: data['studentId'] ?? '',
          eventId: data['eventId'] ?? '',
          eventName: data['eventName'] ?? '',
          eventDate: (data['eventDate'] as Timestamp).toDate(),
          eventTime: data['eventTime'] ?? '',
          status: data['status'] ?? '',
          checkInTime: data['checkInTime'] != null
              ? (data['checkInTime'] as Timestamp).toDate()
              : null,
          remarks: data['remarks'],
        );
      }).toList();
    });
  }

  // Get Attendance Stats
  Future<Map<String, int>> getAttendanceStats(String studentId) async {
    try {
      final records = await _firestore
          .collection('attendance')
          .where('studentId', isEqualTo: studentId)
          .get();

      int total = records.docs.length;
      int present = 0;
      int late = 0;
      int absent = 0;

      for (var doc in records.docs) {
        final status = doc.data()['status'] ?? '';
        if (status == 'present') present++;
        if (status == 'late') late++;
        if (status == 'absent') absent++;
      }

      int rate = total > 0 ? ((present + late) / total * 100).round() : 0;

      return {
        'total': total,
        'present': present,
        'late': late,
        'absent': absent,
        'rate': rate,
      };
    } catch (e) {
      print('Error getting stats: $e');
      return {
        'total': 0,
        'present': 0,
        'late': 0,
        'absent': 0,
        'rate': 0,
      };
    }
  }

  // Get Student Documents
  Stream<List<StudentDocument>> getDocuments(String studentId) {
    return _firestore
        .collection('documents')
        .where('studentId', isEqualTo: studentId)
        .orderBy('uploadDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return StudentDocument(
          id: doc.id,
          studentId: data['studentId'] ?? '',
          fileName: data['fileName'] ?? '',
          fileType: data['fileType'] ?? '',
          fileSize: data['fileSize'] ?? '',
          category: data['category'] ?? '',
          uploadDate: (data['uploadDate'] as Timestamp).toDate(),
          status: data['status'] ?? 'Pending',
          verifiedBy: data['verifiedBy'],
          verifiedDate: data['verifiedDate'] != null
              ? (data['verifiedDate'] as Timestamp).toDate()
              : null,
          rejectionReason: data['rejectionReason'],
        );
      }).toList();
    });
  }

  // Upload Document
  Future<bool> uploadDocument(StudentDocument document) async {
    try {
      await _firestore.collection('documents').add({
        'studentId': document.studentId,
        'fileName': document.fileName,
        'fileType': document.fileType,
        'fileSize': document.fileSize,
        'category': document.category,
        'uploadDate': Timestamp.fromDate(document.uploadDate),
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error uploading document: $e');
      return false;
    }
  }

  // Delete Document
  Future<bool> deleteDocument(String documentId) async {
    try {
      await _firestore.collection('documents').doc(documentId).delete();
      return true;
    } catch (e) {
      print('Error deleting document: $e');
      return false;
    }
  }

  // Get Sanctions
  Stream<List<Sanction>> getSanctions(String studentId) {
    return _firestore
        .collection('sanctions')
        .where('studentId', isEqualTo: studentId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Sanction(
          id: doc.id,
          studentId: data['studentId'] ?? '',
          violationType: data['violationType'] ?? '',
          eventName: data['eventName'] ?? '',
          date: (data['date'] as Timestamp).toDate(),
          severity: data['severity'] ?? '',
          description: data['description'] ?? '',
          status: data['status'] ?? '',
          resolution: data['resolution'],
          appealReason: data['appealReason'],
          appealDate: data['appealDate'] != null
              ? (data['appealDate'] as Timestamp).toDate()
              : null,
          appealStatus: data['appealStatus'],
        );
      }).toList();
    });
  }
}