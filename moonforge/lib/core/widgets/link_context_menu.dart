import 'package:flutter/material.dart';
import 'package:moonforge/core/services/multi_window_service.dart';
import 'package:moonforge/l10n/app_localizations.dart';

/// A wrapper widget that adds context menu support for opening links in new windows.
///
/// Usage:
/// ```dart
/// LinkContextMenu(
///   route: '/campaign/entity/123',
///   child: TextButton(
///     onPressed: () => context.go('/campaign/entity/123'),
///     child: Text('Open Entity'),
///   ),
/// )
/// ```
class LinkContextMenu extends StatelessWidget {
  const LinkContextMenu({
    super.key,
    required this.route,
    required this.child,
    this.enabled = true,
  });

  /// The route to open in a new window
  final String route;

  /// The child widget to wrap with context menu
  final Widget child;

  /// Whether the context menu is enabled
  final bool enabled;

  void _showContextMenu(BuildContext context, TapDownDetails details) {
    if (!enabled || !MultiWindowService.instance.isSupported) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;

    if (overlay == null) return;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        details.globalPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              const Icon(Icons.open_in_new, size: 20),
              const SizedBox(width: 12),
              Text(l10n.openInNewWindow),
            ],
          ),
          onTap: () {
            MultiWindowService.instance.openRouteInNewWindow(route);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!enabled || !MultiWindowService.instance.isSupported) {
      return child;
    }

    return GestureDetector(
      onSecondaryTapDown: _showContextMenu,
      child: child,
    );
  }
}
