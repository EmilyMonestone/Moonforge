import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/features/auth/utils/auth_error_handler.dart';
import 'package:moonforge/features/auth/utils/auth_validators.dart';
import 'package:moonforge/features/auth/widgets/auth_form_field.dart';
import 'package:moonforge/features/auth/widgets/password_strength_indicator.dart';
import 'package:toastification/toastification.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Listen to password changes to update strength indicator
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      toastification.show(
        type: ToastificationType.success,
        title: const Text('Account created. Signed in.'),
      );

      // Let auth listeners react; optionally pop if possible
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        const HomeRoute().go(context);
      }
    } on FirebaseAuthException catch (e) {
      final message = _mapAuthError(e);
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: Text(message),
        );
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Registration failed'),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    return AuthErrorHandler.getErrorMessage(e);
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
                  Text('Join Moonforge', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  AuthFormField(
                    controller: _emailController,
                    labelText: 'Email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [
                      AutofillHints.username,
                      AutofillHints.email,
                    ],
                    validator: AuthValidators.validateEmail,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 12),
                  AuthFormField(
                    controller: _passwordController,
                    labelText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: AuthValidators.validatePassword,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 8),
                  PasswordStrengthIndicator(
                    password: _passwordController.text,
                  ),
                  const SizedBox(height: 12),
                  AuthFormField(
                    controller: _confirmController,
                    labelText: 'Confirm password',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: (v) => AuthValidators.validatePasswordConfirmation(
                      v,
                      _passwordController.text,
                    ),
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Create account'),
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
