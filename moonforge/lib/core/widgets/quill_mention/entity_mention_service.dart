import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/firebase/models/entity.dart';
import 'package:moonforge/data/firebase/models/schema.dart';
import 'package:moonforge/data/firebase/odm.dart';

/// Service for fetching entities for mention autocomplete.
class EntityMentionService {
  /// Search entities by kind and query string.
  ///
  /// [campaignId] - The campaign ID to search entities in
  /// [kinds] - Comma-separated list of entity kinds (e.g., "npc,group,monster")
  /// [query] - Search query to filter by entity name
  /// [limit] - Maximum number of results to return (default: 10)
  static Future<List<Entity>> searchEntities({
    required String campaignId,
    required String kinds,
    String query = '',
    int limit = 10,
  }) async {
    try {
      final odm = Odm.instance;
      final kindList = kinds.split(',').map((k) => k.trim()).toList();

      // Get the entities collection for this campaign
      final entitiesRef = odm.campaigns.doc(campaignId).entities;

      // Build query with where clause for non-deleted entities
      var queryBuilder = entitiesRef.where((f) => f.deleted(isEqualTo: false));

      // If kinds are specified, filter by kind
      if (kindList.isNotEmpty && kindList.first.isNotEmpty) {
        queryBuilder = queryBuilder.where((f) => f.kind(whereIn: kindList));
      }

      // Limit results and execute query
      final entities = await queryBuilder.limit(limit).get();

      // Filter by query string if provided (Firestore doesn't support full text search)
      if (query.isNotEmpty) {
        final lowerQuery = query.toLowerCase();
        return entities
            .where((e) => e.name.toLowerCase().contains(lowerQuery))
            .toList();
      }

      return entities;
    } catch (e) {
      logger.e('Error searching entities: $e');
      return [];
    }
  }

  /// Get a single entity by ID.
  ///
  /// [campaignId] - The campaign ID
  /// [entityId] - The entity ID
  static Future<Entity?> getEntityById({
    required String campaignId,
    required String entityId,
  }) async {
    try {
      final odm = Odm.instance;
      final entitiesRef = odm.campaigns.doc(campaignId).entities;
      final entity = await entitiesRef.doc(entityId).get();
      return entity;
    } catch (e) {
      logger.e('Error getting entity by ID: $e');
      return null;
    }
  }
}
