import 'package:collection/collection.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
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

enum EntityCreationScope { campaign, chapter, adventure, scene, encounter }

Future<void> createEntity(
  BuildContext context,
  db.Campaign campaign, {
  required EntityCreationScope scope,
  String? chapterId,
  String? adventureId,
  String? sceneId,
  String? encounterId,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final entityRepo = context.read<EntityRepository>();
  final chapterRepo = context.read<ChapterRepository>();
  final adventureRepo = context.read<AdventureRepository>();
  final sceneRepo = context.read<SceneRepository>();

  // Ask user: Manual or AI?
  final geminiProvider = context.read<GeminiProvider?>();
  final creationMethod = geminiProvider != null
      ? await showCreationMethodDialog(context, itemType: 'Entity/NPC')
      : CreationMethod.manual;

  if (creationMethod == null) return;

  String name = '';
  String selectedKind = 'npc';
  Map<String, dynamic>? npcStructuredData;

  if (creationMethod == CreationMethod.ai) {
    // AI-assisted creation
    final contextBuilder = StoryContextBuilder(
      campaignRepo: context.read<CampaignRepository>(),
      chapterRepo: context.read<ChapterRepository>(),
      adventureRepo: context.read<AdventureRepository>(),
      sceneRepo: context.read<SceneRepository>(),
      entityRepo: entityRepo,
    );

    final storyContext = await switch (scope) {
      EntityCreationScope.campaign => contextBuilder.buildForCampaign(
        campaign.id,
      ),
      EntityCreationScope.chapter => switch (chapterId) {
        final id? => contextBuilder.buildForChapter(id),
        _ => contextBuilder.buildForCampaign(campaign.id),
      },
      EntityCreationScope.adventure => switch (adventureId) {
        final id? => contextBuilder.buildForAdventure(id),
        _ => contextBuilder.buildForCampaign(campaign.id),
      },
      EntityCreationScope.scene => switch (sceneId) {
        final id? => contextBuilder.buildForScene(id),
        _ => contextBuilder.buildForCampaign(campaign.id),
      },
      EntityCreationScope.encounter => contextBuilder.buildForCampaign(
        campaign.id,
      ),
    };

    if (!context.mounted) return;

    final aiResult = await showAiCreationDialog(
      context,
      storyContext: storyContext,
      creationType: 'npc',
    );

    if (aiResult == null || aiResult.structuredData == null) return;

    npcStructuredData = aiResult.structuredData!;
    name = npcStructuredData['name'] as String? ?? 'Unnamed NPC';
    // AI always creates NPCs
    selectedKind = 'npc';
  } else {
    // Manual creation
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
    final entityId = const Uuid().v7();
    final summary = npcStructuredData?['backstory'] as String? ?? '';
    final statblock = npcStructuredData ?? const <String, dynamic>{};

    final origin = await _resolveOrigin(
      scope: scope,
      campaign: campaign,
      chapterId: chapterId,
      adventureId: adventureId,
      sceneId: sceneId,
      encounterId: encounterId,
      chapterRepo: chapterRepo,
      adventureRepo: adventureRepo,
      sceneRepo: sceneRepo,
    );
    final entity = db.Entity(
      id: entityId,
      kind: selectedKind,
      name: name,
      originType: origin.type,
      originId: origin.id,
      summary: summary,
      tags: const <String>[],
      statblock: statblock,
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
    await _attachToParent(
      entityId: entityId,
      scope: scope,
      chapterId: chapterId,
      adventureId: adventureId,
      sceneId: sceneId,
      chapterRepo: chapterRepo,
      adventureRepo: adventureRepo,
      sceneRepo: sceneRepo,
    );

    if (!context.mounted) return;
    notification.success(context, title: Text(l10n.createEntity));
    EntityRouteData(entityId: entityId).go(context);
  } catch (e, st) {
    logger.e('Create entity failed', error: e, stackTrace: st);
    if (!context.mounted) return;
    notification.error(context, title: Text('Failed: $e'));
  }
}

class _EntityOrigin {
  const _EntityOrigin(this.type, this.id);

  final String type;
  final String id;
}

Future<_EntityOrigin> _resolveOrigin({
  required EntityCreationScope scope,
  required db.Campaign campaign,
  String? chapterId,
  String? adventureId,
  String? sceneId,
  String? encounterId,
  required ChapterRepository chapterRepo,
  required AdventureRepository adventureRepo,
  required SceneRepository sceneRepo,
}) async {
  switch (scope) {
    case EntityCreationScope.campaign:
      return _EntityOrigin('campaign', campaign.id);
    case EntityCreationScope.chapter:
      final chId = chapterId ?? campaign.entityIds.firstOrNull;
      return _EntityOrigin('chapter', chId ?? campaign.id);
    case EntityCreationScope.adventure:
      if (adventureId != null) {
        return _EntityOrigin('adventure', adventureId);
      }
      final chId = chapterId ?? campaign.entityIds.firstOrNull;
      if (chId == null) return _EntityOrigin('campaign', campaign.id);
      final adventures = await adventureRepo.getByChapter(chId);
      final adv = adventures.firstOrNull;
      return _EntityOrigin('adventure', adv?.id ?? chId);
    case EntityCreationScope.scene:
      if (sceneId != null) {
        return _EntityOrigin('scene', sceneId);
      }
      final advId = adventureId ?? chapterId;
      if (advId == null) return _EntityOrigin('campaign', campaign.id);
      final scenes = await sceneRepo.getByAdventure(advId);
      final scene = scenes.firstOrNull;
      return _EntityOrigin('scene', scene?.id ?? advId);
    case EntityCreationScope.encounter:
      if (encounterId != null) {
        return _EntityOrigin('encounter', encounterId);
      }
      return _EntityOrigin('campaign', campaign.id);
  }
}

Future<void> _attachToParent({
  required String entityId,
  required EntityCreationScope scope,
  String? chapterId,
  String? adventureId,
  String? sceneId,
  required ChapterRepository chapterRepo,
  required AdventureRepository adventureRepo,
  required SceneRepository sceneRepo,
}) async {
  switch (scope) {
    case EntityCreationScope.chapter:
      if (chapterId == null) return;
      final chapter = await chapterRepo.getById(chapterId);
      if (chapter == null) return;
      final ids = List<String>.from(chapter.entityIds);
      if (ids.contains(entityId)) return;
      ids.add(entityId);
      await chapterRepo.upsertLocal(
        chapter.copyWith(entityIds: ids, updatedAt: Value(DateTime.now())),
      );
      break;
    case EntityCreationScope.adventure:
      if (adventureId == null) return;
      final adventure = await adventureRepo.getById(adventureId);
      if (adventure == null) return;
      final ids = List<String>.from(adventure.entityIds);
      if (ids.contains(entityId)) return;
      ids.add(entityId);
      await adventureRepo.upsertLocal(
        adventure.copyWith(entityIds: ids, updatedAt: Value(DateTime.now())),
      );
      break;
    case EntityCreationScope.scene:
      if (sceneId == null) return;
      final scene = await sceneRepo.getById(sceneId);
      if (scene == null) return;
      final ids = List<String>.from(scene.entityIds);
      if (ids.contains(entityId)) return;
      ids.add(entityId);
      await sceneRepo.upsertLocal(
        scene.copyWith(entityIds: ids, updatedAt: Value(DateTime.now())),
      );
      break;
    case EntityCreationScope.campaign:
    case EntityCreationScope.encounter:
      break;
  }
}
