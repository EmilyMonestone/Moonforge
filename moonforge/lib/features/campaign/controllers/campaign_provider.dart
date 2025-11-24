import 'package:moonforge/core/di/service_locator.dart';
import 'package:moonforge/core/models/async_state.dart';
import 'package:moonforge/core/providers/base_async_provider.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/db/app_db.dart';

class CampaignProvider extends BaseAsyncProvider<Campaign> {
  static const String _currentCampaignKey = 'current_campaign_id';
  final PersistenceService _persistence = PersistenceService();

  Campaign? get currentCampaign => state.dataOrNull;

  CampaignProvider() {
    _loadPersistedCampaignId();
  }

  /// Load the persisted campaign ID on initialization
  Future<void> _loadPersistedCampaignId() async {
    try {
      final campaignId = _persistence.read<String>(_currentCampaignKey);
      if (campaignId != null) {
        // Fetch the campaign from the DI-registered repository
        final campaign = await getIt<CampaignRepository>().getById(campaignId);
        if (campaign != null) {
          updateState(AsyncState.data(campaign));
        } else {
          logger.w('No campaign found with ID: $campaignId');
          reset();
        }
      }
    } catch (e) {
      logger.e('Failed to load persisted campaign ID: $e');
    }
  }

  /// Get the persisted campaign ID
  String? getPersistedCampaignId() {
    return _persistence.read<String>(_currentCampaignKey);
  }

  void setCurrentCampaign(Campaign? campaign) {
    if (campaign == null) {
      reset();
    } else {
      updateState(AsyncState.data(campaign));
    }

    // Persist the campaign ID
    if (campaign != null) {
      _persistence.write(_currentCampaignKey, campaign.id);
    } else {
      _persistence.remove(_currentCampaignKey);
      logger.i('Removed persisted campaign ID');
    }

    notifyListeners();
  }

  /// Clear the persisted campaign
  void clearPersistedCampaign() {
    _persistence.remove(_currentCampaignKey);
    reset();
    notifyListeners();
  }
}
