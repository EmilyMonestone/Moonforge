import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/firebase/models/adventure.dart';
import 'package:moonforge/data/firebase/models/campaign.dart';
import 'package:moonforge/data/firebase/models/chapter.dart';
import 'package:moonforge/data/firebase/models/encounter.dart'
    as encounter_model;
import 'package:moonforge/data/firebase/models/entity.dart' as entity_model;
import 'package:moonforge/data/firebase/models/media_asset.dart' as media_model;
import 'package:moonforge/data/firebase/models/party.dart' as party_model;
import 'package:moonforge/data/firebase/models/player.dart' as player_model;
import 'package:moonforge/data/firebase/models/scene.dart' as scene_model;
import 'package:moonforge/data/firebase/models/session.dart' as session_model;

/// Sync engine that coordinates pull (Firestore → Drift) and push (Outbox → Firestore)
/// with Compare-And-Set (CAS) conflict resolution on the rev field
class SyncEngine {
  final AppDatabase _db;
  final FirebaseFirestore _firestore;

  StreamSubscription? _pullSubscription;
  StreamSubscription<User?>? _authSubscription;
  Timer? _pushTimer;
  bool _isProcessing = false;

  final Map<String, _CampaignSubscriptions> _campaignSubs = {};

  SyncEngine(this._db, this._firestore);

  /// Start the sync engine
  void start() {
    logger.i('SyncEngine.start()');
    // React to auth changes so we resubscribe after login
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        logger.i('Auth state changed in SyncEngine: uid=${user?.uid}');
        _restartPull();
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
    logger.i('SyncEngine.stop()');
    _pullSubscription?.cancel();
    _pushTimer?.cancel();
    _authSubscription?.cancel();
    // Dispose sub listeners
    for (final subs in _campaignSubs.values) {
      subs.dispose();
    }
    _campaignSubs.clear();
  }

  /// Restart Firestore pull listener
  void _restartPull() {
    logger.d('Restarting Firestore pull listener');
    _pullSubscription?.cancel();
    _startPull();
  }

