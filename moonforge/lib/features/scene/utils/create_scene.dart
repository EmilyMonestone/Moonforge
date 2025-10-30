import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moonforge/data/firebase/odm.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/firebase/models/adventure.dart';
import 'package:moonforge/data/firebase/models/campaign.dart';
import 'package:moonforge/data/firebase/models/chapter.dart';
import 'package:moonforge/data/firebase/models/scene.dart';
import 'package:moonforge/data/firebase/models/schema.dart';
import 'package:moonforge/l10n/app_localizations.dart';

Future<void> createScene(BuildContext context, Campaign campaign) async {
  final l10n = AppLocalizations.of(context)!;
  final firestore = Odm.instance;

  final chaptersSnapshot = await firestore
      .collection('campaigns/${campaign.id}/chapters')
      .orderBy('order')
      .get();
  final chapters = chaptersSnapshot.docs
      .map((doc) => Chapter.fromJson({'id': doc.id, ...doc.data()}))
      .toList();
  if (chapters.isEmpty) {
    if (context.mounted) {
      notification.info(context, title: Text(l10n.noChaptersYet));
    }
    return;
  }
  Chapter selectedChapter = chapters.first;
  var adventuresSnapshot = await firestore
      .collection('campaigns/${campaign.id}/chapters/${selectedChapter.id}/adventures')
      .orderBy('order')
      .get();
  List<Adventure> adventures = adventuresSnapshot.docs
      .map((doc) => Adventure.fromJson({'id': doc.id, ...doc.data()}))
      .toList();
  if (adventures.isEmpty) {
    if (context.mounted) {
      notification.info(context, title: Text(l10n.noAdventuresYet));
    }
    return;
  }
  Adventure selectedAdventure = adventures.first;

  final lastSnapshot = await firestore
      .collection('campaigns/${campaign.id}/chapters/${selectedChapter.id}/adventures/${selectedAdventure.id}/scenes')
      .orderBy('order', descending: true)
      .limit(1)
      .get();
  final last = lastSnapshot.docs
      .map((doc) => Scene.fromJson({'id': doc.id, ...doc.data()}))
      .toList();
  final nextOrder = last.isNotEmpty ? (last.first.order + 1) : 1;

  final titleController = TextEditingController();

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
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
                  final ch = chapters.firstWhere(
                    (c) => c.id == (id ?? selectedChapter.id),
                  );
                  setState(() => selectedChapter = ch);
                  final advsSnapshot = await firestore
                      .collection('campaigns/${campaign.id}/chapters/${ch.id}/adventures')
                      .orderBy('order')
                      .get();
                  final advs = advsSnapshot.docs
                      .map((doc) => Adventure.fromJson({'id': doc.id, ...doc.data()}))
                      .toList();
                  if (advs.isNotEmpty) {
                    setState(() {
                      adventures = advs;
                      selectedAdventure = adventures.first;
                    });
                  } else {
                    setState(() {
                      adventures = <Adventure>[];
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
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
    final sceneRef = firestore
        .collection('campaigns/${campaign.id}/chapters/${selectedChapter.id}/adventures/${selectedAdventure.id}/scenes')
        .doc();
    
    final scene = Scene(
      id: sceneRef.id,
      title: title,
      order: nextOrder,
      summary: null,
      content: null,
      mentions: const <Map<String, dynamic>>[],
      mediaRefs: const <Map<String, dynamic>>[],
      entityIds: const [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rev: 0,
    );
    
    await sceneRef.set(scene.toJson()..remove('id'));

    final createdSnapshot = await firestore
        .collection('campaigns/${campaign.id}/chapters/${selectedChapter.id}/adventures/${selectedAdventure.id}/scenes')
        .where('title', isEqualTo: title)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
    final created = createdSnapshot.docs.isNotEmpty
        ? Scene.fromJson({'id': createdSnapshot.docs.first.id, ...createdSnapshot.docs.first.data()})
        : null;

    if (!context.mounted) return;
    notification.success(context, title: Text(l10n.createScene));
    if (created != null) {
      SceneRoute(
        chapterId: selectedChapter.id,
        adventureId: selectedAdventure.id,
        sceneId: created.id,
      ).go(context);
    }
  } catch (e, st) {
    logger.e('Create scene failed', error: e, stackTrace: st);
    if (!context.mounted) return;
    notification.error(context, title: Text('Failed: $e'));
  }
}
