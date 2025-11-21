import 'package:flutter/material.dart';
import 'package:moonforge/core/providers/gemini_provider.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/services/story_context_builder.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/utils/markdown_to_quill.dart';
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

Future<void> createChapter(BuildContext context, db.Campaign campaign) async {
  final l10n = AppLocalizations.of(context)!;
  final repository = context.read<ChapterRepository>();

  // Ask user: Manual or AI?
  final geminiProvider = context.read<GeminiProvider?>();
  final creationMethod = geminiProvider != null
      ? await showCreationMethodDialog(context, itemType: 'Chapter')
      : CreationMethod.manual;

  if (creationMethod == null) return;

  // Use repository to fetch chapters for this campaign and compute next order
  final chapters = await repository.getByCampaign(campaign.id);
  final sorted = chapters.toList()..sort((a, b) => b.order.compareTo(a.order));
  final nextOrder = sorted.isNotEmpty ? (sorted.first.order + 1) : 1;

  String name = '';
  String? aiContent;

  if (creationMethod == CreationMethod.ai) {
    // AI-assisted creation
    final contextBuilder = StoryContextBuilder(
      campaignRepo: context.read<CampaignRepository>(),
      chapterRepo: repository,
      adventureRepo: context.read<AdventureRepository>(),
      sceneRepo: context.read<SceneRepository>(),
      entityRepo: context.read<EntityRepository>(),
    );

    final storyContext = await contextBuilder.buildForCampaign(campaign.id);

    if (!context.mounted) return;

    final aiResult = await showAiCreationDialog(
      context,
      storyContext: storyContext,
      creationType: 'chapter',
    );

    if (aiResult == null) return;

    name = aiResult.title ?? 'Untitled Chapter';
    aiContent = aiResult.content;
  } else {
    // Manual creation
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('${l10n.createChapter}: Nr. $nextOrder'),
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
    final chapterId = const Uuid().v7();

    // Convert AI content to Quill document if provided
    Map<String, dynamic>? contentDelta;
    if (aiContent != null && aiContent.isNotEmpty) {
      // Convert markdown to Quill delta format
      contentDelta = markdownToQuillDelta(aiContent);
    }

    final chapter = db.Chapter(
      id: chapterId,
      campaignId: campaign.id,
      name: name,
      order: nextOrder,
      summary: '',
      content: contentDelta,
      entityIds: const <String>[],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rev: 0,
    );

    await repository.upsertLocal(chapter);

    if (!context.mounted) return;
    notification.success(context, title: Text(l10n.createChapter));
    ChapterRouteData(chapterId: chapterId).go(context);
  } catch (e, st) {
    logger.e('Create chapter failed', error: e, stackTrace: st);
    if (!context.mounted) return;
    notification.error(context, title: Text('Failed: $e'));
  }
}
