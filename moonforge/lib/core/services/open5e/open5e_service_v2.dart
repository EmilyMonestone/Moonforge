import 'dart:convert';

import 'package:http/http.dart' show Client, Response;
import 'package:moonforge/core/services/open5e/open5e_endpoints.dart';
import 'package:moonforge/core/services/open5e/models/character.dart';
import 'package:moonforge/core/services/open5e/models/common.dart';
import 'package:moonforge/core/services/open5e/models/creatures.dart';
import 'package:moonforge/core/services/open5e/models/equipment.dart';
import 'package:moonforge/core/services/open5e/models/mechanics.dart';
import 'package:moonforge/core/services/open5e/models/rules.dart';
import 'package:moonforge/core/services/open5e/models/spells.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Type-safe game system keys for Open5e API v2
///
/// These values are used for filtering content by game system.
/// Can be fetched dynamically from /v2/gamesystems/ endpoint.
class GameSystemKey {
  static const String edition2024 = '5e-2024';
  static const String edition2014 = '5e-2014';
  static const String advancedEdition = 'a5e';
  
  /// All available game system keys
  static const List<String> all = [edition2024, edition2014, advancedEdition];
}

/// Type-safe document keys for Open5e API v2
///
/// These represent source documents/books. The full list can be fetched
/// dynamically from /v2/documents/ endpoint for the most up-to-date values.
class DocumentKey {
  // 5e 2024 documents
  static const String srd2024 = 'srd-2024';
  
  // 5e 2014 documents  
  static const String srd2014 = 'srd';
  static const String wotcSrd = 'wotc-srd';
  
  // Third-party documents
  static const String tomeOfBeasts = 'tob';
  static const String tomeOfBeasts2 = 'tob2';
  static const String tomeOfBeasts3 = 'tob3';
  static const String creaturesCodex = 'cc';
  static const String creatureCodex = 'cc'; // Alias for creaturesCodex
  static const String menagerie = 'menagerie';
  static const String midgardHeroes = 'dmag';
  
  /// Common document keys
  static const List<String> common = [srd2024, srd2014, tomeOfBeasts];
}

/// Query options for Open5e API v2 requests
///
/// Supports filtering, searching, ordering, and pagination according to
/// the official Open5e API v2 documentation
class Open5eQueryOptions {
  /// Case-insensitive name search (name__icontains parameter)
  final String? search;

  /// Filter by gamesystem key (use GameSystemKey constants)
  /// Defaults to '5e-2024' if not specified
  final String? gameSystemKey;

  /// Filter by source document key (use DocumentKey constants)
  final String? documentKey;

  /// Filter by creature type (e.g., 'dragon', 'undead', 'humanoid')
  /// Only applicable for creatures endpoint. Get values from /v2/creaturetypes/
  final String? creatureType;

  /// Ordering field (e.g., 'name', 'challenge_rating_decimal', '-name' for descending)
  final String? ordering;

  /// Page number (1-based)
  final int page;

  /// Results per page (limit parameter)
  final int? limit;

  /// Additional filter parameters (e.g., {'challenge_rating_decimal': '3'} for creatures)
  final Map<String, String>? filters;

  Open5eQueryOptions({
    this.search,
    this.gameSystemKey,
    this.documentKey,
    this.creatureType,
    this.ordering,
    this.page = 1,
    this.limit,
    this.filters,
  });

