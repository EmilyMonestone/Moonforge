import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:moonforge/data/db/app_database.dart';
import 'package:moonforge/data/db/tables/campaigns.dart';
import 'package:moonforge/data/models/campaign.dart' as model;

part 'campaigns_dao.g.dart';

/// DAO for campaigns table
@DriftAccessor(tables: [Campaigns])
class CampaignsDao extends DatabaseAccessor<AppDatabase>
    with _$CampaignsDaoMixin {
  CampaignsDao(super.db);

  /// Watch all non-deleted campaigns
  Stream<List<model.Campaign>> watchAll() {
    return (select(campaigns)..where((tbl) => tbl.isDeleted.equals(false)))
        .watch()
        .map((rows) => rows.map(_rowToModel).toList());
  }

  /// Watch a single campaign
  Stream<model.Campaign?> watchOne(String id) {
    return (select(campaigns)..where((tbl) => tbl.id.equals(id)))
        .watchSingleOrNull()
        .map((row) => row != null ? _rowToModel(row) : null);
  }

  /// Get a campaign by ID
  Future<model.Campaign?> getById(String id) async {
    final row = await (select(campaigns)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _rowToModel(row) : null;
  }

  /// Insert or update a campaign
  Future<void> upsert(model.Campaign campaign, {bool markDirty = false}) {
    return into(campaigns).insertOnConflictUpdate(
      CampaignsCompanion.insert(
        id: campaign.id,
        name: campaign.name,
        description: campaign.description,
        content: Value(campaign.content),
        ownerUid: Value(campaign.ownerUid),
        memberUids: jsonEncode(campaign.memberUids),
        entityIds: jsonEncode(campaign.entityIds),
        createdAt: Value(campaign.createdAt),
        updatedAt: Value(campaign.updatedAt),
        rev: Value(campaign.rev),
        isDeleted: Value(campaign.isDeleted),
        isDirty: Value(markDirty),
      ),
    );
  }

  /// Soft delete a campaign
  Future<void> softDelete(String id) {
    return (update(campaigns)..where((tbl) => tbl.id.equals(id))).write(
      CampaignsCompanion(
        isDeleted: const Value(true),
        isDirty: const Value(true),
      ),
    );
  }

  /// Hard delete a campaign
  Future<int> delete(String id) {
    return (delete(campaigns)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Get dirty campaigns (need sync)
  Future<List<model.Campaign>> getDirty() async {
    final rows = await (select(campaigns)
          ..where((tbl) => tbl.isDirty.equals(true)))
        .get();
    return rows.map(_rowToModel).toList();
  }

  /// Mark campaign as clean (synced)
  Future<void> markClean(String id) {
    return (update(campaigns)..where((tbl) => tbl.id.equals(id)))
        .write(const CampaignsCompanion(isDirty: Value(false)));
  }

  /// Convert database row to model
  model.Campaign _rowToModel(CampaignData row) {
    return model.Campaign(
      id: row.id,
      name: row.name,
      description: row.description,
      content: row.content,
      ownerUid: row.ownerUid,
      memberUids: _decodeStringList(row.memberUids),
      entityIds: _decodeStringList(row.entityIds),
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
