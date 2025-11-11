import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/data/db/app_db.dart';

/// Widget for navigating between chapters (previous/next)
class ChapterNavigationWidget extends StatelessWidget {
  const ChapterNavigationWidget({
    super.key,
    required this.currentChapter,
    this.previousChapter,
    this.nextChapter,
  });

  final Chapter currentChapter;
  final Chapter? previousChapter;
  final Chapter? nextChapter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Previous chapter button
        Expanded(
          child: previousChapter != null
              ? ButtonM3E(
                  style: ButtonM3EStyle.outlined,
                  shape: ButtonM3EShape.square,
                  icon: const Icon(Icons.arrow_back),
                  label: Text(
                    previousChapter!.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: () {
                    ChapterRouteData(
                      chapterId: previousChapter!.id,
                    ).go(context);
                  },
                )
              : Container(),
        ),
        const SizedBox(width: 16),

        // Next chapter button
        Expanded(
          child: nextChapter != null
              ? ButtonM3E(
                  style: ButtonM3EStyle.outlined,
                  shape: ButtonM3EShape.square,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(
                    nextChapter!.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: () {
                    ChapterRouteData(chapterId: nextChapter!.id).go(context);
                  },
                )
              : Container(),
        ),
      ],
    );
  }
}
