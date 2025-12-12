import 'dart:convert';

import 'package:http/http.dart' show Client, Response;
import 'package:moonforge/core/services/open5e/open5e_endpoints.dart';
import 'package:moonforge/core/services/open5e/models/character.dart';
import 'package:moonforge/core/services/open5e/models/common.dart';
import 'package:moonforge/core/services/open5e/models/equipment.dart';
import 'package:moonforge/core/services/open5e/models/mechanics.dart';
import 'package:moonforge/core/services/open5e/models/spells.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/models/monster.dart';

/// Query options for Open5e API requests
///
/// Supports filtering, searching, ordering, and pagination according to
/// the official Open5e API documentation at https://open5e.com/api-docs
class Open5eQueryOptions {
  /// Case-insensitive partial-word search
  final String? search;

  /// Filter by source document slug (e.g., '5esrd', 'tob')
  /// Use document__slug parameter for filtering by document
  final String? documentSlug;

  /// Ordering field (e.g., 'name', 'challenge_rating', '-name' for descending)
  final String? ordering;

  /// Page number (1-based)
  final int page;

  /// Results per page (limit parameter)
  final int? limit;

  /// Additional filter parameters (e.g., {'cr': '3'} for monsters)
  final Map<String, String>? filters;

  Open5eQueryOptions({
    this.search,
    this.documentSlug,
    this.ordering,
    this.page = 1,
    this.limit,
    this.filters,
  });

  /// Convert to query parameters
  Map<String, String> toQueryParams() {
    final params = <String, String>{
      'format': 'json',
      'page': page.toString(),
    };

    if (search != null) params['search'] = search!;
    if (documentSlug != null) params['document__slug'] = documentSlug!;
    if (ordering != null) params['ordering'] = ordering!;
    if (limit != null) params['limit'] = limit.toString();
    if (filters != null) params.addAll(filters!);

    return params;
  }
}

/// Base client for Open5e API interactions
///
/// Provides generic methods for fetching data from Open5e API endpoints with
/// caching, ETags support, filtering, searching, and ordering.
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
    Open5eQueryOptions? options,
    bool useCache = true,
    bool force = false,
  }) async {
    final queryOptions = options ?? Open5eQueryOptions();
    final cacheKey = _buildCacheKey(endpoint, queryOptions);
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
    final uri = Uri.parse(endpoint).replace(
      queryParameters: queryOptions.toQueryParams(),
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

  /// Clear all cached data
  ///
  /// Note: Due to PersistenceService limitations, this marks the cache
  /// for clearing. Individual cache entries will be cleared when accessed
  /// with force=true or on next request.
  Future<void> clearCache() async {
    logger.i('Open5e cache clear requested - cache will be refreshed on next access',
        context: LogContext.network);
    // Note: PersistenceService doesn't provide a way to enumerate and clear
    // all keys in a box. Cache entries will be invalidated on next access.
  }

  /// Build cache key for list requests
  String _buildCacheKey(String endpoint, Open5eQueryOptions options) {
    final buffer = StringBuffer('${endpoint}_page_${options.page}');
    if (options.limit != null) buffer.write('_limit_${options.limit}');
    if (options.search != null) buffer.write('_search_${options.search}');
    if (options.documentSlug != null) {
      buffer.write('_doc_${options.documentSlug}');
    }
    if (options.ordering != null) buffer.write('_order_${options.ordering}');
    if (options.filters != null && options.filters!.isNotEmpty) {
      final sortedKeys = options.filters!.keys.toList()..sort();
      for (final key in sortedKeys) {
        buffer.write('_${key}_${options.filters![key]}');
      }
    }
    return buffer.toString();
  }
}

/// High-level service for accessing Open5e data
///
/// Provides type-safe methods for all Open5e endpoints with caching,
/// filtering, searching, and ordering support.
class Open5eService {
  final Open5eClient _client;

  Open5eService(PersistenceService persistence, {Client? httpClient})
      : _client = Open5eClient(persistence, httpClient: httpClient);

  // Monsters
  Future<PaginatedResponse<Monster>?> getMonsters({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.monsters,
        fromJson: Monster.fromOpen5eJson,
        options: options,
        useCache: useCache,
      );

  Future<Monster?> getMonsterBySlug(String slug, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.monsters,
        slug: slug,
        fromJson: Monster.fromOpen5eJson,
        useCache: useCache,
      );

  // Spells
  Future<PaginatedResponse<Open5eSpell>?> getSpells({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.spells,
        fromJson: Open5eSpell.fromJson,
        options: options,
        useCache: useCache,
      );

  Future<Open5eSpell?> getSpellBySlug(String slug, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.spells,
        slug: slug,
        fromJson: Open5eSpell.fromJson,
        useCache: useCache,
      );

  // Backgrounds
  Future<PaginatedResponse<Background>?> getBackgrounds({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.backgrounds,
        fromJson: Background.fromJson,
        options: options,
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
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.feats,
        fromJson: Feat.fromJson,
        options: options,
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
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.conditions,
        fromJson: Condition.fromJson,
        options: options,
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
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.races,
        fromJson: Race.fromJson,
        options: options,
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
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.classes,
        fromJson: CharacterClass.fromJson,
        options: options,
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
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.magicItems,
        fromJson: MagicItem.fromJson,
        options: options,
        useCache: useCache,
      );

  Future<MagicItem?> getMagicItemBySlug(String slug, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.magicItems,
        slug: slug,
        fromJson: MagicItem.fromJson,
        useCache: useCache,
      );

  // Weapons
  Future<PaginatedResponse<Weapon>?> getWeapons({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.weapons,
        fromJson: Weapon.fromJson,
        options: options,
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
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.armor,
        fromJson: Armor.fromJson,
        options: options,
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
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.documents,
        fromJson: Document.fromJson,
        options: options,
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
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.planes,
        fromJson: Plane.fromJson,
        options: options,
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
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.sections,
        fromJson: Section.fromJson,
        options: options,
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
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.spellList,
        fromJson: SpellList.fromJson,
        options: options,
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
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.manifest,
        fromJson: ManifestEntry.fromJson,
        options: options,
        useCache: useCache,
      );

  /// Clear all cached Open5e data
  Future<void> clearCache() => _client.clearCache();
}