  /// Convert to query parameters with default gamesystem
  Map<String, String> toQueryParams() {
    final params = <String, String>{
      'format': 'api',
      'page': page.toString(),
      // Default to 5e-2024 gamesystem if not specified
      'document__gamesystem__key__iexact': 
          gameSystemKey ?? Open5eEndpoints.defaultGameSystem,
    };

    if (search != null) params['name__icontains'] = search!;
    if (documentKey != null) params['document__key__iexact'] = documentKey!;
    if (creatureType != null) params['type'] = creatureType!;
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
    if (options.gameSystemKey != null) {
      buffer.write('_gs_${options.gameSystemKey}');
    }
    if (options.documentKey != null) {
      buffer.write('_doc_${options.documentKey}');
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

/// High-level service for accessing Open5e v2 data
///
/// Provides type-safe methods for all Open5e v2 endpoints with caching,
/// filtering, searching, and ordering support. All requests default to
/// 5e-2024 gamesystem unless specified otherwise.
class Open5eService {
  final Open5eClient _client;

  Open5eService(PersistenceService persistence, {Client? httpClient})
      : _client = Open5eClient(persistence, httpClient: httpClient);

  // Creatures (formerly Monsters in v1)
  Future<PaginatedResponse<Creature>?> getCreatures({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.creatures,
        fromJson: Creature.fromJson,
        options: options,
        useCache: useCache,
      );

  Future<Creature?> getCreatureByKey(String key, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.creatures,
        slug: key,
        fromJson: Creature.fromJson,
        useCache: useCache,
      );

  // Creature Types
  Future<PaginatedResponse<CreatureType>?> getCreatureTypes({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.creatureTypes,
        fromJson: CreatureType.fromJson,
        options: options,
        useCache: useCache,
      );

  // Creature Sets
  Future<PaginatedResponse<CreatureSet>?> getCreatureSets({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.creatureSets,
        fromJson: CreatureSet.fromJson,
        options: options,
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

  Future<Open5eSpell?> getSpellByKey(String key, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.spells,
        slug: key,
        fromJson: Open5eSpell.fromJson,
        useCache: useCache,
      );

  // Spell Schools
  Future<PaginatedResponse<SpellSchool>?> getSpellSchools({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.spellSchools,
        fromJson: SpellSchool.fromJson,
        options: options,
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

  Future<Background?> getBackgroundByKey(String key,
          {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.backgrounds,
        slug: key,
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

  Future<Feat?> getFeatByKey(String key, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.feats,
        slug: key,
        fromJson: Feat.fromJson,
        useCache: useCache,
      );

  // Species (formerly Races in v1)
  Future<PaginatedResponse<Species>?> getSpecies({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.species,
        fromJson: Species.fromJson,
        options: options,
        useCache: useCache,
      );

  Future<Species?> getSpeciesByKey(String key, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.species,
        slug: key,
        fromJson: Species.fromJson,
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

  Future<CharacterClass?> getClassByKey(String key,
          {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.classes,
        slug: key,
        fromJson: CharacterClass.fromJson,
        useCache: useCache,
      );

  // Abilities
  Future<PaginatedResponse<Ability>?> getAbilities({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.abilities,
        fromJson: Ability.fromJson,
        options: options,
        useCache: useCache,
      );

  // Skills
  Future<PaginatedResponse<Skill>?> getSkills({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.skills,
        fromJson: Skill.fromJson,
        options: options,
        useCache: useCache,
      );

  // Items
  Future<PaginatedResponse<Item>?> getItems({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.items,
        fromJson: Item.fromJson,
        options: options,
        useCache: useCache,
      );

  Future<Item?> getItemByKey(String key, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.items,
        slug: key,
        fromJson: Item.fromJson,
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

  Future<MagicItem?> getMagicItemByKey(String key, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.magicItems,
        slug: key,
        fromJson: MagicItem.fromJson,
        useCache: useCache,
      );

  // Item Sets
  Future<PaginatedResponse<ItemSet>?> getItemSets({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.itemSets,
        fromJson: ItemSet.fromJson,
        options: options,
        useCache: useCache,
      );

  // Item Categories
  Future<PaginatedResponse<ItemCategory>?> getItemCategories({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.itemCategories,
        fromJson: ItemCategory.fromJson,
        options: options,
        useCache: useCache,
      );

  // Item Rarities
  Future<PaginatedResponse<ItemRarity>?> getItemRarities({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.itemRarities,
        fromJson: ItemRarity.fromJson,
        options: options,
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

  Future<Weapon?> getWeaponByKey(String key, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.weapons,
        slug: key,
        fromJson: Weapon.fromJson,
        useCache: useCache,
      );

  // Weapon Properties
  Future<PaginatedResponse<WeaponProperty>?> getWeaponProperties({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.weaponProperties,
        fromJson: WeaponProperty.fromJson,
        options: options,
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

  Future<Armor?> getArmorByKey(String key, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.armor,
        slug: key,
        fromJson: Armor.fromJson,
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

  Future<Condition?> getConditionByKey(String key, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.conditions,
        slug: key,
        fromJson: Condition.fromJson,
        useCache: useCache,
      );

  // Damage Types
  Future<PaginatedResponse<DamageType>?> getDamageTypes({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.damageTypes,
        fromJson: DamageType.fromJson,
        options: options,
        useCache: useCache,
      );

  // Languages
  Future<PaginatedResponse<Language>?> getLanguages({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.languages,
        fromJson: Language.fromJson,
        options: options,
        useCache: useCache,
      );

  // Alignments
  Future<PaginatedResponse<Alignment>?> getAlignments({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.alignments,
        fromJson: Alignment.fromJson,
        options: options,
        useCache: useCache,
      );

  // Sizes
  Future<PaginatedResponse<Size>?> getSizes({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.sizes,
        fromJson: Size.fromJson,
        options: options,
        useCache: useCache,
      );

  // Environments
  Future<PaginatedResponse<Environment>?> getEnvironments({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.environments,
        fromJson: Environment.fromJson,
        options: options,
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

  Future<Document?> getDocumentByKey(String key, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.documents,
        slug: key,
        fromJson: Document.fromJson,
        useCache: useCache,
      );

  // Licenses
  Future<PaginatedResponse<License>?> getLicenses({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.licenses,
        fromJson: License.fromJson,
        options: options,
        useCache: useCache,
      );

  // Publishers
  Future<PaginatedResponse<Publisher>?> getPublishers({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.publishers,
        fromJson: Publisher.fromJson,
        options: options,
        useCache: useCache,
      );

  // Game Systems
  Future<PaginatedResponse<GameSystem>?> getGameSystems({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.gameSystems,
        fromJson: GameSystem.fromJson,
        options: options,
        useCache: useCache,
      );

  // Rules
  Future<PaginatedResponse<Rule>?> getRules({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.rules,
        fromJson: Rule.fromJson,
        options: options,
        useCache: useCache,
      );

  Future<Rule?> getRuleByKey(String key, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.rules,
        slug: key,
        fromJson: Rule.fromJson,
        useCache: useCache,
      );

  // Rule Sets
  Future<PaginatedResponse<RuleSet>?> getRuleSets({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.ruleSets,
        fromJson: RuleSet.fromJson,
        options: options,
        useCache: useCache,
      );

  // Images
  Future<PaginatedResponse<Open5eImage>?> getImages({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.images,
        fromJson: Open5eImage.fromJson,
        options: options,
        useCache: useCache,
      );

  Future<Open5eImage?> getImageByKey(String key, {bool useCache = true}) =>
      _client.fetchBySlug(
        endpoint: Open5eEndpoints.images,
        slug: key,
        fromJson: Open5eImage.fromJson,
        useCache: useCache,
      );

  // Services
  Future<PaginatedResponse<Open5eServiceResource>?> getServices({
    Open5eQueryOptions? options,
    bool useCache = true,
  }) =>
      _client.fetchList(
        endpoint: Open5eEndpoints.services,
        fromJson: Open5eServiceResource.fromJson,
        options: options,
        useCache: useCache,
      );

  /// Clear all cached Open5e data
  Future<void> clearCache() => _client.clearCache();
}
