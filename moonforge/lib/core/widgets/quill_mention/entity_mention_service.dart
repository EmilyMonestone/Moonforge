import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/entity_repository.dart';

/// Service for fetching entities for mention autocomplete.
class EntityMentionService {
  final EntityRepository entityRepository;

  EntityMentionService({required this.entityRepository});

  /// Search entities by kind and query string.
  ///
  /// [campaignId] - The campaign ID to search entities in (not used in current flat schema)
  /// [kinds] - Comma-separated list of entity kinds (e.g., "npc,group,monster")
  /// [query] - Search query to filter by entity name
  /// [limit] - Maximum number of results to return (default: 10)
  Future<List<Entity>> searchEntities({
    required String campaignId,
    required String kinds,
    String query = '',
    int limit = 10,
  }) async {
    try {
      final kindList = kinds.split(',').map((k) => k.trim()).toList();

      // Get all entities from the repository
      // Note: In Drift flat schema, we get all entities and filter locally
      // For better performance with large datasets, consider adding specific query methods to EntityDao
      final allEntities = await entityRepository.getAll();

      // Filter by non-deleted, matching kinds, and query
      var filteredEntities = allEntities.where((e) {
        // Skip deleted entities
        if (e.deleted) return false;

        // Filter by kind if specified
        if (kindList.isNotEmpty && kindList.first.isNotEmpty) {
          if (!kindList.contains(e.kind)) return false;
        }

        // Filter by query if provided
        if (query.isNotEmpty) {
          final lowerQuery = query.toLowerCase();
          if (!e.name.toLowerCase().contains(lowerQuery)) return false;
        }

        return true;
      }).take(limit).toList();

      return filteredEntities;
    } catch (e) {
      logger.e('Error searching entities: $e');
      return [];
    }
  }

  /// Get a single entity by ID.
  ///
  /// [campaignId] - The campaign ID (not used in current flat schema)
  /// [entityId] - The entity ID
  Future<Entity?> getEntityById({
    required String campaignId,
    required String entityId,
  }) async {
    try {
      final entity = await entityRepository.getById(entityId);
      return entity;
    } catch (e) {
      logger.e('Error getting entity by ID: $e');
      return null;
    }
  }
}
