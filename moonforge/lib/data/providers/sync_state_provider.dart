import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:moonforge/data/models/outbox_operation.dart';
import 'package:moonforge/data/widgets/sync_state_widget.dart';

/// Provider that tracks the current sync state of the offline-first system
class SyncStateProvider extends ChangeNotifier {
  final Isar _isar;
  SyncState _state = SyncState.synced;
  int _pendingCount = 0;
  String? _errorMessage;
  Timer? _pollTimer;

  SyncStateProvider(this._isar) {
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
      final pendingOps = await _isar.outboxOperations
          .filter()
          .statusEqualTo('pending')
          .count();
      
      // Get syncing operations count
      final syncingOps = await _isar.outboxOperations
          .filter()
          .statusEqualTo('syncing')
          .count();
      
      final totalPending = pendingOps + syncingOps;

      SyncState newState;
      if (syncingOps > 0) {
        newState = SyncState.syncing;
      } else if (pendingOps > 0) {
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
