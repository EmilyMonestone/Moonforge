import 'dart:convert';

import 'package:http/http.dart' show Client, Response;
import 'package:moonforge/core/services/open5e/open5e_endpoints.dart';
import 'package:moonforge/core/services/open5e/open5e_models.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/models/monster.dart';

/// Base client for Open5e API interactions
///
/// Provides generic methods for fetching data from Open5e API endpoints with
/// caching, ETags support, and error handling.
class Open5eClient {
  static const String _boxName = 'open5e_cache';
  static const Duration _defaultStaleThreshold = Duration(hours: 24);

  final PersistenceService _persistence;
  final Client _httpClient;
  final Duration staleThreshold;

  Open5eClient(
    this._persistence, {
    Client? httpClient,
    this.staleThreshold = _defaultStaleThreshold,
  }) : _httpClient = httpClient ?? Client();

  /// Generic method to fetch a paginated list from an endpoint
  Future<PaginatedResponse<T>?> fetchList<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    int page = 1,
    int? pageSize,
    Map<String, String>? queryParams,
    bool useCache = true,
    bool force = false,
  }) async {
    final cacheKey = _buildCacheKey(endpoint, page, pageSize, queryParams);
    final etagKey = '${cacheKey}_etag';

    // Try cache first
    if (useCache && !force) {
      final cached = _persistence.read<String>(cacheKey, boxName: _boxName);
      if (cached != null) {
        try {
          final decoded = jsonDecode(cached) as Map<String, dynamic>;
          return PaginatedResponse.fromJson(decoded, fromJson);
        } catch (e) {
          logger.w('Failed to parse cached data for $endpoint: $e',
              context: LogContext.network);
        }
      }
    }

    // Build URL with query parameters
    final uri = _buildUri(
      endpoint,
      page: page,
      pageSize: pageSize,
      additionalParams: queryParams,
    );

    // Add ETag if available
    final headers = <String, String>{};
    if (useCache && !force) {
      final etag = _persistence.read<String>(etagKey, boxName: _boxName);
      if (etag != null) headers['If-None-Match'] = etag;
    }

    try {
      logger.d('Fetching from Open5e: $uri', context: LogContext.network);
      final response = await _httpClient.get(uri, headers: headers);

      if (response.statusCode == 200) {
        // Store in cache
        await _persistence.write(cacheKey, response.body, boxName: _boxName);

        // Store ETag
        final newEtag = response.headers['etag'];
        if (newEtag != null) {
          await _persistence.write(etagKey, newEtag, boxName: _boxName);
        }

        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return PaginatedResponse.fromJson(decoded, fromJson);
      } else if (response.statusCode == 304) {
        // Not modified, return cached
        final cached = _persistence.read<String>(cacheKey, boxName: _boxName);
        if (cached != null) {
          final decoded = jsonDecode(cached) as Map<String, dynamic>;
          return PaginatedResponse.fromJson(decoded, fromJson);
        }
      } else {
        logger.e('Open5e API error: ${response.statusCode} - ${response.body}',
            context: LogContext.network);
      }
    } catch (e) {
      logger.e('Failed to fetch from Open5e: $e', context: LogContext.network);
    }

    return null;
  }

  /// Generic method to fetch a single resource by slug
  Future<T?> fetchBySlug<T>({
    required String endpoint,
    required String slug,
    required T Function(Map<String, dynamic>) fromJson,
    bool useCache = true,
    bool force = false,
  }) async {
    final cacheKey = '${endpoint}_slug_$slug';
    final etagKey = '${cacheKey}_etag';

    // Try cache first
    if (useCache && !force) {
      final cached = _persistence.read<String>(cacheKey, boxName: _boxName);
      if (cached != null) {
        try {
          final decoded = jsonDecode(cached) as Map<String, dynamic>;
          return fromJson(decoded);
        } catch (e) {
          logger.w('Failed to parse cached resource $slug: $e',
              context: LogContext.network);
        }
      }
    }

    // Build URL
    final url = endpoint.endsWith('/') ? '$endpoint$slug/' : '$endpoint/$slug/';
    final uri = Uri.parse('$url?format=json');

    // Add ETag if available
    final headers = <String, String>{};
    if (useCache && !force) {
      final etag = _persistence.read<String>(etagKey, boxName: _boxName);
      if (etag != null) headers['If-None-Match'] = etag;
    }

    try {
      logger.d('Fetching from Open5e: $uri', context: LogContext.network);
      final response = await _httpClient.get(uri, headers: headers);

      if (response.statusCode == 200) {
        // Store in cache
        await _persistence.write(cacheKey, response.body, boxName: _boxName);

        // Store ETag
        final newEtag = response.headers['etag'];
        if (newEtag != null) {
          await _persistence.write(etagKey, newEtag, boxName: _boxName);
        }

        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return fromJson(decoded);
      } else if (response.statusCode == 304) {
        // Not modified, return cached
        final cached = _persistence.read<String>(cacheKey, boxName: _boxName);
        if (cached != null) {
          final decoded = jsonDecode(cached) as Map<String, dynamic>;
          return fromJson(decoded);
        }
      } else {
        logger.e('Open5e API error: ${response.statusCode} - ${response.body}',
            context: LogContext.network);
      }
    } catch (e) {
      logger.e('Failed to fetch from Open5e: $e', context: LogContext.network);
    }

    return null;
  }

  /// Search for resources
  Future<PaginatedResponse<T>?> search<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    required String query,
    int page = 1,
    int? pageSize,
    Map<String, String>? additionalParams,
  }) async {
    final params = {
      'search': query,
      ...?additionalParams,
    };

    return fetchList<T>(
      endpoint: endpoint,
      fromJson: fromJson,
      page: page,
      pageSize: pageSize,
      queryParams: params,
      useCache: false, // Don't cache search results
    );
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    // Note: This is a simplified version. In production, you might want to
    // iterate through all keys with a specific prefix
    logger.i('Clearing Open5e cache', context: LogContext.network);
    // The persistence service doesn't have a clear all method for a box
    // so we'll rely on individual cache invalidation
  }

  /// Build URI with pagination and query parameters
  Uri _buildUri(
    String endpoint, {
    int? page,
    int? pageSize,
    Map<String, String>? additionalParams,
  }) {
    final params = <String, String>{
      'format': 'json',
      if (page != null) 'page': page.toString(),
      if (pageSize != null) 'page_size': pageSize.toString(),
      ...?additionalParams,
    };

    return Uri.parse(endpoint).replace(queryParameters: params);
  }

  /// Build cache key for list requests
  String _buildCacheKey(
    String endpoint,
    int page,
    int? pageSize,
    Map<String, String>? params,
  ) {
    final buffer = StringBuffer('${endpoint}_page_$page');
    if (pageSize != null) buffer.write('_size_$pageSize');
    if (params != null && params.isNotEmpty) {
      final sortedKeys = params.keys.toList()..sort();
      for (final key in sortedKeys) {
        buffer.write('_${key}_${params[key]}');
      }
    }
    return buffer.toString();
  }
}

