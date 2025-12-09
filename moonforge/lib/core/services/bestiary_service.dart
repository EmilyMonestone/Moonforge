import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/models/monster.dart';

/// Service for managing DND 5e bestiary data via Open5e with local caching
class BestiaryService {
  static const String _base = 'https://api.open5e.com';
  static const String _monstersEndpoint = 'https://api.open5e.com/v1/monsters/';
  static const String _apiRootManifest = 'https://api.open5e.com/?format=json';

  static const String _boxName = 'bestiary';
  static const String _manifestKey =
      'open5e_manifest_json'; // stores monsters page/manifest (results)
  static const String _apiManifestKey =
      'open5e_api_manifest_json'; // stores api root mapping

  final PersistenceService _persistence;
  final Duration staleThreshold;
  final Client _client;

  BestiaryService(
    this._persistence, {
    this.staleThreshold = const Duration(hours: 24),
    Client? httpClient,
  }) : _client = httpClient ?? Client();

  /// Get monsters (all pages by default). If page is provided, returns single page.
  /// If ensureFresh is true a background sync may be triggered when data is stale.
  Future<List<Monster>> getAll({
    bool ensureFresh = true,
    int? page,
    int? pageSize,
  }) async {
    // If specific page requested, try to fetch that page and return results
    if (page != null) {
      final key = _listCacheKey(page, pageSize);
      final cached = _persistence.read<String>(key, boxName: _boxName);
      if (cached != null) {
        if (ensureFresh) _maybeBackgroundSync();
        return _parseMonstersFromBody(cached);
      }

      final success = await _fetchMonstersPageAndStore(
        page: page,
        pageSize: pageSize,
      );
      if (!success) return [];
      final stored = _persistence.read<String>(key, boxName: _boxName);
      if (stored == null) return [];
      return _parseMonstersFromBody(stored);
    }

    // No page requested: try to return cached manifest list if we have one
    final cached = _persistence.read<String>(_manifestKey, boxName: _boxName);
    if (cached != null) {
      if (ensureFresh) _maybeBackgroundSync();
      final decoded = jsonDecode(cached);
      if (decoded is Map && decoded.containsKey('results')) {
        final results = decoded['results'] as List<dynamic>;
        return results
            .whereType<Map<String, dynamic>>()
            .map((m) => Monster.fromOpen5eJson(m))
            .toList();
      }
    }

    // Fallback: fetch first page and store manifest key
    final success = await _fetchMonstersPageAndStore(
      page: 1,
      pageSize: pageSize,
      storeAsManifest: true,
    );
    if (!success) return [];
    final stored = _persistence.read<String>(_manifestKey, boxName: _boxName);
    if (stored == null) return [];
    final decoded = jsonDecode(stored);
    if (decoded is Map && decoded.containsKey('results')) {
      final results = decoded['results'] as List<dynamic>;
      return results
          .whereType<Map<String, dynamic>>()
          .map((m) => Monster.fromOpen5eJson(m))
          .toList();
    }

    return [];
  }

  /// Fetch and cache Open5e API root manifest (mapping of resource names to endpoints)
  Future<Map<String, dynamic>?> getApiManifest({bool force = false}) async {
    final cached = _persistence.read<String>(
      _apiManifestKey,
      boxName: _boxName,
    );
    if (cached != null && !force) {
      try {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return decoded;
      } catch (_) {}
    }

    try {
      final uri = Uri.parse(_apiRootManifest);
      final response = await _client.get(uri);
      if (response.statusCode == 200) {
        await _persistence.write(
          _apiManifestKey,
          response.body,
          boxName: _boxName,
        );
        return jsonDecode(response.body) as Map<String, dynamic>?;
      }
    } catch (e) {
      logger.w('Failed to fetch Open5e API manifest: $e');
    }
    return null;
  }

