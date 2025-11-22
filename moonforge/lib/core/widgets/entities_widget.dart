import 'package:flutter/material.dart';
import 'package:moonforge/core/design/domain_visuals.dart';
import 'package:moonforge/core/models/domain_type.dart';
import 'package:moonforge/core/services/entity_gatherer.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/section_header.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/l10n/app_localizations.dart';

/// A reusable widget that displays entities grouped by kind
class EntitiesWidget extends StatelessWidget {
  const EntitiesWidget({required this.entities, super.key});

  final List<EntityWithOrigin> entities;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // De-duplicate by entity ID and keep the most appropriate origin.
    // Strategy: prefer origin that matches entity.originId directly (true origin)
    // Fall back to specificity ranking if no direct match
    int rank(EntityOrigin? o) {
      if (o == null) return 0; // direct
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

      // Check if this origin matches the entity's stored originId (true origin)
      bool isTrueOrigin(EntityWithOrigin e) {
        // Direct match: entity.originId == origin.partId
        return e.origin != null && e.entity.originId == e.origin!.partId;
      }

      if (existing == null) {
        byId[id] = ewo;
        logger.d(
          '[EntitiesWidget] Initial origin for entity=$id originId=${ewo.entity.originId} chosen=${ewo.origin?.partType}:${ewo.origin?.partId} label="${ewo.origin?.label}"',
        );
        continue;
      }

      final existingTrue = isTrueOrigin(existing);
      final newTrue = isTrueOrigin(ewo);

      if (existingTrue && !newTrue) {
        logger.d(
          '[EntitiesWidget] Keep existing TRUE origin for entity=$id (${existing.origin?.label})',
        );
        continue;
      } else if (newTrue && !existingTrue) {
        byId[id] = ewo;
        logger.d(
          '[EntitiesWidget] Replace with new TRUE origin for entity=$id (${ewo.origin?.label})',
        );
        continue;
      }

      // Neither explicitly true or both true; fall back to specificity rank
      if (rank(ewo.origin) > rank(existing.origin)) {
        byId[id] = ewo;
        logger.d(
          '[EntitiesWidget] Specificity override for entity=$id new=${ewo.origin?.label} old=${existing.origin?.label}',
        );
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
            icon: DomainType.entityGroup.icon,
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
            icon: DomainType.entityItem.icon,
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
                          KindChip(kind: entity.kind),
                          if (origin != null) ...[
                            const SizedBox(width: 6),
                            OriginBadge(origin: origin),
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
class KindChip extends StatelessWidget {
  const KindChip({super.key, required this.kind});

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
class OriginBadge extends StatelessWidget {
  const OriginBadge({super.key, required this.origin});

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
