import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/models/data/entity.dart';

/// Service for syncing D&D 5e 2024 monsters from 5etools
///
/// This service downloads monster data from the 5etools repository and caches it
/// locally for better performance. The data is stored using PersistenceService.
class DndMonsterSyncService {
  static final DndMonsterSyncService _instance =
      DndMonsterSyncService._internal();
  factory DndMonsterSyncService() => _instance;
  DndMonsterSyncService._internal();

  static const String _monstersUrl =
      'https://raw.githubusercontent.com/5etools-mirror-3/5etools-src/refs/heads/main/data/bestiary/bestiary-xmm.json';
  static const String _cacheKey = 'dnd_5e_monsters_cache';
  static const String _cacheTimestampKey = 'dnd_5e_monsters_cache_timestamp';
  static const Duration _cacheValidDuration = Duration(days: 7);

  final PersistenceService _persistence = PersistenceService();

  /// Sync monsters from the remote source
  ///
  /// Downloads the latest monster data from 5etools and caches it locally.
  /// Returns a list of raw monster data as maps.
  ///
  /// Throws an exception if the download fails.
  Future<List<Map<String, dynamic>>> syncMonsters(
      {bool forceRefresh = false}) async {
    try {
      // Check if we have cached data and it's still valid
      if (!forceRefresh && _isCacheValid()) {
        logger.i('Using cached D&D 5e monsters');
        return _loadFromCache();
      }

      logger.i('Fetching D&D 5e monsters from remote source');
      final response = await http.get(Uri.parse(_monstersUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final monsters = (data['monster'] as List<dynamic>?)
                ?.map((m) => m as Map<String, dynamic>)
                .toList() ??
            [];

        // Cache the data
        await _saveToCache(monsters);
        logger.i('Successfully synced ${monsters.length} D&D 5e monsters');

        return monsters;
      } else {
        throw Exception(
            'Failed to fetch monsters: HTTP ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error syncing D&D 5e monsters: $e');
      // Try to return cached data as fallback
      if (_persistence.hasData(_cacheKey)) {
        logger.w('Returning cached data as fallback');
        return _loadFromCache();
      }
      rethrow;
    }
  }

  /// Get cached monsters without syncing
  ///
  /// Returns null if no cached data exists.
  List<Map<String, dynamic>>? getCachedMonsters() {
    if (!_persistence.hasData(_cacheKey)) {
      return null;
    }
    return _loadFromCache();
  }

  /// Convert a 5etools monster to a Moonforge Entity
  ///
  /// This method converts the 5etools monster format to the Entity model
  /// used by Moonforge, storing the full monster data in the statblock field.
  Entity convertToEntity(Map<String, dynamic> monsterData, String entityId) {
    final name = monsterData['name'] as String? ?? 'Unknown Monster';
    final cr = monsterData['cr'] as dynamic;
    final type = monsterData['type'] as dynamic;
    final size = monsterData['size'] as dynamic;

    // Create a summary from CR, type, and size
    String summary = '';
    if (cr != null) {
      summary += 'CR $cr ';
    }
    if (size != null) {
      if (size is List) {
        summary += '${size.first} ';
      } else {
        summary += '$size ';
      }
    }
    if (type != null) {
      if (type is String) {
        summary += type;
      } else if (type is Map && type.containsKey('type')) {
        summary += type['type'].toString();
      }
    }

    return Entity(
      id: entityId,
      kind: 'monster',
      name: name,
      summary: summary.trim().isNotEmpty ? summary.trim() : null,
      statblock: monsterData,
      tags: ['dnd-5e-2024', 'xmm'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Check if cached data is still valid
  bool _isCacheValid() {
    if (!_persistence.hasData(_cacheKey) ||
        !_persistence.hasData(_cacheTimestampKey)) {
      return false;
    }

    final timestamp = _persistence.read<int>(_cacheTimestampKey);
    if (timestamp == null) return false;

    final cacheDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    return now.difference(cacheDate) < _cacheValidDuration;
  }

  /// Load monsters from cache
  List<Map<String, dynamic>> _loadFromCache() {
    final cached = _persistence.read<List>(_cacheKey);
    if (cached == null) return [];

    return cached
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  /// Save monsters to cache
  Future<void> _saveToCache(List<Map<String, dynamic>> monsters) async {
    await _persistence.write(_cacheKey, monsters);
    await _persistence.write(
        _cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Clear the cached monster data
  Future<void> clearCache() async {
    await _persistence.remove(_cacheKey);
    await _persistence.remove(_cacheTimestampKey);
    logger.i('Cleared D&D 5e monsters cache');
  }

  /// Get cache information
  Map<String, dynamic>? getCacheInfo() {
    if (!_persistence.hasData(_cacheTimestampKey)) {
      return null;
    }

    final timestamp = _persistence.read<int>(_cacheTimestampKey);
    if (timestamp == null) return null;

    final cacheDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final monsters = getCachedMonsters();

    return {
      'cached_at': cacheDate.toIso8601String(),
      'monster_count': monsters?.length ?? 0,
      'is_valid': _isCacheValid(),
    };
  }
}