  /// Pull: Listen to Firestore snapshots and adopt remote changes when not dirty
  void _startPull() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      logger.w(
        'SyncEngine._startPull(): no signed-in user yet; skipping subscribe',
      );
      return;
    }
    logger.d(
      'SyncEngine._startPull(): subscribing to campaigns for uid=${user.uid}',
    );
    _pullSubscription = _firestore
        .collection('campaigns')
        .where('memberUids', arrayContains: user.uid)
        .snapshots()
        .listen(
          (snapshot) async {
            try {
              logger.d(
                'Firestore pull snapshot: docs=${snapshot.docs.length}, changes=${snapshot.docChanges.length}, fromCache=${snapshot.metadata.isFromCache}',
              );
              for (final change in snapshot.docChanges) {
                logger.d('DocChange: type=${change.type}, id=${change.doc.id}');
                if (change.type == DocumentChangeType.added ||
                    change.type == DocumentChangeType.modified) {
                  await _handleRemoteChange(change.doc);
                }
              }
            } catch (e, st) {
              logger.e(
                'Error handling pull snapshot: $e',
                error: e,
                stackTrace: st,
              );
            }
          },
          onError: (error, [st]) {
            logger.e(
              '⚠️ Firestore pull error: $error',
              error: error,
              stackTrace: st as StackTrace?,
            );
          },
          onDone: () {
            logger.w('Firestore pull stream completed');
          },
        );
  }

  /// Handle a remote document change
  Future<void> _handleRemoteChange(DocumentSnapshot doc) async {
    logger.d('Handling remote change for id=${doc.id} exists=${doc.exists}');
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        logger.w('No data for remote doc ${doc.id}');
        return;
      }

      // Normalize Firestore Timestamps to ISO strings expected by fromJson
      final normalized = Map<String, dynamic>.from(data);
      for (final key in const ['createdAt', 'updatedAt']) {
        final v = normalized[key];
        if (v is Timestamp) {
          normalized[key] = v.toDate().toIso8601String();
        }
      }

      final remote = Campaign.fromJson({'id': doc.id, ...normalized});
      logger.d(
        'Remote campaign: id=${remote.id} rev=${remote.rev} ownerUid=${remote.ownerUid}',
      );
      final isDirty = await _db.campaignsDao.isDirty('campaigns', doc.id);
      final local = await _db.campaignsDao.getById(doc.id);
      logger.d(
        'Local state for ${doc.id}: dirty=$isDirty localRev=${local?.rev}',
      );

      // Only adopt remote if local is clean OR remote rev is ahead
      if (!isDirty || (local != null && remote.rev >= local.rev)) {
        logger.d('Upserting remote into local for ${doc.id} (markDirty=false)');
        await _db.campaignsDao.upsertCampaign(remote, markDirty: false);
        // Ensure subcollection listeners for this campaign
        _ensureSubListenersFor(remote.id);
      } else {
        logger.d(
          'Skipping remote adoption for ${doc.id} due to local dirty state and newer local rev',
        );
      }
    } catch (e, st) {
      logger.e(
        '⚠️ Error handling remote change for ${doc.id}: $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  void _ensureSubListenersFor(String cid) {
    final existing = _campaignSubs[cid];
    if (existing != null) return;
    logger.i('Creating subcollection listeners for campaign $cid');
    final subs = _CampaignSubscriptions(cid, _firestore, _db);
    subs.startAll();
    _campaignSubs[cid] = subs;
  }

  /// Push: Process outbox operations with backoff
  void _startPushLoop() {
    logger.d('SyncEngine._startPushLoop(): interval=5s');
    _pushTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_isProcessing) {
        _processOutbox();
      } else {
        logger.t('Push loop skipped: already processing');
      }
    });
  }

  /// Process next operation in outbox
  Future<void> _processOutbox() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final op = await _db.outboxDao.nextOp();
      if (op == null) {
        return;
      }

      logger.d(
        'Processing op id=${op.id} type=${op.opType} path=${op.docPath}/${op.docId} baseRev=${op.baseRev}',
      );
      await _processOne(op);
    } catch (e, st) {
      logger.e('⚠️ Outbox processing error: $e', error: e, stackTrace: st);
    } finally {
      _isProcessing = false;
    }
  }

  /// Process a single outbox operation with Firestore transaction and CAS
  Future<void> _processOne(OutboxOp op) async {
    try {
      if (op.opType == 'upsert') {
        await _processUpsert(op);
      } else if (op.opType == 'patch') {
        await _processPatch(op);
      } else {
        logger.w('Unknown opType ${op.opType} for op ${op.id}');
      }
    } catch (e, st) {
      logger.e(
        '⚠️ Failed to process op ${op.id}: $e',
        error: e,
        stackTrace: st,
      );
      await _db.outboxDao.markAttempt(op.id);

      // Give up after 10 attempts
      if (op.attempt >= 10) {
        logger.w('⚠️ Giving up on op ${op.id} after ${op.attempt} attempts');
        await _db.outboxDao.remove(op.id);
      }
    }
  }

  /// Process an upsert operation
  Future<void> _processUpsert(OutboxOp op) async {
    final docRef = _firestore.collection(op.docPath).doc(op.docId);
    logger.t('Executing upsert for ${docRef.path}');

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final data = jsonDecode(op.payload) as Map<String, dynamic>;
      final localCampaign = Campaign.fromJson(data);

      if (!snapshot.exists) {
        // Create new document
        logger.d('Remote doc missing, creating new ${docRef.path}');
        transaction.set(docRef, {
          ...localCampaign.toJson()..remove('id'),
          'rev': 0,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        await _db.campaignsDao.setClean(op.docId, 0);
        await _db.outboxDao.remove(op.id);
      } else {
        // Update existing document with CAS
        final remoteData = snapshot.data()!;
        final remoteRev = remoteData['rev'] as int? ?? 0;
        logger.d(
          'Remote exists ${docRef.path} rev=$remoteRev baseRev=${op.baseRev}',
        );

        if (remoteRev == op.baseRev) {
          // No conflict, apply update
          transaction.update(docRef, {
            ...localCampaign.toJson()..remove('id'),
            'rev': remoteRev + 1,
            'updatedAt': FieldValue.serverTimestamp(),
          });

          await _db.campaignsDao.setClean(op.docId, remoteRev + 1);
          await _db.outboxDao.remove(op.id);
        } else {
          // Conflict: replay local change on top of remote
          final remote = Campaign.fromJson({'id': op.docId, ...remoteData});
          final merged = _mergeUpsert(remote, localCampaign);
          logger.w(
            'CAS conflict on ${docRef.path} remoteRev=$remoteRev baseRev=${op.baseRev} → merging',
          );

          transaction.update(docRef, {
            ...merged.toJson()..remove('id'),
            'rev': remoteRev + 1,
            'updatedAt': FieldValue.serverTimestamp(),
          });

          await _db.campaignsDao.setClean(op.docId, remoteRev + 1);
          await _db.outboxDao.remove(op.id);
        }
      }
    });
  }

  /// Process a patch operation
  Future<void> _processPatch(OutboxOp op) async {
    final docRef = _firestore.collection(op.docPath).doc(op.docId);
    logger.t('Executing patch for ${docRef.path}');

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        // Document deleted remotely, remove op
        logger.w('Patch target missing for ${docRef.path}, removing op');
        await _db.outboxDao.remove(op.id);
        return;
      }

      final remoteDataRaw = snapshot.data()!;
      // Normalize Timestamps for fromJson
      final remoteData = Map<String, dynamic>.from(remoteDataRaw);
      for (final key in const ['createdAt', 'updatedAt']) {
        final v = remoteData[key];
        if (v is Timestamp) {
          remoteData[key] = v.toDate().toIso8601String();
        }
      }
      final remote = Campaign.fromJson({'id': op.docId, ...remoteData});

      // Parse patch operations
      final payload = jsonDecode(op.payload) as Map<String, dynamic>;
      final ops = (payload['ops'] as List).cast<Map<String, dynamic>>();
      logger.d(
        'Applying ${ops.length} patch ops to ${docRef.path} at rev=${remoteDataRaw['rev'] ?? 0}',
      );

      // Apply patch operations
      Campaign updated = remote;
      for (final patchOp in ops) {
        updated = _applyOp(updated, patchOp);
      }

      transaction.update(docRef, {
        ...updated.toJson()..remove('id'),
        'rev': (remoteDataRaw['rev'] as int? ?? 0) + 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _db.campaignsDao.setClean(
        op.docId,
        (remoteDataRaw['rev'] as int? ?? 0) + 1,
      );
      await _db.outboxDao.remove(op.id);
    });
  }

  /// Merge local upsert on top of remote (LWW for scalars)
  Campaign _mergeUpsert(Campaign remote, Campaign local) {
    // Simple LWW (Last Write Wins) for scalar fields
    return Campaign(
      id: remote.id,
      name: local.name,
      description: local.description,
      content: local.content,
      ownerUid: local.ownerUid ?? remote.ownerUid,
      memberUids: _mergeLists(remote.memberUids, local.memberUids),
      createdAt: remote.createdAt,
      updatedAt: remote.updatedAt,
      rev: remote.rev,
      entityIds: remote.entityIds,
    );
  }

  /// Merge two lists as sets (union)
  List<String>? _mergeLists(List<String>? remote, List<String>? local) {
    if (local == null) return remote;
    if (remote == null) return local;
    return {...remote, ...local}.toList();
  }

  /// Apply a patch operation to a campaign
  Campaign _applyOp(Campaign campaign, Map<String, dynamic> op) {
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
        return campaign.copyWith(content: value as String?);
      default:
        return campaign;
    }
  }

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

  Campaign _applyAddToSet(Campaign campaign, String field, String value) {
    if (field == 'memberUids') {
      final current = campaign.memberUids ?? [];
      if (!current.contains(value)) {
        return campaign.copyWith(memberUids: [...current, value]);
      }
    }
    return campaign;
  }

  Campaign _applyRemoveFromSet(Campaign campaign, String field, String value) {
    if (field == 'memberUids') {
      final current = campaign.memberUids ?? [];
      return campaign.copyWith(
        memberUids: current.where((uid) => uid != value).toList(),
      );
    }
    return campaign;
  }
}