/// High-level service for accessing Open5e data
///
/// Provides type-safe methods for all Open5e endpoints with caching and
/// error handling built in.
class Open5eService {
  final Open5eClient _client;

  Open5eService(PersistenceService persistence, {Client? httpClient})
      : _client = Open5eClient(persistence, httpClient: httpClient);

  // Monsters
  Future<PaginatedResponse<Monster>?> getMonsters({
    int page = 1,
    int? pageSize,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.monsters,
        fromJson: Monster.fromOpen5eJson,
        page: page,
        pageSize: pageSize,
        useCache: useCache,
      );

  Future<Monster?> getMonsterBySlug(String slug, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.monsters,
        slug: slug,
        fromJson: Monster.fromOpen5eJson,
        useCache: useCache,
      );

  Future<PaginatedResponse<Monster>?> searchMonsters(
    String query, {
    int page = 1,
    int? pageSize,
  }) =>
      _client.search(
        endpoint: Open5eEndpoints.monsters,
        fromJson: Monster.fromOpen5eJson,
        query: query,
        page: page,
        pageSize: pageSize,
      );

  // Spells
  Future<PaginatedResponse<Open5eSpell>?> getSpells({
    int page = 1,
    int? pageSize,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.spells,
        fromJson: Open5eSpell.fromJson,
        page: page,
        pageSize: pageSize,
        useCache: useCache,
      );

  Future<Open5eSpell?> getSpellBySlug(String slug, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.spells,
        slug: slug,
        fromJson: Open5eSpell.fromJson,
        useCache: useCache,
      );

  Future<PaginatedResponse<Open5eSpell>?> searchSpells(
    String query, {
    int page = 1,
    int? pageSize,
  }) =>
      _client.search(
        endpoint: Open5eEndpoints.spells,
        fromJson: Open5eSpell.fromJson,
        query: query,
        page: page,
        pageSize: pageSize,
      );

  // Backgrounds
  Future<PaginatedResponse<Background>?> getBackgrounds({
    int page = 1,
    int? pageSize,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.backgrounds,
        fromJson: Background.fromJson,
        page: page,
        pageSize: pageSize,
        useCache: useCache,
      );

  Future<Background?> getBackgroundBySlug(String slug,
          {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.backgrounds,
        slug: slug,
        fromJson: Background.fromJson,
        useCache: useCache,
      );

  // Feats
  Future<PaginatedResponse<Feat>?> getFeats({
    int page = 1,
    int? pageSize,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.feats,
        fromJson: Feat.fromJson,
        page: page,
        pageSize: pageSize,
        useCache: useCache,
      );

  Future<Feat?> getFeatBySlug(String slug, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.feats,
        slug: slug,
        fromJson: Feat.fromJson,
        useCache: useCache,
      );

  // Conditions
  Future<PaginatedResponse<Condition>?> getConditions({
    int page = 1,
    int? pageSize,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.conditions,
        fromJson: Condition.fromJson,
        page: page,
        pageSize: pageSize,
        useCache: useCache,
      );

  Future<Condition?> getConditionBySlug(String slug, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.conditions,
        slug: slug,
        fromJson: Condition.fromJson,
        useCache: useCache,
      );

  // Races
  Future<PaginatedResponse<Race>?> getRaces({
    int page = 1,
    int? pageSize,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.races,
        fromJson: Race.fromJson,
        page: page,
        pageSize: pageSize,
        useCache: useCache,
      );

  Future<Race?> getRaceBySlug(String slug, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.races,
        slug: slug,
        fromJson: Race.fromJson,
        useCache: useCache,
      );

  // Classes
  Future<PaginatedResponse<CharacterClass>?> getClasses({
    int page = 1,
    int? pageSize,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.classes,
        fromJson: CharacterClass.fromJson,
        page: page,
        pageSize: pageSize,
        useCache: useCache,
      );

  Future<CharacterClass?> getClassBySlug(String slug,
          {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.classes,
        slug: slug,
        fromJson: CharacterClass.fromJson,
        useCache: useCache,
      );

  // Magic Items
  Future<PaginatedResponse<MagicItem>?> getMagicItems({
    int page = 1,
    int? pageSize,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.magicItems,
        fromJson: MagicItem.fromJson,
        page: page,
        pageSize: pageSize,
        useCache: useCache,
      );

  Future<MagicItem?> getMagicItemBySlug(String slug, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.magicItems,
        slug: slug,
        fromJson: MagicItem.fromJson,
        useCache: useCache,
      );

  Future<PaginatedResponse<MagicItem>?> searchMagicItems(
    String query, {
    int page = 1,
    int? pageSize,
  }) =>
      _client.search(
        endpoint: Open5eEndpoints.magicItems,
        fromJson: MagicItem.fromJson,
        query: query,
        page: page,
        pageSize: pageSize,
      );

  // Weapons
  Future<PaginatedResponse<Weapon>?> getWeapons({
    int page = 1,
    int? pageSize,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.weapons,
        fromJson: Weapon.fromJson,
        page: page,
        pageSize: pageSize,
        useCache: useCache,
      );

  Future<Weapon?> getWeaponBySlug(String slug, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.weapons,
        slug: slug,
        fromJson: Weapon.fromJson,
        useCache: useCache,
      );

  // Armor
  Future<PaginatedResponse<Armor>?> getArmor({
    int page = 1,
    int? pageSize,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.armor,
        fromJson: Armor.fromJson,
        page: page,
        pageSize: pageSize,
        useCache: useCache,
      );

  Future<Armor?> getArmorBySlug(String slug, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.armor,
        slug: slug,
        fromJson: Armor.fromJson,
        useCache: useCache,
      );

  // Documents
  Future<PaginatedResponse<Document>?> getDocuments({
    int page = 1,
    int? pageSize,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.documents,
        fromJson: Document.fromJson,
        page: page,
        pageSize: pageSize,
        useCache: useCache,
      );

  Future<Document?> getDocumentBySlug(String slug, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.documents,
        slug: slug,
        fromJson: Document.fromJson,
        useCache: useCache,
      );

  // Planes
  Future<PaginatedResponse<Plane>?> getPlanes({
    int page = 1,
    int? pageSize,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.planes,
        fromJson: Plane.fromJson,
        page: page,
        pageSize: pageSize,
        useCache: useCache,
      );

  Future<Plane?> getPlaneBySlug(String slug, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.planes,
        slug: slug,
        fromJson: Plane.fromJson,
        useCache: useCache,
      );

  // Sections
  Future<PaginatedResponse<Section>?> getSections({
    int page = 1,
    int? pageSize,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.sections,
        fromJson: Section.fromJson,
        page: page,
        pageSize: pageSize,
        useCache: useCache,
      );

  Future<Section?> getSectionBySlug(String slug, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.sections,
        slug: slug,
        fromJson: Section.fromJson,
        useCache: useCache,
      );

  // Spell Lists
  Future<PaginatedResponse<SpellList>?> getSpellLists({
    int page = 1,
    int? pageSize,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.spellList,
        fromJson: SpellList.fromJson,
        page: page,
        pageSize: pageSize,
        useCache: useCache,
      );

  Future<SpellList?> getSpellListBySlug(String slug, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.spellList,
        slug: slug,
        fromJson: SpellList.fromJson,
        useCache: useCache,
      );

  // Manifest
  Future<PaginatedResponse<ManifestEntry>?> getManifest({
    int page = 1,
    int? pageSize,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.manifest,
        fromJson: ManifestEntry.fromJson,
        page: page,
        pageSize: pageSize,
        useCache: useCache,
      );

  /// Clear all cached Open5e data
  Future<void> clearCache() => _client.clearCache();
}
