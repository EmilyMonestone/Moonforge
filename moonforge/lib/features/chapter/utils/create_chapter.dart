import 'package:flutter/material.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

Future<void> createChapter(BuildContext context, db.Campaign campaign) async {
  final l10n = AppLocalizations.of(context)!;
  final repository = context.read<ChapterRepository>();

  // Use repository to fetch chapters for this campaign and compute next order
  final chapters = await repository.getByCampaign(campaign.id);
  final sorted = chapters.toList()..sort((a, b) => b.order.compareTo(a.order));
  final nextOrder = sorted.isNotEmpty ? (sorted.first.order + 1) : 1;

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
  final name = controller.text.trim();
  if (name.isEmpty) return;

  try {
    final chapterId = const Uuid().v7();
    final chapter = db.Chapter(
      id: chapterId,
      campaignId: campaign.id,
      name: name,
      order: nextOrder,
      summary: '',
      content: null,
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
