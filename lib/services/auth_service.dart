// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  // Sign up with email and password
  Future<User?> signUp(String email, String password, String displayName) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(displayName);

      return userCredential.user != null
          ? User(
        uid: userCredential.user!.uid,
        email: email,
        displayName: displayName,
        lastSynced: DateTime.now(),
      )
          : null;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user != null
          ? User(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
        displayName: userCredential.user!.displayName ?? 'User',
        lastSynced: DateTime.now(),
      )
          : null;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Check if user is signed in
  bool isSignedIn() {
    return _firebaseAuth.currentUser != null;
  }

  // Get current user
  User? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return User(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName ?? 'User',
      lastSynced: DateTime.now(),
    );
  }
}