class _CampaignSubscriptions {
  final String cid;
  final FirebaseFirestore firestore;
  final AppDatabase db;

  StreamSubscription? chapters;
  final Map<String, StreamSubscription> adventuresByChapter = {};
  final Map<String, Map<String, StreamSubscription>> scenesByChapterAdventure =
      {};

  StreamSubscription? entities;
  StreamSubscription? encounters;
  StreamSubscription? sessions;
  StreamSubscription? media;
  StreamSubscription? parties;
  StreamSubscription? players;

  _CampaignSubscriptions(this.cid, this.firestore, this.db);

  void startAll() {
    _startChapters();
    _startEntities();
    _startEncounters();
    _startSessions();
    _startMedia();
    _startParties();
    _startPlayers();
  }

  void dispose() {
    chapters?.cancel();
    for (final sub in adventuresByChapter.values) {
      sub.cancel();
    }
    adventuresByChapter.clear();
    for (final byAdv in scenesByChapterAdventure.values) {
      for (final sub in byAdv.values) {
        sub.cancel();
      }
    }
    scenesByChapterAdventure.clear();
    entities?.cancel();
    encounters?.cancel();
    sessions?.cancel();
    media?.cancel();
    parties?.cancel();
    players?.cancel();
  }

  // Chapters -> also start Adventures per chapter
  void _startChapters() {
    final path = 'campaigns/$cid/chapters';
    logger.d('Subscribing chapters: $path');
    chapters = firestore
        .collection('campaigns')
        .doc(cid)
        .collection('chapters')
        .snapshots()
        .listen(
          (snapshot) async {
            logger.t(
              '[chapters:$cid] snapshot docs=${snapshot.docs.length} changes=${snapshot.docChanges.length}',
            );
            for (final change in snapshot.docChanges) {
              final doc = change.doc;
              if (change.type == DocumentChangeType.added ||
                  change.type == DocumentChangeType.modified) {
                await _handleChapter(doc);
                _ensureAdventuresForChapter(doc.id);
              } else if (change.type == DocumentChangeType.removed) {
                // Cancel listeners for this chapter's adventures/scenes
                final advSub = adventuresByChapter.remove(doc.id);
                await advSub?.cancel();
                final scenesMap = scenesByChapterAdventure.remove(doc.id);
                if (scenesMap != null) {
                  for (final sub in scenesMap.values) {
                    await sub.cancel();
                  }
                }
              }
            }
          },
          onError: (error, [st]) {
            logger.e(
              'chapters[$cid] error: $error',
              error: error,
              stackTrace: st as StackTrace?,
            );
          },
        );
  }

