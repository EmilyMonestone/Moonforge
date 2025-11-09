import 'package:moonforge/data/db/app_db.dart';

/// Filter utilities for entity lists
class EntityFilters {
  EntityFilters._();

  /// Filter entities by kind
  static List<Entity> filterByKind(List<Entity> entities, String kind) {
    return entities.where((e) => e.kind == kind).toList();
  }

  /// Filter entities by tag
  static List<Entity> filterByTag(List<Entity> entities, String tag) {
    return entities.where((e) => (e.tags ?? const []).contains(tag)).toList();
  }

  /// Filter entities by multiple tags (AND logic)
  static List<Entity> filterByTags(List<Entity> entities, List<String> tags) {
    if (tags.isEmpty) return entities;
    return entities.where((e) {
      return tags.every((tag) => (e.tags ?? const []).contains(tag));
    }).toList();
  }

  /// Filter entities by any of the tags (OR logic)
  static List<Entity> filterByAnyTag(List<Entity> entities, List<String> tags) {
    if (tags.isEmpty) return entities;
    return entities.where((e) {
      return tags.any((tag) => (e.tags ?? const []).contains(tag));
    }).toList();
  }

  /// Filter entities by search query (name or summary)
  static List<Entity> filterBySearch(List<Entity> entities, String query) {
    if (query.isEmpty) return entities;
    final lowerQuery = query.toLowerCase();
    return entities.where((e) {
      final nameMatch = e.name.toLowerCase().contains(lowerQuery);
      final summaryMatch =
          e.summary?.toLowerCase().contains(lowerQuery) ?? false;
      return nameMatch || summaryMatch;
    }).toList();
  }

  /// Filter entities by origin
  static List<Entity> filterByOrigin(List<Entity> entities, String originId) {
    return entities.where((e) => e.originId == originId).toList();
  }

  /// Filter NPCs and monsters
  static List<Entity> filterNpcsAndMonsters(List<Entity> entities) {
    return entities
        .where((e) => e.kind == 'npc' || e.kind == 'monster')
        .toList();
  }

  /// Filter places
  static List<Entity> filterPlaces(List<Entity> entities) {
    return entities.where((e) => e.kind == 'place').toList();
  }

  /// Filter items
  static List<Entity> filterItems(List<Entity> entities) {
    return entities.where((e) => e.kind == 'item').toList();
  }

  /// Filter groups/organizations
  static List<Entity> filterGroups(List<Entity> entities) {
    return entities.where((e) => e.kind == 'group').toList();
  }

  /// Filter entities created after a date
  static List<Entity> filterCreatedAfter(List<Entity> entities, DateTime date) {
    return entities.where((e) {
      return e.createdAt != null && e.createdAt!.isAfter(date);
    }).toList();
  }

  /// Filter entities updated after a date
  static List<Entity> filterUpdatedAfter(List<Entity> entities, DateTime date) {
    return entities.where((e) {
      return e.updatedAt != null && e.updatedAt!.isAfter(date);
    }).toList();
  }

  /// Filter entities with images
  static List<Entity> filterWithImages(List<Entity> entities) {
    return entities.where((e) => (e.images?.isNotEmpty ?? false)).toList();
  }

  /// Filter entities with stat blocks
  static List<Entity> filterWithStatblock(List<Entity> entities) {
    return entities.where((e) => e.statblock.isNotEmpty).toList();
  }

  /// Complex filter combining multiple criteria
  static List<Entity> filterComplex(
    List<Entity> entities, {
    String? kind,
    List<String>? tags,
    String? searchQuery,
    String? originId,
    DateTime? createdAfter,
    DateTime? updatedAfter,
    bool? hasImages,
    bool? hasStatblock,
  }) {
    var filtered = entities;

    if (kind != null) {
      filtered = filterByKind(filtered, kind);
    }

    if (tags != null && tags.isNotEmpty) {
      filtered = filterByTags(filtered, tags);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      filtered = filterBySearch(filtered, searchQuery);
    }

    if (originId != null) {
      filtered = filterByOrigin(filtered, originId);
    }

    if (createdAfter != null) {
      filtered = filterCreatedAfter(filtered, createdAfter);
    }

    if (updatedAfter != null) {
      filtered = filterUpdatedAfter(filtered, updatedAfter);
    }

    if (hasImages == true) {
      filtered = filterWithImages(filtered);
    }

    if (hasStatblock == true) {
      filtered = filterWithStatblock(filtered);
    }

    return filtered;
  }
}
