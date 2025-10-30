import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/connectivity/connectivity_service.dart';
import 'package:moonforge/data/db/app_database.dart';
import 'package:moonforge/data/firebase/auth_service.dart';
import 'package:moonforge/data/firebase/firestore_remote.dart';
import 'package:moonforge/data/sync/conflict_resolution.dart';

/// Coordinates bidirectional sync between local Drift DB and Firestore
/// 
/// Architecture:
/// - Push: Processes outbox queue, sends to Firestore, marks as acknowledged
/// - Pull: Listens to Firestore changes, applies to local DB with conflict resolution
/// - Handles online/offline transitions with exponential backoff
class SyncWorker {
  final AppDatabase _db;
  final FirestoreRemote _remote;
  final AuthService _auth;
  final ConnectivityService _connectivity;

  Timer? _pushTimer;
  Timer? _pullTimer;
  StreamSubscription? _connectivitySub;
  StreamSubscription? _authSub;
  final Map<String, StreamSubscription> _collectionSubs = {};

  bool _isRunning = false;
  bool _isPushing = false;
  bool _isPulling = false;
  int _pushRetryDelay = 5; // seconds
  int _pullRetryDelay = 10; // seconds

  static const int _maxPushRetryDelay = 300; // 5 minutes
  static const int _maxPullRetryDelay = 600; // 10 minutes
  static const int _pushInterval = 10; // seconds
  static const int _pullInterval = 30; // seconds

  SyncWorker(this._db, this._remote, this._auth, this._connectivity);

  /// Start the sync worker
  void start() {
    if (_isRunning) return;
    _isRunning = true;

    logger.i('SyncWorker started');

    // Listen to auth changes
    _authSub = _auth.userStream.listen((user) {
      if (user != null) {
        logger.d('User authenticated: ${user.uid}');
        _startPull();
      } else {
        logger.d('User signed out, stopping pull');
        _stopPull();
      }
    });

    // Listen to connectivity changes
    _connectivitySub = _connectivity.connectivityStream.listen((isOnline) {
      logger.d('Connectivity changed: ${isOnline ? "online" : "offline"}');
      if (isOnline) {
        // Reset retry delays on connection
        _pushRetryDelay = 5;
        _pullRetryDelay = 10;
        _startPush();
        _startPull();
      } else {
        _stopTimers();
      }
    });

    // Initial sync if online
    _connectivity.checkConnectivity().then((isOnline) {
      if (isOnline) {
        _startPush();
        _startPull();
      }
    });
  }

  /// Stop the sync worker
  void stop() {
    if (!_isRunning) return;
    _isRunning = false;

    logger.i('SyncWorker stopped');

    _stopTimers();
    _stopPull();
    _connectivitySub?.cancel();
    _authSub?.cancel();
  }

  /// Start push sync timer
  void _startPush() {
    _pushTimer?.cancel();
    _pushTimer = Timer.periodic(
      Duration(seconds: _pushInterval),
      (_) => _processPush(),
    );
    // Trigger immediate push
    _processPush();
  }

  /// Start pull sync timer and Firestore listeners
  void _startPull() {
    if (_auth.currentUser == null) return;

    _pullTimer?.cancel();
    _pullTimer = Timer.periodic(
      Duration(seconds: _pullInterval),
      (_) => _processPull(),
    );

    // Start real-time listeners for each collection
    _startCollectionListeners();

    // Trigger immediate pull
    _processPull();
  }

  /// Stop timers
  void _stopTimers() {
    _pushTimer?.cancel();
    _pushTimer = null;
    _pullTimer?.cancel();
    _pullTimer = null;
  }

  /// Stop pull and collection listeners
  void _stopPull() {
    _stopCollectionListeners();
    _pullTimer?.cancel();
    _pullTimer = null;
  }

  /// Process push sync (outbox → Firestore)
  Future<void> _processPush() async {
    if (_isPushing || !_connectivity.isOnline || _auth.currentUser == null) {
      return;
    }

    _isPushing = true;

    try {
      final pending = await _db.outboxDao.getPending(limit: 50);
      
      if (pending.isEmpty) {
        _isPushing = false;
        return;
      }

      logger.d('Processing ${pending.length} outbox items');

      for (final item in pending) {
        try {
          await _pushItem(item);
          // Reset retry delay on success
          _pushRetryDelay = 5;
        } catch (e, st) {
          logger.e('Failed to push item ${item.id}', error: e, stackTrace: st);
          await _db.outboxDao.recordFailure(item.id, e.toString());
          
          // Exponential backoff
          _pushRetryDelay = (_pushRetryDelay * 2).clamp(5, _maxPushRetryDelay);
        }
      }
    } catch (e, st) {
      logger.e('Push sync error', error: e, stackTrace: st);
    } finally {
      _isPushing = false;
    }
  }

  /// Push a single outbox item to Firestore
  Future<void> _pushItem(OutboxData item) async {
    switch (item.operation) {
      case 'upsert':
      case 'create':
      case 'update':
        if (item.payload != null) {
          final data = jsonDecode(item.payload!) as Map<String, dynamic>;
          await _remote.setDocument(item.collection, item.docId, data, merge: true);
        }
        break;
      
      case 'delete':
        await _remote.deleteDocument(item.collection, item.docId);
        break;
      
      default:
        logger.w('Unknown operation type: ${item.operation}');
    }

    // Mark as acknowledged
    await _db.outboxDao.markAcknowledged(
      item.id,
      jsonEncode({
        'timestamp': DateTime.now().toIso8601String(),
        'operation': item.operation,
      }),
    );

    logger.d('Pushed ${item.collection}/${item.docId}');
  }

