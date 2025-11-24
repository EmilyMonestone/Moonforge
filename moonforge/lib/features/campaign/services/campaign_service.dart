import 'package:moonforge/core/services/base_service.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:uuid/uuid.dart';

/// Service responsible for business rules and lifecycle operations for
/// campaigns (create, duplicate, archive, statistics, etc.).
///
/// This class encapsulates campaign-specific logic and coordinates with the
/// [CampaignRepository] for persistence. Keep UI logic out of this class — it
/// should only contain validation and orchestration logic.
class CampaignService extends BaseService {
  final CampaignRepository _repository;

  @override
  String get serviceName => 'CampaignService';

  CampaignService(this._repository);

  /// Duplicate the provided [campaign] using [newName] as the new display name.
  ///
  /// Returns the newly created [Campaign] on success or `null` on failure.
  /// This method performs repository operations and will increment the
  /// campaign revision when persisting in the repository.
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

  /// Archive the campaign. This is a soft-archive placeholder — the
  /// implementation currently logs the action; a production implementation
  /// would set an `archived` flag in the schema or the campaign's metadata.
  Future<bool> archiveCampaign(Campaign campaign) async {
    return execute(() async {
      // In a real implementation, you'd add an 'archived' field to the schema
      // For now, we'll just log it
      logInfo('Campaign archived: ${campaign.id}');
      return true;
    }, operationName: 'archiveCampaign');
  }

  /// Restore a previously archived campaign.
  Future<bool> restoreCampaign(Campaign campaign) async {
    return execute(() async {
      logInfo('Campaign restored: ${campaign.id}');
      return true;
    }, operationName: 'restoreCampaign');
  }

  /// Compute lightweight campaign statistics (chapter count, entity count,
  /// session count and total play time in minutes).
  ///
  /// This implementation returns basic values; replace with queries that
  /// aggregate across related repositories for full statistics.
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

  /// Returns a stream of all campaigns the repository exposes.
  Stream<List<Campaign>> watchAllCampaigns() {
    return _repository.watchAll();
  }

  /// Filter/sort campaigns using in-memory filtering after fetching a
  /// baseline from the repository. Prefer server-side filtering for large
  /// datasets.
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

  /// Delete a campaign by [id]. This performs a repository delete and
  /// logs the operation.
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
