import 'package:flutter/material.dart';
import 'package:moonforge/core/design/domain_visuals.dart';
import 'package:moonforge/core/models/domain_type.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/data/db/app_db.dart';

/// Card widget for displaying a chapter in lists
class ChapterCard extends StatelessWidget {
  const ChapterCard({
    super.key,
    required this.chapter,
    this.onTap,
    this.showOrder = true,
  });

  final Chapter chapter;
  final VoidCallback? onTap;
  final bool showOrder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      color: theme.colorScheme.surfaceContainer,
      child: ListTile(
        leading: showOrder
            ? CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                foregroundColor: theme.colorScheme.onPrimaryContainer,
                child: Text('${chapter.order + 1}'),
              )
            : Icon(DomainType.chapter.icon),
        title: Text(chapter.name, style: textTheme.titleMedium),
        subtitle: chapter.summary != null && chapter.summary!.isNotEmpty
            ? Text(
                chapter.summary!,
                style: textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: const Icon(Icons.chevron_right),
        onTap:
            onTap ??
            () {
              ChapterRouteData(chapterId: chapter.id).go(context);
            },
      ),
    );
  }
}
