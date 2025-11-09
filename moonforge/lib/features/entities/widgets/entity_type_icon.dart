import 'package:flutter/material.dart';

/// Widget that displays an icon representing an entity type/kind
class EntityTypeIcon extends StatelessWidget {
  const EntityTypeIcon({
    super.key,
    required this.kind,
    this.size,
    this.color,
  });

  final String kind;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getKindIcon(kind),
      color: color ?? _getKindColor(context, kind),
      size: size ?? 24,
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

/// Returns the appropriate icon for an entity kind
IconData getEntityKindIcon(String kind) {
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

/// Returns the appropriate color for an entity kind
Color getEntityKindColor(BuildContext context, String kind) {
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

/// Returns a human-readable label for an entity kind
String getEntityKindLabel(String kind) {
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
