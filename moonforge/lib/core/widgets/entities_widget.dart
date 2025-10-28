import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart';
import 'package:moonforge/core/models/entity_with_origin.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/features/home/widgets/section_header.dart';
import 'package:moonforge/l10n/app_localizations.dart';

/// A reusable widget that displays entities grouped by kind
class EntitiesWidget extends StatelessWidget {
  const EntitiesWidget({
    required this.entities,
    super.key,
  });

  final List<EntityWithOrigin> entities;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Group entities by kind
    final npcsMontersGroups = entities
        .where((e) =>
            e.entity.kind == 'npc' ||
            e.entity.kind == 'monster' ||
            e.entity.kind == 'group')
        .toList();

    final places =
        entities.where((e) => e.entity.kind == 'place').toList();

    final itemsOthers = entities
        .where((e) =>
            e.entity.kind == 'item' ||
            e.entity.kind == 'handout' ||
            e.entity.kind == 'journal' ||
            (e.entity.kind != 'npc' &&
                e.entity.kind != 'monster' &&
                e.entity.kind != 'group' &&
                e.entity.kind != 'place'))
        .toList();

    if (entities.isEmpty) {
      return SurfaceContainer(
        title: SectionHeader(
          title: l10n.entities,
          icon: Icons.people_outline,
        ),
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
      title: SectionHeader(
        title: title,
        icon: icon,
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
        },
        children: [
          // Header row
          TableRow(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Name',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Kind',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Origin',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
          // Data rows
          ...entities.map((entityWithOrigin) {
            final entity = entityWithOrigin.entity;
            final origin = entityWithOrigin.origin;

            return TableRow(
              children: [
                InkWell(
                  onTap: () {
                    EntityRoute(entityId: entity.id).push(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      entity.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _KindChip(kind: entity.kind),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: origin != null
                      ? _OriginBadge(origin: origin)
                      : const Text('-'),
                ),
              ],
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
              color: Theme.of(context).colorScheme.onPrimary,
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
        return Colors.blue;
      case 'monster':
        return Colors.red;
      case 'group':
        return Colors.purple;
      case 'place':
        return Colors.green;
      case 'item':
        return Colors.orange;
      case 'handout':
        return Colors.amber;
      case 'journal':
        return Colors.teal;
      default:
        return Theme.of(context).colorScheme.secondary;
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
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
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
