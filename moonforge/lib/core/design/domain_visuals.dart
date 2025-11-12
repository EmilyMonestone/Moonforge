import 'package:flutter/material.dart';
import 'package:moonforge/core/models/domain_type.dart';

/// Visual configuration for a domain type.
///
/// Contains the icon and optional color associated with a specific domain type.
class DomainVisualConfig {
  /// The icon data for this domain type
  final IconData icon;

  /// Optional color for this domain type (can be null to use theme colors)
  final Color? color;

  /// Optional semantic label for the icon (for accessibility)
  final String? semanticLabel;

  const DomainVisualConfig({
    required this.icon,
    this.color,
    this.semanticLabel,
  });
}

/// Centralized registry for domain type visual identities.
///
/// This class provides a single source of truth for icons and colors
/// associated with each domain type in the application. Use the extension
/// methods on [DomainType] for convenient access.
///
/// Example usage:
/// ```dart
/// // Get visuals for a campaign
/// final visuals = DomainType.campaign.visuals;
/// Icon(visuals.icon, color: visuals.color);
///
/// // Or use convenience getters
/// Icon(DomainType.campaign.icon);
/// ```
class DomainVisuals {
  DomainVisuals._();

  /// Visual configuration for each domain type
  static const Map<DomainType, DomainVisualConfig> _visuals = {
    // Core campaign structure
    DomainType.campaign: DomainVisualConfig(
      icon: Icons.book_outlined,
      semanticLabel: 'Campaign',
    ),
    DomainType.chapter: DomainVisualConfig(
      icon: Icons.menu_book_outlined,
      semanticLabel: 'Chapter',
    ),
    DomainType.adventure: DomainVisualConfig(
      icon: Icons.auto_stories_outlined,
      semanticLabel: 'Adventure',
    ),
    DomainType.scene: DomainVisualConfig(
      icon: Icons.theaters_outlined,
      semanticLabel: 'Scene',
    ),

    // Session and gameplay
    DomainType.session: DomainVisualConfig(
      icon: Icons.event_note_outlined,
      semanticLabel: 'Session',
    ),
    DomainType.party: DomainVisualConfig(
      icon: Icons.group_outlined,
      semanticLabel: 'Party',
    ),
    DomainType.encounter: DomainVisualConfig(
      icon: Icons.gavel_outlined,
      semanticLabel: 'Encounter',
    ),
    DomainType.player: DomainVisualConfig(
      icon: Icons.person_outlined,
      semanticLabel: 'Player',
    ),
    DomainType.combatant: DomainVisualConfig(
      icon: Icons.shield_outlined,
      semanticLabel: 'Combatant',
    ),

    // Media
    DomainType.mediaAsset: DomainVisualConfig(
      icon: Icons.image_outlined,
      semanticLabel: 'Media Asset',
    ),

    // Entity types
    DomainType.entityNpc: DomainVisualConfig(
      icon: Icons.face_outlined,
      semanticLabel: 'NPC',
    ),
    DomainType.entityMonster: DomainVisualConfig(
      icon: Icons.bug_report_outlined,
      semanticLabel: 'Monster',
    ),
    DomainType.entityGroup: DomainVisualConfig(
      icon: Icons.groups_outlined,
      semanticLabel: 'Group',
    ),
    DomainType.entityPlace: DomainVisualConfig(
      icon: Icons.place_outlined,
      semanticLabel: 'Place',
    ),
    DomainType.entityItem: DomainVisualConfig(
      icon: Icons.inventory_2_outlined,
      semanticLabel: 'Item',
    ),
    DomainType.entityHandout: DomainVisualConfig(
      icon: Icons.description_outlined,
      semanticLabel: 'Handout',
    ),
    DomainType.entityJournal: DomainVisualConfig(
      icon: Icons.book_outlined,
      semanticLabel: 'Journal',
    ),
    DomainType.entityGeneric: DomainVisualConfig(
      icon: Icons.note_outlined,
      semanticLabel: 'Entity',
    ),
  };

  /// Get the visual configuration for a domain type
  static DomainVisualConfig getConfig(DomainType type) {
    return _visuals[type] ??
        const DomainVisualConfig(
          icon: Icons.help_outline,
          semanticLabel: 'Unknown',
        );
  }

  /// Get the icon for a domain type
  static IconData getIcon(DomainType type) {
    return getConfig(type).icon;
  }

  /// Get the color for a domain type (may be null)
  static Color? getColor(DomainType type) {
    return getConfig(type).color;
  }

  /// Get the semantic label for a domain type
  static String? getSemanticLabel(DomainType type) {
    return getConfig(type).semanticLabel;
  }

  /// Parse entity kind string to DomainType
  ///
  /// Converts entity kind strings (e.g., 'npc', 'monster') to their
  /// corresponding DomainType enum values.
  static DomainType entityKindToDomainType(String kind) {
    switch (kind.toLowerCase()) {
      case 'npc':
        return DomainType.entityNpc;
      case 'monster':
        return DomainType.entityMonster;
      case 'group':
        return DomainType.entityGroup;
      case 'place':
        return DomainType.entityPlace;
      case 'item':
        return DomainType.entityItem;
      case 'handout':
        return DomainType.entityHandout;
      case 'journal':
        return DomainType.entityJournal;
      default:
        return DomainType.entityGeneric;
    }
  }

  /// Get icon for entity kind string
  static IconData getEntityKindIcon(String kind) {
    return getIcon(entityKindToDomainType(kind));
  }

  /// Get color for entity kind string (may be null)
  static Color? getEntityKindColor(String kind) {
    return getColor(entityKindToDomainType(kind));
  }
}

/// Extension methods on [DomainType] for convenient access to visuals
extension DomainTypeVisuals on DomainType {
  /// Get the full visual configuration for this domain type
  DomainVisualConfig get visuals => DomainVisuals.getConfig(this);

  /// Get the icon for this domain type
  IconData get icon => DomainVisuals.getIcon(this);

  /// Get the color for this domain type (may be null)
  Color? get color => DomainVisuals.getColor(this);

  /// Get the semantic label for this domain type
  String? get semanticLabel => DomainVisuals.getSemanticLabel(this);

  /// Create an Icon widget with this domain type's icon and optional color
  ///
  /// The [size] and [color] parameters override the defaults if provided.
  Widget toIcon({double? size, Color? color}) {
    return Icon(
      icon,
      size: size,
      color: color ?? this.color,
      semanticLabel: semanticLabel,
    );
  }
}
