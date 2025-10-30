import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isar/isar.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/models/adventure.dart';
import 'package:moonforge/data/models/campaign.dart';
import 'package:moonforge/data/models/chapter.dart';
import 'package:moonforge/data/models/encounter.dart';
import 'package:moonforge/data/models/entity.dart';
import 'package:moonforge/data/models/media_asset.dart';
import 'package:moonforge/data/models/outbox_operation.dart';
import 'package:moonforge/data/models/party.dart';
import 'package:moonforge/data/models/player.dart';
import 'package:moonforge/data/models/scene.dart';
import 'package:moonforge/data/models/session.dart';
import 'package:moonforge/data/repositories/adventure_repository.dart';
import 'package:moonforge/data/repositories/campaign_repository.dart';
import 'package:moonforge/data/repositories/chapter_repository.dart';
import 'package:moonforge/data/repositories/encounter_repository.dart';
import 'package:moonforge/data/repositories/entity_repository.dart';
import 'package:moonforge/data/repositories/media_asset_repository.dart';
import 'package:moonforge/data/repositories/party_repository.dart';
import 'package:moonforge/data/repositories/player_repository.dart';
import 'package:moonforge/data/repositories/scene_repository.dart';
import 'package:moonforge/data/repositories/session_repository.dart';

/// Sync engine that coordinates bidirectional sync between Isar and Firestore
class IsarSyncEngine {
  final Isar _isar;
  final FirebaseFirestore _firestore;

  // Repositories
  late final CampaignRepository _campaignRepo;
  late final AdventureRepository _adventureRepo;
  late final ChapterRepository _chapterRepo;
  late final SceneRepository _sceneRepo;
  late final EncounterRepository _encounterRepo;
  late final EntityRepository _entityRepo;
  late final PartyRepository _partyRepo;
  late final PlayerRepository _playerRepo;
  late final SessionRepository _sessionRepo;
  late final MediaAssetRepository _mediaAssetRepo;

  StreamSubscription? _campaignSubscription;
  StreamSubscription<User?>? _authSubscription;
  Timer? _pushTimer;
  bool _isProcessing = false;

  final Map<String, List<StreamSubscription>> _subCollectionListeners = {};

  IsarSyncEngine(this._isar, this._firestore) {
    _campaignRepo = CampaignRepository(_isar);
    _adventureRepo = AdventureRepository(_isar);
    _chapterRepo = ChapterRepository(_isar);
    _sceneRepo = SceneRepository(_isar);
    _encounterRepo = EncounterRepository(_isar);
    _entityRepo = EntityRepository(_isar);
    _partyRepo = PartyRepository(_isar);
    _playerRepo = PlayerRepository(_isar);
    _sessionRepo = SessionRepository(_isar);
    _mediaAssetRepo = MediaAssetRepository(_isar);
  }

