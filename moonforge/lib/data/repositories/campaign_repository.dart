import 'dart:convert';

import 'package:moonforge/data/db/app_database.dart';
import 'package:moonforge/data/firebase/auth_service.dart';
import 'package:moonforge/data/models/campaign.dart';

/// Repository for Campaign operations
/// Provides high-level business logic and coordinates between local DB and sync
class CampaignRepository {
  final AppDatabase _db;
  final AuthService _auth;

  CampaignRepository(this._db, this._auth);

  /// Watch all campaigns for the current user
  Stream<List<Campaign>> watchAll() {
    return _db.campaignsDao.watchAll();
  }

  /// Watch a single campaign
  Stream<Campaign?> watchOne(String id) {
    return _db.campaignsDao.watchOne(id);
  }

  /// Get a campaign by ID
  Future<Campaign?> getById(String id) {
    return _db.campaignsDao.getById(id);
  }

  /// Create or update a campaign
  /// This performs an optimistic write to local DB and enqueues for sync
  Future<void> save(Campaign campaign) async {
    await _db.transaction(() async {
      // Update timestamp
      final now = DateTime.now();
      final updated = campaign.copyWith(
        updatedAt: now,
        createdAt: campaign.createdAt ?? now,
      );

      // Write to local DB with dirty flag
      await _db.campaignsDao.upsert(updated, markDirty: true);

      // Enqueue for sync
      await _db.outboxDao.enqueue(
        collection: 'campaigns',
        docId: updated.id,
        operation: 'upsert',
        payload: jsonEncode(updated.toJson()),
        baseRevision: updated.rev,
        userId: _auth.currentUserId,
      );
    });
  }

  /// Delete a campaign
  /// This performs a soft delete locally and enqueues for sync
  Future<void> delete(String id) async {
    await _db.transaction(() async {
      // Soft delete in local DB
      await _db.campaignsDao.softDelete(id);

      // Add tombstone
      await _db.tombstonesDao.addTombstone(
        collection: 'campaigns',
        docId: id,
        deletedBy: _auth.currentUserId,
      );

      // Enqueue delete operation
      await _db.outboxDao.enqueue(
        collection: 'campaigns',
        docId: id,
        operation: 'delete',
        payload: null,
        baseRevision: 0,
        userId: _auth.currentUserId,
        priority: 10, // Higher priority for deletes
      );
    });
  }

  /// Update specific fields of a campaign
  Future<void> updateFields(String id, Map<String, dynamic> updates) async {
    final campaign = await getById(id);
    if (campaign == null) return;

    // Apply updates to create a new campaign instance
    Campaign updated = campaign;
    
    if (updates.containsKey('name')) {
      updated = updated.copyWith(name: updates['name'] as String);
    }
    if (updates.containsKey('description')) {
      updated = updated.copyWith(description: updates['description'] as String);
    }
    if (updates.containsKey('content')) {
      updated = updated.copyWith(content: updates['content'] as String?);
    }
    if (updates.containsKey('memberUids')) {
      updated = updated.copyWith(
        memberUids: (updates['memberUids'] as List).cast<String>(),
      );
    }
    if (updates.containsKey('entityIds')) {
      updated = updated.copyWith(
        entityIds: (updates['entityIds'] as List).cast<String>(),
      );
    }

    await save(updated);
  }

  /// Add a member to a campaign
  Future<void> addMember(String id, String userId) async {
    final campaign = await getById(id);
    if (campaign == null) return;

    if (!campaign.memberUids.contains(userId)) {
      final updatedMembers = [...campaign.memberUids, userId];
      await save(campaign.copyWith(memberUids: updatedMembers));
    }
  }

  /// Remove a member from a campaign
  Future<void> removeMember(String id, String userId) async {
    final campaign = await getById(id);
    if (campaign == null) return;

    final updatedMembers = campaign.memberUids.where((uid) => uid != userId).toList();
    await save(campaign.copyWith(memberUids: updatedMembers));
  }
}
