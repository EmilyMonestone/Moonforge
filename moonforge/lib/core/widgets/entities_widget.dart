import 'package:flutter/material.dart';
import 'package:moonforge/core/services/entity_gatherer.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/features/home/widgets/section_header.dart';
import 'package:moonforge/l10n/app_localizations.dart';

/// A reusable widget that displays entities grouped by kind
class EntitiesWidget extends StatelessWidget {
  const EntitiesWidget({required this.entities, super.key});

  final List<EntityWithOrigin> entities;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // De-duplicate by entity ID and keep the most specific origin when collisions occur.
    // Specificity order: scene > encounter > adventure > chapter > campaign/direct (null)
    int rank(EntityOrigin? o) {
      if (o == null) return 0; // direct on current part
      switch (o.partType) {
        case 'scene':
          return 5;
        case 'encounter':
          return 4;
        case 'adventure':
          return 3;
        case 'chapter':
          return 2;
        case 'campaign':
          return 1;
        default:
          return 1;
      }
    }

    final byId = <String, EntityWithOrigin>{};
    for (final ewo in entities) {
      final id = ewo.entity.id;
      final existing = byId[id];
      if (existing == null) {
        byId[id] = ewo;
      } else {
        // Keep the one with higher specificity
        if (rank(ewo.origin) > rank(existing.origin)) {
          byId[id] = ewo;
        }
      }
    }

    final unique = byId.values.toList(growable: false);

    // Group entities by kind
    final npcsMontersGroups = unique
        .where(
          (e) =>
              e.entity.kind == 'npc' ||
              e.entity.kind == 'monster' ||
              e.entity.kind == 'group',
        )
        .toList();

    final places = unique.where((e) => e.entity.kind == 'place').toList();

    final itemsOthers = unique
        .where(
          (e) =>
              e.entity.kind == 'item' ||
              e.entity.kind == 'handout' ||
              e.entity.kind == 'journal' ||
              (e.entity.kind != 'npc' &&
                  e.entity.kind != 'monster' &&
                  e.entity.kind != 'group' &&
                  e.entity.kind != 'place'),
        )
        .toList();

    if (unique.isEmpty) {
      return SurfaceContainer(
        title: SectionHeader(title: l10n.entities, icon: Icons.people_outline),
        child: Text(l10n.noEntitiesYet),
      );
    }

    return Column(
      children: [
        if (npcsMontersGroups.isNotEmpty)
          _EntityGroupWidget(
            title: 'NPCs, Monsters & Groups',
            icon: Icons.group_outlined,
            entities: npcsMontersGroups,
          ),
        if (places.isNotEmpty)
          _EntityGroupWidget(
            title: 'Places',
            icon: Icons.location_on_outlined,
            entities: places,
          ),
        if (itemsOthers.isNotEmpty)
          _EntityGroupWidget(
            title: 'Items & Others',
            icon: Icons.inventory_2_outlined,
            entities: itemsOthers,
          ),
      ],
    );
  }
}

/// Internal widget to display a group of entities
class _EntityGroupWidget extends StatelessWidget {
  const _EntityGroupWidget({
    required this.title,
    required this.icon,
    required this.entities,
  });

  final String title;
  final IconData icon;
  final List<EntityWithOrigin> entities;

  @override
  Widget build(BuildContext context) {
    return SurfaceContainer(
      title: SectionHeader(title: title, icon: icon),
      child: Column(
        children: [
          ...entities.map((entityWithOrigin) {
            final entity = entityWithOrigin.entity;
            final origin = entityWithOrigin.origin;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        EntityRouteData(entityId: entity.id).push(context);
                      },
                      hoverColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHigh,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            entity.name,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 8),
                          _KindChip(kind: entity.kind),
                          if (origin != null) ...[
                            const SizedBox(width: 6),
                            _OriginBadge(origin: origin),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Widget to display entity kind as a chip
class _KindChip extends StatelessWidget {
  const _KindChip({required this.kind});

  final String kind;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getKindColor(context, kind),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getKindLabel(kind),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: _getKindColorText(context, kind),
        ),
      ),
    );
  }

  String _getKindLabel(String kind) {
    switch (kind) {
      case 'npc':
        return 'NPC';
      case 'monster':
        return 'Monster';
      case 'group':
        return 'Group';
      case 'place':
        return 'Place';
      case 'item':
        return 'Item';
      case 'handout':
        return 'Handout';
      case 'journal':
        return 'Journal';
      default:
        return kind;
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

  Color _getKindColorText(BuildContext context, String kind) {
    switch (kind) {
      case 'npc':
      case 'monster':
      case 'group':
        return Theme.of(context).colorScheme.onPrimary;
      case 'place':
        return Theme.of(context).colorScheme.onSecondary;
      default:
        return Theme.of(context).colorScheme.onTertiary;
    }
  }
}

/// Widget to display origin badge
class _OriginBadge extends StatelessWidget {
  const _OriginBadge({required this.origin});

  final EntityOrigin origin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Text(
        origin.label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
