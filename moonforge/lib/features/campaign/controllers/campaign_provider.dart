import 'package:flutter/material.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';

class CampaignProvider with ChangeNotifier {
  static const String _currentCampaignKey = 'current_campaign_id';
  final PersistenceService _persistence = PersistenceService();

  Campaign? _currentCampaign;

  Campaign? get currentCampaign => _currentCampaign;

  CampaignProvider() {
    _loadPersistedCampaignId();
  }

  /// Load the persisted campaign ID on initialization
  Future<void> _loadPersistedCampaignId() async {
    try {
      final campaignId = _persistence.read<String>(_currentCampaignKey);
      if (campaignId != null) {
        // Fetch the campaign from the database
        final campaign = await CampaignRepository(
          constructDb(),
        ).getById(campaignId);
        if (campaign != null) {
          _currentCampaign = campaign;
        } else {
          logger.w('No campaign found with ID: $campaignId');
        }
        notifyListeners();
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
    _currentCampaign = campaign;

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
    _currentCampaign = null;
    notifyListeners();
  }
}