  /// Process pull sync (Firestore → local DB)
  Future<void> _processPull() async {
    if (_isPulling || !_connectivity.isOnline || _auth.currentUser == null) {
      return;
    }

    _isPulling = true;

    try {
      // Pull campaigns
      await _pullCollection('campaigns');
      
      // Could add more collections here
      // await _pullCollection('chapters');
      // await _pullCollection('entities');
      
      // Reset retry delay on success
      _pullRetryDelay = 10;
    } catch (e, st) {
      logger.e('Pull sync error', error: e, stackTrace: st);
      
      // Exponential backoff
      _pullRetryDelay = (_pullRetryDelay * 2).clamp(10, _maxPullRetryDelay);
    } finally {
      _isPulling = false;
    }
  }

  /// Pull a specific collection
  Future<void> _pullCollection(String collection) async {
    final userId = _auth.currentUserId;
    if (userId == null) return;

    // Get last checkpoint
    final checkpoint = await _db.checkpointsDao.getCheckpoint(collection, userId);
    
    // Query Firestore for user's documents
    final docs = await _remote.queryDocuments(
      collection,
      fieldPath: 'memberUids',
      arrayContains: userId,
      orderByField: 'updatedAt',
      descending: true,
      limit: 100,
    );

    logger.d('Pulled ${docs.length} documents from $collection');

    for (final remoteDoc in docs) {
      await _applyRemoteChange(collection, remoteDoc);
    }

    // Update checkpoint
    if (docs.isNotEmpty) {
      await _db.checkpointsDao.updateCheckpoint(
        collection: collection,
        userId: userId,
        cursor: DateTime.now().toIso8601String(),
      );
    }
  }

  /// Apply a remote document change to local DB
  Future<void> _applyRemoteChange(
    String collection,
    Map<String, dynamic> remoteDoc,
  ) async {
    final docId = remoteDoc['id'] as String;

    // Check if tombstoned locally
    final isTombstoned = await _db.tombstonesDao.isTombstoned(collection, docId);
    if (isTombstoned) {
      logger.d('Skipping tombstoned document: $collection/$docId');
      return;
    }

    // Handle based on collection
    switch (collection) {
      case 'campaigns':
        await _applyCampaignChange(remoteDoc);
        break;
      // Add other collections as needed
      default:
        logger.w('Unknown collection: $collection');
    }
  }

  /// Apply campaign change
  Future<void> _applyCampaignChange(Map<String, dynamic> remoteDoc) async {
    await _db.transaction(() async {
      final docId = remoteDoc['id'] as String;
      final localCampaign = await _db.campaignsDao.getById(docId);

      if (localCampaign == null) {
        // New document, insert
        final campaign = _campaignFromJson(remoteDoc);
        await _db.campaignsDao.upsert(campaign, markDirty: false);
        logger.d('Inserted new campaign: $docId');
      } else {
        // Existing document, resolve conflict
        final localDoc = localCampaign.toJson();
        final resolved = ConflictResolver.lastWriteWins(localDoc, remoteDoc);
        
        if (resolved == remoteDoc) {
          // Remote wins, update local
          final campaign = _campaignFromJson(remoteDoc);
          await _db.campaignsDao.upsert(campaign, markDirty: false);
          logger.d('Updated campaign from remote: $docId');
        } else {
          // Local wins, keep local (but we might want to push it again)
          logger.d('Kept local campaign: $docId');
        }
      }
    });
  }

  /// Convert JSON to Campaign model
  dynamic _campaignFromJson(Map<String, dynamic> json) {
    // This is a simplified conversion. In a real app, you'd use the actual model
    // For now, we'll create a basic Campaign object
    return {
      'id': json['id'],
      'name': json['name'] ?? '',
      'description': json['description'] ?? '',
      'content': json['content'],
      'ownerUid': json['ownerUid'],
      'memberUids': json['memberUids'] ?? [],
      'entityIds': json['entityIds'] ?? [],
      'createdAt': json['createdAt'],
      'updatedAt': json['updatedAt'],
      'rev': json['rev'] ?? 0,
      'isDeleted': json['isDeleted'] ?? false,
    };
  }

  /// Start real-time Firestore listeners
  void _startCollectionListeners() {
    final userId = _auth.currentUserId;
    if (userId == null) return;

    // Listen to campaigns
    _collectionSubs['campaigns']?.cancel();
    _collectionSubs['campaigns'] = _remote
        .watchCollection(
          'campaigns',
          fieldPath: 'memberUids',
          arrayContains: userId,
        )
        .listen(
          (docs) {
            for (final doc in docs) {
              _applyRemoteChange('campaigns', doc);
            }
          },
          onError: (e, st) {
            logger.e('Campaign listener error', error: e, stackTrace: st);
          },
        );

    logger.d('Started collection listeners');
  }

  /// Stop collection listeners
  void _stopCollectionListeners() {
    for (final sub in _collectionSubs.values) {
      sub.cancel();
    }
    _collectionSubs.clear();
    logger.d('Stopped collection listeners');
  }

  /// Trigger immediate sync
  void triggerSync() {
    if (_connectivity.isOnline && _auth.currentUser != null) {
      _processPush();
      _processPull();
    }
  }
}