  /// Start the sync engine
  void start() {
    logger.i('IsarSyncEngine.start()');

    // React to auth changes
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        logger.i('Auth state changed: uid=${user?.uid}');
        _restartSync();
      },
      onError: (e, st) {
        logger.e('Auth state listener error: $e', error: e, stackTrace: st);
      },
    );

    _startPull();
    _startPushLoop();
  }

  /// Stop the sync engine
  void stop() {
    logger.i('IsarSyncEngine.stop()');
    _campaignSubscription?.cancel();
    _pushTimer?.cancel();
    _authSubscription?.cancel();
    
    for (final subs in _subCollectionListeners.values) {
      for (final sub in subs) {
        sub.cancel();
      }
    }
    _subCollectionListeners.clear();
  }

  /// Restart sync after auth change
  void _restartSync() {
    logger.d('Restarting sync');
    _campaignSubscription?.cancel();
    for (final subs in _subCollectionListeners.values) {
      for (final sub in subs) {
        sub.cancel();
      }
    }
    _subCollectionListeners.clear();
    _startPull();
  }

  /// Pull: Listen to Firestore snapshots and apply to Isar
  void _startPull() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      logger.w('No signed-in user; skipping pull subscription');
      return;
    }

    logger.d('Starting Firestore pull for uid=${user.uid}');

    // Listen to campaigns
    _campaignSubscription = _firestore
        .collection('campaigns')
        .where('memberUids', arrayContains: user.uid)
        .snapshots()
        .listen(
          (snapshot) => _handleCampaignSnapshot(snapshot),
          onError: (e, st) {
            logger.e('Campaign snapshot error: $e', error: e, stackTrace: st);
          },
        );
  }

  /// Handle campaign snapshot from Firestore
  Future<void> _handleCampaignSnapshot(QuerySnapshot snapshot) async {
    try {
      logger.d('Campaign snapshot: ${snapshot.docs.length} docs, fromCache=${snapshot.metadata.isFromCache}');

      for (final change in snapshot.docChanges) {
        final docId = change.doc.id;
        final data = change.doc.data() as Map<String, dynamic>?;

        if (change.type == DocumentChangeType.removed || data == null) {
          // Handle deletion
          await _handleCampaignDeletion(docId);
        } else {
          // Handle add/modify
          await _handleCampaignUpdate(docId, data);
          // Subscribe to subcollections
          await _subscribeToSubcollections(docId);
        }
      }
    } catch (e, st) {
      logger.e('Error handling campaign snapshot: $e', error: e, stackTrace: st);
    }
  }

  /// Handle campaign update from Firestore
  Future<void> _handleCampaignUpdate(String docId, Map<String, dynamic> data) async {
    try {
      final campaign = Campaign.fromFirestore(data, docId);
      await _campaignRepo.applyRemoteUpdate(campaign);
    } catch (e, st) {
      logger.e('Error applying campaign update: $e', error: e, stackTrace: st);
    }
  }

  /// Handle campaign deletion
  Future<void> _handleCampaignDeletion(String docId) async {
    try {
      await _campaignRepo.delete(docId);
      // Unsubscribe from subcollections
      final subs = _subCollectionListeners.remove(docId);
      if (subs != null) {
        for (final sub in subs) {
          sub.cancel();
        }
      }
    } catch (e, st) {
      logger.e('Error handling campaign deletion: $e', error: e, stackTrace: st);
    }
  }

  /// Subscribe to subcollections for a campaign
  Future<void> _subscribeToSubcollections(String campaignId) async {
    // Cancel existing subscriptions for this campaign
    final existing = _subCollectionListeners[campaignId];
    if (existing != null) {
      for (final sub in existing) {
        sub.cancel();
      }
    }

    final subscriptions = <StreamSubscription>[];

    // Parties
    subscriptions.add(
      _firestore
          .collection('campaigns/$campaignId/parties')
          .snapshots()
          .listen((snapshot) => _handleSubcollectionSnapshot<Party>(
                snapshot,
                Party.fromFirestore,
                _partyRepo.applyRemoteUpdate,
              )),
    );

    // Players
    subscriptions.add(
      _firestore
          .collection('campaigns/$campaignId/players')
          .snapshots()
          .listen((snapshot) => _handleSubcollectionSnapshot<Player>(
                snapshot,
                Player.fromFirestore,
                _playerRepo.applyRemoteUpdate,
              )),
    );

    // Entities
    subscriptions.add(
      _firestore
          .collection('campaigns/$campaignId/entities')
          .snapshots()
          .listen((snapshot) => _handleSubcollectionSnapshot<Entity>(
                snapshot,
                Entity.fromFirestore,
                _entityRepo.applyRemoteUpdate,
              )),
    );

    // Encounters
    subscriptions.add(
      _firestore
          .collection('campaigns/$campaignId/encounters')
          .snapshots()
          .listen((snapshot) => _handleSubcollectionSnapshot<Encounter>(
                snapshot,
                Encounter.fromFirestore,
                _encounterRepo.applyRemoteUpdate,
              )),
    );

    // Sessions
    subscriptions.add(
      _firestore
          .collection('campaigns/$campaignId/sessions')
          .snapshots()
          .listen((snapshot) => _handleSubcollectionSnapshot<Session>(
                snapshot,
                Session.fromFirestore,
                _sessionRepo.applyRemoteUpdate,
              )),
    );

    // Media
    subscriptions.add(
      _firestore
          .collection('campaigns/$campaignId/media')
          .snapshots()
          .listen((snapshot) => _handleSubcollectionSnapshot<MediaAsset>(
                snapshot,
                MediaAsset.fromFirestore,
                _mediaAssetRepo.applyRemoteUpdate,
              )),
    );

    // Chapters and nested collections
    subscriptions.add(
      _firestore
          .collection('campaigns/$campaignId/chapters')
          .snapshots()
          .listen((snapshot) async {
            await _handleSubcollectionSnapshot<Chapter>(
              snapshot,
              Chapter.fromFirestore,
              _chapterRepo.applyRemoteUpdate,
            );
            // Subscribe to adventures for each chapter
            for (final doc in snapshot.docs) {
              await _subscribeToAdventures(campaignId, doc.id);
            }
          }),
    );

    _subCollectionListeners[campaignId] = subscriptions;
  }

  /// Subscribe to adventures for a chapter
  Future<void> _subscribeToAdventures(String campaignId, String chapterId) async {
    final sub = _firestore
        .collection('campaigns/$campaignId/chapters/$chapterId/adventures')
        .snapshots()
        .listen((snapshot) async {
          await _handleSubcollectionSnapshot<Adventure>(
            snapshot,
            Adventure.fromFirestore,
            _adventureRepo.applyRemoteUpdate,
          );
          // Subscribe to scenes for each adventure
          for (final doc in snapshot.docs) {
            await _subscribeToScenes(campaignId, chapterId, doc.id);
          }
        });

    _subCollectionListeners.putIfAbsent(campaignId, () => []).add(sub);
  }

  /// Subscribe to scenes for an adventure
  Future<void> _subscribeToScenes(
    String campaignId,
    String chapterId,
    String adventureId,
  ) async {
    final sub = _firestore
        .collection('campaigns/$campaignId/chapters/$chapterId/adventures/$adventureId/scenes')
        .snapshots()
        .listen((snapshot) => _handleSubcollectionSnapshot<Scene>(
              snapshot,
              Scene.fromFirestore,
              _sceneRepo.applyRemoteUpdate,
            ));

    _subCollectionListeners.putIfAbsent(campaignId, () => []).add(sub);
  }

  /// Generic handler for subcollection snapshots
  Future<void> _handleSubcollectionSnapshot<T>(
    QuerySnapshot snapshot,
    T Function(Map<String, dynamic>, String) fromFirestore,
    Future<void> Function(T) applyUpdate,
  ) async {
    try {
      for (final change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.removed) continue;

        final data = change.doc.data() as Map<String, dynamic>?;
        if (data == null) continue;

        final entity = fromFirestore(data, change.doc.id);
        await applyUpdate(entity);
      }
    } catch (e, st) {
      logger.e('Error handling subcollection snapshot: $e', error: e, stackTrace: st);
    }
  }

  /// Start push loop to process outbox
  void _startPushLoop() {
    // Process outbox every 5 seconds
    _pushTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _processPendingOperations();
    });

    // Also process immediately
    Future.delayed(const Duration(milliseconds: 500), _processPendingOperations);
  }

  /// Process pending operations from outbox
  Future<void> _processPendingOperations() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final pending = await _isar.outboxOperations
          .filter()
          .statusEqualTo('pending')
          .sortByCreatedAt()
          .limit(10)
          .findAll();

      for (final op in pending) {
        await _processOperation(op);
      }
    } catch (e, st) {
      logger.e('Error processing outbox: $e', error: e, stackTrace: st);
    } finally {
      _isProcessing = false;
    }
  }

  /// Process a single outbox operation
  Future<void> _processOperation(OutboxOperation op) async {
    try {
      logger.d('Processing outbox op: ${op.collection}/${op.docId} (${op.opType})');

      // Mark as syncing
      await _isar.writeTxn(() async {
        op.status = 'syncing';
        await _isar.outboxOperations.put(op);
      });

      // Get Firestore reference
      final docRef = _getFirestoreReference(op.collection, op.docId);

      if (op.opType == 'delete') {
        await docRef.delete();
      } else if (op.opType == 'upsert') {
        final data = jsonDecode(op.payload) as Map<String, dynamic>;
        data['updatedAt'] = FieldValue.serverTimestamp();
        data['rev'] = op.baseRev + 1;
        await docRef.set(data, SetOptions(merge: true));
      } else if (op.opType == 'patch') {
        final patchData = jsonDecode(op.payload) as Map<String, dynamic>;
        patchData['updatedAt'] = FieldValue.serverTimestamp();
        patchData['rev'] = op.baseRev + 1;
        await docRef.update(patchData);
      }

      // Mark as synced and delete from outbox
      await _isar.writeTxn(() async {
        await _isar.outboxOperations.delete(op.isarId);
      });

      logger.d('Successfully synced ${op.collection}/${op.docId}');
    } catch (e, st) {
      logger.e('Error syncing operation: $e', error: e, stackTrace: st);

      // Mark as failed and increment retry count
      await _isar.writeTxn(() async {
        op.status = 'failed';
        op.lastError = e.toString();
        op.retryCount += 1;

        // If retry count exceeds threshold, keep it failed
        // Otherwise, set back to pending for retry
        if (op.retryCount < 3) {
          op.status = 'pending';
        }

        await _isar.outboxOperations.put(op);
      });
    }
  }

  /// Get Firestore document reference for a collection and docId
  DocumentReference _getFirestoreReference(String collection, String docId) {
    // Parse the collection path to handle subcollections
    // Format: campaigns/campaignId/entities/entityId
    return _firestore.doc('$collection/$docId');
  }
}
