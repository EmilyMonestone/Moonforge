import 'dart:math';
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
  Future<Session> enableSharing(
    Session session, {
    DateTime? expiresAt,
  }) async {
    final token = generateShareToken();
    final updatedSession = session.copyWith(
      shareToken: token,
      shareEnabled: true,
      shareExpiresAt: expiresAt,
    );
    await _repository.update(updatedSession);
    return updatedSession;
  }

  /// Disable sharing for a session
  Future<Session> disableSharing(Session session) async {
    final updatedSession = session.copyWith(
      shareEnabled: false,
      shareToken: null,
      shareExpiresAt: null,
    );
    await _repository.update(updatedSession);
    return updatedSession;
  }

  /// Regenerate share token for a session
  Future<Session> regenerateShareToken(Session session) async {
    final token = generateShareToken();
    final updatedSession = session.copyWith(
      shareToken: token,
    );
    await _repository.update(updatedSession);
    return updatedSession;
  }

  /// Check if a session share has expired
  static bool isShareExpired(Session session) {
    if (!session.shareEnabled) return true;
    if (session.shareExpiresAt == null) return false;
    return DateTime.now().isAfter(session.shareExpiresAt!);
  }

  /// Calculate session statistics
  static SessionStats calculateStats(List<Session> sessions) {
    if (sessions.isEmpty) {
      return SessionStats(
        totalSessions: 0,
        averageDuration: Duration.zero,
        totalDuration: Duration.zero,
      );
    }

    var totalDuration = Duration.zero;
    var sessionsWithDuration = 0;

    for (final session in sessions) {
      // Note: Duration tracking would need to be added to the Session model
      // For now, we're just counting sessions
      sessionsWithDuration++;
    }

    final avgDuration = sessionsWithDuration > 0
        ? Duration(
            milliseconds:
                totalDuration.inMilliseconds ~/ sessionsWithDuration,
          )
        : Duration.zero;

    return SessionStats(
      totalSessions: sessions.length,
      averageDuration: avgDuration,
      totalDuration: totalDuration,
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