  Future<Monster?> getByName(String name) async {
    // Use search endpoint
    try {
      final uri = Uri.parse(
        '$_monstersEndpoint?search=${Uri.encodeQueryComponent(name)}',
      );
      final response = await _client.get(uri);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded.containsKey('results')) {
          final results = decoded['results'] as List<dynamic>;
          for (final r in results) {
            if (r is Map<String, dynamic> && (r['name'] as String?) == name) {
              return Monster.fromOpen5eJson(r);
            }
          }
        }
      }
    } catch (e) {
      logger.w('getByName failed: $e');
    }
    return null;
  }

  Future<Monster?> getBySlug(String slug) async {
    final key = _singleCacheKey(slug);
    final cached = _persistence.read<String>(key, boxName: _boxName);
    if (cached != null) {
      try {
        final decoded = jsonDecode(cached) as Map<String, dynamic>;
        return Monster.fromOpen5eJson(decoded);
      } catch (e) {
        logger.w('Failed to parse cached monster $slug: $e');
      }
    }

    try {
      final url = Uri.parse('$_monstersEndpoint$slug/?format=json');
      final etag = _persistence.read<String>(
        _etagKeyForSlug(slug),
        boxName: _boxName,
      );
      final headers = <String, String>{};
      if (etag != null) headers['If-None-Match'] = etag;
      final response = await _client.get(url, headers: headers);
      if (response.statusCode == 200) {
        await _persistence.write(key, response.body, boxName: _boxName);
        final newEtag = response.headers['etag'];
        if (newEtag != null)
          await _persistence.write(
            _etagKeyForSlug(slug),
            newEtag,
            boxName: _boxName,
          );
        return Monster.fromOpen5eJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else if (response.statusCode == 304 && cached != null) {
        return Monster.fromOpen5eJson(
          jsonDecode(cached) as Map<String, dynamic>,
        );
      }
    } catch (e) {
      logger.w('Failed to fetch monster $slug: $e');
    }
    return null;
  }

  Future<bool> forceSync() async {
    // Fetch first page and replace manifest (monsters list)
    // Also refresh API manifest mapping
    await getApiManifest(force: true);
    return _fetchMonstersPageAndStore(
      page: 1,
      storeAsManifest: true,
      force: true,
    );
  }

  Future<void> _maybeBackgroundSync() async {
    final lastSyncMillis = _persistence.read<int>(
      '${_lastSyncKey}',
      boxName: _boxName,
    );
    if (lastSyncMillis == null ||
        DateTime.now().difference(
              DateTime.fromMillisecondsSinceEpoch(lastSyncMillis),
            ) >
            staleThreshold) {
      // fire and forget
      _fetchMonstersPageAndStore(page: 1, storeAsManifest: true)
          .then((_) => logger.d('Background Open5e bestiary sync completed'))
          .catchError(
            (e) => logger.w('Background Open5e bestiary sync failed: $e'),
          );
    }
  }

  Future<bool> _fetchMonstersPageAndStore({
    required int page,
    int? pageSize,
    bool storeAsManifest = false,
    bool force = false,
    String resourceName = 'monsters',
  }) async {
    final key = storeAsManifest ? _manifestKey : _listCacheKey(page, pageSize);
    try {
      // Prefer API manifest mapping if available
      String endpoint = _monstersEndpoint;
      final apiManifest = await getApiManifest();
      if (apiManifest != null && apiManifest.containsKey(resourceName)) {
        endpoint = apiManifest[resourceName] as String? ?? endpoint;
      }

      final uri = Uri.parse(
        '$endpoint?format=json&page=$page${pageSize != null ? '&page_size=$pageSize' : ''}',
      );
      final etagKey = _etagKeyForList(page, pageSize);
      final etag = _persistence.read<String>(etagKey, boxName: _boxName);
      final headers = <String, String>{};
      if (etag != null && !force) headers['If-None-Match'] = etag;

      logger.d('Fetching Open5e monsters page $page from $endpoint');
      final response = await _client.get(uri, headers: headers);
      if (response.statusCode == 200) {
        await _persistence.write(key, response.body, boxName: _boxName);
        final newEtag =
            response.headers['etag'] ?? _computeLocalEtag(response.body);
        if (newEtag != null)
          await _persistence.write(etagKey, newEtag, boxName: _boxName);
        await _persistence.write(
          _lastSyncKey,
          DateTime.now().millisecondsSinceEpoch,
          boxName: _boxName,
        );
        logger.i('Open5e monsters page $page fetched and stored');
        return true;
      } else if (response.statusCode == 304) {
        // not modified
        await _persistence.write(
          _lastSyncKey,
          DateTime.now().millisecondsSinceEpoch,
          boxName: _boxName,
        );
        logger.d('Open5e monsters page $page not modified (304)');
        return true;
      } else {
        logger.e('Open5e fetch failed: HTTP ${response.statusCode}');
        return false;
      }
    } catch (e) {
      logger.e('Failed to fetch Open5e monsters: $e');
      return false;
    }
  }

  List<Monster> _parseMonstersFromBody(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded.containsKey('results')) {
        final results = decoded['results'] as List<dynamic>;
        return results
            .whereType<Map<String, dynamic>>()
            .map((m) => Monster.fromOpen5eJson(m))
            .toList();
      } else if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map((m) => Monster.fromOpen5eJson(m))
            .toList();
      }
    } catch (e) {
      logger.e('Failed to decode monsters JSON: $e');
    }
    return [];
  }

  String? _computeLocalEtag(String body) {
    try {
      // simple checksum: use md5 hex
      // avoid adding a crypto dependency; use a very small checksum fallback
      return body.hashCode.toString();
    } catch (_) {
      return null;
    }
  }

  String _listCacheKey(int page, int? pageSize) =>
      'open5e:monsters:page:$page:${pageSize ?? 0}';

  String _singleCacheKey(String slug) => 'open5e:monster:slug:$slug';

  String _etagKeyForList(int page, int? pageSize) =>
      'open5e:etag:monsters:page:$page:${pageSize ?? 0}';

  String _etagKeyForSlug(String slug) => 'open5e:etag:monster:slug:$slug';

  static const String _lastSyncKey = 'bestiary_lastSync';

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
    // remove manifest and page keys heuristically
    await _persistence.remove(_manifestKey, boxName: _boxName);
    await _persistence.remove(_apiManifestKey, boxName: _boxName);
    // remove some etag keys could be left behind; best to keep box namespace small
    await _persistence.remove(_lastSyncKey, boxName: _boxName);
    logger.i('Bestiary cache cleared');
  }
}
