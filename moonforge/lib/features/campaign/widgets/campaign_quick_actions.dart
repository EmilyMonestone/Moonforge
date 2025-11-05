import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/chapter/utils/create_chapter.dart';
import 'package:moonforge/l10n/app_localizations.dart';

/// Quick action buttons for common campaign operations
class CampaignQuickActions extends StatelessWidget {
  final Campaign campaign;

  const CampaignQuickActions({
    super.key,
    required this.campaign,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ButtonM3E(
          style: ButtonM3EStyle.filled,
          shape: ButtonM3EShape.square,
          icon: const Icon(Icons.library_books_outlined),
          label: Text(l10n.createChapter),
          onPressed: () => createChapter(context, campaign),
        ),
        ButtonM3E(
          style: ButtonM3EStyle.tonal,
          shape: ButtonM3EShape.square,
          icon: const Icon(Icons.category_outlined),
          label: Text(l10n.createEntity),
          onPressed: () {
            // Navigate to entity creation
            // This would typically call createEntity utility
          },
        ),
        ButtonM3E(
          style: ButtonM3EStyle.outlined,
          shape: ButtonM3EShape.square,
          icon: const Icon(Icons.event_outlined),
          label: const Text('New Session'),
          onPressed: () {
            // Navigate to session creation
          },
        ),
        ButtonM3E(
          style: ButtonM3EStyle.outlined,
          shape: ButtonM3EShape.square,
          icon: const Icon(Icons.edit_outlined),
          label: Text(l10n.edit),
          onPressed: () {
            const CampaignEditRoute().go(context);
          },
        ),
      ],
    );
  }
}
