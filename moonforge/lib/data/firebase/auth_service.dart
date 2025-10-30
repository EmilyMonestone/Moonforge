import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Service for Firebase Authentication
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream of current user
  Stream<User?> get userStream => _auth.authStateChanges();

  /// Get current user (nullable)
  User? get currentUser => _auth.currentUser;

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      logger.i('User signed out');
    } catch (e, st) {
      logger.e('Sign out failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Wait for authentication to complete
  /// Returns the current user or null if timed out
  Future<User?> waitForAuth({Duration timeout = const Duration(seconds: 5)}) async {
    final user = _auth.currentUser;
    if (user != null) return user;

    try {
      return await _auth.authStateChanges()
          .firstWhere((user) => user != null)
          .timeout(timeout);
    } on TimeoutException {
      return null;
    }
  }
}
