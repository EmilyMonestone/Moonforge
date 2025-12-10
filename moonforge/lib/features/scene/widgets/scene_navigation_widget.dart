import 'package:flutter/material.dart';
import 'package:moonforge/core/widgets/navigation_widget.dart';
import 'package:moonforge/features/scene/services/scene_navigation_service.dart';

/// A widget for navigating between scenes (previous/next)
class SceneNavigationWidget extends StatelessWidget {
  const SceneNavigationWidget({super.key, required this.navigationService});

  final SceneNavigationService navigationService;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SceneNavState>(
      stream: navigationService.stateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state == null) return const SizedBox.shrink();
        return NavigationWidget(
          currentLabel: state.currentName,
          positionLabel: 'Scene ${state.position} / ${state.total}',
          progressValue: state.total > 0 ? state.position / state.total : null,
          isPreviousDisabled: !state.hasPrevious,
          isNextDisabled: !state.hasNext,
          previousLabel: 'Previous scene',
          nextLabel: 'Next scene',
          onPrevious: () => navigationService.goToPrevious(context),
          onNext: () => navigationService.goToNext(context),
        );
      },
    );
  }
}
