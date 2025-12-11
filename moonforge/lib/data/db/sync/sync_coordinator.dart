import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moonforge/core/utils/logger.dart';

import '../app_db.dart';
import 'inbound_listener.dart';
import 'outbox_processor.dart';

/// Coordinates bidirectional sync between Drift and Firestore
class SyncCoordinator {
  final AppDb _db;
  final FirebaseFirestore _firestore;

  late final OutboxProcessor _outboxProcessor;
  late final InboundListener _inboundListener;

  Timer? _pushTimer;
  StreamSubscription<User?>? _authSubscription;

  /// Interval for periodic outbox flushing
  static const Duration _flushInterval = Duration(seconds: 5);

  SyncCoordinator(this._db, this._firestore) {
    logger.i('SyncCoordinator: Initializing...', context: LogContext.sync);
    _outboxProcessor = OutboxProcessor(_db, _firestore);
    _inboundListener = InboundListener(_db, _firestore);
  }

  /// Start the sync coordinator
  void start() {
    logger.i('SyncCoordinator: Starting...', context: LogContext.sync);
    // React to auth changes
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        if (user != null) {
          logger.i(
            'SyncCoordinator: User authenticated (uid: ${user.uid}), starting sync',
            context: LogContext.sync,
          );
          _inboundListener.start(user.uid);
          _startPushLoop();
        } else {
          logger.i(
            'SyncCoordinator: User logged out, stopping sync',
            context: LogContext.sync,
          );
          _inboundListener.stop();
          _pushTimer?.cancel();
        }
      },
      onError: (e, st) {
        logger.e('SyncCoordinator: Auth state error: $e', context: LogContext.sync);
      },
    );
  }

  /// Stop the sync coordinator
  void stop() {
    logger.i('SyncCoordinator: Stopping...', context: LogContext.sync);
    _authSubscription?.cancel();
    _pushTimer?.cancel();
    _inboundListener.stop();
  }

  /// Start periodic push loop to flush outbox
  void _startPushLoop() {
    _pushTimer?.cancel();

    logger.d(
      'SyncCoordinator: Starting push loop (initial flush + every ${_flushInterval.inSeconds}s)',
      context: LogContext.sync,
    );

    // Initial flush
    _flush();

    // Periodic flush
    _pushTimer = Timer.periodic(_flushInterval, (_) {
      _flush();
    });
  }

  Future<void> _flush() async {
    try {
      logger.d('SyncCoordinator: Flushing outbox...', context: LogContext.sync);
      await _outboxProcessor.flush();
      logger.d('SyncCoordinator: Flush completed', context: LogContext.sync);
    } catch (e) {
      logger.e('SyncCoordinator: Flush error: $e', context: LogContext.sync);
    }
  }

  /// Manually trigger a sync flush
  Future<void> triggerSync() async {
    logger.i('SyncCoordinator: Manual sync triggered', context: LogContext.sync);
    await _flush();
  }
}
