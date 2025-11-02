import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

Future<void> createAdventure(BuildContext context, Campaign campaign) async {
  final l10n = AppLocalizations.of(context)!;
  final chapterRepo = context.read<ChapterRepository>();
  final adventureRepo = context.read<AdventureRepository>();

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

  final nameController = TextEditingController();

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) =>
            AlertDialog(
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
  final name = nameController.text.trim();
  if (name.isEmpty) return;

  try {
    final newId = const Uuid().v4();
    final adv = Adventure(
      id: newId,
      chapterId: selected.id,
      name: name,
      order: nextOrder,
      summary: '',
      content: null,
      entityIds: const <String>[],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rev: 0,
    );

    await adventureRepo.create(adv);

    if (!context.mounted) return;
    notification.success(context, title: Text(l10n.createAdventure));
    AdventureRoute(
      chapterId: selected.id,
      adventureId: adv.id,
    ).go(context);
  } catch (e, st) {
    logger.e('Create adventure failed', error: e, stackTrace: st);
    if (!context.mounted) return;
    notification.error(context, title: Text('Failed: $e'));
  }
}
