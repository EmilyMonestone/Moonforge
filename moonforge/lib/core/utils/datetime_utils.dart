/// Utility functions for handling DateTime values, especially those from Firestore
library;

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
  return dateTime.isAfter(minValidDate);
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
  return dateTime!.toLocal().toString();
}
