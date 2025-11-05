import 'package:firebase_auth/firebase_auth.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/features/auth/utils/auth_error_handler.dart';

/// Service class that wraps Firebase Authentication operations.
///
/// Provides a clean interface for authentication operations with
/// consistent error handling and logging.
class AuthService {
  final FirebaseAuth _auth;

  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  /// Returns the current authenticated user, if any.
  User? get currentUser => _auth.currentUser;

  /// Stream of authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Signs in a user with email and password.
  ///
  /// Throws [FirebaseAuthException] on failure.
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      logger.d('Attempting sign in for: $email');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user == null) {
        throw FirebaseAuthException(
          code: 'USER_NULL',
          message: 'User is null after sign-in.',
        );
      }

      logger.i('User signed in successfully: ${credential.user!.email}');
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      logger.e('Sign in failed: ${AuthErrorHandler.getErrorCode(e)}');
      rethrow;
    }
  }

  /// Registers a new user with email and password.
  ///
  /// Throws [FirebaseAuthException] on failure.
  Future<User> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      logger.d('Attempting registration for: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user == null) {
        throw FirebaseAuthException(
          code: 'USER_NULL',
          message: 'User is null after registration.',
        );
      }

      logger.i('User registered successfully: ${credential.user!.email}');
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      logger.e('Registration failed: ${AuthErrorHandler.getErrorCode(e)}');
      rethrow;
    }
  }

  /// Sends a password reset email to the specified email address.
  ///
  /// Throws [FirebaseAuthException] on failure.
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      logger.d('Sending password reset email to: $email');
      await _auth.sendPasswordResetEmail(email: email.trim());
      logger.i('Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      logger.e('Password reset failed: ${AuthErrorHandler.getErrorCode(e)}');
      rethrow;
    }
  }

  /// Signs out the current user.
  ///
  /// Throws [FirebaseAuthException] on failure.
  Future<void> signOut() async {
    try {
      logger.d('Signing out user: ${_auth.currentUser?.email}');
      await _auth.signOut();
      logger.i('User signed out successfully');
    } on FirebaseAuthException catch (e) {
      logger.e('Sign out failed: ${AuthErrorHandler.getErrorCode(e)}');
      rethrow;
    }
  }

  /// Sends an email verification to the current user.
  ///
  /// Throws [FirebaseAuthException] on failure.
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'USER_NULL',
        message: 'No user is currently signed in.',
      );
    }

    if (user.emailVerified) {
      logger.d('Email already verified for: ${user.email}');
      return;
    }

    try {
      logger.d('Sending email verification to: ${user.email}');
      await user.sendEmailVerification();
      logger.i('Email verification sent to: ${user.email}');
    } on FirebaseAuthException catch (e) {
      logger.e('Email verification failed: ${AuthErrorHandler.getErrorCode(e)}');
      rethrow;
    }
  }

  /// Reloads the current user's information from Firebase.
  ///
  /// Useful for checking if email has been verified.
  Future<void> reloadUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'USER_NULL',
        message: 'No user is currently signed in.',
      );
    }

    try {
      await user.reload();
      logger.d('User data reloaded');
    } on FirebaseAuthException catch (e) {
      logger.e('User reload failed: ${AuthErrorHandler.getErrorCode(e)}');
      rethrow;
    }
  }

  /// Updates the current user's display name.
  ///
  /// Throws [FirebaseAuthException] on failure.
  Future<void> updateDisplayName(String displayName) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'USER_NULL',
        message: 'No user is currently signed in.',
      );
    }

    try {
      logger.d('Updating display name to: $displayName');
      await user.updateDisplayName(displayName.trim());
      await user.reload();
      logger.i('Display name updated successfully');
    } on FirebaseAuthException catch (e) {
      logger.e('Display name update failed: ${AuthErrorHandler.getErrorCode(e)}');
      rethrow;
    }
  }

  /// Updates the current user's photo URL.
  ///
  /// Throws [FirebaseAuthException] on failure.
  Future<void> updatePhotoURL(String photoURL) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'USER_NULL',
        message: 'No user is currently signed in.',
      );
    }

    try {
      logger.d('Updating photo URL');
      await user.updatePhotoURL(photoURL.trim());
      await user.reload();
      logger.i('Photo URL updated successfully');
    } on FirebaseAuthException catch (e) {
      logger.e('Photo URL update failed: ${AuthErrorHandler.getErrorCode(e)}');
      rethrow;
    }
  }

  /// Deletes the current user's account.
  ///
  /// Throws [FirebaseAuthException] on failure.
  /// May require recent authentication.
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'USER_NULL',
        message: 'No user is currently signed in.',
      );
    }

    try {
      logger.d('Deleting account for: ${user.email}');
      await user.delete();
      logger.i('Account deleted successfully');
    } on FirebaseAuthException catch (e) {
      logger.e('Account deletion failed: ${AuthErrorHandler.getErrorCode(e)}');
      rethrow;
    }
  }
}
