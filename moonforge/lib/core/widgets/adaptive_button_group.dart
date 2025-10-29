import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart';
import 'package:moonforge/core/models/menu_bar_actions.dart' as mb_actions;

/// A button group that handles overflow by placing extra buttons in an overflow menu
class AdaptiveButtonGroup extends StatefulWidget {
  const AdaptiveButtonGroup({
    super.key,
    required this.actions,
    required this.showLabels,
    this.maxWidth,
  });

  final List<mb_actions.MenuBarAction> actions;
  final bool showLabels;
  final double? maxWidth;

  @override
  State<AdaptiveButtonGroup> createState() => _AdaptiveButtonGroupState();
}

class _AdaptiveButtonGroupState extends State<AdaptiveButtonGroup> {
  final List<GlobalKey> _buttonKeys = [];
  int _visibleButtonCount = 0;
  bool _needsOverflow = false;

  @override
  void initState() {
    super.initState();
    _updateKeys();
  }

  @override
  void didUpdateWidget(AdaptiveButtonGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.actions.length != widget.actions.length) {
      _updateKeys();
    }
  }

  void _updateKeys() {
    _buttonKeys.clear();
    for (int i = 0; i < widget.actions.length; i++) {
      _buttonKeys.add(GlobalKey());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = widget.maxWidth ?? constraints.maxWidth;

        // If width is unbounded, skip overflow logic and render all buttons.
        if (!maxWidth.isFinite) {
          // Ensure internal state reflects "no overflow" to keep behavior consistent
          if (_needsOverflow || _visibleButtonCount != widget.actions.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              setState(() {
                _needsOverflow = false;
                _visibleButtonCount = widget.actions.length;
              });
            });
          }
          return Align(
            alignment: Alignment.centerLeft,
            child: _buildButtonGroup(forceAll: true),
          );
        }

        // Synchronous estimate to avoid first-frame overflow
        final estimate = _estimateVisibleButtons(maxWidth);

        // Post-frame callback to measure and adjust overflow when width is finite
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkOverflow(maxWidth);
        });

        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: _buildButtonGroup(
            needsOverflowOverride: estimate.needsOverflow,
            visibleCountOverride: estimate.visibleCount,
          ),
        );
      },
    );
  }

  Widget _buildButtonGroup({
    bool forceAll = false,
    bool? needsOverflowOverride,
    int? visibleCountOverride,
  }) {
    final useOverflow = needsOverflowOverride ?? _needsOverflow;
    final visibleCount = visibleCountOverride ?? _visibleButtonCount;

    if (forceAll || !useOverflow || widget.actions.length <= 1) {
      // Show all buttons normally
      return ButtonGroupM3E(
        shape: ButtonGroupM3EShape.square,
        children: [
          for (int i = 0; i < widget.actions.length; i++)
            KeyedSubtree(
              key: _buttonKeys[i],
              child: _buildButton(widget.actions[i], i),
            ),
        ],
      );
    }

    // Show visible buttons + overflow menu
    final visibleActions = widget.actions.take(visibleCount).toList();
    final overflowActions = widget.actions.skip(visibleCount).toList();

    return ButtonGroupM3E(
      shape: ButtonGroupM3EShape.square,
      children: [
        for (int i = 0; i < visibleActions.length; i++)
          KeyedSubtree(
            key: _buttonKeys[i],
            child: _buildButton(visibleActions[i], i),
          ),
        if (overflowActions.isNotEmpty) _buildOverflowButton(overflowActions),
      ],
    );
  }

  Widget _buildButton(mb_actions.MenuBarAction action, int index) {
    return Tooltip(
      message: action.helpText ?? action.label,
      child: widget.showLabels
          ? (action.icon != null
                ? ButtonM3E(
                    onPressed: () {
                      final cb = action.onPressed;
                      if (cb != null) cb(context);
                    },
                    icon: Icon(action.icon),
                    label: Text(action.label),
                    style: ButtonM3EStyle.tonal,
                    shape: ButtonM3EShape.square,
                  )
                : ButtonM3E(
                    onPressed: () {
                      final cb = action.onPressed;
                      if (cb != null) cb(context);
                    },
                    label: Text(action.label),
                    style: ButtonM3EStyle.tonal,
                    shape: ButtonM3EShape.square,
                  ))
          : (action.icon != null
                ? IconButtonM3E(
                    onPressed: () {
                      final cb = action.onPressed;
                      if (cb != null) cb(context);
                    },
                    icon: Icon(action.icon),
                  )
                : TextButton(
                    onPressed: () {
                      final cb = action.onPressed;
                      if (cb != null) cb(context);
                    },
                    child: Text(action.label),
                  )),
    );
  }

  Widget _buildOverflowButton(List<mb_actions.MenuBarAction> overflowActions) {
    return PopupMenuButton<mb_actions.MenuBarAction>(
      icon: const Icon(Icons.more_vert),
      tooltip: 'More actions',
      itemBuilder: (context) {
        return overflowActions.map((action) {
          return PopupMenuItem<mb_actions.MenuBarAction>(
            value: action,
            child: Row(
              children: [
                if (action.icon != null) ...[
                  Icon(action.icon, size: 20),
                  const SizedBox(width: 12),
                ],
                Expanded(child: Text(action.label)),
              ],
            ),
          );
        }).toList();
      },
      onSelected: (action) {
        final cb = action.onPressed;
        if (cb != null) cb(context);
      },
    );
  }

  // Returns an estimated number of visible buttons that can fit into maxWidth
  _Estimate _estimateVisibleButtons(double maxWidth) {
    // Estimate button widths
    final estimatedWidths = <double>[];
    for (int i = 0; i < widget.actions.length; i++) {
      // Rough heuristic: text+icon ~ 140, text-only ~ 110, icon-only ~ 48
      final a = widget.actions[i];
      final width = widget.showLabels
          ? (a.icon != null ? 140.0 : 110.0)
          : (a.icon != null ? 48.0 : 80.0);
      estimatedWidths.add(width);
    }

    // Total width
    final totalWidth = estimatedWidths.fold(0.0, (s, w) => s + w);
    if (totalWidth <= maxWidth) {
      return _Estimate(false, widget.actions.length);
    }

    // Reserve overflow button
    const overflowButtonWidth = 48.0;
    double available = maxWidth - overflowButtonWidth;
    int visible = 0;
    double used = 0;
    for (final w in estimatedWidths) {
      if (used + w <= available) {
        used += w;
        visible++;
      } else {
        break;
      }
    }

    if (visible == 0 && estimatedWidths.isNotEmpty) {
      // Try to allow a single button if possible
      if (estimatedWidths.first <= maxWidth) {
        visible = 1;
      }
    }

    final needsOverflow = visible < widget.actions.length;
    return _Estimate(needsOverflow, visible);
  }

  void _checkOverflow(double maxWidth) {
    if (!mounted) return;

    // Measure button widths
    final buttonWidths = <double>[];
    for (int i = 0; i < widget.actions.length; i++) {
      final context = _buttonKeys[i].currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize) {
          buttonWidths.add(renderBox.size.width);
        } else {
          // Estimate button width
          final a = widget.actions[i];
          buttonWidths.add(
            widget.showLabels
                ? (a.icon != null ? 140 : 110)
                : (a.icon != null ? 48 : 80),
          );
        }
      } else {
        // Estimate button width
        final a = widget.actions[i];
        buttonWidths.add(
          widget.showLabels
              ? (a.icon != null ? 140 : 110)
              : (a.icon != null ? 48 : 80),
        );
      }
    }

    // Calculate total width
    double totalWidth = buttonWidths.fold(0, (sum, width) => sum + width);

    // Check if overflow is needed
    if (totalWidth <= maxWidth) {
      if (_needsOverflow) {
        setState(() {
          _needsOverflow = false;
          _visibleButtonCount = widget.actions.length;
        });
      }
      return;
    }

    // Calculate how many buttons can fit (reserve space for overflow button)
    const overflowButtonWidth = 48.0;
    double availableWidth = maxWidth - overflowButtonWidth;
    int visibleCount = 0;
    double usedWidth = 0;

    for (int i = 0; i < buttonWidths.length; i++) {
      if (usedWidth + buttonWidths[i] <= availableWidth) {
        usedWidth += buttonWidths[i];
        visibleCount++;
      } else {
        break;
      }
    }

    // Ensure at least one button is visible (or none if no space at all)
    if (visibleCount == 0 && buttonWidths.isNotEmpty) {
      // If even one button doesn't fit, try without the overflow button
      if (buttonWidths[0] <= maxWidth) {
        visibleCount = 1;
      }
    }

    if (!_needsOverflow || _visibleButtonCount != visibleCount) {
      setState(() {
        _needsOverflow = visibleCount < widget.actions.length;
        _visibleButtonCount = visibleCount;
      });
    }
  }
}

class _Estimate {
  final bool needsOverflow;
  final int visibleCount;

  _Estimate(this.needsOverflow, this.visibleCount);
}
