import 'package:flutter/material.dart';
import 'package:moonforge/core/di/service_locator.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/widgets/navigation_widget.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/chapter/services/chapter_navigation_service.dart';

/// Widget for navigating between chapters (previous/next)
class ChapterNavigationWidget extends StatelessWidget {
  const ChapterNavigationWidget({
    super.key,
    required this.currentChapter,
    this.currentPosition,
    this.totalChapters,
  });

  final Chapter currentChapter;
  final int? currentPosition;
  final int? totalChapters;

  @override
  Widget build(BuildContext context) {
    final navigationService = getIt<ChapterNavigationService>();
    return StreamBuilder<ChapterNavState>(
      stream: navigationService.watchState(currentChapter.id),
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state == null) {
          return const SizedBox.shrink();
        }
        return NavigationWidget(
          currentLabel: state.currentName,
          positionLabel: 'Chapter ${state.position} / ${state.total}',
          isPreviousDisabled: !state.hasPrevious,
          isNextDisabled: !state.hasNext,
          previousLabel: 'Previous chapter',
          nextLabel: 'Next chapter',
          onPrevious: () async {
            final prev = await navigationService.getPreviousChapter(
              currentChapter.id,
            );
            if (prev != null && context.mounted) {
              ChapterRouteData(chapterId: prev.id).go(context);
            }
          },
          onNext: () async {
            final next = await navigationService.getNextChapter(
              currentChapter.id,
            );
            if (next != null && context.mounted) {
              ChapterRouteData(chapterId: next.id).go(context);
            }
          },
        );
      },
    );
  }
}
