import 'package:flutter/material.dart';
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
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

Future<void> createEntity(BuildContext context, db.Campaign campaign) async {
  final l10n = AppLocalizations.of(context)!;
  final repository = context.read<EntityRepository>();

  // Ask user: Manual or AI?
  final geminiProvider = context.read<GeminiProvider?>();
  final creationMethod = geminiProvider != null
      ? await showCreationMethodDialog(context, itemType: 'Entity/NPC')
      : CreationMethod.manual;

  if (creationMethod == null) return;

  String name = '';
  String selectedKind = 'npc';
  String? aiSummary;

  if (creationMethod == CreationMethod.ai) {
    // AI-assisted creation
    final contextBuilder = StoryContextBuilder(
      campaignRepo: context.read<CampaignRepository>(),
      chapterRepo: context.read<ChapterRepository>(),
      adventureRepo: context.read<AdventureRepository>(),
      sceneRepo: context.read<SceneRepository>(),
      entityRepo: repository,
    );

    final storyContext = await contextBuilder.buildForCampaign(campaign.id);

    if (!context.mounted) return;

    final aiResult = await showAiCreationDialog(
      context,
      storyContext: storyContext,
      creationType: 'npc',
    );

    if (aiResult == null) return;

    name = aiResult.title ?? 'Unnamed NPC';
    aiSummary = aiResult.content;
    // AI always creates NPCs
    selectedKind = 'npc';
  } else {
    // Manual creation
    final nameController = TextEditingController();
    final kinds = const <String>[
      'npc',
      'monster',
      'group',
      'place',
      'item',
      'handout',
      'journal',
    ];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            title: Text(l10n.createEntity),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(labelText: l10n.name),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedKind,
                  decoration: InputDecoration(labelText: l10n.kind),
                  items: kinds
                      .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => selectedKind = v);
                  },
                ),
              ],
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
          ),
        );
      },
    );
    if (confirmed != true) return;
    name = nameController.text.trim();
    if (name.isEmpty) return;
  }

  try {
    // Embed campaign ID in entity ID for filtering
    final entityId = const Uuid().v7();
    final entity = db.Entity(
      id: entityId,
      kind: selectedKind,
      name: name,
      originType: 'campaign',
      // new default when created at campaign level
      originId: campaign.id,
      summary: aiSummary ?? '',
      tags: const <String>[],
      statblock: const <String, dynamic>{},
      placeType: null,
      parentPlaceId: null,
      coords: const <String, dynamic>{},
      content: null,
      images: const <Map<String, dynamic>>[],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rev: 0,
      deleted: false,
      members: const <String>[],
    );

    // Use Drift repository for optimistic local write
    await repository.upsertLocal(entity);

    if (!context.mounted) return;
    notification.success(context, title: Text(l10n.createEntity));
    EntityRouteData(entityId: entityId).go(context);
  } catch (e, st) {
    logger.e('Create entity failed', error: e, stackTrace: st);
    if (!context.mounted) return;
    notification.error(context, title: Text('Failed: $e'));
  }
}
