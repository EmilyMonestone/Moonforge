import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moonforge/core/utils/logger.dart';

import '../app_db.dart';
import '../firestore_mappers.dart';

/// Listens to Firestore changes and syncs them to local Drift database
class InboundListener {
  final AppDb _db;
  final FirebaseFirestore _firestore;

  final Map<String, StreamSubscription> _subscriptions = {};

  InboundListener(this._db, this._firestore);

  /// Start listening to Firestore changes for the given user
  void start(String uid) {
    stop(); // Clean up any existing subscriptions

    // Listen to campaigns where user is owner or member
    _subscriptions['campaigns'] = _firestore
        .collection('campaigns')
        .where('memberUids', arrayContains: uid)
        .snapshots()
        .listen(_handleCampaignChanges, onError: _handleError);

    // For other collections, we could add more specific listeners
    // or use a more sophisticated approach based on campaign membership
  }

  /// Stop all listeners
  void stop() {
    for (final sub in _subscriptions.values) {
      sub.cancel();
    }
    _subscriptions.clear();
  }

  void _handleError(Object error, StackTrace stackTrace) {
    logger.e('Inbound sync error: $error');
  }

  void _handleCampaignChanges(QuerySnapshot snapshot) async {
    for (final change in snapshot.docChanges) {
      final data = change.doc.data() as Map<String, dynamic>?;
      if (data == null) continue;

      final id = change.doc.id;
      final deleted = (data['deleted'] ?? false) as bool;

      if (deleted) {
        // Handle soft delete
        await _db.campaignDao.deleteById(id);
      } else {
        // Upsert campaign
        final companion = campaignFromFirestore(id, data);
        await _db.campaignDao.upsert(companion);

        // Also sync related collections
        await _syncCampaignRelated(id);
      }
    }
  }

  Future<void> _syncCampaignRelated(String campaignId) async {
    // Sync chapters
    final chaptersSnap = await _firestore
        .collection('chapters')
        .where('campaignId', isEqualTo: campaignId)
        .get();

    for (final doc in chaptersSnap.docs) {
      final data = doc.data();
      final deleted = (data['deleted'] ?? false) as bool;

      if (deleted) {
        await _db.chapterDao.deleteById(doc.id);
      } else {
        final companion = chapterFromFirestore(doc.id, data);
        await _db.chapterDao.upsert(companion);

        // Sync adventures for this chapter
        await _syncChapterRelated(doc.id);
      }
    }

    // Sync parties
    final partiesSnap = await _firestore
        .collection('parties')
        .where('campaignId', isEqualTo: campaignId)
        .get();

    for (final doc in partiesSnap.docs) {
      final data = doc.data();
      final deleted = (data['deleted'] ?? false) as bool;

      if (deleted) {
        await _db.partyDao.deleteById(doc.id);
      } else {
        final companion = partyFromFirestore(doc.id, data);
        await _db.partyDao.upsert(companion);
      }
    }

    // Sync entities
    final entitiesSnap = await _firestore
        .collection('entities')
        .where('originId', isEqualTo: campaignId)
        .get();

    for (final doc in entitiesSnap.docs) {
      final data = doc.data();
      final companion = entityFromFirestore(doc.id, data);
      await _db.entityDao.upsert(companion);
    }

    // Sync players by campaign
    final playersSnap = await _firestore
        .collection('players')
        .where('campaignId', isEqualTo: campaignId)
        .get();

    for (final doc in playersSnap.docs) {
      final data = doc.data();
      final deleted = (data['deleted'] ?? false) as bool;
      if (deleted) {
        await _db.playerDao.deleteById(doc.id);
      } else {
        final companion = playerFromFirestore(doc.id, data);
        await _db.playerDao.upsert(companion);
      }
    }

    // Players sync will be enabled after local DAO is generated
  }

  Future<void> _syncChapterRelated(String chapterId) async {
    // Sync adventures
    final adventuresSnap = await _firestore
        .collection('adventures')
        .where('chapterId', isEqualTo: chapterId)
        .get();

    for (final doc in adventuresSnap.docs) {
      final data = doc.data();
      final deleted = (data['deleted'] ?? false) as bool;

      if (deleted) {
        await _db.adventureDao.deleteById(doc.id);
      } else {
        final companion = adventureFromFirestore(doc.id, data);
        await _db.adventureDao.upsert(companion);

        // Sync scenes for this adventure
        await _syncAdventureRelated(doc.id);
      }
    }
  }

  Future<void> _syncAdventureRelated(String adventureId) async {
    // Sync scenes
    final scenesSnap = await _firestore
        .collection('scenes')
        .where('adventureId', isEqualTo: adventureId)
        .get();

    for (final doc in scenesSnap.docs) {
      final data = doc.data();
      final deleted = (data['deleted'] ?? false) as bool;

      if (deleted) {
        await _db.sceneDao.deleteById(doc.id);
      } else {
        final companion = sceneFromFirestore(doc.id, data);
        await _db.sceneDao.upsert(companion);
      }
    }

    // Additional per-adventure sync (entities/encounters) can be added here.
  }
}
