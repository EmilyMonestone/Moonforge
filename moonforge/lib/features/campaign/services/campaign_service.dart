import 'package:moonforge/core/services/base_service.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:uuid/uuid.dart';

/// Service for campaign lifecycle management and operations
class CampaignService extends BaseService {
  final CampaignRepository _repository;

  @override
  String get serviceName => 'CampaignService';

  CampaignService(this._repository);

  /// Duplicate a campaign with a new name
  Future<Campaign?> duplicateCampaign(Campaign campaign, String newName) async {
    return execute(() async {
      final newCampaign = Campaign(
        id: const Uuid().v4(),
        name: newName,
        description: campaign.description,
        content: campaign.content,
        ownerUid: campaign.ownerUid,
        memberUids: campaign.memberUids,
        entityIds: campaign.entityIds,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 0,
      );

      await _repository.create(newCampaign);
      logInfo('Campaign duplicated: ${campaign.id} -> ${newCampaign.id}');
      return newCampaign;
    }, operationName: 'duplicateCampaign');
  }

  /// Archive a campaign (soft delete by adding archived flag in description or metadata)
  /// Note: Since there's no archived field in the schema, we could use a naming convention
  /// or add it to content. For now, this is a placeholder.
  Future<bool> archiveCampaign(Campaign campaign) async {
    return execute(() async {
      // In a real implementation, you'd add an 'archived' field to the schema
      // For now, we'll just log it
      logInfo('Campaign archived: ${campaign.id}');
      return true;
    }, operationName: 'archiveCampaign');
  }

  /// Restore an archived campaign
  Future<bool> restoreCampaign(Campaign campaign) async {
    return execute(() async {
      logInfo('Campaign restored: ${campaign.id}');
      return true;
    }, operationName: 'restoreCampaign');
  }

  /// Calculate campaign statistics
  Future<CampaignStats> getCampaignStats(Campaign campaign) async {
    // This would query related entities, chapters, sessions, etc.
    // For now, return basic stats
    return execute(() async {
      return CampaignStats(
        campaignId: campaign.id,
        chapterCount: 0,
        entityCount: campaign.entityIds.length,
        sessionCount: 0,
        totalPlayTimeMinutes: 0,
      );
    }, operationName: 'getCampaignStats');
  }

  /// Get all campaigns for the current user
  Stream<List<Campaign>> watchAllCampaigns() {
    return _repository.watchAll();
  }

  /// Get campaigns filtered by various criteria
  Future<List<Campaign>> getFilteredCampaigns({
    String? searchQuery,
    bool? archived,
    String? sortBy,
    bool descending = false,
  }) async {
    // Implement filtering logic
    final campaigns = await _repository.customQuery();

    var filtered = campaigns;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      filtered = filtered.where((c) {
        return c.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            c.description.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Sort
    if (sortBy == 'name') {
      filtered.sort(
        (a, b) =>
            descending ? b.name.compareTo(a.name) : a.name.compareTo(b.name),
      );
    } else if (sortBy == 'updated') {
      filtered.sort((a, b) {
        final aDate = a.updatedAt ?? a.createdAt ?? DateTime(1970);
        final bDate = b.updatedAt ?? b.createdAt ?? DateTime(1970);
        return descending ? bDate.compareTo(aDate) : aDate.compareTo(bDate);
      });
    } else if (sortBy == 'created') {
      filtered.sort((a, b) {
        final aDate = a.createdAt ?? DateTime(1970);
        final bDate = b.createdAt ?? DateTime(1970);
        return descending ? bDate.compareTo(aDate) : aDate.compareTo(bDate);
      });
    }

    return filtered;
  }

  /// Delete a campaign by id
  Future<void> deleteCampaign(String id) async {
    return execute(() async {
      await _repository.delete(id);
      logInfo('Deleted campaign: $id');
    }, operationName: 'deleteCampaign');
  }
}

/// Statistics for a campaign
class CampaignStats {
  final String campaignId;
  final int chapterCount;
  final int entityCount;
  final int sessionCount;
  final int totalPlayTimeMinutes;

  CampaignStats({
    required this.campaignId,
    required this.chapterCount,
    required this.entityCount,
    required this.sessionCount,
    required this.totalPlayTimeMinutes,
  });
}
