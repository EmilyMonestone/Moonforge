import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:moonforge/core/providers/auth_providers.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:provider/provider.dart';

/// A small auth-aware widget:
/// - If no user is logged in: shows a Login button.
/// - If a user is logged in: shows a profile button with a dropdown menu
///   containing user name + email (header), a link to profile settings,
///   and a logout action.
class AuthUserButton extends StatefulWidget {
  const AuthUserButton({super.key, required this.expanded});

  final bool expanded;

  @override
  State<AuthUserButton> createState() => _AuthUserButtonState();
}

class _AuthUserButtonState extends State<AuthUserButton> {
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _authProvider = Provider.of<AuthProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_authProvider.firebaseUser == null) {
      return FilledButton(
        onPressed: () => const LoginRoute().go(context),
        child: const Text('Login'),
      );
    }

    final firebaseUser = _authProvider.firebaseUser!;
    final displayName = firebaseUser.displayName?.trim();
    final email = firebaseUser.email?.trim();

    return PopupMenuButton<_AuthMenuAction>(
      tooltip: 'Account',
      onSelected: (value) async {
        switch (value) {
          case _AuthMenuAction.settings:
            const SettingsRoute().go(context);
            break;
          case _AuthMenuAction.logout:
            try {
              await _authProvider.signOut();
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
      child: _ProfileAvatar(user: firebaseUser, expanded: widget.expanded),
    );
  }
}

enum _AuthMenuAction { settings, logout }

class _ProfileAvatar extends StatefulWidget {
  const _ProfileAvatar({required this.user, required this.expanded});

  final User user;
  final bool expanded;

  @override
  State<_ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<_ProfileAvatar> {
  late Reference _storage;
  late String? photoUrl;
  static const oneMegabyte = 1024 * 1024;
  late Uint8List? imageData;

  @override
  void didChangeDependencies() {
    _storage = FirebaseStorage.instance.ref();
    photoUrl = widget.user.photoURL;
    _loadImage();
    super.didChangeDependencies();
  }

  Future<void> _loadImage() async {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      try {
        final ref = _storage.child(photoUrl!);
        final data = await ref.getData(oneMegabyte);
        if (data != null) {
          setState(() {
            imageData = data;
          });
        }
      } catch (e) {
        // Handle errors if necessary
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final initials = _initialsFrom(
      widget.user.displayName ?? widget.user.email ?? '',
    );

    final avatar = (photoUrl != null && photoUrl!.isNotEmpty)
        ? CircleAvatar(
            backgroundImage: imageData != null ? MemoryImage(imageData!) : null,
          )
        : CircleAvatar(child: Text(initials));

    if (widget.expanded) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 24, height: 24, child: avatar),
            const SizedBox(width: 8),
            Text(
              widget.user.displayName?.isNotEmpty == true
                  ? widget.user.displayName!
                  : (widget.user.email ?? 'Account'),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      );
    } else {
      return SizedBox(width: 40, height: 40, child: avatar);
    }
  }

  String _initialsFrom(String input) {
    final parts = input.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty) return '?';
    final take = parts.length >= 2 ? parts.take(2) : parts.take(1);
    return take.map((p) => p.isNotEmpty ? p[0].toUpperCase() : '').join();
  }
}
