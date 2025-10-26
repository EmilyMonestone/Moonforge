import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:moonforge/core/models/data/campaign.dart';
import 'package:moonforge/data/drift/app_database.dart';

/// Sync engine that coordinates pull (Firestore → Drift) and push (Outbox → Firestore)
/// with Compare-And-Set (CAS) conflict resolution on the rev field
class SyncEngine {
  final AppDatabase _db;
  final FirebaseFirestore _firestore;
  
  StreamSubscription? _pullSubscription;
  Timer? _pushTimer;
  bool _isProcessing = false;

  SyncEngine(this._db, this._firestore);

  /// Start the sync engine
  void start() {
    _startPull();
    _startPushLoop();
  }

  /// Stop the sync engine
  void stop() {
    _pullSubscription?.cancel();
    _pushTimer?.cancel();
  }

  /// Pull: Listen to Firestore snapshots and adopt remote changes when not dirty
  void _startPull() {
    _pullSubscription = _firestore
        .collection('campaigns')
        .snapshots()
        .listen((snapshot) async {
      for (final change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added ||
            change.type == DocumentChangeType.modified) {
          await _handleRemoteChange(change.doc);
        }
      }
    }, onError: (error) {
      debugPrint('⚠️ Firestore pull error: $error');
    });
  }

  /// Handle a remote document change
  Future<void> _handleRemoteChange(DocumentSnapshot doc) async {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return;

      final remote = Campaign.fromJson({'id': doc.id, ...data});
      final isDirty = await _db.campaignsDao.isDirty(doc.id);

      // Only adopt remote if local is clean OR remote rev is ahead
      final local = await _db.campaignsDao.getById(doc.id);
      if (!isDirty || (local != null && remote.rev >= local.rev)) {
        await _db.campaignsDao.upsertCampaign(remote, markDirty: false);
      }
    } catch (e) {
      debugPrint('⚠️ Error handling remote change: $e');
    }
  }

  /// Push: Process outbox operations with backoff
  void _startPushLoop() {
    _pushTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_isProcessing) {
        _processOutbox();
      }
    });
  }

  /// Process next operation in outbox
  Future<void> _processOutbox() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final op = await _db.outboxDao.nextOp();
      if (op == null) return;

      await _processOne(op);
    } catch (e) {
      debugPrint('⚠️ Outbox processing error: $e');
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
      }
    } catch (e) {
      debugPrint('⚠️ Failed to process op ${op.id}: $e');
      await _db.outboxDao.markAttempt(op.id);
      
      // Give up after 10 attempts
      if (op.attempt >= 10) {
        debugPrint('⚠️ Giving up on op ${op.id} after ${op.attempt} attempts');
        await _db.outboxDao.remove(op.id);
      }
    }
  }

  /// Process an upsert operation
  Future<void> _processUpsert(OutboxOp op) async {
    final docRef = _firestore.collection(op.docPath).doc(op.docId);
    
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final data = jsonDecode(op.payload) as Map<String, dynamic>;
      final localCampaign = Campaign.fromJson(data);

      if (!snapshot.exists) {
        // Create new document
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
    
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        // Document deleted remotely, remove op
        await _db.outboxDao.remove(op.id);
        return;
      }

      final remoteData = snapshot.data()!;
      final remoteRev = remoteData['rev'] as int? ?? 0;
      final remote = Campaign.fromJson({'id': op.docId, ...remoteData});

      // Parse patch operations
      final payload = jsonDecode(op.payload) as Map<String, dynamic>;
      final ops = (payload['ops'] as List).cast<Map<String, dynamic>>();

      // Apply patch operations
      Campaign updated = remote;
      for (final patchOp in ops) {
        updated = _applyOp(updated, patchOp);
      }

      transaction.update(docRef, {
        ...updated.toJson()..remove('id'),
        'rev': remoteRev + 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _db.campaignsDao.setClean(op.docId, remoteRev + 1);
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
