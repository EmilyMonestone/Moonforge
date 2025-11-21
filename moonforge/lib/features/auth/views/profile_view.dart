import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:moonforge/core/providers/auth_providers.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/features/auth/services/auth_service.dart';
import 'package:moonforge/features/auth/utils/auth_error_handler.dart';
import 'package:moonforge/features/auth/utils/auth_validators.dart';
import 'package:moonforge/features/auth/widgets/auth_form_field.dart';
import 'package:moonforge/features/auth/widgets/email_verification_banner.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

/// Screen for viewing and editing user profile information.
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _isEditingDisplayName = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.firebaseUser;
    if (user != null) {
      _displayNameController.text = user.displayName ?? '';
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _updateDisplayName() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _authService.updateDisplayName(_displayNameController.text);

      // Reload auth provider to reflect changes
      // final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await _authService.reloadUser();
      // Trigger UI update by rebuilding; provider listeners will update on auth state changes.

      if (mounted) {
        toastification.show(
          type: ToastificationType.success,
          title: const Text('Profile updated'),
          description: const Text('Your display name has been updated.'),
        );
        setState(() {
          _isEditingDisplayName = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Update failed'),
          description: Text(AuthErrorHandler.getErrorMessage(e)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _sendVerificationEmail() async {
    setState(() => _isLoading = true);
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
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _confirmDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _deleteAccount();
    }
  }

  Future<void> _deleteAccount() async {
    setState(() => _isLoading = true);
    try {
      await _authService.deleteAccount();
      if (mounted) {
        toastification.show(
          type: ToastificationType.success,
          title: const Text('Account deleted'),
          description: const Text('Your account has been deleted.'),
        );
        const HomeRouteData().go(context);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = AuthErrorHandler.getErrorMessage(e);
        if (AuthErrorHandler.requiresReauth(e)) {
          message =
              'This operation requires recent authentication. Please sign out and sign in again before deleting your account.';
        }
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Delete failed'),
          description: Text(message),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.firebaseUser;

    if (user == null) {
      return const Center(child: Text('Not signed in'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email verification banner
            EmailVerificationBanner(user: user),

            // Profile information card
            SurfaceContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile Information',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),

                  // Display Name
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isEditingDisplayName) ...[
                          AuthFormField(
                            controller: _displayNameController,
                            labelText: 'Display Name',
                            prefixIcon: Icons.person_outline,
                            validator: AuthValidators.validateDisplayName,
                            enabled: !_isLoading,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        setState(() {
                                          _displayNameController.text =
                                              user.displayName ?? '';
                                          _isEditingDisplayName = false;
                                        });
                                      },
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(width: 8),
                              FilledButton(
                                onPressed: _isLoading
                                    ? null
                                    : _updateDisplayName,
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Save'),
                              ),
                            ],
                          ),
                        ] else ...[
                          ListTile(
                            leading: const Icon(Icons.person_outline),
                            title: const Text('Display Name'),
                            subtitle: Text(
                              user.displayName?.isNotEmpty == true
                                  ? user.displayName!
                                  : 'Not set',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () {
                                setState(() {
                                  _isEditingDisplayName = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const Divider(),

                  // Email
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Email'),
                    subtitle: Text(user.email ?? 'No email'),
                    trailing: user.emailVerified
                        ? Icon(
                            Icons.verified,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : TextButton(
                            onPressed: _isLoading
                                ? null
                                : _sendVerificationEmail,
                            child: const Text('Verify'),
                          ),
                  ),

                  const Divider(),

                  // User ID
                  ListTile(
                    leading: const Icon(Icons.fingerprint),
                    title: const Text('User ID'),
                    subtitle: Text(
                      user.uid,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                    ),
                  ),

                  const Divider(),

                  // Account created
                  ListTile(
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: const Text('Account Created'),
                    subtitle: Text(
                      user.metadata.creationTime != null
                          ? _formatDate(user.metadata.creationTime!)
                          : 'Unknown',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Danger zone
            SurfaceContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Danger Zone',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Once you delete your account, there is no going back. Please be certain.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _confirmDeleteAccount,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete Account'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
