import 'package:drift/drift.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/session_repository.dart';

/// Service for managing session scheduling and calendar operations
class SessionCalendarService {
  final SessionRepository _repository;

  SessionCalendarService(this._repository);

  /// Get sessions within a date range
  Future<List<Session>> getSessionsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _repository.customQuery(
      filter: (s) =>
          s.datetime.isBiggerOrEqualValue(startDate) &
          s.datetime.isSmallerOrEqualValue(endDate),
      sort: [(s) => OrderingTerm.asc(s.datetime)],
    );
  }

  /// Get sessions for a specific month
  Future<List<Session>> getSessionsForMonth(int year, int month) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59);
    return await getSessionsInRange(startDate, endDate);
  }

  /// Get sessions for a specific week
  Future<List<Session>> getSessionsForWeek(DateTime date) async {
    final startOfWeek = date.subtract(Duration(days: date.weekday % 7));
    final endOfWeek = startOfWeek.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );
    return await getSessionsInRange(startOfWeek, endOfWeek);
  }

  /// Get sessions for a specific day
  Future<List<Session>> getSessionsForDay(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return await getSessionsInRange(startOfDay, endOfDay);
  }

  /// Schedule a session for a specific date/time
  Future<void> scheduleSession(Session session, DateTime dateTime) async {
    final updatedSession = session.copyWith(datetime: Value(dateTime));
    await _repository.update(updatedSession);
  }

  /// Reschedule a session to a new date/time
  Future<void> rescheduleSession(Session session, DateTime newDateTime) async {
    await scheduleSession(session, newDateTime);
  }

  /// Get upcoming sessions (future sessions only)
  Future<List<Session>> getUpcomingSessions({int limit = 10}) async {
    final now = DateTime.now();
    return await _repository.customQuery(
      filter: (s) => s.datetime.isBiggerOrEqualValue(now),
      sort: [(s) => OrderingTerm.asc(s.datetime)],
      limit: limit,
    );
  }

  /// Get past sessions (historical sessions only)
  Future<List<Session>> getPastSessions({int limit = 10}) async {
    final now = DateTime.now();
    return await _repository.customQuery(
      filter: (s) => s.datetime.isSmallerThanValue(now),
      sort: [(s) => OrderingTerm.desc(s.datetime)],
      limit: limit,
    );
  }

  /// Get the next scheduled session
  Future<Session?> getNextSession() async {
    final upcoming = await getUpcomingSessions(limit: 1);
    return upcoming.isNotEmpty ? upcoming.first : null;
  }

  /// Get the most recent past session
  Future<Session?> getLastSession() async {
    final past = await getPastSessions(limit: 1);
    return past.isNotEmpty ? past.first : null;
  }

  /// Check if a date has any sessions
  Future<bool> hasSessionsOnDate(DateTime date) async {
    final sessions = await getSessionsForDay(date);
    return sessions.isNotEmpty;
  }

  /// Get days with sessions in a month
  Future<List<DateTime>> getDaysWithSessionsInMonth(int year, int month) async {
    final sessions = await getSessionsForMonth(year, month);
    final daysWithSessions = <DateTime>{};

    for (final session in sessions) {
      if (session.datetime != null) {
        final date = DateTime(
          session.datetime!.year,
          session.datetime!.month,
          session.datetime!.day,
        );
        daysWithSessions.add(date);
      }
    }

    return daysWithSessions.toList()..sort();
  }

  /// Calculate average time between sessions
  Duration calculateAverageSessionInterval(List<Session> sessions) {
    if (sessions.length < 2) return Duration.zero;

    final sortedSessions = sessions.where((s) => s.datetime != null).toList()
      ..sort((a, b) => a.datetime!.compareTo(b.datetime!));

    if (sortedSessions.length < 2) return Duration.zero;

    var totalInterval = Duration.zero;
    for (var i = 1; i < sortedSessions.length; i++) {
      totalInterval += sortedSessions[i].datetime!.difference(
        sortedSessions[i - 1].datetime!,
      );
    }

    return Duration(
      milliseconds: totalInterval.inMilliseconds ~/ (sortedSessions.length - 1),
    );
  }
}
