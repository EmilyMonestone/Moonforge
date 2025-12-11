import 'package:flutter/material.dart';
import 'package:moonforge/core/di/service_locator.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/data/repo/party_repository.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

/// Creates a new Party and navigates to the party edit view.
///
/// This function follows the pattern established by other create utilities
/// in the codebase (e.g., create_campaign, create_chapter).
Future<void> createParty(BuildContext context, db.Campaign campaign) async {
  final l10n = AppLocalizations.of(context)!;
  final repository = getIt<PartyRepository>();

  // Manual creation - prompt for name
  final controller = TextEditingController();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(l10n.createParty),
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
    final partyId = const Uuid().v4();

    final party = db.Party(
      id: partyId,
      campaignId: campaign.id,
      name: name,
      summary: null,
      memberEntityIds: const <String>[],
      memberPlayerIds: const <String>[],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rev: 0,
    );

    await repository.create(party);

    if (!context.mounted) return;
    notification.success(context, title: Text(l10n.createParty));
    PartyEditRouteData(partyId: partyId).go(context);
  } catch (e, st) {
    logger.e('Create party failed', error: e, stackTrace: st);
    if (!context.mounted) return;
    notification.error(context, title: Text('Failed: $e'));
  }
}
