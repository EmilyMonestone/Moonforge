import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/models/campaign.dart';
import 'package:moonforge/data/models/outbox_operation.dart';
import 'package:moonforge/data/services/isar_service.dart';

/// Repository for Campaign operations with local-first Isar storage
class CampaignRepository {
  final Isar _isar;

  CampaignRepository(this._isar);

  /// Watch all campaigns as a stream (local-first, instant)
  Stream<List<Campaign>> watchAll() {
    return _isar.campaigns
        .filter()
        .deletedEqualTo(false)
        .watch(fireImmediately: true);
  }

  /// Get a single campaign by ID
  Future<Campaign?> getById(String id) async {
    return await _isar.campaigns.filter().idEqualTo(id).findFirst();
  }

  /// Upsert a campaign locally and enqueue for sync
  Future<void> upsert(Campaign campaign) async {
    await _isar.writeTxn(() async {
      // Update timestamps and sync status
      campaign
        ..updatedAt = DateTime.now()
        ..syncStatus = 'pending';

      // Save to Isar
      await _isar.campaigns.put(campaign);

      // Enqueue for sync
      await _enqueueSync(
        collection: 'campaigns',
        docId: campaign.id,
        opType: 'upsert',
        payload: jsonEncode(campaign.toFirestore()),
        baseRev: campaign.rev,
      );
    });
    logger.d('Campaign ${campaign.id} upserted and enqueued for sync');
  }

  /// Delete a campaign (soft delete)
  Future<void> delete(String id) async {
    await _isar.writeTxn(() async {
      final campaign = await getById(id);
      if (campaign == null) return;

      campaign
        ..deleted = true
        ..updatedAt = DateTime.now()
        ..syncStatus = 'pending';

      await _isar.campaigns.put(campaign);

      // Enqueue delete operation
      await _enqueueSync(
        collection: 'campaigns',
        docId: id,
        opType: 'delete',
        payload: jsonEncode({'deleted': true}),
        baseRev: campaign.rev,
      );
    });
    logger.d('Campaign $id marked as deleted and enqueued for sync');
  }

  /// Apply a remote update from Firestore
  Future<void> applyRemoteUpdate(Campaign remoteCampaign) async {
    await _isar.writeTxn(() async {
      final local = await getById(remoteCampaign.id);

      // If local doesn't exist or remote is newer, apply update
      if (local == null ||
          local.syncStatus == 'synced' ||
          (remoteCampaign.updatedAt?.isAfter(local.updatedAt ?? DateTime(1970)) ?? false)) {
        remoteCampaign
          ..syncStatus = 'synced'
          ..lastSyncedAt = DateTime.now();
        await _isar.campaigns.put(remoteCampaign);
        logger.d('Applied remote update for campaign ${remoteCampaign.id}');
      } else {
        logger.w(
          'Skipped remote update for campaign ${remoteCampaign.id} - local changes pending',
        );
      }
    });
  }

  /// Enqueue a sync operation to the outbox
  Future<void> _enqueueSync({
    required String collection,
    required String docId,
    required String opType,
    required String payload,
    required int baseRev,
  }) async {
    final outboxOp = OutboxOperation()
      ..collection = collection
      ..docId = docId
      ..opType = opType
      ..payload = payload
      ..baseRev = baseRev
      ..createdAt = DateTime.now()
      ..status = 'pending';

    await _isar.outboxOperations.put(outboxOp);
  }
}
