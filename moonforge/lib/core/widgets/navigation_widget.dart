import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show ButtonM3E, ButtonM3EStyle, ButtonM3EShape;

class NavigationWidget extends StatelessWidget {
  const NavigationWidget({
    super.key,
    required this.currentLabel,
    this.positionLabel,
    required this.onPrevious,
    required this.onNext,
    this.isPreviousDisabled = false,
    this.isNextDisabled = false,
    this.previousLabel,
    this.nextLabel,
    this.progressValue,
  });

  final String currentLabel;
  final String? positionLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool isPreviousDisabled;
  final bool isNextDisabled;
  final String? previousLabel;
  final String? nextLabel;
  final double? progressValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: ButtonM3E(
                style: ButtonM3EStyle.outlined,
                shape: ButtonM3EShape.square,
                icon: const Icon(Icons.arrow_back),
                label: Text(
                  previousLabel ?? 'Previous',
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: isPreviousDisabled ? null : onPrevious,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentLabel,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (positionLabel != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      positionLabel!,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (progressValue != null) ...[
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: progressValue!.clamp(0, 1)),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ButtonM3E(
                style: ButtonM3EStyle.outlined,
                shape: ButtonM3EShape.square,
                icon: const Icon(Icons.arrow_forward),
                label: Text(
                  nextLabel ?? 'Next',
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: isNextDisabled ? null : onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
