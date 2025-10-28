import 'package:flutter/material.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/firebase/models/schema.dart';
import 'package:moonforge/data/firebase/odm.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:provider/provider.dart';

/// Widget that initializes app state from persistent storage
///
/// This widget loads persisted data like the current campaign
/// and restores it when the app starts or hot reloads.
class AppStateInitializer extends StatefulWidget {
  final Widget child;

  const AppStateInitializer({super.key, required this.child});

  @override
  State<AppStateInitializer> createState() => _AppStateInitializerState();
}

class _AppStateInitializerState extends State<AppStateInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeAppState();
  }

  Future<void> _initializeAppState() async {
    try {
      final campaignProvider = context.read<CampaignProvider>();

      // Get the persisted campaign ID
      final campaignId = campaignProvider.getPersistedCampaignId();

      if (campaignId != null) {
        logger.i('Restoring persisted campaign: $campaignId');

        // Load the campaign from Firestore
        final odm = Odm.instance;
        try {
          final campaign = await odm.campaigns.doc(campaignId).get();
          if (campaign != null) {
            campaignProvider.setCurrentCampaign(campaign);
            logger.i('Successfully restored campaign: ${campaign.name}');
          } else {
            logger.w('Persisted campaign not found: $campaignId');
            // Clear the invalid persisted ID
            campaignProvider.clearPersistedCampaign();
          }
        } catch (e) {
          logger.e('Error loading persisted campaign: $e');
          // Don't clear on error - might be network issue
        }
      }
    } catch (e) {
      logger.e('Error initializing app state: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Always render the child, initialization happens in background
    return widget.child;
  }
}
