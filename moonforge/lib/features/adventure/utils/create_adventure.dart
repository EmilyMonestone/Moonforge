import 'package:flutter/material.dart';
import 'package:moonforge/core/providers/gemini_provider.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/services/story_context_builder.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/utils/markdown_to_quill.dart';
import 'package:moonforge/core/widgets/ai/ai_creation_dialog.dart';
import 'package:moonforge/core/widgets/ai/creation_method_dialog.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

Future<void> createAdventure(BuildContext context, Campaign campaign) async {
  final l10n = AppLocalizations.of(context)!;
  final chapterRepo = context.read<ChapterRepository>();
  final adventureRepo = context.read<AdventureRepository>();

  // Ask user: Manual or AI?
  final geminiProvider = context.read<GeminiProvider?>();
  final creationMethod = geminiProvider != null
      ? await showCreationMethodDialog(context, itemType: 'Adventure')
      : CreationMethod.manual;

  if (creationMethod == null) return;

  // Load chapters for campaign
  final chapters = await chapterRepo.getByCampaign(campaign.id);
  if (chapters.isEmpty) {
    if (context.mounted) {
      notification.info(context, title: Text(l10n.noChaptersYet));
    }
    return;
  }
  var selected = chapters.first;

  // Compute next order in chapter
  Future<int> computeNextOrder(String chapterId) async {
    final list = await adventureRepo.getByChapter(chapterId);
    if (list.isEmpty) return 1;
    list.sort((a, b) => b.order.compareTo(a.order));
    return list.first.order + 1;
  }

  var nextOrder = await computeNextOrder(selected.id);

  String name = '';
  String? aiContent;

  if (creationMethod == CreationMethod.ai) {
    // AI-assisted creation
    final contextBuilder = StoryContextBuilder(
      campaignRepo: context.read<CampaignRepository>(),
      chapterRepo: chapterRepo,
      adventureRepo: adventureRepo,
      sceneRepo: context.read<SceneRepository>(),
      entityRepo: context.read<EntityRepository>(),
    );

    final storyContext = await contextBuilder.buildForChapter(selected.id);

    if (!context.mounted) return;

    final aiResult = await showAiCreationDialog(
      context,
      storyContext: storyContext,
      creationType: 'adventure',
    );

    if (aiResult == null) return;

    name = aiResult.title ?? 'Untitled Adventure';
    aiContent = aiResult.content;
  } else {
    // Manual creation
    final nameController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            title: Text('${l10n.createAdventure}: Nr. $nextOrder'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selected.id,
                  decoration: InputDecoration(labelText: l10n.selectChapter),
                  items: [
                    for (final c in chapters)
                      DropdownMenuItem(value: c.id, child: Text(c.name)),
                  ],
                  onChanged: (id) async {
                    if (id == null) return;
                    final found = chapters.firstWhere((c) => c.id == id);
                    setState(() => selected = found);
                    nextOrder = await computeNextOrder(selected.id);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
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
    name = nameController.text.trim();
    if (name.isEmpty) return;
  }

  try {
    final newId = const Uuid().v7();

    // Convert AI content to Quill document if provided
    Map<String, dynamic>? contentDelta;
    if (aiContent != null && aiContent.isNotEmpty) {
      // Convert markdown to Quill delta format
      contentDelta = markdownToQuillDelta(aiContent);
    }

    final adv = Adventure(
      id: newId,
      chapterId: selected.id,
      name: name,
      order: nextOrder,
      summary: '',
      content: contentDelta,
      entityIds: const <String>[],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rev: 0,
    );

    await adventureRepo.create(adv);

    if (!context.mounted) return;
    notification.success(context, title: Text(l10n.createAdventure));
    AdventureRouteData(chapterId: selected.id, adventureId: adv.id).go(context);
  } catch (e, st) {
    logger.e('Create adventure failed', error: e, stackTrace: st);
    if (!context.mounted) return;
    notification.error(context, title: Text('Failed: $e'));
  }
}
