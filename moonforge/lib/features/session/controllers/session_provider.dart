import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';

/// Provider for managing session state
class SessionProvider with ChangeNotifier {
  Session? _currentSession;
  bool _isSessionActive = false;
  DateTime? _sessionStartTime;
  Duration _sessionDuration = Duration.zero;

  Session? get currentSession => _currentSession;
  bool get isSessionActive => _isSessionActive;
  DateTime? get sessionStartTime => _sessionStartTime;
  Duration get sessionDuration => _sessionDuration;

  /// Set the current active session
  void setCurrentSession(Session? session) {
    _currentSession = session;
    notifyListeners();
  }

  /// Start a session timer
  void startSession() {
    if (_currentSession == null) return;
    _isSessionActive = true;
    _sessionStartTime = DateTime.now();
    notifyListeners();
  }

  /// Pause a session timer
  void pauseSession() {
    if (!_isSessionActive) return;
    _isSessionActive = false;
    if (_sessionStartTime != null) {
      _sessionDuration += DateTime.now().difference(_sessionStartTime!);
    }
    notifyListeners();
  }

  /// Resume a paused session
  void resumeSession() {
    if (_currentSession == null) return;
    _isSessionActive = true;
    _sessionStartTime = DateTime.now();
    notifyListeners();
  }

  /// End a session and reset state
  void endSession() {
    if (_sessionStartTime != null && _isSessionActive) {
      _sessionDuration += DateTime.now().difference(_sessionStartTime!);
    }
    _isSessionActive = false;
    _sessionStartTime = null;
    _sessionDuration = Duration.zero;
    notifyListeners();
  }

  /// Get current session elapsed time
  Duration getCurrentElapsedTime() {
    if (!_isSessionActive || _sessionStartTime == null) {
      return _sessionDuration;
    }
    return _sessionDuration + DateTime.now().difference(_sessionStartTime!);
  }

  /// Clear the current session
  void clearSession() {
    _currentSession = null;
    _isSessionActive = false;
    _sessionStartTime = null;
    _sessionDuration = Duration.zero;
    notifyListeners();
  }
}
