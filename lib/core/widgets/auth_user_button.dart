import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';

/// A small auth-aware widget:
/// - If no user is logged in: shows a Login button.
/// - If a user is logged in: shows a profile button with a dropdown menu
///   containing user name + email (header), a link to profile settings,
///   and a logout action.
class AuthUserButton extends StatelessWidget {
  const AuthUserButton({super.key});

  @override
  Widget build(BuildContext context) {
    Stream<User?>? authChanges;
    User? user;
    try {
      final auth = FirebaseAuth.instance;
      authChanges = auth.authStateChanges();
      user = auth.currentUser;
    } catch (_) {
      // Firebase might not be initialized (e.g., in tests). Fall back to null user.
      authChanges = null;
      user = null;
    }

    if (authChanges == null) {
      // No stream available, render based on current snapshot only.
      return _buildForUser(context, user);
    }

    return StreamBuilder<User?>(
      stream: authChanges,
      initialData: user,
      builder: (context, snapshot) {
        return _buildForUser(context, snapshot.data);
      },
    );
  }

  Widget _buildForUser(BuildContext context, User? user) {
    if (user == null) {
      return FilledButton(
        onPressed: () => const LoginRoute().go(context),
        child: const Text('Login'),
      );
    }

    final displayName = user.displayName?.trim();
    final email = user.email?.trim();

    return PopupMenuButton<_AuthMenuAction>(
      tooltip: 'Account',
      onSelected: (value) async {
        switch (value) {
          case _AuthMenuAction.settings:
            const SettingsRoute().go(context);
            break;
          case _AuthMenuAction.logout:
            try {
              await FirebaseAuth.instance.signOut();
            } catch (_) {}
            if (context.mounted) {
              const HomeRoute().go(context);
            }
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<_AuthMenuAction>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if ((displayName ?? '').isNotEmpty)
                Text(
                  displayName!,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              Text(
                (email ?? 'Unknown user'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<_AuthMenuAction>(
          value: _AuthMenuAction.settings,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.settings_outlined),
            title: Text('Profile settings'),
          ),
        ),
        const PopupMenuItem<_AuthMenuAction>(
          value: _AuthMenuAction.logout,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ),
      ],
      child: _ProfileAvatar(user: user),
    );
  }
}

enum _AuthMenuAction { settings, logout }

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final photoUrl = user.photoURL;
    final initials = _initialsFrom(user.displayName ?? user.email ?? '');

    final avatar = (photoUrl != null && photoUrl.isNotEmpty)
        ? CircleAvatar(backgroundImage: NetworkImage(photoUrl))
        : CircleAvatar(child: Text(initials));

    // Wrap in an OutlinedButton-style container to look like a button in rails.
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 24, height: 24, child: avatar),
          const SizedBox(width: 8),
          Text(
            user.displayName?.isNotEmpty == true
                ? user.displayName!
                : (user.email ?? 'Account'),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  String _initialsFrom(String input) {
    final parts = input.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty) return '?';
    final take = parts.length >= 2 ? parts.take(2) : parts.take(1);
    return take.map((p) => p.isNotEmpty ? p[0].toUpperCase() : '').join();
  }
}
