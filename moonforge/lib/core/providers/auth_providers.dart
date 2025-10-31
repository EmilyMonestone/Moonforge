import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/firebase/models/schema.dart';
import 'package:moonforge/data/firebase/models/user.dart' as user_model;
import 'package:moonforge/data/firebase/odm.dart';

/// Provider to manage authentication state and actions.
/// This provider uses Firebase Authentication to handle user sign-in,
/// sign-out, registration, and password reset functionalities.
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
  final odm = Odm.instance;
  user_model.User? _user;
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

  user_model.User? get user => _user;

  User? get firebaseUser => _firebaseUser;

  bool get isLoggedIn => _isLoggedIn;

  bool get isLoading => _isLoading;

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    _firebaseUser = firebaseUser;
    if (firebaseUser == null) {
      _user = null;
      _isLoggedIn = false;
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();
      // Load existing user or create a new one if missing
      final loaded = await odm.users(firebaseUser.uid).get();
      if (loaded == null) {
        _user = user_model.User(
          id: firebaseUser.uid,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await odm.users.insert(_user!);
      } else {
        _user = loaded;
      }
      _isLoggedIn = true;
    } catch (e, st) {
      logger.e('Failed to sync auth state: $e\n$st');
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
      _user = await odm.users(userCredential.user!.uid).get();
      // create a new user document if it doesn't exist
      if (_user == null) {
        _user = user_model.User(
          id: userCredential.user!.uid,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await odm.users.insert(_user!);
      }
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
      // After successful sign-in, set _user and _isLoggedIn accordingly
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
      _user = null;
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
          message: 'User is null after sign-in.',
        );
      }
      _user = await odm.users(userCredential.user!.uid).get();
      _isLoggedIn = true;
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
