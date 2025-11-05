import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/data/db/app_db.dart';

/// A card widget for displaying an entity in lists and grids
class EntityCard extends StatelessWidget {
  const EntityCard({
    super.key,
    required this.entity,
    this.onTap,
    this.onLongPress,
    this.trailing,
  });

  final Entity entity;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap ??
            () {
              EntityRoute(entityId: entity.id).push(context);
            },
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _EntityTypeIcon(kind: entity.kind),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entity.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              if (entity.summary != null && entity.summary!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  entity.summary!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (entity.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: entity.tags.take(5).map((tag) {
                    return Chip(
                      label: Text(tag),
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Icon that represents an entity type
class _EntityTypeIcon extends StatelessWidget {
  const _EntityTypeIcon({required this.kind});

  final String kind;

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getKindIcon(kind),
      color: _getKindColor(context, kind),
      size: 20,
    );
  }

  IconData _getKindIcon(String kind) {
    switch (kind) {
      case 'npc':
        return Icons.person;
      case 'monster':
        return Icons.pets;
      case 'group':
        return Icons.groups;
      case 'place':
        return Icons.place;
      case 'item':
        return Icons.category;
      case 'handout':
        return Icons.description;
      case 'journal':
        return Icons.book;
      default:
        return Icons.fiber_manual_record;
    }
  }

  Color _getKindColor(BuildContext context, String kind) {
    switch (kind) {
      case 'npc':
      case 'monster':
      case 'group':
        return Theme.of(context).colorScheme.primary;
      case 'place':
        return Theme.of(context).colorScheme.secondary;
      default:
        return Theme.of(context).colorScheme.tertiary;
    }
  }
}
