import 'package:flutter/material.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/sync/sync_engine.dart';
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
  void initState() {
    super.initState();
    _initializeAppState();
    // Ensure SyncEngine provider is realized even if laziness interferes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        // Accessing it ensures the provider is created and started
        final _ = context.read<SyncEngine>();
        logger.i('Ensured SyncEngine is initialized via AppStateInitializer');
      } catch (e) {
        logger.w('Failed to ensure SyncEngine from AppStateInitializer: $e');
      }
    });
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
    } catch (e) {
      logger.e('Error initializing app state: $e');
    }
  Widget build(BuildContext context) {
    // Always render the child, initialization happens in background
    return widget.child;
