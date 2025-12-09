import 'package:moonforge/core/services/base_service.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:uuid/uuid.dart';

const List<String> _emptyStringList = <String>[];

/// Service for entity operations and business logic
class EntityService extends BaseService {
  final EntityRepository _repository;
  final Uuid _uuid = const Uuid();

  @override
  String get serviceName => 'EntityService';

  EntityService(this._repository);

  /// Create a new entity
  Future<Entity> createEntity({
    required String name,
    required String kind,
    required String originType,
    required String originId,
    String? summary,
    List<String>? tags,
    Map<String, dynamic>? statblock,
    String? placeType,
    String? parentPlaceId,
    Map<String, dynamic>? coords,
    Map<String, dynamic>? content,
    List<Map<String, dynamic>>? images,
    List<String>? members,
  }) async {
    return execute(() async {
      final entity = Entity(
        id: _uuid.v4(),
        kind: kind,
        name: name,
        originType: originType,
        originId: originId,
        summary: summary,
        tags: tags,
        statblock: statblock ?? const {},
        placeType: placeType,
        parentPlaceId: parentPlaceId,
        coords: coords ?? const {},
        content: content,
        images: images,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 0,
        deleted: false,
        members: members,
      );

      await _repository.create(entity);
      logInfo('Created entity: ${entity.id} (${entity.name})');
      return entity;
    }, operationName: 'createEntity');
  }

  /// Update an entity
  Future<void> updateEntity(Entity entity) async {
    return execute(() async {
      await _repository.update(entity);
      logInfo('Updated entity: ${entity.id} (${entity.name})');
    }, operationName: 'updateEntity');
  }

  /// Delete an entity (soft delete)
  Future<void> deleteEntity(String id) async {
    return execute(() async {
      await _repository.delete(id);
      logInfo('Deleted entity: $id');
    }, operationName: 'deleteEntity');
  }

  /// Get entity by ID
  Future<Entity?> getEntity(String id) async {
    return _repository.getById(id);
  }

  /// Get all entities
  Future<List<Entity>> getAllEntities() async {
    return _repository.getAll();
  }

  /// Get entities by origin
  Future<List<Entity>> getEntitiesByOrigin(String originId) async {
    final stream = _repository.watchByOrigin(originId);
    return stream.first;
  }

  /// Duplicate an entity
  Future<Entity> duplicateEntity(Entity original, {String? newName}) async {
    return execute(() async {
      final entity = Entity(
        id: _uuid.v4(),
        kind: original.kind,
        name: newName ?? '${original.name} (Copy)',
        originType: original.originType,
        originId: original.originId,
        summary: original.summary,
        tags: original.tags,
        statblock: original.statblock,
        placeType: original.placeType,
        parentPlaceId: original.parentPlaceId,
        coords: original.coords,
        content: original.content,
        images: original.images,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 0,
        deleted: false,
        members: original.members,
      );

      await _repository.create(entity);
      logInfo('Duplicated entity: ${original.id} -> ${entity.id}');
      return entity;
    }, operationName: 'duplicateEntity');
  }

  /// Move entity to different origin
  Future<void> moveEntity(
    String entityId,
    String newOriginId,
    String newOriginType,
  ) async {
    return execute(() async {
      final entity = await _repository.getById(entityId);
      if (entity == null) {
        logError('Entity not found: $entityId');
        return;
      }

      final updated = Entity(
        id: entity.id,
        kind: entity.kind,
        name: entity.name,
        originType: newOriginType,
        originId: newOriginId,
        summary: entity.summary,
        tags: entity.tags,
        statblock: entity.statblock,
        placeType: entity.placeType,
        parentPlaceId: entity.parentPlaceId,
        coords: entity.coords,
        content: entity.content,
        images: entity.images,
        createdAt: entity.createdAt,
        updatedAt: DateTime.now(),
        rev: entity.rev,
        deleted: entity.deleted,
        members: entity.members,
      );

      await _repository.update(updated);
      logInfo('Moved entity $entityId to origin $newOriginId');
    }, operationName: 'moveEntity');
  }

