import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/entity_repository.dart';

/// Controller for managing entity list state, filters, and search
class EntityListController with ChangeNotifier {
  final EntityRepository _repository;

  List<Entity> _entities = [];
  List<Entity> _filteredEntities = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _selectedKind;
  List<String> _selectedTags = [];
  String _sortBy = 'name'; // 'name', 'kind', 'createdAt', 'updatedAt'
  bool _sortAscending = true;

  List<Entity> get entities => _filteredEntities;

  bool get isLoading => _isLoading;

  String get searchQuery => _searchQuery;

  String? get selectedKind => _selectedKind;

  List<String> get selectedTags => _selectedTags;

  String get sortBy => _sortBy;

  bool get sortAscending => _sortAscending;

  EntityListController(this._repository);

  /// Load all entities
  Future<void> loadEntities() async {
    _isLoading = true;
    notifyListeners();

    try {
      _entities = await _repository.getAll();
      _applyFiltersAndSort();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFiltersAndSort();
  }

  /// Set kind filter
  void setKindFilter(String? kind) {
    _selectedKind = kind;
    _applyFiltersAndSort();
  }

  /// Toggle tag filter
  void toggleTagFilter(String tag) {
    if (_selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      _selectedTags.add(tag);
    }
    _applyFiltersAndSort();
  }

  /// Clear tag filters
  void clearTagFilters() {
    _selectedTags.clear();
    _applyFiltersAndSort();
  }

  /// Set sort criteria
  void setSortBy(String sortBy, {bool? ascending}) {
    _sortBy = sortBy;
    if (ascending != null) {
      _sortAscending = ascending;
    }
    _applyFiltersAndSort();
  }

  /// Toggle sort direction
  void toggleSortDirection() {
    _sortAscending = !_sortAscending;
    _applyFiltersAndSort();
  }

  /// Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedKind = null;
    _selectedTags.clear();
    _applyFiltersAndSort();
  }

  /// Apply filters and sorting
  void _applyFiltersAndSort() {
    var filtered = _entities.where((entity) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final matchesName = entity.name.toLowerCase().contains(_searchQuery);
        final matchesSummary =
            entity.summary?.toLowerCase().contains(_searchQuery) ?? false;
        if (!matchesName && !matchesSummary) return false;
      }

      // Kind filter
      if (_selectedKind != null && entity.kind != _selectedKind) {
        return false;
      }

      // Tag filter
      if (_selectedTags.isNotEmpty) {
        if (entity.tags == null || entity.tags!.isEmpty) return false;
        final hasMatchingTag = _selectedTags.any(
          (t) => entity.tags!.contains(t),
        );
        if (!hasMatchingTag) return false;
      }

      return true;
    }).toList();

    // Sort
    filtered.sort((a, b) {
      int comparison;
      switch (_sortBy) {
        case 'kind':
          comparison = a.kind.compareTo(b.kind);
          break;
        case 'createdAt':
          comparison = (a.createdAt ?? DateTime(0)).compareTo(
            b.createdAt ?? DateTime(0),
          );
          break;
        case 'updatedAt':
          comparison = (a.updatedAt ?? DateTime(0)).compareTo(
            b.updatedAt ?? DateTime(0),
          );
          break;
        case 'name':
        default:
          comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    _filteredEntities = filtered;
    notifyListeners();
  }

  /// Watch entities stream
  Stream<List<Entity>> watchEntities() => _repository.watchAll();

  /// Get entities by kind
  Future<List<Entity>> getEntitiesByKind(String kind) async {
    return _repository.customQuery(
      filter: (e) => e.kind.equals(kind) & e.deleted.equals(false),
    );
  }

  /// Get all unique tags from entities
  Set<String> getAllTags() {
    final tags = <String>{};
    for (final entity in _entities) {
      if (entity.tags != null) tags.addAll(entity.tags!);
    }
    return tags;
  }

  /// Get all unique kinds from entities
  Set<String> getAllKinds() {
    return _entities.map((e) => e.kind).toSet();
  }
}
