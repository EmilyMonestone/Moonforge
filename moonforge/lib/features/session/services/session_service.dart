import 'dart:math';

import 'package:drift/drift.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/session_repository.dart';

/// Service for session lifecycle management and operations
class SessionService {
  final SessionRepository _repository;

  SessionService(this._repository);

  /// Generate a unique share token for session sharing
  static String generateShareToken() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(
      32,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  /// Enable sharing for a session
  Future<Session> enableSharing(Session session, {DateTime? expiresAt}) async {
    final token = generateShareToken();
    final updated = session.copyWith(
      shareToken: Value(token),
      shareEnabled: true,
      shareExpiresAt: Value(expiresAt),
    );
    await _repository.update(updated);
    return updated;
  }

  /// Disable sharing for a session
  Future<Session> disableSharing(Session session) async {
    final updated = session.copyWith(
      shareEnabled: false,
      shareToken: const Value(null),
      shareExpiresAt: const Value(null),
    );
    await _repository.update(updated);
    return updated;
  }

  /// Regenerate share token for a session
  Future<Session> regenerateShareToken(Session session) async {
    final token = generateShareToken();
    final updated = session.copyWith(shareToken: Value(token));
    await _repository.update(updated);
    return updated;
  }

  /// Check if a session share has expired
  static bool isShareExpired(Session session) {
    if (!session.shareEnabled) return true;
    if (session.shareExpiresAt == null) return false;
    return DateTime.now().isAfter(session.shareExpiresAt!);
  }

  /// Calculate session statistics
  /// Note: Duration tracking is not yet implemented in the Session model.
  /// This currently returns zero for duration-related stats.
  static SessionStats calculateStats(List<Session> sessions) {
    if (sessions.isEmpty) {
      return SessionStats(
        totalSessions: 0,
        averageDuration: Duration.zero,
        totalDuration: Duration.zero,
      );
    }

    // TODO: When duration field is added to Session model, calculate:
    // - Sum all session durations for totalDuration
    // - Calculate average from total divided by count
    // For now, return placeholder values

    return SessionStats(
      totalSessions: sessions.length,
      averageDuration: Duration.zero,
      totalDuration: Duration.zero,
    );
  }

  /// Get sessions by date range
  Future<List<Session>> getSessionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _repository.customQuery(
      filter: (s) =>
          s.datetime.isBiggerOrEqualValue(startDate) &
          s.datetime.isSmallerOrEqualValue(endDate),
      sort: [(s) => OrderingTerm.desc(s.datetime)],
    );
  }

  /// Get upcoming sessions
  Future<List<Session>> getUpcomingSessions({int limit = 5}) async {
    final now = DateTime.now();
    return await _repository.customQuery(
      filter: (s) => s.datetime.isBiggerOrEqualValue(now),
      sort: [(s) => OrderingTerm.asc(s.datetime)],
      limit: limit,
    );
  }

  /// Get past sessions
  Future<List<Session>> getPastSessions({int limit = 10}) async {
    final now = DateTime.now();
    return await _repository.customQuery(
      filter: (s) => s.datetime.isSmallerThanValue(now),
      sort: [(s) => OrderingTerm.desc(s.datetime)],
      limit: limit,
    );
  }
}

/// Statistics for sessions
class SessionStats {
  final int totalSessions;
  final Duration averageDuration;
  final Duration totalDuration;

  SessionStats({
    required this.totalSessions,
    required this.averageDuration,
    required this.totalDuration,
  });
}
