import 'package:flutter/material.dart';
import 'package:moonforge/core/controllers/toc_controller.dart';
import 'package:moonforge/core/models/toc_entry.dart';

/// A widget that displays a Table of Contents with auto-highlighting.
///
/// Shows a list of TOC entries and highlights the currently active entry
/// based on scroll position. Clicking an entry scrolls to that section.
class TableOfContents extends StatelessWidget {
  const TableOfContents({
    super.key,
    required this.controller,
    this.width = 240,
    this.padding = const EdgeInsets.all(16),
  });

  /// The TOC controller managing entries and active state
  final TocController controller;

  /// Width of the TOC widget (for sidebar usage)
  final double width;

  /// Padding around the TOC content
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final entries = controller.entries;
          
          if (entries.isEmpty) {
            return const SizedBox.shrink();
          }

          return SingleChildScrollView(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                ...entries.map((entry) => _buildEntry(context, entry)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      'Contents',
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildEntry(BuildContext context, TocEntry entry) {
    final theme = Theme.of(context);
    final isActive = controller.activeKey == entry.key;
    final indentLevel = entry.level;

    return Padding(
      padding: EdgeInsets.only(
        left: indentLevel * 16.0,
        bottom: 8,
      ),
      child: InkWell(
        onTap: () => controller.scrollToEntry(entry),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.primaryContainer
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              if (entry.icon != null) ...[
                Icon(
                  entry.icon,
                  size: 16,
                  color: isActive
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  entry.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isActive
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A compact button that opens the TOC in a bottom sheet.
///
/// Used in compact layouts where there's no room for a persistent sidebar.
class TocButton extends StatelessWidget {
  const TocButton({
    super.key,
    required this.controller,
  });

  final TocController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        // Only show button if there are TOC entries
        if (controller.entries.isEmpty) {
          return const SizedBox.shrink();
        }

        return IconButton(
          icon: const Icon(Icons.list_outlined),
          tooltip: 'Table of Contents',
          onPressed: () => _showTocSheet(context),
        );
      },
    );
  }

  void _showTocSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.25,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.list_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Contents',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // TOC content
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.entries.length,
                    itemBuilder: (context, index) {
                      final entry = controller.entries[index];
                      final isActive = controller.activeKey == entry.key;
                      
                      return Padding(
                        padding: EdgeInsets.only(
                          left: entry.level * 16.0,
                          bottom: 4,
                        ),
                        child: ListTile(
                          leading: entry.icon != null
                              ? Icon(
                                  entry.icon,
                                  size: 20,
                                  color: isActive
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurfaceVariant,
                                )
                              : null,
                          title: Text(
                            entry.title,
                            style: TextStyle(
                              color: isActive
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          selected: isActive,
                          selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onTap: () {
                            controller.scrollToEntry(entry);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
