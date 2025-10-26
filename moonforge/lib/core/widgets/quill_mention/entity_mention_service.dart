import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moonforge/core/database/odm.dart';
import 'package:moonforge/core/models/data/entity.dart';
import 'package:moonforge/core/models/data/schema.dart';
import 'package:moonforge/core/utils/logger.dart';

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

      // Build query
      Query<Entity> queryRef = entitiesRef.reference;

      // Filter by deleted flag
      queryRef = queryRef.where('deleted', isEqualTo: false);

      // If kinds are specified, filter by kind
      if (kindList.isNotEmpty && kindList.first.isNotEmpty) {
        queryRef = queryRef.where('kind', whereIn: kindList);
      }

      // Limit results
      queryRef = queryRef.limit(limit);

      // Execute query
      final snapshot = await queryRef.get();
      final entities = snapshot.docs
          .map((doc) => doc.data() as Entity)
          .toList();

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
      final doc = await entitiesRef.doc(entityId).get();
      return doc.data;
    } catch (e) {
      logger.e('Error getting entity by ID: $e');
      return null;
    }
  }
}
