import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Create a new scene in a specific chapter context
Future<void> createSceneInChapter(
  BuildContext context,
  Campaign campaign,
  String chapterId,
) async {
  final l10n = AppLocalizations.of(context)!;
  final repository = context.read<SceneRepository>();
  
  // Get all adventures from Drift and filter by chapter using startsWith
  final allAdventures = context.read<List<Adventure>>();
  final adventures = allAdventures
      .where((adv) => adv.id.startsWith('adventure-$chapterId-'))
      .toList()
    ..sort((a, b) => a.order.compareTo(b.order));
  if (adventures.isEmpty) {
    if (context.mounted) {
      notification.info(context, title: Text(l10n.noAdventuresYet));
    }
    return;
  }
  Adventure selectedAdventure = adventures.first;
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
          ],
        ),
      );
    },
  );
  if (confirmed != true) return;
  final title = titleController.text.trim();
  if (title.isEmpty) return;
  try {
    // Embed adventure ID in scene ID
    final sceneId = 'scene-${selectedAdventure.id}-${DateTime.now().millisecondsSinceEpoch}';
    final scene = Scene(
      id: sceneId,
      title: title,
      content: null,
      mentions: const <Map<String, dynamic>>[],
      mediaRefs: const <Map<String, dynamic>>[],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rev: 0,
    );
    
    // Use Drift repository for optimistic local write
    await repository.upsertLocal(scene);
    if (!context.mounted) return;
    notification.success(context, title: Text(l10n.createScene));
    SceneRoute(
      chapterId: chapterId,
      adventureId: selectedAdventure.id,
      sceneId: sceneId,
    ).go(context);
  } catch (e, st) {
    logger.e('Create scene failed', error: e, stackTrace: st);
    notification.error(context, title: Text('Failed: $e'));
}
