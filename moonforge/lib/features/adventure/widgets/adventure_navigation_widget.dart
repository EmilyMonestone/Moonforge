import 'package:flutter/material.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/widgets/navigation_widget.dart';
import 'package:moonforge/features/adventure/services/adventure_navigation_service.dart';

class AdventureNavigationWidget extends StatelessWidget {
  const AdventureNavigationWidget({
    super.key,
    required this.chapterId,
    required this.adventureId,
    required this.navigationService,
  });

  final String chapterId;
  final String adventureId;
  final AdventureNavigationService navigationService;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AdventureNavState>(
      stream: navigationService.watchState(chapterId, adventureId),
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state == null) return const SizedBox.shrink();
        return NavigationWidget(
          currentLabel: state.currentName,
          positionLabel: 'Adventure ${state.position} / ${state.total}',
          isPreviousDisabled: !state.hasPrevious,
          isNextDisabled: !state.hasNext,
          previousLabel: 'Previous adventure',
          nextLabel: 'Next adventure',
          onPrevious: () async {
            final prev = await navigationService.getAdjacentAdventure(
              chapterId,
              adventureId,
              forward: false,
            );
            if (prev != null && context.mounted) {
              AdventureRouteData(
                chapterId: chapterId,
                adventureId: prev.id,
              ).go(context);
            }
          },
          onNext: () async {
            final next = await navigationService.getAdjacentAdventure(
              chapterId,
              adventureId,
              forward: true,
            );
            if (next != null && context.mounted) {
              AdventureRouteData(
                chapterId: chapterId,
                adventureId: next.id,
              ).go(context);
            }
          },
        );
      },
    );
  }
}
