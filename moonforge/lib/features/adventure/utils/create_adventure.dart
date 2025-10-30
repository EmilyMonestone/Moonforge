import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/firebase/models/adventure.dart';
import 'package:moonforge/data/firebase/models/campaign.dart';
import 'package:moonforge/data/firebase/models/chapter.dart';
import 'package:moonforge/data/firebase/models/schema.dart';
import 'package:moonforge/data/firebase/odm.dart';
import 'package:moonforge/l10n/app_localizations.dart';

Future<void> createAdventure(BuildContext context, Campaign campaign) async {
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
  Chapter selected = chapters.first;

  final lastSnapshot = await firestore
      .collection('campaigns/${campaign.id}/chapters/${selected.id}/adventures')
      .orderBy('order', descending: true)
      .limit(1)
      .get();
  final last = lastSnapshot.docs
      .map((doc) => Adventure.fromJson({'id': doc.id, ...doc.data()}))
      .toList();
  final nextOrder = last.isNotEmpty ? (last.first.order + 1) : 1;

  final nameController = TextEditingController();

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
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
                onChanged: (id) {
                  final found = chapters.firstWhere(
                    (c) => c.id == (id ?? selected.id),
                  );
                  setState(() => selected = found);
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
    final advRef = firestore
        .collection('campaigns/${campaign.id}/chapters/${selected.id}/adventures')
        .doc();
    
    final adv = Adventure(
      id: advRef.id,
      name: name,
      order: nextOrder,
      summary: '',
      content: null,
      entityIds: const [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rev: 0,
    );
    
    await advRef.set(adv.toJson()..remove('id'));

    final createdSnapshot = await firestore
        .collection('campaigns/${campaign.id}/chapters/${selected.id}/adventures')
        .where('name', isEqualTo: name)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
    final created = createdSnapshot.docs.isNotEmpty
        ? Adventure.fromJson({'id': createdSnapshot.docs.first.id, ...createdSnapshot.docs.first.data()})
        : null;

    if (!context.mounted) return;
    notification.success(context, title: Text(l10n.createAdventure));
    if (created != null) {
      AdventureRoute(
        chapterId: selected.id,
        adventureId: created.id,
      ).go(context);
    }
  } catch (e, st) {
    logger.e('Create adventure failed', error: e, stackTrace: st);
    if (!context.mounted) return;
    notification.error(context, title: Text('Failed: $e'));
  }
}
