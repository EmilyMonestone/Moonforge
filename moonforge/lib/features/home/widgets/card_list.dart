import 'package:flutter/material.dart';

/// Generic card list used to render simple lists with title/subtitle and a chevron.
class CardList<T> extends StatelessWidget {
  const CardList({
    super.key,
    required this.items,
    required this.titleOf,
    this.onTap,
    this.subtitleOf,
    this.backgroundColor,
  });

  final List<T> items;
  final String Function(T item) titleOf;
  final String Function(T item)? subtitleOf;
  final void Function(T item)? onTap;
  final Color? backgroundColor;

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
        return Card(
          color:
              backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
          child: ListTile(
            title: Text(title, style: textTheme.titleMedium),
            subtitle: Text(subtitle, style: textTheme.bodyMedium),
            trailing: const Icon(Icons.chevron_right),
            onTap: onTap != null ? () => onTap!(item) : null,
          ),
        );
      },
    );
  }
}
