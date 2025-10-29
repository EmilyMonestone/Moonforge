import 'package:flutter/material.dart';

/// A breadcrumb item with content and optional tap handler
class AdaptiveBreadcrumbItem {
  final Widget content;
  final VoidCallback? onTap;

  const AdaptiveBreadcrumbItem({required this.content, this.onTap});
}

/// A breadcrumb widget that handles overflow with middle-ellipsis
/// Shows first and last segments always, collapses middle segments when needed
class AdaptiveBreadcrumb extends StatefulWidget {
  const AdaptiveBreadcrumb({
    super.key,
    required this.items,
    this.divider = const Icon(Icons.chevron_right, size: 16),
    this.maxWidth,
  });

  final List<AdaptiveBreadcrumbItem> items;
  final Widget divider;
  final double? maxWidth;

  @override
  State<AdaptiveBreadcrumb> createState() => _AdaptiveBreadcrumbState();
}

class _AdaptiveBreadcrumbState extends State<AdaptiveBreadcrumb> {
  final Map<int, GlobalKey> _itemKeys = {};
  final GlobalKey _dividerKey = GlobalKey();
  bool _hasOverflow = false;
  int _visibleMiddleCount = 0;

  @override
  void initState() {
    super.initState();
    _updateKeys();
  }

  @override
  void didUpdateWidget(AdaptiveBreadcrumb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _updateKeys();
    }
  }

  void _updateKeys() {
    _itemKeys.clear();
    for (int i = 0; i < widget.items.length; i++) {
      _itemKeys[i] = GlobalKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    if (widget.items.length == 1) {
      return _buildClickableItem(widget.items[0], 0);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = widget.maxWidth ?? constraints.maxWidth;

        // If width is unbounded, skip overflow logic and render all items
        if (!maxWidth.isFinite) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildBreadcrumbItems(),
          );
        }

        // Post-frame callback to measure and adjust overflow only when finite
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkOverflow(maxWidth);
        });

        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildBreadcrumbItems(),
          ),
        );
      },
    );
  }

  List<Widget> _buildBreadcrumbItems() {
    final items = <Widget>[];
    final totalItems = widget.items.length;

    if (totalItems <= 2 || !_hasOverflow) {
      // Show all items when no overflow or only 2 items
      for (int i = 0; i < totalItems; i++) {
        if (i > 0) {
          items.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: KeyedSubtree(
                key: i == 1 ? _dividerKey : null,
                child: widget.divider,
              ),
            ),
          );
        }
        items.add(_buildClickableItem(widget.items[i], i));
      }
    } else {
      // Show first item
      items.add(_buildClickableItem(widget.items[0], 0));
      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: KeyedSubtree(key: _dividerKey, child: widget.divider),
        ),
      );

      // Show middle items if space allows
      if (_visibleMiddleCount > 0) {
        for (int i = 1; i < _visibleMiddleCount + 1; i++) {
          items.add(_buildClickableItem(widget.items[i], i));
          items.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: widget.divider,
            ),
          );
        }
      }

      // Show ellipsis if some middle items are hidden
      if (_visibleMiddleCount < totalItems - 2) {
        items.add(
          Tooltip(
            message: 'Hidden path segments',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text('…', style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        );
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: widget.divider,
          ),
        );
      }

      // Show last item
      items.add(
        _buildClickableItem(widget.items[totalItems - 1], totalItems - 1),
      );
    }

    return items;
  }

  Widget _buildClickableItem(AdaptiveBreadcrumbItem item, int index) {
    final widget = MouseRegion(
      cursor: item.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: item.onTap,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
          child: item.content,
        ),
      ),
    );

    return KeyedSubtree(key: _itemKeys[index], child: widget);
  }

  void _checkOverflow(double maxWidth) {
    if (!mounted) return;

    // Measure total width of all items
    double totalWidth = 0;
    double dividerWidth = 0;

    // Measure divider width once
    final dividerContext = _dividerKey.currentContext;
    if (dividerContext != null) {
      final renderBox = dividerContext.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        dividerWidth = renderBox.size.width + 8; // 4px padding on each side
      } else {
        dividerWidth = 24; // Estimate
      }
    } else {
      dividerWidth = 24; // Estimate: icon 16px + 8px padding
    }

    // Measure all item widths
    final itemWidths = <double>[];
    for (int i = 0; i < widget.items.length; i++) {
      final context = _itemKeys[i]?.currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize) {
          itemWidths.add(renderBox.size.width);
        } else {
          itemWidths.add(50); // Estimate
        }
      } else {
        itemWidths.add(50); // Estimate
      }
    }

    // Calculate total width
    for (int i = 0; i < itemWidths.length; i++) {
      totalWidth += itemWidths[i];
      if (i < itemWidths.length - 1) {
        totalWidth += dividerWidth;
      }
    }

    // Check if we need overflow handling
    if (totalWidth <= maxWidth) {
      if (_hasOverflow) {
        setState(() {
          _hasOverflow = false;
          _visibleMiddleCount = 0;
        });
      }
      return;
    }

    // Calculate how many middle items we can show
    // Always show first and last, plus ellipsis marker
    final ellipsisWidth = 30; // Estimate for "…" + dividers
    double requiredWidth =
        itemWidths.first + itemWidths.last + dividerWidth * 2 + ellipsisWidth;

    int visibleCount = 0;
    if (widget.items.length > 2) {
      for (int i = 1; i < widget.items.length - 1; i++) {
        final testWidth = requiredWidth + itemWidths[i] + dividerWidth;
        if (testWidth <= maxWidth) {
          requiredWidth = testWidth;
          visibleCount++;
        } else {
          break;
        }
      }
    }

    if (_hasOverflow != true || _visibleMiddleCount != visibleCount) {
      setState(() {
        _hasOverflow = true;
        _visibleMiddleCount = visibleCount;
      });
    }
  }
}
