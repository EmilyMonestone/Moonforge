import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/widgets/navigation_history_service.dart';

/// Global back/forward controls using NavigationHistoryService.
class NavigationHistoryControls extends StatelessWidget {
  const NavigationHistoryControls({super.key});

  @override
  Widget build(BuildContext context) {
    final history = NavigationHistoryScope.of(context);

    return AnimatedBuilder(
      animation: history,
      builder: (context, _) {
        final canBack = history.canGoBack;
        final canForward = history.canGoForward;
        return Wrap(
          spacing: 4,
          children: [
            IconButton(
              tooltip: 'Back',
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              onPressed: canBack
                  ? () {
                      final target = history.back();
                      if (target != null) {
                        AppRouter.router.go(target);
                      }
                    }
                  : null,
            ),
            IconButton(
              tooltip: 'Forward',
              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
              onPressed: canForward
                  ? () {
                      final target = history.forward();
                      if (target != null) {
                        AppRouter.router.go(target);
                      }
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }
}
