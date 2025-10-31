import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Provider to manage authentication state and actions.
/// This provider uses Firebase Authentication to handle user sign-in,
/// sign-out, registration, and password reset functionalities.
///
/// Note: With the new Drift-first architecture, we no longer maintain a custom
/// User model in the database. User data is managed by Firebase Auth only.
///
/// Example usage:
/// ```dart
/// final authProvider = Provider.of<AuthProvider>(context);
/// if (authProvider.isLoggedIn) {
///  // User is logged in
///  } else {
///  // User is not logged in
///  }
/// ```
class AuthProvider with ChangeNotifier {
  User? _firebaseUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  StreamSubscription<User?>? _authSub;

  AuthProvider() {
    // Ensure provider mirrors Firebase auth state across hot reloads and app restarts
    _authSub = FirebaseAuth.instance.authStateChanges().listen(
      _onAuthStateChanged,
      onError: (Object e, StackTrace st) {
        // Log but don't crash the stream
        logger.e('authStateChanges error: $e | stack: $st');
      },
    );

    // Seed initial state if already signed in (e.g., on hot restart)
    _onAuthStateChanged(FirebaseAuth.instance.currentUser);
  }

  User? get firebaseUser => _firebaseUser;

  bool get isLoggedIn => _isLoggedIn;

  bool get isLoading => _isLoading;

  String? get uid => _firebaseUser?.uid;

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    _firebaseUser = firebaseUser;
    _isLoggedIn = firebaseUser != null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) {
        throw FirebaseAuthException(
          code: 'USER_NULL',
          message: 'User is null after sign-in.',
        );
      }
      _firebaseUser = userCredential.user;
      _isLoggedIn = true;
      logger.i("User signed in: ${_firebaseUser?.email}");
    } catch (e) {
      _isLoggedIn = false;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Implement Google Sign-In logic here
      // After successful sign-in, set _firebaseUser and _isLoggedIn accordingly
    } catch (e) {
      _isLoggedIn = false;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseAuth.instance.signOut();
      _firebaseUser = null;
      _isLoggedIn = false;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) {
        throw FirebaseAuthException(
          code: 'USER_NULL',
          message: 'User is null after registration.',
        );
      }
      _firebaseUser = userCredential.user;
      _isLoggedIn = true;
      logger.i("User registered: ${_firebaseUser?.email}");
    } catch (e) {
      _isLoggedIn = false;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
