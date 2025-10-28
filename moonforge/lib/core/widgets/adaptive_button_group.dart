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

        // Post-frame callback to measure and adjust overflow
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkOverflow(maxWidth);
        });

        return SizedBox(
          width: maxWidth,
          child: _buildButtonGroup(),
        );
      },
    );
  }

  Widget _buildButtonGroup() {
    if (!_needsOverflow || widget.actions.length <= 1) {
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
    final visibleActions = widget.actions.take(_visibleButtonCount).toList();
    final overflowActions = widget.actions.skip(_visibleButtonCount).toList();

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

  void _checkOverflow(double maxWidth) {
    if (!mounted) return;

    // Measure button widths
    final buttonWidths = <double>[];
    for (int i = 0; i < widget.actions.length; i++) {
      final context = _buttonKeys[i].currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          buttonWidths.add(renderBox.size.width);
        } else {
          // Estimate button width
          buttonWidths.add(widget.showLabels ? 120 : 48);
        }
      } else {
        // Estimate button width
        buttonWidths.add(widget.showLabels ? 120 : 48);
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
