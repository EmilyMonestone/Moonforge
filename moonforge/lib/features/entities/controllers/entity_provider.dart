import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/entity_repository.dart';

/// Provider for managing current entity state
class EntityProvider with ChangeNotifier {
  final EntityRepository _repository;

  Entity? _currentEntity;
  bool _isLoading = false;

  Entity? get currentEntity => _currentEntity;
  bool get isLoading => _isLoading;

  EntityProvider(this._repository);

  /// Load an entity by ID
  Future<void> loadEntity(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final entity = await _repository.getById(id);
      _currentEntity = entity;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set the current entity
  void setCurrentEntity(Entity? entity) {
    _currentEntity = entity;
    notifyListeners();
  }

  /// Clear the current entity
  void clearCurrentEntity() {
    _currentEntity = null;
    notifyListeners();
  }

  /// Update the current entity
  Future<void> updateCurrentEntity(Entity entity) async {
    await _repository.update(entity);
    _currentEntity = entity;
    notifyListeners();
  }
}
