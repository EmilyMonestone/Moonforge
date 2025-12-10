import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/design/app_spacing.dart';

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
    return Padding(
      padding: AppSpacing.paddingLg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 140),
            child: ButtonM3E(
              style: ButtonM3EStyle.outlined,
              shape: ButtonM3EShape.square,
              icon: const Icon(Icons.arrow_back),
              label: Text('Previous', overflow: TextOverflow.ellipsis),
              onPressed: isPreviousDisabled ? null : onPrevious,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 140),
            child: ButtonM3E(
              style: ButtonM3EStyle.outlined,
              shape: ButtonM3EShape.square,
              icon: const Icon(Icons.arrow_forward),
              label: Text('Next', overflow: TextOverflow.ellipsis),
              onPressed: isNextDisabled ? null : onNext,
            ),
          ),
        ],
      ),
    );
  }
}
