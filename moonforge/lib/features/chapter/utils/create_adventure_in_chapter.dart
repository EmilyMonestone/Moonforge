import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Create a new adventure in a specific chapter context
Future<void> createAdventureInChapter(
  BuildContext context,
  Campaign campaign,
  String chapterId,
) async {
  final l10n = AppLocalizations.of(context)!;
  final repository = context.read<AdventureRepository>();
  
  // Get all adventures from Drift and filter by chapter using startsWith
  final allAdventures = context.read<List<Adventure>>();
  final chapterAdventures = allAdventures
      .where((adv) => adv.id.startsWith('adventure-$chapterId-'))
      .toList()
    ..sort((a, b) => b.order.compareTo(a.order));
  final nextOrder = chapterAdventures.isNotEmpty ? (chapterAdventures.first.order + 1) : 1;
  final nameController = TextEditingController();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text('${l10n.createAdventure}: Nr. $nextOrder'),
        content: TextField(
          controller: nameController,
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
  final name = nameController.text.trim();
  if (name.isEmpty) return;
  try {
    // Embed chapter ID in adventure ID
    final adventureId = 'adventure-$chapterId-${DateTime.now().millisecondsSinceEpoch}';
    final adv = Adventure(
      id: adventureId,
      name: name,
      order: nextOrder,
      summary: '',
      content: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rev: 0,
    );
    
    // Use Drift repository for optimistic local write
    await repository.upsertLocal(adv);
    if (!context.mounted) return;
    notification.success(context, title: Text(l10n.createAdventure));
    AdventureRoute(chapterId: chapterId, adventureId: adventureId).go(context);
  } catch (e, st) {
    logger.e('Create adventure failed', error: e, stackTrace: st);
    notification.error(context, title: Text('Failed: $e'));
  }
}
