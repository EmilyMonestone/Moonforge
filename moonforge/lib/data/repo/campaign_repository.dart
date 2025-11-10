import 'package:drift/drift.dart';
import 'package:moonforge/data/db/tables.dart';

import '../db/app_db.dart';

/// Repository for Campaign operations
class CampaignRepository {
  final AppDb _db;

  CampaignRepository(this._db);

  /// Expose underlying db for low-level maintenance (internal use only)
  AppDb get db => _db;

  /// Watch all campaigns as a stream
  Stream<List<Campaign>> watchAll() => _db.campaignDao.watchAll();

  Future<List<Campaign>> getAll() => _db.campaignDao.getAll();

  /// Get a single campaign by ID
  Future<Campaign?> getById(String id) => _db.campaignDao.getById(id);

  /// Create a new campaign
  Future<void> create(Campaign campaign) async {
    await _db.transaction(() async {
      // Insert into local database
      await _db.campaignDao.upsert(
        CampaignsCompanion.insert(
          id: campaign.id,
          name: campaign.name,
          description: campaign.description,
          content: Value(campaign.content),
          ownerUid: Value(campaign.ownerUid),
          memberUids: Value(campaign.memberUids),
          entityIds: campaign.entityIds,
          createdAt: Value(campaign.createdAt ?? DateTime.now()),
          updatedAt: Value(DateTime.now()),
          rev: campaign.rev,
        ),
      );

      // Enqueue for sync
      await _db.outboxDao.enqueue(
        table: 'campaigns',
        rowId: campaign.id,
        op: 'upsert',
      );
    });
  }

  /// Update an existing campaign
  Future<void> update(Campaign campaign) async {
    await _db.transaction(() async {
      await _db.campaignDao.upsert(
        CampaignsCompanion(
          id: Value(campaign.id),
          name: Value(campaign.name),
          description: Value(campaign.description),
          content: Value(campaign.content),
          ownerUid: Value(campaign.ownerUid),
          memberUids: Value(campaign.memberUids),
          entityIds: Value(campaign.entityIds),
          updatedAt: Value(DateTime.now()),
          rev: Value(campaign.rev + 1),
        ),
      );

      await _db.outboxDao.enqueue(
        table: 'campaigns',
        rowId: campaign.id,
        op: 'upsert',
      );
    });
  }

  /// Delete a campaign
  Future<void> delete(String id) async {
    await _db.transaction(() async {
      await _db.campaignDao.deleteById(id);

      await _db.outboxDao.enqueue(table: 'campaigns', rowId: id, op: 'delete');
    });
  }

  /// Custom query with custom filter, custom sort and custom limit
  Future<List<Campaign>> customQuery({
    Expression<bool> Function(Campaigns c)? filter,
    List<OrderingTerm Function(Campaigns c)>? sort,
    int? limit,
  }) {
    return _db.campaignDao.customQuery(
      filter: filter,
      sort: sort,
      limit: limit,
    );
  }
}
