import 'package:flutter/material.dart';
import 'package:moonforge/core/models/toc_declaration.dart';
import 'package:moonforge/core/models/toc_entry.dart';
import 'package:moonforge/core/models/toc_notification.dart';
import 'package:moonforge/core/widgets/window_top_bar.dart' as topbar;
import 'package:moonforge/layout/destinations.dart';
import 'package:moonforge/layout/widgets/common/app_navigation_rail.dart';
import 'package:moonforge/layout/widgets/common/scrollable_body.dart';

/// A scaffold optimized for wide/desktop layouts on desktop platforms
/// (Windows, macOS, Linux, Web).
///
/// Renders a persistent navigation rail (Material 3 Expressive variant) on the
/// left with expandable/collapsible behavior and places content on the right.
/// Includes an extended trailing area for user/profile controls and sync status.
/// Designed for mouse/keyboard interactions typical of desktop environments.
class DesktopWideScaffold extends StatefulWidget {
  /// The list of tabs (objects with `icon` and `label`) shown in the rail.
  final List<TabSpec> tabs;

  /// The primary content widget for the scaffold body.
  final Widget body;

  /// The currently selected tab index.
  final int selectedIndex;

  /// Callback when the user selects a tab. Receives the `BuildContext` and
  /// the selected tab index.
  final void Function(BuildContext, int) onSelect;

  /// Widget used to render breadcrumbs in the top bar.
  final Widget breadcrumbs;

  /// Create a desktop wide scaffold.
  const DesktopWideScaffold({
    super.key,
    required this.tabs,
    required this.body,
    required this.selectedIndex,
    required this.onSelect,
    required this.breadcrumbs,
  });

  @override
  State<DesktopWideScaffold> createState() => _DesktopWideScaffoldState();
}

class _DesktopWideScaffoldState extends State<DesktopWideScaffold> {
  List<TocEntry>? _tocEntries;

  @override
  Widget build(BuildContext context) {
    final scaffoldBody = Row(
      children: [
        AppNavigationRail(
          tabs: widget.tabs,
          selectedIndex: widget.selectedIndex,
          onSelect: widget.onSelect,
          forceCollapsed: false,
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
            ),
            child: ScrollableBody(child: widget.body),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        title: null,
        centerTitle: false,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: topbar.WindowTopBar(
          leading: widget.breadcrumbs,
        ),
      ),
      body: SafeArea(
        child: NotificationListener<TocEntriesNotification>(
          onNotification: (notification) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _tocEntries = notification.entries;
                });
              }
            });
            return true;
          },
          child: _tocEntries != null && _tocEntries!.isNotEmpty
              ? TocDeclaration(
                  entries: _tocEntries!,
                  child: scaffoldBody,
                )
              : scaffoldBody,
        ),
      ),
    );
  }
}
}
