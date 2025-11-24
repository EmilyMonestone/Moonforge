import 'package:moonforge/core/models/async_state.dart';
import 'package:moonforge/core/providers/base_async_provider.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/entity_repository.dart';

/// Provider for managing current entity state
class EntityProvider extends BaseAsyncProvider<Entity?> {
  final EntityRepository _repository;

  Entity? get currentEntity => state.dataOrNull;
  bool get isLoading => state.isLoading;

  EntityProvider(this._repository);

  /// Load an entity by ID
  Future<void> loadEntity(String id) async {
    await executeAsync(() => _repository.getById(id));
  }

  /// Set the current entity
  void setCurrentEntity(Entity? entity) {
    updateState(AsyncState.data(entity));
  }

  /// Clear the current entity
  void clearCurrentEntity() {
    reset();
  }

  /// Update the current entity
  Future<void> updateCurrentEntity(Entity entity) async {
    await _repository.update(entity);
    updateState(AsyncState.data(entity));
  }
}
