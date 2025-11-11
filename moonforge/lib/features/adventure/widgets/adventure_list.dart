import 'package:flutter/material.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/adventure/widgets/adventure_card.dart';
import 'package:moonforge/l10n/app_localizations.dart';

/// A widget that displays a list of adventures
class AdventureList extends StatelessWidget {
  const AdventureList({
    super.key,
    required this.adventures,
    this.enableContextMenu = false,
  });

  final List<Adventure> adventures;
  final bool enableContextMenu;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (adventures.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            l10n.noAdventuresYet,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: adventures.length,
      separatorBuilder: (context, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final adventure = adventures[index];
        return AdventureCard(
          adventure: adventure,
          onTap: () {
            AdventureRouteData(
              chapterId: adventure.chapterId,
              adventureId: adventure.id,
            ).go(context);
          },
          enableContextMenu: enableContextMenu,
        );
      },
    );
  }
}
