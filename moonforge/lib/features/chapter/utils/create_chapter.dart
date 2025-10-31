import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Future<void> createChapter(BuildContext context, Campaign campaign) async {
  final l10n = AppLocalizations.of(context)!;
  final repository = context.read<ChapterRepository>();
  
  // Get all chapters from Drift - without campaignId field, we get all
  // In local-first mode, hierarchical filtering will be added later
  final allChapters = context.read<List<Chapter>>();
  // For now, sort all chapters by order to determine next order
  // This is a temporary approach until campaignId is added to Chapter model
  final sortedChapters = allChapters.toList()
    ..sort((a, b) => b.order.compareTo(a.order));
  final nextOrder = sortedChapters.isNotEmpty ? (sortedChapters.first.order + 1) : 1;
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
        ],
      );
    },
  );
  if (confirmed != true) return;
  final name = controller.text.trim();
  if (name.isEmpty) return;
  try {
    // Embed campaign ID in the chapter ID for later filtering
    final chapterId = 'chapter-${campaign.id}-${DateTime.now().millisecondsSinceEpoch}';
    final chapter = Chapter(
      id: chapterId,
      name: name,
      order: nextOrder,
      summary: '',
      content: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rev: 0,
    );
    
    // Use Drift repository for optimistic local write
    await repository.upsertLocal(chapter);
    if (!context.mounted) return;
    notification.success(context, title: Text(l10n.createChapter));
    ChapterRoute(chapterId: chapterId).go(context);
  } catch (e, st) {
    logger.e('Create chapter failed', error: e, stackTrace: st);
    notification.error(context, title: Text('Failed: $e'));
  }
}
