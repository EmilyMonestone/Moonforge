import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:moonforge/data/db/app_database.dart';
import 'package:moonforge/data/db/tables/entities.dart';
import 'package:moonforge/data/models/entity.dart' as model;

part 'entities_dao.g.dart';

/// DAO for entities table
@DriftAccessor(tables: [Entities])
class EntitiesDao extends DatabaseAccessor<AppDatabase>
    with _$EntitiesDaoMixin {
  EntitiesDao(super.db);

  /// Watch all entities for a campaign
  Stream<List<model.Entity>> watchByCampaign(String campaignId) {
    return (select(entities)
          ..where((tbl) =>
              tbl.campaignId.equals(campaignId) & tbl.isDeleted.equals(false)))
        .watch()
        .map((rows) => rows.map(_rowToModel).toList());
  }

  /// Watch entities by type
  Stream<List<model.Entity>> watchByType(String campaignId, String entityType) {
    return (select(entities)
          ..where((tbl) =>
              tbl.campaignId.equals(campaignId) &
              tbl.entityType.equals(entityType) &
              tbl.isDeleted.equals(false)))
        .watch()
        .map((rows) => rows.map(_rowToModel).toList());
  }

  /// Watch a single entity
  Stream<model.Entity?> watchOne(String id) {
    return (select(entities)..where((tbl) => tbl.id.equals(id)))
        .watchSingleOrNull()
        .map((row) => row != null ? _rowToModel(row) : null);
  }

  /// Get an entity by ID
  Future<model.Entity?> getById(String id) async {
    final row = await (select(entities)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _rowToModel(row) : null;
  }

  /// Insert or update an entity
  Future<void> upsert(model.Entity entity, {bool markDirty = false}) {
    return into(entities).insertOnConflictUpdate(
      EntitiesCompanion.insert(
        id: entity.id,
        campaignId: entity.campaignId,
        name: entity.name,
        entityType: entity.entityType,
        description: Value(entity.description),
        content: Value(entity.content),
        tags: jsonEncode(entity.tags),
        createdAt: Value(entity.createdAt),
        updatedAt: Value(entity.updatedAt),
        rev: Value(entity.rev),
        isDeleted: Value(entity.isDeleted),
        isDirty: Value(markDirty),
      ),
    );
  }

  /// Soft delete an entity
  Future<void> softDelete(String id) {
    return (update(entities)..where((tbl) => tbl.id.equals(id))).write(
      const EntitiesCompanion(
        isDeleted: Value(true),
        isDirty: Value(true),
      ),
    );
  }

  /// Convert database row to model
  model.Entity _rowToModel(EntityData row) {
    return model.Entity(
      id: row.id,
      campaignId: row.campaignId,
      name: row.name,
      entityType: row.entityType,
      description: row.description,
      content: row.content,
      tags: _decodeStringList(row.tags),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      rev: row.rev,
      isDeleted: row.isDeleted,
    );
  }

  /// Decode JSON string list
  List<String> _decodeStringList(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
