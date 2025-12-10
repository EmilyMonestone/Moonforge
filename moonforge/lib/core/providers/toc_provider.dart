import 'package:flutter/material.dart';
import 'package:moonforge/core/controllers/toc_controller.dart';
import 'package:moonforge/core/models/toc_entry.dart';

/// Provider for managing Table of Contents entries for the current page.
///
/// This widget sits at the top of the page hierarchy and provides access to
/// the TOC controller for both registering entries and tracking scroll position.
class TocProvider extends InheritedNotifier<TocController> {
  const TocProvider({
    super.key,
    required TocController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Get the TOC controller from the widget tree
  static TocController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TocProvider>()
        ?.notifier;
  }

  /// Get the TOC controller from the widget tree (throws if not found)
  static TocController controllerOf(BuildContext context) {
    final controller = of(context);
    assert(controller != null, 'No TocProvider found in context');
    return controller!;
  }
}

/// Widget that wraps page content and provides TOC functionality.
///
/// This widget creates a TocController and provides it to descendants via
/// TocProvider. It also sets up scroll tracking to automatically highlight
/// the active TOC entry as the user scrolls.
class TocScope extends StatefulWidget {
  const TocScope({
    super.key,
    required this.scrollController,
    required this.entries,
    required this.child,
  });

  /// The scroll controller for the page content
  final ScrollController scrollController;

  /// The list of TOC entries for this page
  final List<TocEntry> entries;

  /// The page content
  final Widget child;

  @override
  State<TocScope> createState() => _TocScopeState();
}

class _TocScopeState extends State<TocScope> {
  late TocController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TocController(
      scrollController: widget.scrollController,
      entries: widget.entries,
    );
    
    // Set up scroll listener for auto-highlighting
    widget.scrollController.addListener(_onScroll);
    
    // Initial update after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.updateActiveFromScroll();
      }
    });
  }

  @override
  void didUpdateWidget(TocScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.entries != oldWidget.entries) {
      _controller.updateEntries(widget.entries);
    }
    
    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController.removeListener(_onScroll);
      widget.scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (mounted) {
      _controller.updateActiveFromScroll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TocProvider(
      controller: _controller,
      child: widget.child,
    );
  }
}
