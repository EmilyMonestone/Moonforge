import 'dart:convert';

import 'package:moonforge/data/db/app_db.dart';

/// Service for exporting session data in various formats
class SessionExportService {
  SessionExportService._();

  /// Export session as JSON
  static String exportAsJson(Session session) {
    final data = {
      'id': session.id,
      'datetime': session.datetime?.toIso8601String(),
      'createdAt': session.createdAt?.toIso8601String(),
      'updatedAt': session.updatedAt?.toIso8601String(),
      'info': session.info,
      'log': session.log,
      'shareEnabled': session.shareEnabled,
      'shareToken': session.shareToken,
      'shareExpiresAt': session.shareExpiresAt?.toIso8601String(),
    };
    return jsonEncode(data);
  }

  /// Export multiple sessions as JSON array
  static String exportMultipleAsJson(List<Session> sessions) {
    final data = sessions
        .map(
          (session) => {
            'id': session.id,
            'datetime': session.datetime?.toIso8601String(),
            'createdAt': session.createdAt?.toIso8601String(),
            'updatedAt': session.updatedAt?.toIso8601String(),
            'info': session.info,
            'log': session.log,
            'shareEnabled': session.shareEnabled,
            'shareToken': session.shareToken,
            'shareExpiresAt': session.shareExpiresAt?.toIso8601String(),
          },
        )
        .toList();
    return jsonEncode(data);
  }

  /// Export session log as plain text
  static String exportLogAsText(Session session) {
    final buffer = StringBuffer();

    buffer.writeln('Session Log');
    buffer.writeln('=' * 50);

    if (session.datetime != null) {
      buffer.writeln('Date: ${session.datetime}');
    }

    buffer.writeln();

    if (session.log != null) {
      // Extract text from Quill delta
      final log = session.log;
      if (log != null && log.containsKey('ops')) {
        final ops = log['ops'] as List<dynamic>?;
        if (ops != null) {
          for (final op in ops) {
            if (op is Map && op.containsKey('insert')) {
              buffer.write(op['insert']);
            }
          }
        }
      }
    }

    return buffer.toString();
  }

  /// Export session info (DM notes) as plain text
  static String exportInfoAsText(Session session) {
    final buffer = StringBuffer();

    buffer.writeln('Session Notes (DM Only)');
    buffer.writeln('=' * 50);

    if (session.datetime != null) {
      buffer.writeln('Date: ${session.datetime}');
    }

    buffer.writeln();

    if (session.info != null) {
      // Extract text from Quill delta
      final info = session.info;
      if (info != null && info.containsKey('ops')) {
        final ops = info['ops'] as List<dynamic>?;
        if (ops != null) {
          for (final op in ops) {
            if (op is Map && op.containsKey('insert')) {
              buffer.write(op['insert']);
            }
          }
        }
      }
    }

    return buffer.toString();
  }

  /// Export session as markdown
  static String exportAsMarkdown(Session session) {
    final buffer = StringBuffer();

    buffer.writeln('# Session Report');
    buffer.writeln();

    if (session.datetime != null) {
      buffer.writeln('**Date:** ${session.datetime}');
    }

    if (session.createdAt != null) {
      buffer.writeln('**Created:** ${session.createdAt}');
    }

    buffer.writeln();
    buffer.writeln('## Session Log');
    buffer.writeln();

    if (session.log != null) {
      final log = session.log;
      if (log != null && log.containsKey('ops')) {
        final ops = log['ops'] as List<dynamic>?;
        if (ops != null) {
          for (final op in ops) {
            if (op is Map && op.containsKey('insert')) {
              buffer.write(op['insert']);
            }
          }
        }
      }
    } else {
      buffer.writeln('*No log available*');
    }

    return buffer.toString();
  }

  /// Generate session summary report
  static String generateSummaryReport(List<Session> sessions) {
    final buffer = StringBuffer();

    buffer.writeln('Session Summary Report');
    buffer.writeln('=' * 50);
    buffer.writeln();
    buffer.writeln('Total Sessions: ${sessions.length}');

    final sessionsWithDate = sessions.where((s) => s.datetime != null).length;
    buffer.writeln('Scheduled Sessions: $sessionsWithDate');

    final now = DateTime.now();
    final pastSessions = sessions
        .where((s) => s.datetime != null && s.datetime!.isBefore(now))
        .length;
    buffer.writeln('Past Sessions: $pastSessions');

    final upcomingSessions = sessions
        .where((s) => s.datetime != null && s.datetime!.isAfter(now))
        .length;
    buffer.writeln('Upcoming Sessions: $upcomingSessions');

    buffer.writeln();
    buffer.writeln('Session List:');
    buffer.writeln('-' * 50);

    for (final session in sessions) {
      buffer.writeln();
      if (session.datetime != null) {
        buffer.writeln('Date: ${session.datetime}');
      } else {
        buffer.writeln('Date: Not scheduled');
      }
      buffer.writeln('ID: ${session.id}');
      if (session.shareEnabled) {
        buffer.writeln('Shared: Yes');
      }
    }

    return buffer.toString();
  }

  /// Export sessions as CSV
  static String exportAsCSV(List<Session> sessions) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('ID,Date,Created,Shared,Share Token,Share Expires');

    // Data rows
    for (final session in sessions) {
      buffer.write('"${session.id}",');
      buffer.write('"${session.datetime?.toIso8601String() ?? ''}",');
      buffer.write('"${session.createdAt?.toIso8601String() ?? ''}",');
      buffer.write('"${session.shareEnabled}",');
      buffer.write('"${session.shareToken ?? ''}",');
      buffer.write('"${session.shareExpiresAt?.toIso8601String() ?? ''}"');
      buffer.writeln();
    }

    return buffer.toString();
  }
}
