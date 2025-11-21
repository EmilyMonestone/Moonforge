import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Service for managing DND 5e 2024 bestiary data with local caching
class BestiaryService {
  static const String _url =
      'https://raw.githubusercontent.com/5etools-mirror-3/5etools-src/refs/heads/main/data/bestiary/bestiary-xmm.json';
  static const String _boxName = 'bestiary';
  static const String _dataKey = 'bestiary_json';
  static const String _etagKey = 'bestiary_etag';
  static const String _lastSyncKey = 'bestiary_lastSync';

  final PersistenceService _persistence;
  final Duration staleThreshold;

  BestiaryService(
    this._persistence, {
    this.staleThreshold = const Duration(hours: 24),
  });

  /// Get all bestiary entries
  /// If ensureFresh is true, triggers a background sync if data is stale
  Future<List<dynamic>> getAll({bool ensureFresh = true}) async {
    // Return cached data immediately if present
    final cached = _persistence.read<String>(_dataKey, boxName: _boxName);
    if (cached != null) {
      // Kick off background sync if stale or ensureFresh
      if (ensureFresh) {
        _maybeBackgroundSync();
      }
      try {
        final decoded = jsonDecode(cached);
        if (decoded is Map && decoded.containsKey('monster')) {
          return decoded['monster'] as List<dynamic>;
        }
        return decoded as List<dynamic>;
      } catch (e) {
        logger.e('Failed to decode bestiary data: $e');
        // If decode fails, try fetching fresh data
      }
    }

    // No cache: fetch from remote
    final success = await _fetchAndStore();
    if (!success) {
      logger.w('Failed to fetch bestiary data from remote');
      return []; // or throw, depending on desired behavior
    }
    final stored = _persistence.read<String>(_dataKey, boxName: _boxName);
    if (stored == null) return [];

    try {
      final decoded = jsonDecode(stored);
      if (decoded is Map && decoded.containsKey('monster')) {
        return decoded['monster'] as List<dynamic>;
      }
      return decoded as List<dynamic>;
    } catch (e) {
      logger.e('Failed to decode bestiary data after fetch: $e');
      return [];
    }
  }

  /// Get a specific monster by name
  Future<Map<String, dynamic>?> getByName(String name) async {
    final all = await getAll(ensureFresh: false);
    try {
      return all.firstWhere(
            (monster) => (monster as Map<String, dynamic>)['name'] == name,
            orElse: () => null,
          )
          as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  /// Force a fresh sync from remote
  Future<bool> forceSync() => _fetchAndStore();

  /// Check if data needs syncing and trigger background sync if needed
  Future<void> _maybeBackgroundSync() async {
    final lastSyncMillis = _persistence.read<int>(
      _lastSyncKey,
      boxName: _boxName,
    );
    if (lastSyncMillis == null ||
        DateTime.now().difference(
              DateTime.fromMillisecondsSinceEpoch(lastSyncMillis),
            ) >
            staleThreshold) {
      // Fire and forget - don't await
      _fetchAndStore()
          .then((_) {
            logger.d('Background bestiary sync completed');
          })
          .catchError((e) {
            logger.w('Background bestiary sync failed: $e');
          });
    }
  }

  /// Fetch bestiary data from remote and store locally
  Future<bool> _fetchAndStore() async {
    try {
      final etag = _persistence.read<String>(_etagKey, boxName: _boxName);
      final headers = <String, String>{};
      if (etag != null) {
        headers['If-None-Match'] = etag;
      }

      logger.d('Fetching bestiary data from remote...');
      final response = await http.get(Uri.parse(_url), headers: headers);

      if (response.statusCode == 200) {
        final body = response.body;
        await _persistence.write(_dataKey, body, boxName: _boxName);
        final newEtag = response.headers['etag'];
        if (newEtag != null) {
          await _persistence.write(_etagKey, newEtag, boxName: _boxName);
        }
        await _persistence.write(
          _lastSyncKey,
          DateTime.now().millisecondsSinceEpoch,
          boxName: _boxName,
        );
        logger.i('Bestiary data fetched and stored successfully');
        return true;
      } else if (response.statusCode == 304) {
        // Not modified - update last sync time
        await _persistence.write(
          _lastSyncKey,
          DateTime.now().millisecondsSinceEpoch,
          boxName: _boxName,
        );
        logger.d('Bestiary data not modified (304)');
        return true;
      } else {
        logger.e('Failed to fetch bestiary: HTTP ${response.statusCode}');
        return false;
      }
    } catch (e) {
      logger.e('Failed to fetch bestiary data: $e');
      return false;
    }
  }

  /// Get the last sync timestamp
  DateTime? getLastSyncTime() {
    final lastSyncMillis = _persistence.read<int>(
      _lastSyncKey,
      boxName: _boxName,
    );
    if (lastSyncMillis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(lastSyncMillis);
  }

  /// Check if bestiary data is cached
  bool isCached() {
    return _persistence.hasData(_dataKey, boxName: _boxName);
  }

  /// Clear all cached bestiary data
  Future<void> clearCache() async {
    await _persistence.remove(_dataKey, boxName: _boxName);
    await _persistence.remove(_etagKey, boxName: _boxName);
    await _persistence.remove(_lastSyncKey, boxName: _boxName);
    logger.i('Bestiary cache cleared');
  }
}
