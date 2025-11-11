import 'dart:convert';

/// Utility class for safe parsing of data types with comprehensive error handling
/// and support for various input formats.
///
/// This class provides type-safe methods to parse DateTime, List, and Map types
/// from various sources (JSON, strings, etc.) with fallback values to prevent
/// runtime errors from malformed data.
class SafeDataParser {
  SafeDataParser._();

  /// Safely parse DateTime from various formats.
  ///
  /// Supports:
  /// - ISO8601 strings (e.g., "2024-01-15T10:30:00Z")
  /// - Unix timestamps in seconds (e.g., 1234567890)
  /// - Unix timestamps in milliseconds (e.g., 1234567890000)
  /// - Malformed epoch strings with trailing 'Z' (e.g., "1234567890Z")
  ///
  /// Returns null if parsing fails or input is null.
  static DateTime? tryParseDateTime(dynamic value) {
    if (value == null) return null;

    try {
      // If already a DateTime, return it
      if (value is DateTime) return value;

      // If it's a number (int or double), treat as milliseconds since epoch
      if (value is int) {
        // If value looks like seconds (< year 3000 in seconds), convert to ms
        if (value < 32503680000) {
          // 32503680000 seconds = Jan 1, 3000
          return DateTime.fromMillisecondsSinceEpoch(value * 1000);
        }
        return DateTime.fromMillisecondsSinceEpoch(value);
      }

      if (value is double) {
        return DateTime.fromMillisecondsSinceEpoch(value.toInt());
      }

      // If it's a string, try various formats
      if (value is String) {
        final trimmed = value.trim();
        if (trimmed.isEmpty) return null;

        // Remove trailing 'Z' if it's attached to a number (malformed epoch)
        String cleaned = trimmed;
        if (cleaned.endsWith('Z') &&
            cleaned.length > 1 &&
            _isNumeric(cleaned.substring(0, cleaned.length - 1))) {
          cleaned = cleaned.substring(0, cleaned.length - 1);
        }

        // Try parsing as ISO8601
        final parsed = DateTime.tryParse(cleaned);
        if (parsed != null) return parsed;

        // Try parsing as epoch (seconds or milliseconds)
        final epochValue = int.tryParse(cleaned);
        if (epochValue != null) {
          // If value looks like seconds (< year 3000 in seconds), convert to ms
          if (epochValue < 32503680000) {
            return DateTime.fromMillisecondsSinceEpoch(epochValue * 1000);
          }
          return DateTime.fromMillisecondsSinceEpoch(epochValue);
        }
      }

      return null;
    } catch (e) {
      // Silently catch any parsing errors and return null
      return null;
    }
  }

  /// Safely parse a list of strings from JSON or other sources.
  ///
  /// Returns an empty list if parsing fails or input is null.
  static List<String> tryParseStringList(dynamic value) {
    if (value == null) return [];

    try {
      // If already a List<String>, return it
      if (value is List<String>) return value;

      // If it's a List of any type, convert to strings
      if (value is List) {
        return value.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
      }

      // If it's a JSON string, parse it
      if (value is String) {
        if (value.trim().isEmpty) return [];
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// Safely parse a list of maps from JSON or other sources.
  ///
  /// Returns an empty list if parsing fails or input is null.
  static List<Map<String, dynamic>> tryParseMapList(dynamic value) {
    if (value == null) return [];

    try {
      // If already a List<Map<String, dynamic>>, return it
      if (value is List<Map<String, dynamic>>) return value;

      // If it's a List of maps, convert them
      if (value is List) {
        return value
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }

      // If it's a JSON string, parse it
      if (value is String) {
        if (value.trim().isEmpty) return [];
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// Safely parse a map from JSON or other sources.
  ///
  /// Returns an empty map if parsing fails or input is null.
  static Map<String, dynamic> tryParseMap(dynamic value) {
    if (value == null) return {};

    try {
      // If already a Map<String, dynamic>, return it
      if (value is Map<String, dynamic>) return value;

      // If it's any Map, convert it
      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }

      // If it's a JSON string, parse it
      if (value is String) {
        if (value.trim().isEmpty) return {};
        final decoded = jsonDecode(value);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      }

      return {};
    } catch (e) {
      return {};
    }
  }

  /// Check if a string contains only numeric characters
  static bool _isNumeric(String str) {
    if (str.isEmpty) return false;
    return RegExp(r'^[0-9]+$').hasMatch(str);
  }

  /// Safely convert DateTime to milliseconds since epoch for storage.
  ///
  /// Returns null if input is null.
  static int? dateTimeToEpochMs(DateTime? dateTime) {
    return dateTime?.millisecondsSinceEpoch;
  }

  /// Safely convert DateTime to ISO8601 string for storage.
  ///
  /// Returns null if input is null.
  static String? dateTimeToIso8601(DateTime? dateTime) {
    return dateTime?.toUtc().toIso8601String();
  }
}
