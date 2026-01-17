// Student Model
class Student {
  final String id;
  final String studentId;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String program;
  final String yearLevel;
  final String section;
  final String department;
  final String status;
  final double gpa;
  final int totalUnits;
  final String emergencyContactName;
  final String emergencyContactNumber;

  Student({
    required this.id,
    required this.studentId,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.program,
    required this.yearLevel,
    required this.section,
    required this.department,
    required this.status,
    required this.gpa,
    required this.totalUnits,
    required this.emergencyContactName,
    required this.emergencyContactNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'program': program,
      'yearLevel': yearLevel,
      'section': section,
      'department': department,
      'status': status,
      'gpa': gpa,
      'totalUnits': totalUnits,
      'emergencyContactName': emergencyContactName,
      'emergencyContactNumber': emergencyContactNumber,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      program: json['program'] ?? '',
      yearLevel: json['yearLevel'] ?? '',
      section: json['section'] ?? '',
      department: json['department'] ?? '',
      status: json['status'] ?? '',
      gpa: json['gpa']?.toDouble() ?? 0.0,
      totalUnits: json['totalUnits'] ?? 0,
      emergencyContactName: json['emergencyContactName'] ?? '',
      emergencyContactNumber: json['emergencyContactNumber'] ?? '',
    );
  }
}

// Event Model
class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String lateCutoff;
  final String status; // 'upcoming', 'active', 'completed'
  final int totalStudents;
  final int? checkedIn;
  final int? late;
  final int? absent;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.lateCutoff,
    required this.status,
    required this.totalStudents,
    this.checkedIn,
    this.late,
    this.absent,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'lateCutoff': lateCutoff,
      'status': status,
      'totalStudents': totalStudents,
      'checkedIn': checkedIn,
      'late': late,
      'absent': absent,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      lateCutoff: json['lateCutoff'] ?? '',
      status: json['status'] ?? '',
      totalStudents: json['totalStudents'] ?? 0,
      checkedIn: json['checkedIn'],
      late: json['late'],
      absent: json['absent'],
    );
  }
}

// Attendance Record Model
class AttendanceRecord {
  final String id;
  final String studentId;
  final String eventId;
  final String eventName;
  final DateTime eventDate;
  final String eventTime;
  final String status; // 'present', 'late', 'absent'
  final DateTime? checkInTime;
  final String? remarks;

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.status,
    this.checkInTime,
    this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'eventId': eventId,
      'eventName': eventName,
      'eventDate': eventDate.toIso8601String(),
      'eventTime': eventTime,
      'status': status,
      'checkInTime': checkInTime?.toIso8601String(),
      'remarks': remarks,
    };
  }

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      eventId: json['eventId'] ?? '',
      eventName: json['eventName'] ?? '',
      eventDate: DateTime.parse(json['eventDate']),
      eventTime: json['eventTime'] ?? '',
      status: json['status'] ?? '',
      checkInTime: json['checkInTime'] != null 
          ? DateTime.parse(json['checkInTime']) 
          : null,
      remarks: json['remarks'],
    );
  }
}

// Document Model
class StudentDocument {
  final String id;
  final String studentId;
  final String fileName;
  final String fileType;
  final String fileSize;
  final String category; // 'Academic', 'Medical', 'Certificates', 'Clearance'
  final DateTime uploadDate;
  final String status; // 'Verified', 'Pending', 'Rejected'
  final String? verifiedBy;
  final DateTime? verifiedDate;
  final String? rejectionReason;

  StudentDocument({
    required this.id,
    required this.studentId,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.category,
    required this.uploadDate,
    required this.status,
    this.verifiedBy,
    this.verifiedDate,
    this.rejectionReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'fileName': fileName,
      'fileType': fileType,
      'fileSize': fileSize,
      'category': category,
      'uploadDate': uploadDate.toIso8601String(),
      'status': status,
      'verifiedBy': verifiedBy,
      'verifiedDate': verifiedDate?.toIso8601String(),
      'rejectionReason': rejectionReason,
    };
  }

