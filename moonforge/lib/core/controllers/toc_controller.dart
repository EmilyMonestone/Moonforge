import 'package:flutter/material.dart';
import 'package:moonforge/core/models/toc_entry.dart';

/// Controller for managing Table of Contents state and scroll synchronization.
///
/// Tracks the currently active entry based on scroll position and provides
/// methods to programmatically scroll to entries.
class TocController extends ChangeNotifier {
  TocController({
    required this.scrollController,
    List<TocEntry> entries = const [],
  }) : _entries = entries;

  final ScrollController scrollController;
  List<TocEntry> _entries;
  GlobalKey? _activeKey;

  /// The list of TOC entries
  List<TocEntry> get entries => _entries;

  /// The currently active/highlighted entry key
  GlobalKey? get activeKey => _activeKey;

  /// Update the list of TOC entries
  void updateEntries(List<TocEntry> entries) {
    _entries = entries;
    notifyListeners();
  }

  /// Set the active entry by its key
  void setActiveEntry(GlobalKey? key) {
    if (_activeKey != key) {
      _activeKey = key;
      notifyListeners();
    }
  }

  /// Scroll to a specific TOC entry with animation
  Future<void> scrollToEntry(TocEntry entry) async {
    final context = entry.key.currentContext;
    if (context == null) return;

    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.1, // Position near top of viewport
    );
  }

  /// Update the active entry based on current scroll position
  void updateActiveFromScroll() {
    if (_entries.isEmpty) return;

    // Get the current scroll position
    final scrollOffset = scrollController.offset;
    final viewportHeight = scrollController.position.viewportDimension;

    GlobalKey? newActiveKey;
    double closestDistance = double.infinity;

    // Find the entry closest to the top of the viewport
    for (final entry in _entries) {
      final context = entry.key.currentContext;
      if (context == null) continue;

      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null) continue;

      // Get the position relative to the scrollable
      final position = renderBox.localToGlobal(Offset.zero);
      final distanceFromTop = position.dy.abs();

      // Consider entries that are within the viewport or just above it
      if (distanceFromTop < closestDistance && distanceFromTop < viewportHeight) {
        closestDistance = distanceFromTop;
        newActiveKey = entry.key;
      }
    }

    setActiveEntry(newActiveKey);
  }

  @override
  void dispose() {
    // Don't dispose the scrollController as it's owned by the parent
    super.dispose();
  }
}
