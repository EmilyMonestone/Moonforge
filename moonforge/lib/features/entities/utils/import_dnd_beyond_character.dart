import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/services/dnd_beyond_character_service.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Import a D&D Beyond character by ID or URL
Future<void> importDndBeyondCharacter(
  BuildContext context,
  db.Campaign campaign,
) async {
  final l10n = AppLocalizations.of(context)!;
  final service = context.read<DndBeyondCharacterService>();

  final inputController = TextEditingController();

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Import D&D Beyond Character'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter a D&D Beyond character ID or URL:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              'Example: 152320860\nor: https://www.dndbeyond.com/characters/152320860',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: inputController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Character ID or URL',
                hintText: '152320860',
              ),
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
            child: const Text('Import'),
          ),
        ],
      );
    },
  );

  if (confirmed != true) return;
  final input = inputController.text.trim();
  if (input.isEmpty) return;

  // Show loading indicator
  if (!context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  final loadingSnackBar = SnackBar(
    content: const Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        SizedBox(width: 16),
        Text('Importing character from D&D Beyond...'),
      ],
    ),
    duration: const Duration(minutes: 1),
  );
  messenger.showSnackBar(loadingSnackBar);

  try {
    final entityId = await service.importCharacter(
      input: input,
      campaignId: campaign.id,
    );

    messenger.hideCurrentSnackBar();

    if (entityId == null) {
      if (!context.mounted) return;
      notification.error(
        context,
        title: const Text('Import Failed'),
        description: const Text(
          'Failed to import character. Please check the ID/URL and try again.',
        ),
      );
      return;
    }

    if (!context.mounted) return;
    notification.success(
      context,
      title: const Text('Character Imported'),
      description: const Text('D&D Beyond character imported successfully!'),
    );
    EntityRoute(entityId: entityId).go(context);
  } catch (e, st) {
    logger.e('Import D&D Beyond character failed', error: e, stackTrace: st);
    messenger.hideCurrentSnackBar();
    if (!context.mounted) return;
    notification.error(
      context,
      title: const Text('Import Failed'),
      description: Text('Error: $e'),
    );
  }
}
