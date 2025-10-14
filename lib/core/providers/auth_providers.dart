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
