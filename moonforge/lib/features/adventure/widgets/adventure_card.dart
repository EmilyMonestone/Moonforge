import 'package:flutter/material.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/utils/datetime_utils.dart';
import 'package:moonforge/core/widgets/link_context_menu.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:provider/provider.dart';

/// A card widget that displays an adventure summary
class AdventureCard extends StatelessWidget {
  const AdventureCard({
    super.key,
    required this.adventure,
    this.onTap,
    this.enableContextMenu = false,
  });

  final Adventure adventure;
  final VoidCallback? onTap;
  final bool enableContextMenu;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final sceneRepo = context.read<SceneRepository>();

    final card = Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: ListTile(
        title: Text(adventure.name, style: textTheme.titleMedium),
        subtitle: FutureBuilder<List<Scene>>(
          future: sceneRepo.getByAdventure(adventure.id),
          builder: (context, snapshot) {
            final sceneCount = snapshot.data?.length ?? 0;
            final updatedText = formatDateTime(adventure.updatedAt);
            return Text(
              '$sceneCount scenes • $updatedText',
              style: textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );

    // Wrap with context menu if enabled
    if (enableContextMenu) {
      return LinkContextMenu(
        route: AdventureRouteData(
          chapterId: adventure.chapterId,
          adventureId: adventure.id,
        ).location,
        child: card,
      );
    }

    return card;
  }
}
