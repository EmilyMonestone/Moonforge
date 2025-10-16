import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stream of the current [User] auth state (signed in/out).
final authStateProvider = StreamProvider<User?>((ref) {
  final auth = FirebaseAuth.instance;
  return auth.authStateChanges();
});

/// Convenience provider for the current [User?].
final currentUserProvider = Provider<User?>((ref) {
  return ref
      .watch(authStateProvider)
      .maybeWhen(data: (user) => user, orElse: () => null);
});

/// Whether a user is currently authenticated.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

/// Login with email and password.
final signInProvider =
    Provider<Future<UserCredential> Function(String email, String password)>((
      ref,
    ) {
      return (String email, String password) {
        final auth = FirebaseAuth.instance;
        return auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      };
    });

/// Register a new user with email and password.
final registerProvider =
    Provider<Future<UserCredential> Function(String email, String password)>((
      ref,
    ) {
      return (String email, String password) {
        final auth = FirebaseAuth.instance;
        return auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      };
    });

/// Sign out the current user.
final signOutProvider = Provider<Future<void> Function()>((ref) {
  return () {
    final auth = FirebaseAuth.instance;
    return auth.signOut();
  };
});

/// Send a password reset email.
final sendPasswordResetEmailProvider =
    Provider<Future<void> Function(String email)>((ref) {
      return (String email) {
        final auth = FirebaseAuth.instance;
        return auth.sendPasswordResetEmail(email: email);
      };
    });