  /// Add tag to entity
  Future<void> addTag(String entityId, String tag) async {
    final entity = await _repository.getById(entityId);
    if (entity == null) return;

    final currentTags = entity.tags ?? _emptyStringList;
    if (!currentTags.contains(tag)) {
      final updatedTags = [...currentTags, tag];
      final updated = Entity(
        id: entity.id,
        kind: entity.kind,
        name: entity.name,
        originType: entity.originType,
        originId: entity.originId,
        summary: entity.summary,
        tags: updatedTags,
        statblock: entity.statblock,
        placeType: entity.placeType,
        parentPlaceId: entity.parentPlaceId,
        coords: entity.coords,
        content: entity.content,
        images: entity.images,
        createdAt: entity.createdAt,
        updatedAt: DateTime.now(),
        rev: entity.rev,
        deleted: entity.deleted,
        members: entity.members,
      );
      await _repository.update(updated);
    }
  }

  /// Remove tag from entity
  Future<void> removeTag(String entityId, String tag) async {
    final entity = await _repository.getById(entityId);
    if (entity == null) return;

    if ((entity.tags ?? _emptyStringList).contains(tag)) {
      final updatedTags = (entity.tags ?? _emptyStringList)
          .where((t) => t != tag)
          .toList();
      final updated = Entity(
        id: entity.id,
        kind: entity.kind,
        name: entity.name,
        originType: entity.originType,
        originId: entity.originId,
        summary: entity.summary,
        tags: updatedTags,
        statblock: entity.statblock,
        placeType: entity.placeType,
        parentPlaceId: entity.parentPlaceId,
        coords: entity.coords,
        content: entity.content,
        images: entity.images,
        createdAt: entity.createdAt,
        updatedAt: DateTime.now(),
        rev: entity.rev,
        deleted: entity.deleted,
        members: entity.members,
      );
      await _repository.update(updated);
    }
  }

  /// Add member to organization entity
  Future<void> addMember(String entityId, String memberId) async {
    final entity = await _repository.getById(entityId);
    if (entity == null || entity.kind != 'group') return;

    final currentMembers = entity.members ?? _emptyStringList;
    if (!currentMembers.contains(memberId)) {
      final updatedMembers = [...currentMembers, memberId];
      final updated = Entity(
        id: entity.id,
        kind: entity.kind,
        name: entity.name,
        originType: entity.originType,
        originId: entity.originId,
        summary: entity.summary,
        tags: entity.tags,
        statblock: entity.statblock,
        placeType: entity.placeType,
        parentPlaceId: entity.parentPlaceId,
        coords: entity.coords,
        content: entity.content,
        images: entity.images,
        createdAt: entity.createdAt,
        updatedAt: DateTime.now(),
        rev: entity.rev,
        deleted: entity.deleted,
        members: updatedMembers,
      );
      await _repository.update(updated);
    }
  }

  /// Remove member from organization entity
  Future<void> removeMember(String entityId, String memberId) async {
    final entity = await _repository.getById(entityId);
    if (entity == null || entity.kind != 'group') return;

    final currentMembers = entity.members ?? _emptyStringList;
    if (currentMembers.contains(memberId)) {
      final updatedMembers = currentMembers
          .where((m) => m != memberId)
          .toList();
      final updated = Entity(
        id: entity.id,
        kind: entity.kind,
        name: entity.name,
        originType: entity.originType,
        originId: entity.originId,
        summary: entity.summary,
        tags: entity.tags,
        statblock: entity.statblock,
        placeType: entity.placeType,
        parentPlaceId: entity.parentPlaceId,
        coords: entity.coords,
        content: entity.content,
        images: entity.images,
        createdAt: entity.createdAt,
        updatedAt: DateTime.now(),
        rev: entity.rev,
        deleted: entity.deleted,
        members: updatedMembers,
      );
      await _repository.update(updated);
    }
  }
}
