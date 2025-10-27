import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/widgets/sync_state_widget.dart';

/// Provider that tracks the current sync state of the offline-first system
class SyncStateProvider extends ChangeNotifier {
  final AppDatabase _db;
  SyncState _state = SyncState.synced;
  int _pendingCount = 0;
  String? _errorMessage;
  Timer? _pollTimer;

  SyncStateProvider(this._db) {
    _startPolling();
  }

  SyncState get state => _state;
  int get pendingCount => _pendingCount;
  String? get errorMessage => _errorMessage;

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _updateState();
    });
    _updateState(); // Initial check
  }

  Future<void> _updateState() async {
    try {
      // Get pending outbox count
      final outboxCount = await _db.outboxDao.pendingCount();
      
      // Get pending storage queue count
      final storageCount = await _db.storageQueueDao.pendingCount();
      
      final totalPending = outboxCount + storageCount;

      // Check if any operations are in progress
      final inProgressOps = await _db.select(_db.storageQueue)
          .where((op) => op.status.equals('in_progress'))
          .get();

      SyncState newState;
      if (inProgressOps.isNotEmpty) {
        newState = SyncState.syncing;
      } else if (totalPending > 0) {
        newState = SyncState.pendingSync;
      } else {
        newState = SyncState.synced;
      }

      if (_state != newState || _pendingCount != totalPending) {
        _state = newState;
        _pendingCount = totalPending;
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      if (_state != SyncState.error) {
        _state = SyncState.error;
        _errorMessage = e.toString();
        notifyListeners();
      }
    }
  }

  /// Manually trigger a sync state update
  Future<void> refresh() async {
    await _updateState();
  }

  /// Set offline state
  void setOffline() {
    if (_state != SyncState.offline) {
      _state = SyncState.offline;
      notifyListeners();
    }
  }

  /// Set online state and refresh
  Future<void> setOnline() async {
    await _updateState();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }
}
