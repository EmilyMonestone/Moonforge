import 'package:flutter/material.dart';
import 'package:moonforge/core/controllers/toc_controller.dart';
import 'package:moonforge/core/models/toc_entry.dart';
import 'package:moonforge/core/utils/logger.dart';

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
/// 
/// Note: The scroll controller will be provided by the ScrollableBody in the
/// layout. Do not wrap this in a SingleChildScrollView.
class TocScope extends StatefulWidget {
  const TocScope({
    super.key,
    this.scrollController,
    required this.entries,
    required this.child,
  });

  /// Optional scroll controller for the page content.
  /// If null, will attempt to get it from _ScrollControllerProvider in the widget tree.
  final ScrollController? scrollController;

  /// The list of TOC entries for this page
  final List<TocEntry> entries;

  /// The page content
  final Widget child;

  @override
  State<TocScope> createState() => _TocScopeState();
}

class _TocScopeState extends State<TocScope> {
  TocController? _controller;
  ScrollController? _scrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get scroll controller from widget or context
    final scrollController = widget.scrollController ?? 
        context.dependOnInheritedWidgetOfExactType<_ScrollControllerProvider>()?.scrollController;
    
    logger.d('TocScope: didChangeDependencies - scrollController: ${scrollController != null ? "found" : "null"}, entries: ${widget.entries.length}');
    
    if (scrollController != null && _scrollController != scrollController) {
      // Clean up old controller if exists
      if (_controller != null) {
        logger.d('TocScope: Disposing old controller');
        _scrollController?.removeListener(_onScroll);
        _controller?.dispose();
      }
      
      logger.d('TocScope: Creating new TocController with ${widget.entries.length} entries');
      _scrollController = scrollController;
      _controller = TocController(
        scrollController: scrollController,
        entries: widget.entries,
      );
      
      // Set up scroll listener for auto-highlighting
      scrollController.addListener(_onScroll);
      
      // Initial update after first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          logger.d('TocScope: Performing initial scroll update');
          _controller?.updateActiveFromScroll();
        }
      });
    } else if (_controller != null && widget.entries != _controller!.entries) {
      // Update entries if they changed
      logger.d('TocScope: Updating entries to ${widget.entries.length}');
      _controller!.updateEntries(widget.entries);
    }
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_onScroll);
    _controller?.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (mounted) {
      _controller?.updateActiveFromScroll();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      // No scroll controller available yet, just return child
      logger.w('TocScope: No controller available, returning plain child');
      return widget.child;
    }
    
    logger.d('TocScope: Building with TocProvider, ${_controller!.entries.length} entries');
    return TocProvider(
      controller: _controller!,
      child: widget.child,
    );
  }
}

/// InheritedWidget to provide scroll controller to TocScope
/// This is used by ScrollableBody to inject its scroll controller
class _ScrollControllerProvider extends InheritedWidget {
  final ScrollController scrollController;

  const _ScrollControllerProvider({
    required this.scrollController,
    required super.child,
  });

  @override
  bool updateShouldNotify(_ScrollControllerProvider oldWidget) {
    return scrollController != oldWidget.scrollController;
  }
}
