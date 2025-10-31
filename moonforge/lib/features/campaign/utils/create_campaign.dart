import 'package:flutter/widgets.dart';
import 'package:moonforge/core/models/return_message.dart';
import 'package:moonforge/core/providers/auth_providers.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:provider/provider.dart';

/// Creates a new Campaign in Drift (local-first) and navigates to the Campaign edit page.
///
/// - Persists the newly created campaign id using [selectedCampaignIdProvider]
/// - Navigates using typed routes: [CampaignEditRoute]
/// Parameters [name] and [description] are optional and default to a minimal
/// placeholder if not provided. No user-facing toasts are shown here to
/// avoid introducing non-localized strings; errors are logged.
Future<ReturnMessage<Campaign?>> createCampaignAndOpenEditor(
  BuildContext context, {
  String? name,
  String? description,
}) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final campaignProvider = Provider.of<CampaignProvider>(
    context,
    listen: false,
  );
  final repository = Provider.of<CampaignRepository>(context, listen: false);
  try {
    final ownerUid = authProvider.user?.id;
    if (ownerUid == null) {
      logger.w('createCampaign aborted: user not authenticated');
      return ReturnMessage.failure('Bitte zuerst anmelden.', null);
    }
    // Capture target location before async operations.
    final location = const CampaignEditRoute().location;
    // Generate a unique ID for the campaign
    final campaignId = 'campaign-${DateTime.now().millisecondsSinceEpoch}';
    final data = Campaign(
      id: campaignId,
      name: name?.trim().isNotEmpty == true ? name!.trim() : '',
      description: description ?? '',
      content: null,
      ownerUid: ownerUid,
      memberUids: <String>[ownerUid],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rev: 0,
    );
    // Use Drift repository for optimistic local write
    await repository.upsertLocal(data);
    // Persist selected id so dependent screens can resolve the document
    campaignProvider.setCurrentCampaign(data);
    // Navigate to the campaign edit screen without using context now
    AppRouter.router.go(location);
    return ReturnMessage.success(
      "Campaign created successfully",
      data,
  } catch (e, st) {
    logger.e('Failed to create campaign', error: e, stackTrace: st);
    return ReturnMessage.failure('Failed to create campaign: $e', null);
  }
}
