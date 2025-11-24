import 'package:flutter/material.dart';
import 'package:moonforge/core/services/entity_gatherer.dart';

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
