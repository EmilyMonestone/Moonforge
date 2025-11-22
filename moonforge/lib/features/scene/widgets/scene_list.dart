import 'package:flutter/material.dart';
import 'package:moonforge/core/widgets/empty_state.dart';
import 'package:moonforge/core/widgets/error_display.dart';
import 'package:moonforge/core/widgets/loading_indicator.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/features/scene/widgets/scene_card.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// A widget that displays a list of scenes for an adventure
class SceneList extends StatefulWidget {
  const SceneList({
    super.key,
    required this.adventureId,
    this.onSceneTap,
    this.onSceneEdit,
    this.onSceneDelete,
    this.emptyMessage = 'No scenes yet',
    this.showOrder = true,
  });

  final String adventureId;
  final void Function(Scene scene)? onSceneTap;
  final void Function(Scene scene)? onSceneEdit;
  final void Function(Scene scene)? onSceneDelete;
  final String emptyMessage;
  final bool showOrder;

  @override
  State<SceneList> createState() => _SceneListState();
}

class _SceneListState extends State<SceneList> {
  @override
  Widget build(BuildContext context) {
    final sceneRepo = context.watch<SceneRepository>();
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder<List<Scene>>(
      stream: sceneRepo.watchByAdventure(widget.adventureId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator(message: l10n.loadingMessage);
        }

        if (snapshot.hasError) {
          return ErrorDisplay(
            title: l10n.errorSomethingWentWrong,
            message: snapshot.error?.toString(),
          );
        }

        final scenes = snapshot.data ?? [];

        if (scenes.isEmpty) {
          return EmptyState(
            icon: Icons.movie_outlined,
            title: widget.emptyMessage,
            message: l10n.emptyStateGenericMessage,
          );
        }

        return ListView.builder(
          itemCount: scenes.length,
          itemBuilder: (context, index) {
            final scene = scenes[index];
            return SceneCard(
              scene: scene,
              showOrder: widget.showOrder,
              onTap: widget.onSceneTap != null
                  ? () => widget.onSceneTap!(scene)
                  : null,
              onEdit: widget.onSceneEdit != null
                  ? () => widget.onSceneEdit!(scene)
                  : null,
              onDelete: widget.onSceneDelete != null
                  ? () => widget.onSceneDelete!(scene)
                  : null,
            );
          },
        );
      },
    );
  }
}
