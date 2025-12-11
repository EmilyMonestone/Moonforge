import 'package:flutter/material.dart';
import 'package:moonforge/core/di/service_locator.dart';
import 'package:moonforge/core/providers/gemini_provider.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/services/story_context_builder.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/ai/ai_creation_dialog.dart';
import 'package:moonforge/core/widgets/ai/creation_method_dialog.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/data/repo/party_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

/// Creates a new Party and navigates to the party edit view.
///
/// This function follows the pattern established by other create utilities
/// in the codebase (e.g., create_campaign, create_chapter).
/// Supports both manual and AI-assisted creation.
Future<void> createParty(BuildContext context, db.Campaign campaign) async {
  final l10n = AppLocalizations.of(context)!;
  final repository = getIt<PartyRepository>();

  // Ask user: Manual or AI?
  final geminiProvider = getIt.isRegistered<GeminiProvider>()
      ? getIt<GeminiProvider>()
      : null;
  final creationMethod = geminiProvider != null
      ? await showCreationMethodDialog(context, itemType: 'Party')
      : CreationMethod.manual;

  if (creationMethod == null) return;

  String name = '';
  String? aiSummary;

  if (creationMethod == CreationMethod.ai) {
    // AI-assisted creation
    final contextBuilder = StoryContextBuilder(
      campaignRepo: getIt<CampaignRepository>(),
      chapterRepo: getIt<ChapterRepository>(),
      adventureRepo: getIt<AdventureRepository>(),
      sceneRepo: getIt<SceneRepository>(),
      entityRepo: getIt<EntityRepository>(),
    );

    final storyContext = await contextBuilder.buildForCampaign(campaign.id);

    if (!context.mounted) return;

    final aiResult = await showAiCreationDialog(
      context,
      storyContext: storyContext,
      creationType: 'party',
    );

    if (aiResult == null) return;

    name = aiResult.title ?? 'Untitled Party';
    aiSummary = aiResult.content;
  } else {
    // Manual creation - prompt for name
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.createParty),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(labelText: l10n.name),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.create),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;
    
    name = controller.text.trim();
    if (name.isEmpty) return;
  }

  try {
    final partyId = const Uuid().v4();

    final party = db.Party(
      id: partyId,
      campaignId: campaign.id,
      name: name,
      summary: aiSummary,
      memberEntityIds: const <String>[],
      memberPlayerIds: const <String>[],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rev: 0,
    );

    await repository.create(party);

    if (!context.mounted) return;
    notification.success(context, title: Text(l10n.createParty));
    PartyEditRouteData(partyId: partyId).go(context);
  } catch (e, st) {
    logger.e('Create party failed', error: e, stackTrace: st);
    if (!context.mounted) return;
    notification.error(context, title: Text('Failed: $e'));
  }
}
