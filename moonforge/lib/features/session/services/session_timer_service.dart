import 'dart:async';
import 'package:flutter/material.dart';

/// Service for tracking session duration with timer functionality
class SessionTimerService extends ChangeNotifier {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  DateTime? _startTime;
  bool _isRunning = false;
  bool _isPaused = false;
  Duration _pausedDuration = Duration.zero;

  Duration get elapsed => _elapsed;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  DateTime? get startTime => _startTime;

  /// Start the session timer
  void start() {
    if (_isRunning) return;

    _isRunning = true;
    _isPaused = false;
    _startTime = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        _elapsed = DateTime.now().difference(_startTime!) - _pausedDuration;
        notifyListeners();
      }
    });
  }

  /// Pause the session timer
  void pause() {
    if (!_isRunning || _isPaused) return;

    _isPaused = true;
    // Calculate current elapsed time before pausing
    _elapsed = DateTime.now().difference(_startTime!) - _pausedDuration;
    notifyListeners();
  }

  /// Resume the session timer
  void resume() {
    if (!_isRunning || !_isPaused) return;

    _isPaused = false;
    // Store the paused duration and reset start time
    _pausedDuration = _elapsed;
    _startTime = DateTime.now();
    notifyListeners();
  }

  /// Stop the session timer and return total duration
  Duration stop() {
    if (!_isRunning) return _elapsed;

    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _isPaused = false;

    final totalDuration = _elapsed;

    // Reset state
    _elapsed = Duration.zero;
    _startTime = null;
    _pausedDuration = Duration.zero;

    notifyListeners();
    return totalDuration;
  }

  /// Reset the timer to zero
  void reset() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _isPaused = false;
    _elapsed = Duration.zero;
    _startTime = null;
    _pausedDuration = Duration.zero;
    notifyListeners();
  }

  /// Format duration as HH:MM:SS
  static String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  /// Format duration as human-readable string
  static String formatDurationHuman(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      if (minutes > 0) {
        return '$hours hr $minutes min';
      }
      return '$hours hr';
    } else if (duration.inMinutes > 0) {
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds % 60;
      if (seconds > 0) {
        return '$minutes min $seconds sec';
      }
      return '$minutes min';
    } else {
      return '${duration.inSeconds} sec';
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
