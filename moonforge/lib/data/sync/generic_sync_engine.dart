import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:moonforge/data/drift/app_database.dart';

/// Generic sync engine for syncing any Firestore collection with Drift
/// Supports CAS (Compare-And-Set) conflict resolution on rev field
class GenericSyncEngine {
  final AppDatabase _db;
  final FirebaseFirestore _firestore;
  final Map<String, CollectionSyncConfig> _collections = {};
  final Map<String, StreamSubscription?> _subscriptions = {};
  Timer? _pushTimer;
  bool _isProcessing = false;

  GenericSyncEngine(this._db, this._firestore);

  /// Register a collection for sync
  void registerCollection(CollectionSyncConfig config) {
    _collections[config.collectionName] = config;
  }

  /// Start syncing all registered collections
  void start() {
    for (final config in _collections.values) {
      _startPullFor(config);
    }
    _startPushLoop();
  }

  /// Stop all sync operations
  void stop() {
    for (final sub in _subscriptions.values) {
      sub?.cancel();
    }
    _subscriptions.clear();
    _pushTimer?.cancel();
  }

  /// Pull: Listen to Firestore snapshots for a specific collection
  void _startPullFor(CollectionSyncConfig config) {
    _subscriptions[config.collectionName] = _firestore
        .collection(config.collectionName)
        .snapshots()
        .listen((snapshot) async {
      for (final change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added ||
            change.type == DocumentChangeType.modified) {
          await _handleRemoteChange(config, change.doc);
        }
      }
    }, onError: (error) {
      debugPrint('⚠️ Firestore pull error for ${config.collectionName}: $error');
    });
  }

  /// Handle a remote document change
  Future<void> _handleRemoteChange(
    CollectionSyncConfig config,
    DocumentSnapshot doc,
  ) async {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return;

      final remoteDoc = {'id': doc.id, ...data};
      final remoteRev = data['rev'] as int? ?? 0;

      // Check if local is dirty
      final isDirty = await config.isDirty(_db, doc.id);

      if (!isDirty) {
        // Not dirty, adopt remote
        await config.upsert(_db, remoteDoc, markDirty: false);
      } else {
        // Dirty, check if remote is ahead
        final local = await config.getById(_db, doc.id);
        final localRev = config.getRevFromDoc(local) ?? 0;

        if (remoteRev >= localRev) {
          // Remote is ahead or equal, adopt it
          await config.upsert(_db, remoteDoc, markDirty: false);
        }
        // Else keep local changes
      }
    } catch (e) {
      debugPrint('⚠️ Error handling remote change: $e');
    }
  }

  /// Push: Process outbox operations
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

      final config = _collections[op.docPath];
      if (config == null) {
        debugPrint('⚠️ No config for collection: ${op.docPath}');
        await _db.outboxDao.remove(op.id);
        return;
      }

      await _processOne(config, op);
    } catch (e) {
      debugPrint('⚠️ Outbox processing error: $e');
    } finally {
      _isProcessing = false;
    }
  }

  /// Process a single outbox operation
  Future<void> _processOne(CollectionSyncConfig config, OutboxOp op) async {
    try {
      if (op.opType == 'upsert') {
        await _processUpsert(config, op);
      } else if (op.opType == 'patch') {
        await _processPatch(config, op);
      }
    } catch (e) {
      debugPrint('⚠️ Failed to process op ${op.id}: $e');
      await _db.outboxDao.markAttempt(op.id);

      if (op.attempt >= 10) {
        debugPrint('⚠️ Giving up on op ${op.id} after ${op.attempt} attempts');
        await _db.outboxDao.remove(op.id);
      }
    }
  }

  /// Process an upsert operation
  Future<void> _processUpsert(CollectionSyncConfig config, OutboxOp op) async {
    final docRef = _firestore.collection(op.docPath).doc(op.docId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final data = jsonDecode(op.payload) as Map<String, dynamic>;

      if (!snapshot.exists) {
        // Create new document
        transaction.set(docRef, {
          ...data..remove('id'),
          'rev': 0,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        await config.setClean(_db, op.docId, 0);
        await _db.outboxDao.remove(op.id);
      } else {
        // Update existing with CAS
        final remoteData = snapshot.data()!;
        final remoteRev = remoteData['rev'] as int? ?? 0;

        if (remoteRev == op.baseRev) {
          // No conflict
          transaction.update(docRef, {
            ...data..remove('id'),
            'rev': remoteRev + 1,
            'updatedAt': FieldValue.serverTimestamp(),
          });

          await config.setClean(_db, op.docId, remoteRev + 1);
          await _db.outboxDao.remove(op.id);
        } else {
          // Conflict: merge and apply
          final merged = config.mergeConflict(remoteData, data);

          transaction.update(docRef, {
            ...merged..remove('id'),
            'rev': remoteRev + 1,
            'updatedAt': FieldValue.serverTimestamp(),
          });

          await config.setClean(_db, op.docId, remoteRev + 1);
          await _db.outboxDao.remove(op.id);
        }
      }
    });
  }

  /// Process a patch operation
  Future<void> _processPatch(CollectionSyncConfig config, OutboxOp op) async {
    final docRef = _firestore.collection(op.docPath).doc(op.docId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        await _db.outboxDao.remove(op.id);
        return;
      }

      final remoteData = snapshot.data()!;
      final remoteRev = remoteData['rev'] as int? ?? 0;

      // Parse and apply patch operations
      final payload = jsonDecode(op.payload) as Map<String, dynamic>;
      final ops = (payload['ops'] as List).cast<Map<String, dynamic>>();

      var updated = Map<String, dynamic>.from(remoteData);
      for (final patchOp in ops) {
        updated = config.applyPatchOp(updated, patchOp);
      }

      transaction.update(docRef, {
        ...updated..remove('id'),
        'rev': remoteRev + 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await config.setClean(_db, op.docId, remoteRev + 1);
      await _db.outboxDao.remove(op.id);
    });
  }
}

/// Configuration for syncing a specific collection
class CollectionSyncConfig<T> {
  final String collectionName;
  
  /// Get document by ID from local database
  final Future<Map<String, dynamic>?> Function(AppDatabase db, String id) getById;
  
  /// Upsert document to local database
  final Future<void> Function(AppDatabase db, Map<String, dynamic> doc, {bool markDirty}) upsert;
  
  /// Mark document as clean and set new rev
  final Future<void> Function(AppDatabase db, String id, int newRev) setClean;
  
  /// Check if document is dirty
  final Future<bool> Function(AppDatabase db, String id) isDirty;
  
  /// Get rev from document map
  final int? Function(Map<String, dynamic>? doc) getRevFromDoc;
  
  /// Merge conflicting changes (remote + local)
  final Map<String, dynamic> Function(Map<String, dynamic> remote, Map<String, dynamic> local) mergeConflict;
  
  /// Apply a patch operation to a document
  final Map<String, dynamic> Function(Map<String, dynamic> doc, Map<String, dynamic> op) applyPatchOp;

  CollectionSyncConfig({
    required this.collectionName,
    required this.getById,
    required this.upsert,
    required this.setClean,
    required this.isDirty,
    required this.getRevFromDoc,
    required this.mergeConflict,
    required this.applyPatchOp,
  });
}