  factory StudentDocument.fromJson(Map<String, dynamic> json) {
    return StudentDocument(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      fileName: json['fileName'] ?? '',
      fileType: json['fileType'] ?? '',
      fileSize: json['fileSize'] ?? '',
      category: json['category'] ?? '',
      uploadDate: DateTime.parse(json['uploadDate']),
      status: json['status'] ?? '',
      verifiedBy: json['verifiedBy'],
      verifiedDate: json['verifiedDate'] != null 
          ? DateTime.parse(json['verifiedDate']) 
          : null,
      rejectionReason: json['rejectionReason'],
    );
  }
}

// Sanction Model
class Sanction {
  final String id;
  final String studentId;
  final String violationType;
  final String eventName;
  final DateTime date;
  final String severity; // 'Minor', 'Major'
  final String description;
  final String status; // 'Active', 'Resolved', 'Appealed'
  final String? resolution;
  final String? appealReason;
  final DateTime? appealDate;
  final String? appealStatus; // 'Pending', 'Approved', 'Rejected'

  Sanction({
    required this.id,
    required this.studentId,
    required this.violationType,
    required this.eventName,
    required this.date,
    required this.severity,
    required this.description,
    required this.status,
    this.resolution,
    this.appealReason,
    this.appealDate,
    this.appealStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'violationType': violationType,
      'eventName': eventName,
      'date': date.toIso8601String(),
      'severity': severity,
      'description': description,
      'status': status,
      'resolution': resolution,
      'appealReason': appealReason,
      'appealDate': appealDate?.toIso8601String(),
      'appealStatus': appealStatus,
    };
  }

  factory Sanction.fromJson(Map<String, dynamic> json) {
    return Sanction(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      violationType: json['violationType'] ?? '',
      eventName: json['eventName'] ?? '',
      date: DateTime.parse(json['date']),
      severity: json['severity'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      resolution: json['resolution'],
      appealReason: json['appealReason'],
      appealDate: json['appealDate'] != null 
          ? DateTime.parse(json['appealDate']) 
          : null,
      appealStatus: json['appealStatus'],
    );
  }
}

// Approval Request Model
class ApprovalRequest {
  final String id;
  final String studentId;
  final String studentName;
  final String type; // 'Document Verification', 'Sanction Appeal', 'Clearance Request'
  final String category;
  final String reason;
  final DateTime submittedDate;
  final String urgency; // 'High', 'Medium', 'Low'
  final String status; // 'Pending', 'Approved', 'Rejected'
  final List<String>? attachments;
  final String? approvedBy;
  final DateTime? approvedDate;
  final String? rejectedBy;
  final DateTime? rejectedDate;
  final String? rejectionReason;
  final String? notes;

  ApprovalRequest({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.type,
    required this.category,
    required this.reason,
    required this.submittedDate,
    required this.urgency,
    required this.status,
    this.attachments,
    this.approvedBy,
    this.approvedDate,
    this.rejectedBy,
    this.rejectedDate,
    this.rejectionReason,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'type': type,
      'category': category,
      'reason': reason,
      'submittedDate': submittedDate.toIso8601String(),
      'urgency': urgency,
      'status': status,
      'attachments': attachments,
      'approvedBy': approvedBy,
      'approvedDate': approvedDate?.toIso8601String(),
      'rejectedBy': rejectedBy,
      'rejectedDate': rejectedDate?.toIso8601String(),
      'rejectionReason': rejectionReason,
      'notes': notes,
    };
  }

  factory ApprovalRequest.fromJson(Map<String, dynamic> json) {
    return ApprovalRequest(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      reason: json['reason'] ?? '',
      submittedDate: DateTime.parse(json['submittedDate']),
      urgency: json['urgency'] ?? '',
      status: json['status'] ?? '',
      attachments: json['attachments'] != null 
          ? List<String>.from(json['attachments']) 
          : null,
      approvedBy: json['approvedBy'],
      approvedDate: json['approvedDate'] != null 
          ? DateTime.parse(json['approvedDate']) 
          : null,
      rejectedBy: json['rejectedBy'],
      rejectedDate: json['rejectedDate'] != null 
          ? DateTime.parse(json['rejectedDate']) 
          : null,
      rejectionReason: json['rejectionReason'],
      notes: json['notes'],
    );
  }
}