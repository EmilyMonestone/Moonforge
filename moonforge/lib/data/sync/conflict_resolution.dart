import 'package:moonforge/core/utils/logger.dart';

/// Conflict resolution strategies for sync
class ConflictResolver {
  /// Resolve conflict using Last-Write-Wins (LWW) strategy
  /// 
  /// Compares timestamps and revision numbers to determine winner.
  /// Returns the document that should be kept.
  static Map<String, dynamic> lastWriteWins(
    Map<String, dynamic> local,
    Map<String, dynamic> remote,
  ) {
    // Extract timestamps
    final localUpdated = _parseTimestamp(local['updatedAt']);
    final remoteUpdated = _parseTimestamp(remote['updatedAt']);

    // If timestamps are equal, use revision number
    if (localUpdated == remoteUpdated) {
      final localRev = local['rev'] as int? ?? 0;
      final remoteRev = remote['rev'] as int? ?? 0;
      
      if (remoteRev > localRev) {
        logger.d('Conflict resolved: Remote wins (higher rev)');
        return remote;
      } else {
        logger.d('Conflict resolved: Local wins (higher rev)');
        return local;
      }
    }

    // Compare timestamps
    if (remoteUpdated != null && localUpdated != null) {
      if (remoteUpdated.isAfter(localUpdated)) {
        logger.d('Conflict resolved: Remote wins (newer timestamp)');
        return remote;
      } else {
        logger.d('Conflict resolved: Local wins (newer timestamp)');
        return local;
      }
    }

    // Fallback: prefer remote if timestamps are missing
    if (remoteUpdated != null) {
      logger.d('Conflict resolved: Remote wins (has timestamp)');
      return remote;
    }

    logger.d('Conflict resolved: Local wins (default)');
    return local;
  }

  /// Merge two documents field-by-field
  /// 
  /// Useful for more granular conflict resolution.
  /// Takes the most recent value for each field based on timestamps.
  static Map<String, dynamic> fieldLevelMerge(
    Map<String, dynamic> local,
    Map<String, dynamic> remote,
  ) {
    final merged = <String, dynamic>{};
    final allKeys = {...local.keys, ...remote.keys};

    final localUpdated = _parseTimestamp(local['updatedAt']);
    final remoteUpdated = _parseTimestamp(remote['updatedAt']);

    for (final key in allKeys) {
      // Skip metadata fields that should always come from remote
      if (key == 'updatedAt' || key == 'createdAt' || key == '_serverTimestamp') {
        merged[key] = remote[key] ?? local[key];
        continue;
      }

      // If only one has the key, use that value
      if (!local.containsKey(key)) {
        merged[key] = remote[key];
      } else if (!remote.containsKey(key)) {
        merged[key] = local[key];
      } else {
        // Both have the key, use LWW logic
        if (remoteUpdated != null && localUpdated != null) {
          merged[key] = remoteUpdated.isAfter(localUpdated) 
              ? remote[key] 
              : local[key];
        } else {
          // Prefer remote if timestamps unclear
          merged[key] = remote[key];
        }
      }
    }

    logger.d('Conflict resolved: Field-level merge completed');
    return merged;
  }

  /// Parse timestamp from various formats
  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    
    if (value is DateTime) {
      return value;
    }
    
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    
    // Firestore Timestamp
    if (value is Map && value.containsKey('_seconds')) {
      try {
        final seconds = value['_seconds'] as int;
        return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
      } catch (e) {
        return null;
      }
    }
    
    return null;
  }

  /// Check if a document should be considered a tombstone
  static bool isTombstone(Map<String, dynamic> doc) {
    return doc['isDeleted'] == true;
  }

  /// Create a tombstone document
  static Map<String, dynamic> createTombstone(String id) {
    return {
      'id': id,
      'isDeleted': true,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}
