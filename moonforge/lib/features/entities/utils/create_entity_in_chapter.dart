import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Create a new entity and attach it to the given chapter (entityIds)
Future<void> createEntityInChapter(
  BuildContext context,
  Campaign campaign,
  String chapterId,
) async {
  final l10n = AppLocalizations.of(context)!;
  final entityRepo = context.read<EntityRepository>();
  final chapterRepo = context.read<ChapterRepository>();
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
  String selectedKind = kinds.first;
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
  final name = nameController.text.trim();
  if (name.isEmpty) return;
  try {
    // Create entity under this campaign
    final entityId =
        'entity-${campaign.id}-${DateTime.now().millisecondsSinceEpoch}';
    final entity = Entity(
      id: entityId,
      kind: selectedKind,
      name: name,
      summary: '',
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
    await entityRepo.upsertLocal(entity);
    // Attach entity to chapter.entityIds
    Chapter? chapter = await chapterRepo.getById(chapterId);
    if (chapter != null) {
      final currentIds = List<String>.from(chapter.entityIds);
      if (!currentIds.contains(entityId)) {
        currentIds.add(entityId);
        final updated = chapter.copyWith(
          entityIds: currentIds,
          updatedAt: DateTime.now(),
        );
        await chapterRepo.upsertLocal(updated);
      }
    } else {
      logger.w(
        'Chapter $chapterId not found locally; entity will not be linked in entityIds yet',
    }
    if (!context.mounted) return;
    notification.success(context, title: Text(l10n.createEntity));
    EntityRoute(entityId: entityId).go(context);
  } catch (e, st) {
    logger.e('Create entity in chapter failed', error: e, stackTrace: st);
    notification.error(context, title: Text('Failed: $e'));
  }
}
