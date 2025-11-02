import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

Future<void> createScene(BuildContext context, Campaign campaign) async {
  final l10n = AppLocalizations.of(context)!;
  final chapterRepo = context.read<ChapterRepository>();
  final adventureRepo = context.read<AdventureRepository>();
  final sceneRepo = context.read<SceneRepository>();

  // Load chapters for campaign
  final chapters = await chapterRepo.getByCampaign(campaign.id);
  if (chapters.isEmpty) {
    if (context.mounted) {
      notification.info(context, title: Text(l10n.noChaptersYet));
    }
    return;
  }
  var selectedChapter = chapters.first;

  // Load adventures for selected chapter
  Future<List<Adventure>> loadAdventures(String chapterId) async =>
      await adventureRepo.getByChapter(chapterId);

  var adventures = await loadAdventures(selectedChapter.id);
  if (adventures.isEmpty) {
    if (context.mounted) {
      notification.info(context, title: Text(l10n.noAdventuresYet));
    }
    return;
  }
  var selectedAdventure = adventures.first;

  // Compute next order in adventure
  Future<int> computeNextOrder(String adventureId) async {
    final list = await sceneRepo.getByAdventure(adventureId);
    if (list.isEmpty) return 1;
    list.sort((a, b) => b.order.compareTo(a.order));
    return list.first.order + 1;
  }

  var nextOrder = await computeNextOrder(selectedAdventure.id);

  final titleController = TextEditingController();

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) =>
            AlertDialog(
              title: Text('${l10n.createScene}: Nr. $nextOrder'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedChapter.id,
                    decoration: InputDecoration(labelText: l10n.selectChapter),
                    items: [
                      for (final c in chapters)
                        DropdownMenuItem(value: c.id, child: Text(c.name)),
                    ],
                    onChanged: (id) async {
                      if (id == null) return;
                      final ch = chapters.firstWhere((c) => c.id == id);
                      setState(() => selectedChapter = ch);
                      adventures = await loadAdventures(ch.id);
                      if (adventures.isNotEmpty) {
                        setState(() => selectedAdventure = adventures.first);
                        nextOrder =
                        await computeNextOrder(selectedAdventure.id);
                      } else {
                        setState(() => adventures = <Adventure>[]);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedAdventure.id,
                    decoration: InputDecoration(
                        labelText: l10n.selectAdventure),
                    items: [
                      for (final a in adventures)
                        DropdownMenuItem(value: a.id, child: Text(a.name)),
                    ],
                    onChanged: (id) async {
                      if (id == null) return;
                      final adv = adventures.firstWhere((a) => a.id == id);
                      setState(() => selectedAdventure = adv);
                      nextOrder = await computeNextOrder(selectedAdventure.id);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleController,
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
  final title = titleController.text.trim();
  if (title.isEmpty || adventures.isEmpty) return;

  try {
    final newId = const Uuid().v4();
    final scene = Scene(
      id: newId,
      adventureId: selectedAdventure.id,
      name: title,
      order: nextOrder,
      summary: null,
      content: null,
      entityIds: const <String>[],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rev: 0,
    );

    await sceneRepo.create(scene);

    if (!context.mounted) return;
    notification.success(context, title: Text(l10n.createScene));
    SceneRoute(
      chapterId: selectedChapter.id,
      adventureId: selectedAdventure.id,
      sceneId: scene.id,
    ).go(context);
  } catch (e, st) {
    logger.e('Create scene failed', error: e, stackTrace: st);
    if (!context.mounted) return;
    notification.error(context, title: Text('Failed: $e'));
  }
}
