import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/features/session/services/session_timer_service.dart';
import 'package:provider/provider.dart';

/// Widget for displaying and controlling a session timer
class SessionTimerWidget extends StatelessWidget {
  const SessionTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final timerService = context.watch<SessionTimerService>();

    return SurfaceContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session Timer',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                SessionTimerService.formatDuration(timerService.elapsed),
                style: theme.textTheme.displayMedium?.copyWith(
                  fontFeatures: [const FontFeature.tabularFigures()],
                  fontWeight: FontWeight.bold,
                  color: timerService.isRunning
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!timerService.isRunning)
                  ButtonM3E(
                    onPressed: () => timerService.start(),
                    style: ButtonM3EStyle.filled,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow, size: 20),
                        SizedBox(width: 8),
                        Text('Start'),
                      ],
                    ),
                  ),
                if (timerService.isRunning && !timerService.isPaused)
                  ButtonM3E(
                    onPressed: () => timerService.pause(),
                    style: ButtonM3EStyle.filled,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.pause, size: 20),
                        SizedBox(width: 8),
                        Text('Pause'),
                      ],
                    ),
                  ),
                if (timerService.isRunning && timerService.isPaused)
                  ButtonM3E(
                    onPressed: () => timerService.resume(),
                    style: ButtonM3EStyle.filled,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow, size: 20),
                        SizedBox(width: 8),
                        Text('Resume'),
                      ],
                    ),
                  ),
                if (timerService.isRunning) ...[
                  const SizedBox(width: 12),
                  ButtonM3E(
                    onPressed: () => timerService.stop(),
                    style: ButtonM3EStyle.outlined,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.stop, size: 20),
                        SizedBox(width: 8),
                        Text('Stop'),
                      ],
                    ),
                  ),
                ],
                if (timerService.elapsed > Duration.zero &&
                    !timerService.isRunning) ...[
                  const SizedBox(width: 12),
                  ButtonM3E(
                    onPressed: () => timerService.reset(),
                    style: ButtonM3EStyle.outlined,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, size: 20),
                        SizedBox(width: 8),
                        Text('Reset'),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            if (timerService.isPaused) ...[
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Paused',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
