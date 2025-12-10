import 'package:flutter/material.dart';
import 'package:moonforge/core/models/toc_declaration.dart';
import 'package:moonforge/core/models/toc_entry.dart';
import 'package:moonforge/core/models/toc_notification.dart';
import 'package:moonforge/layout/destinations.dart';
import 'package:moonforge/layout/widgets/common/app_navigation_rail.dart';
import 'package:moonforge/layout/widgets/common/menu_sheet_builder.dart';
import 'package:moonforge/layout/widgets/common/scrollable_body.dart';

/// A scaffold optimized for wide/tablet layouts on mobile platforms
/// (Android, iOS, Fuchsia).
///
/// Renders a persistent navigation rail on the left and places content on the
/// right. Designed for tablet form factors on mobile platforms with touch-first
/// interactions.
class MobileWideScaffold extends StatefulWidget {
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

  /// Create a mobile wide scaffold.
  const MobileWideScaffold({
    super.key,
    required this.tabs,
    required this.body,
    required this.selectedIndex,
    required this.onSelect,
    required this.breadcrumbs,
  });

  @override
  State<MobileWideScaffold> createState() => _MobileWideScaffoldState();
}

class _MobileWideScaffoldState extends State<MobileWideScaffold> {
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
        const VerticalDivider(width: 1),
        Expanded(
          child: ScrollableBody(child: widget.body),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title: widget.breadcrumbs,
        centerTitle: false,
        titleSpacing: 16,
        automaticallyImplyLeading: false,
        toolbarHeight: 56,
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
      floatingActionButton: const MenuFloatingActionButton(),
    );
  }
}
