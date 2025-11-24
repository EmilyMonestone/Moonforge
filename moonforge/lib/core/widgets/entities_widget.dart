import 'package:flutter/material.dart';
import 'package:moonforge/core/services/entity_gatherer.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/entities/entity_deduper.dart';
import 'package:moonforge/core/widgets/entities/entity_group_widget.dart';
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

    final unique = dedupeEntities(entities);

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
          EntityGroupWidget(
            title: 'NPCs, Monsters & Groups',
            icon: Icons.groups,
            entities: npcsMontersGroups,
          ),
        if (places.isNotEmpty)
          EntityGroupWidget(
            title: 'Places',
            icon: Icons.location_on_outlined,
            entities: places,
          ),
        if (itemsOthers.isNotEmpty)
          EntityGroupWidget(
            title: 'Items & Others',
            icon: Icons.inventory_2_outlined,
            entities: itemsOthers,
          ),
      ],
    );
  }
}

// entity badges moved to entity_badges.dart; imported where needed to avoid circular exports