  Future<void> _handleChapter(DocumentSnapshot doc) async {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return;
      final normalized = _normTS(data);
      final remote = Chapter.fromJson({'id': doc.id, ...normalized});
      final isDirty = await db.chaptersDao.isDirty('chapters', doc.id);
      final local = await db.chaptersDao.getById(doc.id);
      if (!isDirty || (local != null && remote.rev >= local.rev)) {
        await db.chaptersDao.upsert(remote, markDirty: false);
        logger.t('chapters[$cid] upserted ${remote.id} rev=${remote.rev}');
      }
    } catch (e, st) {
      logger.e('handleChapter error: $e', error: e, stackTrace: st);
    }
  }

  void _ensureAdventuresForChapter(String chapId) {
    if (adventuresByChapter.containsKey(chapId)) return;
    logger.d('Subscribing adventures for chapter $chapId');
    final sub = firestore
        .collection('campaigns')
        .doc(cid)
        .collection('chapters')
        .doc(chapId)
        .collection('adventures')
        .snapshots()
        .listen(
          (snapshot) async {
            logger.t(
              '[adventures:$cid/$chapId] docs=${snapshot.docs.length} changes=${snapshot.docChanges.length}',
            );
            for (final change in snapshot.docChanges) {
              final doc = change.doc;
              if (change.type == DocumentChangeType.added ||
                  change.type == DocumentChangeType.modified) {
                await _handleAdventure(doc);
                _ensureScenesForAdventure(chapId, doc.id);
              } else if (change.type == DocumentChangeType.removed) {
                // Cancel scenes listener for this adventure
                final scenesMap = scenesByChapterAdventure[chapId];
                final s = scenesMap?.remove(doc.id);
                await s?.cancel();
              }
            }
          },
          onError: (error, [st]) {
            logger.e(
              'adventures[$cid/$chapId] error: $error',
              error: error,
              stackTrace: st as StackTrace?,
            );
          },
        );
    adventuresByChapter[chapId] = sub;
  }

  Future<void> _handleAdventure(DocumentSnapshot doc) async {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return;
      final normalized = _normTS(data);
      final remote = Adventure.fromJson({'id': doc.id, ...normalized});
      final isDirty = await db.adventuresDao.isDirty('adventures', doc.id);
      final local = await db.adventuresDao.getById(doc.id);
      if (!isDirty || (local != null && remote.rev >= local.rev)) {
        await db.adventuresDao.upsert(remote, markDirty: false);
        logger.t('adventures[$cid] upserted ${remote.id} rev=${remote.rev}');
      }
    } catch (e, st) {
      logger.e('handleAdventure error: $e', error: e, stackTrace: st);
    }
  }

  void _ensureScenesForAdventure(String chapId, String advId) {
    final map = scenesByChapterAdventure.putIfAbsent(chapId, () => {});
    if (map.containsKey(advId)) return;
    logger.d('Subscribing scenes for adventure $chapId/$advId');
    final sub = firestore
        .collection('campaigns')
        .doc(cid)
        .collection('chapters')
        .doc(chapId)
        .collection('adventures')
        .doc(advId)
        .collection('scenes')
        .snapshots()
        .listen(
          (snapshot) async {
            logger.t(
              '[scenes:$cid/$chapId/$advId] docs=${snapshot.docs.length} changes=${snapshot.docChanges.length}',
            );
            for (final change in snapshot.docChanges) {
              final doc = change.doc;
              if (change.type == DocumentChangeType.added ||
                  change.type == DocumentChangeType.modified) {
                await _handleScene(doc);
              }
            }
          },
          onError: (error, [st]) {
            logger.e(
              'scenes[$cid/$chapId/$advId] error: $error',
              error: error,
              stackTrace: st as StackTrace?,
            );
          },
        );
    map[advId] = sub;
  }

  Future<void> _handleScene(DocumentSnapshot doc) async {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return;
      final normalized = _normTS(data);
      final remote = scene_model.Scene.fromJson({'id': doc.id, ...normalized});
      final isDirty = await db.scenesDao.isDirty('scenes', doc.id);
      final local = await db.scenesDao.getById(doc.id);
      if (!isDirty || (local != null && remote.rev >= local.rev)) {
        await db.scenesDao.upsert(remote, markDirty: false);
        logger.t('scenes[$cid] upserted ${remote.id} rev=${remote.rev}');
      }
    } catch (e, st) {
      logger.e('handleScene error: $e', error: e, stackTrace: st);
    }
  }

  void _startEntities() {
    entities = _startSimpleSub<entity_model.Entity>(
      name: 'entities',
      upsert: (remote) => db.entitiesDao.upsert(remote, markDirty: false),
      isDirty: (id) => db.entitiesDao.isDirty('entities', id),
      getLocal: (id) => db.entitiesDao.getById(id),
      fromDoc: (doc) => entity_model.Entity.fromJson({
        'id': doc.id,
        ..._normTS(doc.data() as Map<String, dynamic>),
      }),
    );
  }

  void _startEncounters() {
    encounters = _startSimpleSub<encounter_model.Encounter>(
      name: 'encounters',
      upsert: (remote) => db.encountersDao.upsert(remote, markDirty: false),
      isDirty: (id) => db.encountersDao.isDirty('encounters', id),
      getLocal: (id) => db.encountersDao.getById(id),
      fromDoc: (doc) => encounter_model.Encounter.fromJson({
        'id': doc.id,
        ..._normTS(doc.data() as Map<String, dynamic>),
      }),
    );
  }

  void _startSessions() {
    sessions = _startSimpleSub<session_model.Session>(
      name: 'sessions',
      upsert: (remote) => db.sessionsDao.upsert(remote, markDirty: false),
      isDirty: (id) => db.sessionsDao.isDirty('sessions', id),
      getLocal: (id) => db.sessionsDao.getById(id),
      fromDoc: (doc) => session_model.Session.fromJson({
        'id': doc.id,
        ..._normTS(doc.data() as Map<String, dynamic>),
      }),
    );
  }

  void _startMedia() {
    media = _startSimpleSub<media_model.MediaAsset>(
      name: 'media',
      upsert: (remote) => db.mediaAssetsDao.upsert(remote, markDirty: false),
      isDirty: (id) => db.mediaAssetsDao.isDirty('media_assets', id),
      getLocal: (id) => db.mediaAssetsDao.getById(id),
      fromDoc: (doc) => media_model.MediaAsset.fromJson({
        'id': doc.id,
        ..._normTS(doc.data() as Map<String, dynamic>),
      }),
    );
  }

  void _startParties() {
    parties = _startSimpleSub<party_model.Party>(
      name: 'parties',
      upsert: (remote) => db.partiesDao.upsert(remote, markDirty: false),
      isDirty: (id) => db.partiesDao.isDirty('parties', id),
      getLocal: (id) => db.partiesDao.getById(id),
      fromDoc: (doc) => party_model.Party.fromJson({
        'id': doc.id,
        ..._normTS(doc.data() as Map<String, dynamic>),
      }),
    );
  }

  void _startPlayers() {
    players = _startSimpleSub<player_model.Player>(
      name: 'players',
      upsert: (remote) => db.playersDao.upsert(remote, markDirty: false),
      isDirty: (id) => db.playersDao.isDirty('players', id),
      getLocal: (id) => db.playersDao.getById(id),
      fromDoc: (doc) => player_model.Player.fromJson({
        'id': doc.id,
        ..._normTS(doc.data() as Map<String, dynamic>),
      }),
    );
  }

  StreamSubscription _startSimpleSub<T>({
    required String name,
    required Future<void> Function(dynamic remote) upsert,
    required Future<bool> Function(String id) isDirty,
    required Future<dynamic> Function(String id) getLocal,
    required dynamic Function(DocumentSnapshot doc) fromDoc,
  }) {
    final coll = firestore.collection('campaigns').doc(cid).collection(name);
    logger.d('Subscribing $name: campaigns/$cid/$name');
    return coll.snapshots().listen(
      (snapshot) async {
        logger.t(
          '[$name:$cid] docs=${snapshot.docs.length} changes=${snapshot.docChanges.length}',
        );
        for (final change in snapshot.docChanges) {
          if (change.type != DocumentChangeType.added &&
              change.type != DocumentChangeType.modified)
            continue;
          final doc = change.doc;
          try {
            final remote = fromDoc(doc);
            final dirty = await isDirty(doc.id);
            final local = await getLocal(doc.id);
            final remoteRev =
                (doc.data() as Map<String, dynamic>)['rev'] as int? ?? 0;
            final localRev = local == null
                ? null
                : (local as dynamic).rev as int?;
            if (!dirty || (localRev != null && remoteRev >= localRev)) {
              await upsert(remote);
              logger.t('$name[$cid] upserted ${doc.id} rev=$remoteRev');
            }
          } catch (e, st) {
            logger.e(
              '$name[$cid] handle error for ${doc.id}: $e',
              error: e,
              stackTrace: st,
            );
          }
        }
      },
      onError: (error, [st]) {
        logger.e(
          '$name[$cid] listener error: $error',
          error: error,
          stackTrace: st as StackTrace?,
        );
      },
    );
  }

  Map<String, dynamic> _normTS(Map<String, dynamic> data) {
    final normalized = Map<String, dynamic>.from(data);
    for (final key in const ['createdAt', 'updatedAt']) {
      final v = normalized[key];
      if (v is Timestamp) normalized[key] = v.toDate().toIso8601String();
    }
    return normalized;
  }
}
