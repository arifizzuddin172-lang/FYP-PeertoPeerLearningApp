import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No account found with this email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'invalid-credential':
          return 'Invalid email or password.';
        case 'invalid-email':
          return 'Invalid email address.';
        case 'user-disabled':
          return 'This account has been disabled.';
        default:
          return e.message ?? 'Login failed. Please try again.';
      }
    } on FirebaseException catch (e) {
      return e.message ?? 'Database error during login.';
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  static Future<String?> register({
    required String email,
    required String password,
    required String fullName,
    required String studentId,
    required String university,
    required String yearOfStudy,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final initials = fullName
          .trim()
          .split(' ')
          .map((w) => w.isNotEmpty ? w[0] : '')
          .take(2)
          .join()
          .toUpperCase();

      await _db.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'fullName': fullName,
        'studentId': studentId,
        'university': university,
        'yearOfStudy': yearOfStudy,
        'email': email,
        'avatarInitials': initials,
        'skillsPosted': 0,
        'sessions': 0,
        'connections': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null; // Success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'An account already exists with this email.';
        case 'weak-password':
          return 'Password is too weak.';
        case 'invalid-email':
          return 'Invalid email address.';
        default:
          return e.message ?? 'Registration failed. Please try again.';
      }
    } on FirebaseException catch (e) {
      // Catches Firestore permission-denied & network errors cleanly
      if (e.code == 'permission-denied') {
        return 'Account created, but database access was denied. Check Firestore security rules.';
      }
      return e.message ?? 'Database error during registration.';
    } catch (e) {
      return 'An unexpected error occurred: ${e.toString()}';
    }
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }
}