import 'package:flutter/material.dart';
import 'package:moonforge/core/providers/toc_provider.dart';

/// A scrollable body container that ensures proper layout with minimum height.
///
/// This widget wraps content in a LayoutBuilder with SingleChildScrollView
/// and ConstrainedBox to ensure consistent scrolling behavior across scaffolds.
/// 
/// If the child is wrapped in TocScope, this widget will use the TocScope's
/// scroll controller for proper TOC tracking.
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
          // Check if there's a TocScope in the widget tree that needs a scroll controller
          return _TocAwareScrollView(
            minHeight: constraints.maxHeight,
            child: child,
          );
        },
      ),
    );
  }
}

/// Internal widget that handles scroll controller injection for TocScope
class _TocAwareScrollView extends StatefulWidget {
  final double minHeight;
  final Widget child;

  const _TocAwareScrollView({
    required this.minHeight,
    required this.child,
  });

  @override
  State<_TocAwareScrollView> createState() => _TocAwareScrollViewState();
}

class _TocAwareScrollViewState extends State<_TocAwareScrollView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: widget.minHeight,
        ),
        child: _InjectScrollController(
          scrollController: _scrollController,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Widget that injects the scroll controller into TocScope if present
class _InjectScrollController extends StatelessWidget {
  final ScrollController scrollController;
  final Widget child;

  const _InjectScrollController({
    required this.scrollController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // The child will be the page content, potentially wrapped in TocScope
    // We need to provide the scroll controller to TocScope
    return _ScrollControllerProvider(
      scrollController: scrollController,
      child: child,
    );
  }
}

/// InheritedWidget to provide scroll controller to TocScope
class _ScrollControllerProvider extends InheritedWidget {
  final ScrollController scrollController;

  const _ScrollControllerProvider({
    required this.scrollController,
    required super.child,
  });

  static ScrollController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ScrollControllerProvider>()
        ?.scrollController;
  }

  @override
  bool updateShouldNotify(_ScrollControllerProvider oldWidget) {
    return scrollController != oldWidget.scrollController;
  }
}
