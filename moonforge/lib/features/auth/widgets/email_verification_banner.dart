import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moonforge/features/auth/services/auth_service.dart';
import 'package:moonforge/features/auth/utils/auth_error_handler.dart';
import 'package:toastification/toastification.dart';

/// A banner widget that prompts users to verify their email address.
///
/// Shows a dismissible alert with option to resend verification email.
class EmailVerificationBanner extends StatefulWidget {
  const EmailVerificationBanner({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<EmailVerificationBanner> createState() =>
      _EmailVerificationBannerState();
}

class _EmailVerificationBannerState extends State<EmailVerificationBanner> {
  bool _isDismissed = false;
  bool _isSending = false;
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    // Don't show if email is verified or banner is dismissed
    if (widget.user.emailVerified || _isDismissed) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: theme.colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Email not verified',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Please verify your email address to access all features.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: _isSending ? null : _resendVerificationEmail,
            child: _isSending
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  )
                : Text(
                    'Resend',
                    style: TextStyle(
                      color: theme.colorScheme.onErrorContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: theme.colorScheme.onErrorContainer,
            ),
            onPressed: () {
              setState(() {
                _isDismissed = true;
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _resendVerificationEmail() async {
    setState(() {
      _isSending = true;
    });

    try {
      await _authService.sendEmailVerification();
      if (mounted) {
        toastification.show(
          type: ToastificationType.success,
          title: const Text('Verification email sent'),
          description: const Text('Please check your email inbox.'),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Failed to send verification email'),
          description: Text(AuthErrorHandler.getErrorMessage(e)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }
}
