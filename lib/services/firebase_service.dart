// lib/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;

  // Collections
  static CollectionReference get users => firestore.collection('users');
  static CollectionReference get students => firestore.collection('students');
  static CollectionReference get events => firestore.collection('events');
  static CollectionReference get attendance => firestore.collection('attendance');
  static CollectionReference get documents => firestore.collection('documents');
  static CollectionReference get sanctions => firestore.collection('sanctions');
  static CollectionReference get approvals => firestore.collection('approvals');

  // Current User
  static User? get currentUser => auth.currentUser;
  static String? get currentUserId => auth.currentUser?.uid;

  // Auth State Stream
  static Stream<User?> get authStateChanges => auth.authStateChanges();

  // ==================== PASSWORD MANAGEMENT ====================
  
  /// Change user password
  /// Requires re-authentication for security
  static Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final user = auth.currentUser;
    
    if (user == null) {
      throw Exception('No user logged in');
    }

    if (user.email == null) {
      throw Exception('User email not found');
    }

    // Re-authenticate user before changing password (required by Firebase)
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    try {
      // Re-authenticate
      await user.reauthenticateWithCredential(credential);
      
      // Update password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          throw Exception('Current password is incorrect');
        case 'weak-password':
          throw Exception('New password is too weak (minimum 6 characters)');
        case 'requires-recent-login':
          throw Exception('Please log out and log in again before changing password');
        default:
          throw Exception('Failed to change password: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // ==================== SIGN OUT ====================
  
  /// Sign out current user
  static Future<void> signOut() async {
    await auth.signOut();
  }
}