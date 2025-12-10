import 'package:flutter/material.dart';

/// A scrollable body container that ensures proper layout with minimum height.
///
/// This widget wraps content in a LayoutBuilder with SingleChildScrollView
/// and ConstrainedBox to ensure consistent scrolling behavior across scaffolds.
class ScrollableBody extends StatelessWidget {
  /// The child widget to display in the scrollable body.
  final Widget child;

  /// The background color of the container.
  final Color? color;

  const ScrollableBody({
    super.key,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Theme.of(context).colorScheme.surface,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
