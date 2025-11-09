import 'package:moonforge/data/db/app_db.dart';

/// Sorting utilities for entity lists
class EntitySorting {
  EntitySorting._();

  /// Sort entities by name (ascending)
  static List<Entity> sortByNameAsc(List<Entity> entities) {
    final sorted = List<Entity>.from(entities);
    sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return sorted;
  }

  /// Sort entities by name (descending)
  static List<Entity> sortByNameDesc(List<Entity> entities) {
    final sorted = List<Entity>.from(entities);
    sorted.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
    return sorted;
  }

  /// Sort entities by kind (ascending)
  static List<Entity> sortByKindAsc(List<Entity> entities) {
    final sorted = List<Entity>.from(entities);
    sorted.sort((a, b) => a.kind.compareTo(b.kind));
    return sorted;
  }

  /// Sort entities by kind (descending)
  static List<Entity> sortByKindDesc(List<Entity> entities) {
    final sorted = List<Entity>.from(entities);
    sorted.sort((a, b) => b.kind.compareTo(a.kind));
    return sorted;
  }

  /// Sort entities by created date (ascending - oldest first)
  static List<Entity> sortByCreatedAsc(List<Entity> entities) {
    final sorted = List<Entity>.from(entities);
    sorted.sort((a, b) {
      final aDate = a.createdAt ?? DateTime(0);
      final bDate = b.createdAt ?? DateTime(0);
      return aDate.compareTo(bDate);
    });
    return sorted;
  }

  /// Sort entities by created date (descending - newest first)
  static List<Entity> sortByCreatedDesc(List<Entity> entities) {
    final sorted = List<Entity>.from(entities);
    sorted.sort((a, b) {
      final aDate = a.createdAt ?? DateTime(0);
      final bDate = b.createdAt ?? DateTime(0);
      return bDate.compareTo(aDate);
    });
    return sorted;
  }

  /// Sort entities by updated date (ascending - oldest first)
  static List<Entity> sortByUpdatedAsc(List<Entity> entities) {
    final sorted = List<Entity>.from(entities);
    sorted.sort((a, b) {
      final aDate = a.updatedAt ?? DateTime(0);
      final bDate = b.updatedAt ?? DateTime(0);
      return aDate.compareTo(bDate);
    });
    return sorted;
  }

  /// Sort entities by updated date (descending - newest first)
  static List<Entity> sortByUpdatedDesc(List<Entity> entities) {
    final sorted = List<Entity>.from(entities);
    sorted.sort((a, b) {
      final aDate = a.updatedAt ?? DateTime(0);
      final bDate = b.updatedAt ?? DateTime(0);
      return bDate.compareTo(aDate);
    });
    return sorted;
  }

  /// Sort entities by tag count (ascending)
  static List<Entity> sortByTagCountAsc(List<Entity> entities) {
    final sorted = List<Entity>.from(entities);
    sorted.sort((a, b) => a.tags.length.compareTo(b.tags.length));
    return sorted;
  }

  /// Sort entities by tag count (descending)
  static List<Entity> sortByTagCountDesc(List<Entity> entities) {
    final sorted = List<Entity>.from(entities);
    sorted.sort((a, b) => b.tags.length.compareTo(a.tags.length));
    return sorted;
  }

  /// Generic sort function
  static List<Entity> sort(
    List<Entity> entities,
    String sortBy,
    bool ascending,
  ) {
    switch (sortBy.toLowerCase()) {
      case 'name':
        return ascending ? sortByNameAsc(entities) : sortByNameDesc(entities);
      case 'kind':
        return ascending ? sortByKindAsc(entities) : sortByKindDesc(entities);
      case 'created':
      case 'createdat':
        return ascending
            ? sortByCreatedAsc(entities)
            : sortByCreatedDesc(entities);
      case 'updated':
      case 'updatedat':
        return ascending
            ? sortByUpdatedAsc(entities)
            : sortByUpdatedDesc(entities);
      case 'tags':
      case 'tagcount':
        return ascending
            ? sortByTagCountAsc(entities)
            : sortByTagCountDesc(entities);
      default:
        return sortByNameAsc(entities);
    }
  }

  /// Sort entities by multiple criteria
  /// Example: sortByMultiple(entities, ['kind', 'name'], [true, true])
  static List<Entity> sortByMultiple(
    List<Entity> entities,
    List<String> sortFields,
    List<bool> ascending,
  ) {
    if (sortFields.isEmpty) return entities;

    final sorted = List<Entity>.from(entities);
    sorted.sort((a, b) {
      for (var i = 0; i < sortFields.length; i++) {
        final field = sortFields[i].toLowerCase();
        final asc = i < ascending.length ? ascending[i] : true;
        int comparison = 0;

        switch (field) {
          case 'name':
            comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
            break;
          case 'kind':
            comparison = a.kind.compareTo(b.kind);
            break;
          case 'created':
          case 'createdat':
            final aDate = a.createdAt ?? DateTime(0);
            final bDate = b.createdAt ?? DateTime(0);
            comparison = aDate.compareTo(bDate);
            break;
          case 'updated':
          case 'updatedat':
            final aDate = a.updatedAt ?? DateTime(0);
            final bDate = b.updatedAt ?? DateTime(0);
            comparison = aDate.compareTo(bDate);
            break;
          case 'tags':
          case 'tagcount':
            comparison = a.tags.length.compareTo(b.tags.length);
            break;
        }

        if (comparison != 0) {
          return asc ? comparison : -comparison;
        }
      }
      return 0;
    });
    return sorted;
  }
}
