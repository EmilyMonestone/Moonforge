import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart';
import 'package:moonforge/core/providers/auth_providers.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthProvider authProvider;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscure = true;

  @override
  void didChangeDependencies() {
    authProvider = Provider.of<AuthProvider>(context, listen: true);
    if (authProvider.isLoggedIn) {
      const HomeRoute().go(context);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'account-exists-with-different-credential':
        return 'Account exists with different sign-in method.';
      default:
        return e.message ?? 'Authentication error.';
    }
  }

  void _goToRegister() {
    const RegisterRoute().go(context);
  }

  void _goToForgotPassword() {
    const ForgotPasswordRoute().push(context);
  }

  void _signInWithPasswordAndEmail() {
    if (_formKey.currentState?.validate() ?? false) {
      authProvider
          .signInWithEmailAndPassword(
            _emailController.text,
            _passwordController.text,
          )
          .catchError((error) {
            if (error is FirebaseAuthException) {
              final message = _mapAuthError(error);
              NotificationService.showError(
                context,
                title: Text('Login Failed'),
                description: Text(message),
              );
            } else {
              NotificationService.showError(
                context,
                title: Text('Login Failed'),
                description: Text(error.toString()),
              );
            }
          });
      if (authProvider.isLoggedIn) {
        const HomeRoute().go(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome to Moonforge',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [
                      AutofillHints.username,
                      AutofillHints.email,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return 'Email required';
                      if (!value.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscure,
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    onFieldSubmitted: (_) => _signInWithPasswordAndEmail(),
                    validator: (v) {
                      if ((v ?? '').isEmpty) return 'Password required';
                      if ((v ?? '').length < 6) return 'Min 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () => _signInWithPasswordAndEmail(),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicatorM3E(
                              size: CircularProgressM3ESize.s,
                            ),
                          )
                        : const Text('Sign in'),
                  ),
                  const SizedBox(height: 8),
                  // package google sign-in does not support desktop platforms yet
                  /*                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _signInWithGoogle,
                    icon: const Icon(Icons.login),
                    label: const Text('Continue with Google'),
                  ),
                  const SizedBox(height: 8),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : _goToRegister,
                        child: const Text('Create account'),
                      ),
                      TextButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : _goToForgotPassword,
                        child: const Text('Forgot password?'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
