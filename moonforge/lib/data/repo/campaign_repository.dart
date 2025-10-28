import 'dart:convert';

import 'package:moonforge/data/drift/app_database.dart' show AppDatabase;
import 'package:moonforge/data/firebase/models/campaign.dart' show Campaign;

/// Repository for Campaign operations with optimistic writes and outbox queueing
class CampaignRepository {
  final AppDatabase _db;

  CampaignRepository(this._db);

  /// Watch all campaigns as a stream (local-first, instant)
  Stream<List<Campaign>> watchAll() {
    return _db.campaignsDao.watchAll();
  }

  /// Get a single campaign by ID
  Future<Campaign?> getById(String id) {
    return _db.campaignsDao.getById(id);
  }

  /// Upsert a campaign locally and enqueue for sync
  Future<void> upsertLocal(Campaign campaign) async {
    await _db.transaction(() async {
      // Optimistic local write
      await _db.campaignsDao.upsertCampaign(campaign, markDirty: true);

      // Enqueue for sync
      await _db.outboxDao.enqueue(
        docPath: 'campaigns',
        docId: campaign.id,
        baseRev: campaign.rev,
        opType: 'upsert',
        payload: jsonEncode(campaign.toJson()),
      );
    });
  }

  /// Apply a patch operation locally and enqueue for sync
  ///
  /// Supported patch operations:
  /// - set: { "type": "set", "field": "name", "value": "New Name" }
  /// - addToSet: { "type": "addToSet", "field": "memberUids", "value": "uid123" }
  /// - removeFromSet: { "type": "removeFromSet", "field": "memberUids", "value": "uid123" }
  /// - applyDelta: { "type": "applyDelta", "field": "content", "value": "{...quill delta...}" }
  Future<void> patchLocal({
    required String id,
    required int baseRev,
    required List<Map<String, dynamic>> ops,
  }) async {
    await _db.transaction(() async {
      // Get current campaign
      final current = await _db.campaignsDao.getById(id);
      if (current == null) return;

      // Apply operations locally
      Campaign updated = current;
      for (final op in ops) {
        updated = _applyPatchOp(updated, op);
      }

      // Write optimistically
      await _db.campaignsDao.upsertCampaign(updated, markDirty: true);

      // Enqueue patch operation
      await _db.outboxDao.enqueue(
        docPath: 'campaigns',
        docId: id,
        baseRev: baseRev,
        opType: 'patch',
        payload: jsonEncode({'ops': ops}),
      );
    });
  }

  /// Apply a single patch operation to a campaign
  Campaign _applyPatchOp(Campaign campaign, Map<String, dynamic> op) {
    final type = op['type'] as String;
    final field = op['field'] as String;
    final value = op['value'];

    switch (type) {
      case 'set':
        return _applySet(campaign, field, value);
      case 'addToSet':
        return _applyAddToSet(campaign, field, value as String);
      case 'removeFromSet':
        return _applyRemoveFromSet(campaign, field, value as String);
      case 'applyDelta':
        // For now, just replace content (LWW)
        // Future enhancement: merge Quill deltas
        return campaign.copyWith(content: value as String?);
      default:
        return campaign;
    }
  }

  /// Apply a 'set' operation
  Campaign _applySet(Campaign campaign, String field, dynamic value) {
    switch (field) {
      case 'name':
        return campaign.copyWith(name: value as String);
      case 'description':
        return campaign.copyWith(description: value as String);
      case 'content':
        return campaign.copyWith(content: value as String?);
      case 'ownerUid':
        return campaign.copyWith(ownerUid: value as String?);
      default:
        return campaign;
    }
  }

  /// Apply 'addToSet' operation (add to list if not present)
  Campaign _applyAddToSet(Campaign campaign, String field, String value) {
    if (field == 'memberUids') {
      final current = campaign.memberUids ?? [];
      if (!current.contains(value)) {
        return campaign.copyWith(memberUids: [...current, value]);
      }
    }
    return campaign;
  }

  /// Apply 'removeFromSet' operation (remove from list)
  Campaign _applyRemoveFromSet(Campaign campaign, String field, String value) {
    if (field == 'memberUids') {
      final current = campaign.memberUids ?? [];
      return campaign.copyWith(
        memberUids: current.where((uid) => uid != value).toList(),
      );
    }
    return campaign;
  }

  /// Delete a campaign (not implemented yet, would need Firestore integration)
  Future<void> deleteLocal(String id) async {
    // Would enqueue delete operation
    throw UnimplementedError('Delete not yet implemented');
  }
}
