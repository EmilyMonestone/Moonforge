/// Utility functions for handling DateTime values, especially those from Firestore
library;

import 'package:intl/intl.dart';

/// Checks if a DateTime is a valid, displayable date
///
/// Returns false for:
/// - null values
/// - Sentinel values (e.g., DateTime(0) or dates before year 1900)
/// - Dates that are too far in the past to be meaningful
///
/// This helps filter out unresolved Firestore serverTimestamp placeholders
/// which may appear as minimum DateTime values.
bool isValidDateTime(DateTime? dateTime) {
  if (dateTime == null) return false;

  // Filter out dates before January 1, 1900 (likely sentinel/invalid values)
  final minValidDate = DateTime(1900);
  return !dateTime.isBefore(minValidDate);
}

/// Formats a DateTime for display, returning a placeholder for invalid dates
///
/// Returns the formatted local time string for valid dates, or an em dash (—)
/// for null/invalid dates. This is useful for displaying timestamps in the UI
/// without showing confusing sentinel values.
String formatDateTime(DateTime? dateTime, {String placeholder = '—'}) {
  if (!isValidDateTime(dateTime)) {
    return placeholder;
  }
  final formatYMD = DateFormat.yMd();
  final formatHM = DateFormat.Hm();
  return '${formatYMD.format(dateTime!)} ${formatHM.format(dateTime)}';
}

/// Formats a DateTime as a relative time string, e.g., "5m ago", "2h ago"
///
/// This provides a human-readable way to display dates that emphasizes
/// the relative passage of time, which can be more meaningful for
/// timestamps like message sent times or activity logs.
String formatRelativeDate(DateTime? dateTime, {String placeholder = '—'}) {
  if (!isValidDateTime(dateTime)) return placeholder;
  final now = DateTime.now();
  final diff = now.difference(dateTime!);
  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
  final months = (diff.inDays / 30).floor();
  if (months < 12) return '${months}mo ago';
  final years = (diff.inDays / 365).floor();
  return '${years}y ago';
}

class DateTimeUtils {
  DateTimeUtils._();

  static bool isValid(DateTime? dt) => isValidDateTime(dt);

  static String formatDateTime(DateTime? dt, {String placeholder = '—'}) =>
      formatDateTime(dt, placeholder: placeholder);

  static String formatRelativeDate(DateTime? dt, {String placeholder = '—'}) =>
      formatRelativeDate(dt, placeholder: placeholder);
}
