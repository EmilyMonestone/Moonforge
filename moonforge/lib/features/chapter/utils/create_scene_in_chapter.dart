import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
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

/// Create a new scene in a specific chapter context
Future<void> createSceneInChapter(
  BuildContext context,
  db.Campaign campaign,
  String chapterId,
) async {
  final l10n = AppLocalizations.of(context)!;
  final repository = context.read<SceneRepository>();

  // Ask user: Manual or AI?
  final geminiProvider = context.read<GeminiProvider?>();
  final creationMethod = geminiProvider != null
      ? await showCreationMethodDialog(context, itemType: 'Scene')
      : CreationMethod.manual;

  if (creationMethod == null) return;

  // Get all adventures from Drift and filter by chapter using startsWith
  final allAdventures = context.read<List<db.Adventure>>();
  final adventures =
      allAdventures.where((adv) => adv.chapterId == chapterId).toList()
        ..sort((a, b) => a.order.compareTo(b.order));

  if (adventures.isEmpty) {
    if (context.mounted) {
      notification.info(context, title: Text(l10n.noAdventuresYet));
    }
    return;
  }

  db.Adventure selectedAdventure = adventures.first;

  String title = '';
  String? aiContent;

  if (creationMethod == CreationMethod.ai) {
    // AI-assisted creation
    final contextBuilder = StoryContextBuilder(
      campaignRepo: context.read<CampaignRepository>(),
      chapterRepo: context.read<ChapterRepository>(),
      adventureRepo: context.read<AdventureRepository>(),
      sceneRepo: repository,
      entityRepo: context.read<EntityRepository>(),
    );

    final storyContext = await contextBuilder.buildForAdventure(selectedAdventure.id);

    if (!context.mounted) return;

    final aiResult = await showAiCreationDialog(
      context,
      storyContext: storyContext,
      creationType: 'scene',
    );

    if (aiResult == null) return;

    title = aiResult.title ?? 'Untitled Scene';
    aiContent = aiResult.content;
  } else {
    // Manual creation
    final titleController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            title: Text(l10n.createScene),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedAdventure.id,
                  decoration: InputDecoration(labelText: l10n.selectAdventure),
                  items: [
                    for (final a in adventures)
                      DropdownMenuItem(value: a.id, child: Text(a.name)),
                  ],
                  onChanged: (id) {
                    final adv = adventures.firstWhere(
                      (a) => a.id == (id ?? selectedAdventure.id),
                    );
                    setState(() => selectedAdventure = adv);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: InputDecoration(labelText: l10n.name),
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
    title = titleController.text.trim();
    if (title.isEmpty) return;
  }

  try {
    // Compute next order for scenes of this adventure by id prefix
    final allScenes = context.read<List<db.Scene>>();
    final scenesOfAdventure =
        allScenes.where((s) => s.adventureId == selectedAdventure.id).toList()
          ..sort((a, b) => b.order.compareTo(a.order));
    final nextOrder = scenesOfAdventure.isNotEmpty
        ? (scenesOfAdventure.first.order + 1)
        : 1;

    final sceneId = const Uuid().v7();

    // Convert AI content to Quill document if provided
    Map<String, dynamic>? contentDelta;
    if (aiContent != null && aiContent.isNotEmpty) {
      final document = Document()..insert(0, aiContent);
      contentDelta = {'ops': document.toDelta().toJson()};
    }

    final scene = db.Scene(
      id: sceneId,
      adventureId: selectedAdventure.id,
      name: title,
      order: nextOrder,
      summary: '',
      content: contentDelta,
      entityIds: const <String>[],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rev: 0,
    );

    await repository.upsertLocal(scene);

    if (!context.mounted) return;
    notification.success(context, title: Text(l10n.createScene));
    SceneRouteData(
      chapterId: chapterId,
      adventureId: selectedAdventure.id,
      sceneId: sceneId,
    ).go(context);
  } catch (e, st) {
    logger.e('Create scene failed', error: e, stackTrace: st);
    if (!context.mounted) return;
    notification.error(context, title: Text('Failed: $e'));
  }
}
