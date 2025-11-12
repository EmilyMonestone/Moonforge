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

  SyncCoordinator(this._db, this._firestore) {
    _outboxProcessor = OutboxProcessor(_db, _firestore);
    _inboundListener = InboundListener(_db, _firestore);
  }

  /// Start the sync coordinator
  void start() {
    // React to auth changes
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        if (user != null) {
          _inboundListener.start(user.uid);
          _startPushLoop();
        } else {
          _inboundListener.stop();
          _pushTimer?.cancel();
        }
      },
      onError: (e, st) {
        logger.e('SyncCoordinator: Auth state error: $e');
      },
    );
  }

  /// Stop the sync coordinator
  void stop() {
    logger.i('SyncCoordinator: Stopping...');
    _authSubscription?.cancel();
    _pushTimer?.cancel();
    _inboundListener.stop();
  }

  /// Start periodic push loop to flush outbox
  void _startPushLoop() {
    _pushTimer?.cancel();

    // Initial flush
    _flush();

    // Periodic flush every 5 seconds
    _pushTimer = Timer.periodic(Duration(seconds: 5), (_) {
      _flush();
    });
  }

  Future<void> _flush() async {
    try {
      await _outboxProcessor.flush();
    } catch (e) {
      logger.e('SyncCoordinator: Flush error: $e');
    }
  }

  /// Manually trigger a sync flush
  Future<void> triggerSync() async {
    await _flush();
  }
}
