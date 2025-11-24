import 'package:firebase_auth/firebase_auth.dart';
import 'package:moonforge/core/services/base_service.dart';

/// Service class that wraps Firebase Authentication operations.
///
/// Provides a clean interface for authentication operations with
/// consistent error handling and logging.
class AuthService extends BaseService {
  final FirebaseAuth _auth;

  @override
  String get serviceName => 'AuthService';

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
    return execute(() async {
      logInfo('Attempting sign in for: $email');
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

      logInfo('User signed in successfully: ${credential.user!.email}');
      return credential.user!;
    }, operationName: 'signInWithEmailAndPassword');
  }

  /// Registers a new user with email and password.
  ///
  /// Throws [FirebaseAuthException] on failure.
  Future<User> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return execute(() async {
      logInfo('Attempting registration for: $email');
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

      logInfo('User registered successfully: ${credential.user!.email}');
      return credential.user!;
    }, operationName: 'registerWithEmailAndPassword');
  }

  /// Sends a password reset email to the specified email address.
  ///
  /// Throws [FirebaseAuthException] on failure.
  Future<void> sendPasswordResetEmail({required String email}) async {
    return execute(() async {
      logInfo('Sending password reset email to: $email');
      await _auth.sendPasswordResetEmail(email: email.trim());
      logInfo('Password reset email sent to: $email');
    }, operationName: 'sendPasswordResetEmail');
  }

  /// Signs out the current user.
  ///
  /// Throws [FirebaseAuthException] on failure.
  Future<void> signOut() async {
    return execute(() async {
      logInfo('Signing out user: ${_auth.currentUser?.email}');
      await _auth.signOut();
      logInfo('User signed out successfully');
    }, operationName: 'signOut');
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
      logInfo('Email already verified for: ${user.email}');
      return;
    }

    return execute(() async {
      logInfo('Sending email verification to: ${user.email}');
      await user.sendEmailVerification();
      logInfo('Email verification sent to: ${user.email}');
    }, operationName: 'sendEmailVerification');
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

    return execute(() async {
      await user.reload();
      logInfo('User data reloaded');
    }, operationName: 'reloadUser');
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

    return execute(() async {
      logInfo('Updating display name to: $displayName');
      await user.updateDisplayName(displayName.trim());
      await user.reload();
      logInfo('Display name updated successfully');
    }, operationName: 'updateDisplayName');
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

    return execute(() async {
      logInfo('Updating photo URL');
      await user.updatePhotoURL(photoURL.trim());
      await user.reload();
      logInfo('Photo URL updated successfully');
    }, operationName: 'updatePhotoURL');
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

    return execute(() async {
      logInfo('Deleting account for: ${user.email}');
      await user.delete();
      logInfo('Account deleted successfully');
    }, operationName: 'deleteAccount');
  }
}
