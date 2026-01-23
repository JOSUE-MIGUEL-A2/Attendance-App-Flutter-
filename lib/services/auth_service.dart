// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thesis_attendance/services/firebase_service.dart';
import 'package:thesis_attendance/models/student_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseService.auth;
  final FirebaseFirestore _firestore = FirebaseService.firestore;

  // Sign In
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return {'success': false, 'message': 'Login failed'};
      }

      // Get user role
      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!userDoc.exists) {
        await _auth.signOut();
        return {'success': false, 'message': 'User not found'};
      }

      final role = userDoc.data()?['role'] ?? 'student';

      return {
        'success': true,
        'role': role,
        'uid': credential.user!.uid,
      };
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        default:
          message = e.message ?? 'An error occurred';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Sign Up (Student)
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String studentId,
    required String name,
    required String program,
    required String yearLevel,
    required String section,
  }) async {
    try {
      // Create auth user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return {'success': false, 'message': 'Registration failed'};
      }

      final uid = credential.user!.uid;

      // Create user document
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'role': 'student',
        'studentId': studentId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Create student document
      await _firestore.collection('students').doc(uid).set({
        'studentId': studentId,
        'name': name,
        'email': email,
        'program': program,
        'yearLevel': yearLevel,
        'section': section,
        'department': 'College of Information and Communications Technology',
        'status': 'Active',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Registration successful',
        'uid': uid,
      };
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      switch (e.code) {
        case 'email-already-in-use':
          message = 'An account already exists with this email';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        default:
          message = e.message ?? 'An error occurred';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get Current Student
  Future<Student?> getCurrentStudent() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('students').doc(user.uid).get();
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
    } catch (e) {
      print('Error getting current student: $e');
      return null;
    }
  }

  // Reset Password
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Password reset email sent',
      };
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': e.message ?? 'Failed to send reset email',
      };
    }
  }
}