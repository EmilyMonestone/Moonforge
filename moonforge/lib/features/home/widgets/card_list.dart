import 'package:flutter/material.dart';
import 'package:moonforge/core/widgets/link_context_menu.dart';

/// Generic card list used to render simple lists with title/subtitle and a chevron.
class CardList<T> extends StatelessWidget {
  const CardList({
    super.key,
    required this.items,
    required this.titleOf,
    this.onTap,
    this.subtitleOf,
    this.subtitleMaxLines = 2,
    this.backgroundColor,
    this.routeOf,
    this.enableContextMenu = false,
  });

  final List<T> items;
  final String Function(T item) titleOf;
  final String Function(T item)? subtitleOf;
  final int subtitleMaxLines;
  final void Function(T item)? onTap;
  final Color? backgroundColor;

  /// Optional route provider for context menu support.
  /// If provided with [enableContextMenu] = true, enables "Open in new window".
  final String Function(T item)? routeOf;

  /// Whether to enable the context menu for opening items in new windows.
  final bool enableContextMenu;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        final title = titleOf(item);
        final subtitle = subtitleOf != null ? subtitleOf!(item) : '';

        final card = Card(
          color:
              backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
          child: ListTile(
            title: Text(title, style: textTheme.titleMedium),
            subtitle: Text(
              subtitle,
              style: textTheme.bodyMedium,
              maxLines: subtitleMaxLines,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: onTap != null ? () => onTap!(item) : null,
          ),
        );

        // Wrap with context menu if enabled and route provider is available
        if (enableContextMenu && routeOf != null) {
          return LinkContextMenu(route: routeOf!(item), child: card);
        }

        return card;
      },
    );
  }
}
