import 'package:http/http.dart' show Client;
import 'package:moonforge/core/services/open5e/index.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/models/monster.dart';

/// Service for managing DND 5e bestiary data via Open5e with local caching
///
/// This service now uses the comprehensive Open5eService internally while
/// maintaining backward compatibility with existing code.
class BestiaryService {
  static const String _boxName = 'bestiary';
  static const String _manifestKey =
      'open5e_manifest_json'; // stores monsters page/manifest (results)
  static const String _lastSyncKey = 'bestiary_lastSync';

  final PersistenceService _persistence;
  final Open5eService _open5eService;
  final Duration staleThreshold;

  BestiaryService(
    this._persistence, {
    this.staleThreshold = const Duration(hours: 24),
    Client? httpClient,
  }) : _open5eService = Open5eService(_persistence, httpClient: httpClient);

  /// Get monsters (all pages by default). If page is provided, returns single page.
  /// If ensureFresh is true a background sync may be triggered when data is stale.
  Future<List<Monster>> getAll({
    bool ensureFresh = true,
    int? page,
    int? pageSize,
  }) async {
    if (ensureFresh) {
      _maybeBackgroundSync();
    }

    // Use the new Open5eService to fetch monsters
    try {
      final response = await _open5eService.getMonsters(
        page: page ?? 1,
        pageSize: pageSize,
        useCache: !ensureFresh,
      );

      if (response != null && response.results.isNotEmpty) {
        // Update last sync time
        await _persistence.write(
          _lastSyncKey,
          DateTime.now().millisecondsSinceEpoch,
          boxName: _boxName,
        );
        return response.results;
      }
    } catch (e) {
      logger.e('Failed to fetch monsters: $e', context: LogContext.network);
    }

    return [];
  }

  /// Fetch and cache Open5e API manifest (list of available documents/resources)
  Future<List<ManifestEntry>?> getApiManifest({bool force = false}) async {
    try {
      final response = await _open5eService.getManifest(
        useCache: !force,
      );
      return response?.results;
    } catch (e) {
      logger.w('Failed to fetch Open5e API manifest: $e',
          context: LogContext.network);
      return null;
    }
  }

  Future<Monster?> getByName(String name) async {
    try {
      final response = await _open5eService.searchMonsters(name);
      if (response != null && response.results.isNotEmpty) {
        // Return the first exact match if available
        for (final monster in response.results) {
          if (monster.name.toLowerCase() == name.toLowerCase()) {
            return monster;
          }
        }
        // Otherwise return the first result
        return response.results.first;
      }
    } catch (e) {
      logger.w('getByName failed: $e', context: LogContext.network);
    }
    return null;
  }

  Future<Monster?> getBySlug(String slug) async {
    try {
      return await _open5eService.getMonsterBySlug(slug);
    } catch (e) {
      logger.w('Failed to fetch monster $slug: $e', context: LogContext.network);
      return null;
    }
  }

  Future<bool> forceSync() async {
    try {
      // Fetch first page and update sync time
      final response = await _open5eService.getMonsters(
        page: 1,
        useCache: false,
      );

      if (response != null) {
        await _persistence.write(
          _lastSyncKey,
          DateTime.now().millisecondsSinceEpoch,
          boxName: _boxName,
        );
        logger.i('Open5e bestiary sync completed', context: LogContext.network);
        return true;
      }
    } catch (e) {
      logger.e('Failed to sync bestiary: $e', context: LogContext.network);
    }
    return false;
  }

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
      // Fire and forget background sync
      forceSync()
          .then((_) => logger.d(
              'Background Open5e bestiary sync completed',
              context: LogContext.network))
          .catchError(
            (e) => logger.w(
              'Background Open5e bestiary sync failed: $e',
              context: LogContext.network,
            ),
          );
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
    return _persistence.hasData(_manifestKey, boxName: _boxName);
  }

  /// Clear all cached bestiary data
  Future<void> clearCache() async {
    await _persistence.remove(_manifestKey, boxName: _boxName);
    await _persistence.remove(_lastSyncKey, boxName: _boxName);
    await _open5eService.clearCache();
    logger.i('Bestiary cache cleared', context: LogContext.network);
  }
}
