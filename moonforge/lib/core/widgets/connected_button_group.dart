import 'package:flutter/material.dart';

/// Selection behavior for [ConnectedButtonGroup].
enum ConnectedSelectionMode { single, multi, actionOnly }

/// Preferred size ramp for [ConnectedButtonGroup].
enum ConnectedGroupSize { xs, s, m, l, xl }

/// Semantic role for assistive tech.
enum ConnectedSemanticRole { auto, tablist, toolbar }

/// Overflow handling policy for ConnectedButtonGroup layout.
enum ConnectedOverflowStrategy {
  none, // never use overflow; just wrap (up to maxLines)
  menu, // enforce single row with "More"; if even [first+More] doesn't fit, fall back to wrap
  menuThenWrap, // preferred: use "More"; if still too wide, wrap additional rows
  wrapThenMenu, // wrap first; if a row still overflows, add "More" on that row
}

/// Menu alignment for split-button and overflow menus.
enum ConnectedMenuAlignment { auto, start, end }

/// Item definition used by [ConnectedButtonGroup].
class ConnectedButtonItem<T> {
  const ConnectedButtonItem({
    required this.value,
    this.label,
    this.icon,
    this.tooltip,
    this.enabled = true,
    // Menus & split-button
    this.menu,
    this.isSplit = false,
    this.onPrimaryPressed,
    this.menuAlignment = ConnectedMenuAlignment.auto,
    this.openMenuOnLongPress = false,
  });

  final T value;
  final String? label;
  final IconData? icon;
  final String? tooltip;
  final bool enabled;

  // Menu & split support
  final List<ConnectedMenuEntry<T>>? menu;
  final bool isSplit;
  final VoidCallback? onPrimaryPressed;
  final ConnectedMenuAlignment menuAlignment;
  final bool openMenuOnLongPress;
}

/// Menu entry model used for split-button menus and overflow menus.
class ConnectedMenuEntry<T> {
  const ConnectedMenuEntry({
    required this.label,
    this.icon,
    this.value,
    this.enabled = true,
    this.destructive = false,
    this.checked,
    this.onSelected,
    this.submenu,
  });

  final String label;
  final IconData? icon;
  final T? value;
  final bool enabled;
  final bool destructive;
  final bool? checked; // null = not checkable
  final VoidCallback? onSelected;
  final List<ConnectedMenuEntry<T>>? submenu;
}

/// Theme overrides (ThemeExtension) for [ConnectedButtonGroup].
@immutable
class ConnectedButtonGroupThemeData
    extends ThemeExtension<ConnectedButtonGroupThemeData> {
  const ConnectedButtonGroupThemeData({
    this.containerShape,
    this.outline,
    this.containerColor,
    this.dividerColor,
    this.selectedContainerColor,
    this.selectedContentColor,
    this.unselectedContentColor,
    this.disabledContentColor,
    this.focusOutlineColor,
    this.selectionAnimationDuration,
    this.selectionAnimationCurve,
  });

  final ShapeBorder? containerShape; // outer pill
  final BorderSide? outline;
  final Color? containerColor;
  final Color? dividerColor;

  final Color? selectedContainerColor;
  final Color? selectedContentColor;
  final Color? unselectedContentColor;
  final Color? disabledContentColor;
  final Color? focusOutlineColor;

  final Duration? selectionAnimationDuration; // width/shape morph
  final Curve? selectionAnimationCurve;

  @override
  ConnectedButtonGroupThemeData copyWith({
    ShapeBorder? containerShape,
    BorderSide? outline,
    Color? containerColor,
    Color? dividerColor,
    Color? selectedContainerColor,
    Color? selectedContentColor,
    Color? unselectedContentColor,
    Color? disabledContentColor,
    Color? focusOutlineColor,
    Duration? selectionAnimationDuration,
    Curve? selectionAnimationCurve,
  }) {
    return ConnectedButtonGroupThemeData(
      containerShape: containerShape ?? this.containerShape,
      outline: outline ?? this.outline,
      containerColor: containerColor ?? this.containerColor,
      dividerColor: dividerColor ?? this.dividerColor,
      selectedContainerColor:
          selectedContainerColor ?? this.selectedContainerColor,
      selectedContentColor: selectedContentColor ?? this.selectedContentColor,
      unselectedContentColor:
          unselectedContentColor ?? this.unselectedContentColor,
      disabledContentColor: disabledContentColor ?? this.disabledContentColor,
      focusOutlineColor: focusOutlineColor ?? this.focusOutlineColor,
      selectionAnimationDuration:
          selectionAnimationDuration ?? this.selectionAnimationDuration,
      selectionAnimationCurve:
          selectionAnimationCurve ?? this.selectionAnimationCurve,
    );
  }

  @override
  ThemeExtension<ConnectedButtonGroupThemeData> lerp(
    covariant ThemeExtension<ConnectedButtonGroupThemeData>? other,
    double t,
  ) {
    if (other is! ConnectedButtonGroupThemeData) return this;
    return ConnectedButtonGroupThemeData(
      containerShape: t < 0.5 ? containerShape : other.containerShape,
      outline: t < 0.5 ? outline : other.outline,
      containerColor: Color.lerp(containerColor, other.containerColor, t),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      selectedContainerColor: Color.lerp(
        selectedContainerColor,
        other.selectedContainerColor,
        t,
      ),
      selectedContentColor: Color.lerp(
        selectedContentColor,
        other.selectedContentColor,
        t,
      ),
      unselectedContentColor: Color.lerp(
        unselectedContentColor,
        other.unselectedContentColor,
        t,
      ),
      disabledContentColor: Color.lerp(
        disabledContentColor,
        other.disabledContentColor,
        t,
      ),
      focusOutlineColor: Color.lerp(
        focusOutlineColor,
        other.focusOutlineColor,
        t,
      ),
      selectionAnimationDuration: (t < 0.5)
          ? selectionAnimationDuration
          : other.selectionAnimationDuration,
      selectionAnimationCurve: t < 0.5
          ? selectionAnimationCurve
          : other.selectionAnimationCurve,
    );
  }
}

/// A Material 3 Expressive connected button group.
/// Spans its parent width, coordinates shape/motion, and supports
/// single- or multi-select as well as action-only mode.
class ConnectedButtonGroup<T> extends StatelessWidget {
  const ConnectedButtonGroup({
    super.key,
    required this.items,
    this.value,
    this.values = const {},
    this.onChanged,
    this.onPressed,
    this.onMenuItemSelected,
    this.selectionMode = ConnectedSelectionMode.single,
    this.size = ConnectedGroupSize.m,
    this.density = VisualDensity.standard,
    this.leadingGap = 8,
    this.semanticRole = ConnectedSemanticRole.auto,
    // Layout policy additions
    this.overflowStrategy = ConnectedOverflowStrategy.menuThenWrap,
    this.maxLines,
    this.rowSpacing = 8.0,
    this.runPadding = const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
    this.overflowItem,
    this.scrollIfOverflow = true, // kept for backward compatibility; ignored
    this.showDividers = false,
    this.theme,
  });

  /// Items to render, in order.
  final List<ConnectedButtonItem<T>> items;

  /// Single-select: currently selected value.
  final T? value;

  /// Multi-select: currently selected values.
  final Set<T> values;

  /// Selection callback (single- or multi-select).
  final ValueChanged<T>? onChanged;

  /// Action callback for action-only mode (fires on every press).
  final ValueChanged<T>? onPressed;

  /// Menu selection callback (for split-button or overflow menu items).
  final ValueChanged<(T, ConnectedMenuEntry<T>)>? onMenuItemSelected;

  final ConnectedSelectionMode selectionMode;
  final ConnectedGroupSize size;
  final VisualDensity density;
  final double leadingGap;
  final ConnectedSemanticRole semanticRole;

  // Layout policy additions
  final ConnectedOverflowStrategy overflowStrategy;
  final int? maxLines; // null = unlimited; 1 = force single row logic
  final double rowSpacing;
  final EdgeInsets runPadding;
  final ConnectedButtonItem<T>? overflowItem;

  final bool scrollIfOverflow; // deprecated; ignored
  final bool showDividers;

  final ConnectedButtonGroupThemeData? theme;

  bool _isSelected(T itemValue) {
    switch (selectionMode) {
      case ConnectedSelectionMode.single:
        return value != null && value == itemValue;
      case ConnectedSelectionMode.multi:
        return values.contains(itemValue);
      case ConnectedSelectionMode.actionOnly:
        return false;
    }
  }

  TextStyle _textStyleForSize(TextTheme textTheme) {
    switch (size) {
      case ConnectedGroupSize.xs:
      case ConnectedGroupSize.s:
        return textTheme.labelSmall!;
      case ConnectedGroupSize.m:
        return textTheme.labelLarge!;
      case ConnectedGroupSize.l:
        return textTheme.titleSmall!;
      case ConnectedGroupSize.xl:
        return textTheme.titleMedium!;
    }
  }

  double _heightForSize() {
    // Use suggested map but enforce 48dp min target size.
    final map = <ConnectedGroupSize, double>{
      ConnectedGroupSize.xs: 32,
      ConnectedGroupSize.s: 36,
      ConnectedGroupSize.m: 40,
      ConnectedGroupSize.l: 48,
      ConnectedGroupSize.xl: 56,
    };
    return map[size]!.clamp(48.0, double.infinity);
  }

  double _outerRadiusForSize() {
    switch (size) {
      case ConnectedGroupSize.xs:
        return 4;
      case ConnectedGroupSize.s:
        return 8;
      case ConnectedGroupSize.m:
        return 8;
      case ConnectedGroupSize.l:
        return 16;
      case ConnectedGroupSize.xl:
        return 20;
    }
  }

  ConnectedButtonGroupThemeData _defaultsFor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ConnectedButtonGroupThemeData(
      containerShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_outerRadiusForSize()),
        side: BorderSide(color: cs.outlineVariant),
      ),
      outline: BorderSide(color: cs.outlineVariant),
      containerColor: cs.surfaceContainerLowest,
      dividerColor: cs.outlineVariant.withValues(alpha: 0.5),
      selectedContainerColor: cs.primaryContainer,
      selectedContentColor: cs.onPrimaryContainer,
      unselectedContentColor: cs.onSurfaceVariant,
      disabledContentColor: cs.onSurface.withValues(alpha: 0.38),
      focusOutlineColor: cs.outline,
      selectionAnimationDuration: const Duration(milliseconds: 160),
      selectionAnimationCurve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final ext = Theme.of(
      context,
    ).extension<ConnectedButtonGroupThemeData>()?.copyWith();
    final resolved = _defaultsFor(context).copyWith(
      containerShape: theme?.containerShape ?? ext?.containerShape,
      outline: theme?.outline ?? ext?.outline,
      containerColor: theme?.containerColor ?? ext?.containerColor,
      dividerColor: theme?.dividerColor ?? ext?.dividerColor,
      selectedContainerColor:
          theme?.selectedContainerColor ?? ext?.selectedContainerColor,
      selectedContentColor:
          theme?.selectedContentColor ?? ext?.selectedContentColor,
      unselectedContentColor:
          theme?.unselectedContentColor ?? ext?.unselectedContentColor,
      disabledContentColor:
          theme?.disabledContentColor ?? ext?.disabledContentColor,
      focusOutlineColor: theme?.focusOutlineColor ?? ext?.focusOutlineColor,
      selectionAnimationDuration:
          theme?.selectionAnimationDuration ?? ext?.selectionAnimationDuration,
      selectionAnimationCurve:
          theme?.selectionAnimationCurve ?? ext?.selectionAnimationCurve,
    );

    final textStyle = _textStyleForSize(Theme.of(context).textTheme);

    // Helper: per-size padding (horizontal sum) used for measurement
    EdgeInsets _paddingForSizeMeasure(ConnectedGroupSize s) {
      switch (s) {
        case ConnectedGroupSize.xs:
          return const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
        case ConnectedGroupSize.s:
          return const EdgeInsets.symmetric(horizontal: 10, vertical: 8);
        case ConnectedGroupSize.m:
          return const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
        case ConnectedGroupSize.l:
          return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
        case ConnectedGroupSize.xl:
          return const EdgeInsets.symmetric(horizontal: 20, vertical: 14);
      }
    }

    double _measureItemWidth(ConnectedButtonItem<T> it) {
      // Base is min 48
      double w = 48;
      final pad =
          _paddingForSizeMeasure(size).horizontal + 8; // +icon/label gap pad
      final iconW = (it.icon != null) ? 24.0 : 0.0;
      double labelW = 0.0;
      final label = it.label;
      if (label != null && label.isNotEmpty) {
        final tp = TextPainter(
          text: TextSpan(text: label, style: textStyle),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout();
        labelW = tp.size.width;
      }
      if (iconW > 0 && labelW > 0)
        w = iconW + leadingGap + labelW + pad;
      else if (labelW > 0)
        w = labelW + pad;
      else if (iconW > 0)
        w = iconW + pad;
      // Split-button adds chevron target (min 48) + divider
      if (it.isSplit && (it.menu?.isNotEmpty ?? false)) {
        w = w + 48 + 1;
      }
      return w.clamp(48.0, double.infinity);
    }

    ConnectedButtonItem<T> _defaultMoreItem() =>
        overflowItem ??
        ConnectedButtonItem<T>(
          value: items.first.value,
          icon: Icons.more_horiz,
          tooltip: 'More',
        );

    // Packing algorithm producing list of rows. Each row is list of indices and optional overflow list.
    List<_RowPack> _pack(double maxWidth) {
      final rows = <_RowPack>[];
      final widths = [for (final it in items) _measureItemWidth(it)];
      int i = 0;
      int linesUsed = 0;
      while (i < items.length && (maxLines == null || linesUsed < maxLines!)) {
        double used = runPadding.horizontal + 4; // 2dp inner on both sides
        final rowItems = <int>[];
        while (i < items.length) {
          final nextW = widths[i];
          if (used + nextW <= maxWidth) {
            rowItems.add(i);
            used += nextW + (showDividers && rowItems.length > 1 ? 1 : 0);
            i++;
          } else {
            break;
          }
        }

        List<int> overflowList = <int>[];
        bool addMore = false;
        if (i < items.length) {
          switch (overflowStrategy) {
            case ConnectedOverflowStrategy.none:
              // Wrap to next line immediately
              break;
            case ConnectedOverflowStrategy.menu:
            case ConnectedOverflowStrategy.menuThenWrap:
            case ConnectedOverflowStrategy.wrapThenMenu:
              // Try replacing a minimal suffix with More
              final moreW = _measureItemWidth(_defaultMoreItem());
              int k = 0;
              while (rowItems.isNotEmpty &&
                  used - widths[rowItems.removeLast()] + moreW > maxWidth) {
                // remove from end until fits with More
                k++;
                used -= (widths[i - 1]);
                i--;
              }
              // if nothing in row yet, start new row (wrap)
              if (rowItems.isEmpty) {
                // no items fit on this row; start new row without consuming
              } else {
                // Collect removed items into overflow menu
                final removed = <int>[];
                for (int j = 0; j < k; j++) {
                  removed.add(i + j);
                }
                overflowList = removed;
                addMore = k > 0;
              }
              break;
          }
        }

        rows.add(
          _RowPack(
            spec: _RowSpec(rowItems: rowItems, addMore: addMore),
            overflow: overflowList,
          ),
        );
        linesUsed++;

        // If we're enforcing single row with menu only
        if (overflowStrategy == ConnectedOverflowStrategy.menu &&
            linesUsed >= 1) {
          break;
        }

        // If no more items fit or maxLines reached, continue loop; otherwise continue packing next row
      }

      // If there are remaining items not yet placed, start new rows (menuThenWrap)
      if (i < items.length && (maxLines == null || rows.length < maxLines!)) {
        // pack remaining naively into rows without menu for simplicity
        final remaining = items
            .sublist(i)
            .asMap()
            .keys
            .map((k) => i + k)
            .toList();
        int start = 0;
        while (start < remaining.length &&
            (maxLines == null || rows.length < maxLines!)) {
          double used = runPadding.horizontal + 4;
          final rowItems = <int>[];
          int end = start;
          while (end < remaining.length) {
            final idx = remaining[end];
            final w = widths[idx];
            if (used + w <= maxWidth) {
              rowItems.add(idx);
              used += w + (showDividers && rowItems.length > 1 ? 1 : 0);
              end++;
            } else {
              break;
            }
          }
          rows.add(
            _RowPack(
              spec: _RowSpec(rowItems: rowItems, addMore: false),
              overflow: <int>[],
            ),
          );
          start = end;
        }
      }

      return rows;
    }

    Widget _buildRow(List<int> rowIdxs, {List<int> overflowIdxs = const []}) {
      final children = <Widget>[];
      for (int c = 0; c < rowIdxs.length; c++) {
        final idx = rowIdxs[c];
        if (c > 0 && showDividers) {
          children.add(_InnerDivider(color: resolved.dividerColor));
        }
        final it = items[idx];
        if (it.isSplit && (it.menu?.isNotEmpty ?? false)) {
          children.add(
            Expanded(
              child: _SplitButtonItem<T>(
                item: it,
                selected: _isSelected(it.value),
                onPrimary: () {
                  if (!it.enabled) return;
                  (it.onPrimaryPressed ??
                      () {
                        switch (selectionMode) {
                          case ConnectedSelectionMode.single:
                          case ConnectedSelectionMode.multi:
                            onChanged?.call(it.value);
                            break;
                          case ConnectedSelectionMode.actionOnly:
                            onPressed?.call(it.value);
                            break;
                        }
                      })();
                },
                onMenuSelected: (entry) {
                  onMenuItemSelected?.call((it.value, entry));
                  entry.onSelected?.call();
                },
                size: size,
                theme: resolved,
                textStyle: textStyle,
                leadingGap: leadingGap,
              ),
            ),
          );
        } else {
          children.add(
            Expanded(
              child: _ConnectedItem<T>(
                item: it,
                selected: _isSelected(it.value),
                onTap: () {
                  if (!it.enabled) return;
                  switch (selectionMode) {
                    case ConnectedSelectionMode.single:
                    case ConnectedSelectionMode.multi:
                      onChanged?.call(it.value);
                      break;
                    case ConnectedSelectionMode.actionOnly:
                      onPressed?.call(it.value);
                      break;
                  }
                },
                size: size,
                resolvedTheme: resolved,
                textStyle: textStyle,
                leadingGap: leadingGap,
                density: density,
              ),
            ),
          );
        }
      }

      // Overflow More button at the end of row
      if (overflowIdxs.isNotEmpty) {
        if (children.isNotEmpty && showDividers) {
          children.add(_InnerDivider(color: resolved.dividerColor));
        }
        final entries = [
          for (final oi in overflowIdxs) _toMenuEntry(items[oi]),
        ];
        children.add(
          _OverflowMenuButton<T>(
            item: _defaultMoreItem(),
            entries: entries,
            size: size,
            theme: resolved,
            textStyle: textStyle,
            leadingGap: leadingGap,
            onSelected: (entry) {
              // Mirror original action
              final src = entry.value;
              if (src != null) {
                // find the item and fire same callback
                final foundIndex = items.indexWhere((it) => it.value == src);
                if (foundIndex != -1) {
                  final it = items[foundIndex];
                  switch (selectionMode) {
                    case ConnectedSelectionMode.single:
                    case ConnectedSelectionMode.multi:
                      onChanged?.call(it.value);
                      break;
                    case ConnectedSelectionMode.actionOnly:
                      onPressed?.call(it.value);
                      break;
                  }
                }
              }
              onMenuItemSelected?.call((entry.value as T, entry));
              entry.onSelected?.call();
            },
          ),
        );
      }

      return Material(
        shape:
            resolved.containerShape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_outerRadiusForSize()),
            ),
        color: resolved.containerColor,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(2).add(runPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final rows = _pack(constraints.maxWidth);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int r = 0; r < rows.length; r++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: r == rows.length - 1 ? 0 : rowSpacing,
                ),
                child: _buildRow(rows[r].spec.rowItems, overflowIdxs: rows[r].overflow),
              ),
          ],
        );
      },
    );
  }
}

class _RowSpec {
  _RowSpec({required this.rowItems, required this.addMore});
  final List<int> rowItems;
  final bool addMore;
}

class _RowPack {
  const _RowPack({required this.spec, required this.overflow});
  final _RowSpec spec;
  final List<int> overflow;
}

ConnectedMenuEntry<T> _toMenuEntry<T>(ConnectedButtonItem<T> it) {
  return ConnectedMenuEntry<T>(
    label: it.label ?? '',
    icon: it.icon,
    value: it.value,
    enabled: it.enabled,
  );
}

class _InnerDivider extends StatelessWidget {
  const _InnerDivider({required this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(width: 1, thickness: 1, color: color);
  }
}

class _ConnectedItem<T> extends StatefulWidget {
  const _ConnectedItem({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.size,
    required this.resolvedTheme,
    required this.textStyle,
    required this.leadingGap,
    required this.density,
  });

  final ConnectedButtonItem<T> item;
  final bool selected;
  final VoidCallback onTap;
  final ConnectedGroupSize size;
  final ConnectedButtonGroupThemeData resolvedTheme;
  final TextStyle textStyle;
  final double leadingGap;
  final VisualDensity density;

  @override
  State<_ConnectedItem<T>> createState() => _ConnectedItemState<T>();
}

class _ConnectedItemState<T> extends State<_ConnectedItem<T>>
    with TickerProviderStateMixin {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.resolvedTheme;
    final selected = widget.selected;

    final bgColor = selected
        ? theme.selectedContainerColor
        : Colors.transparent;

    final contentColor = !widget.item.enabled
        ? theme.disabledContentColor
        : selected
        ? theme.selectedContentColor
        : theme.unselectedContentColor;

    final overlayBase = Theme.of(context).colorScheme.onSurface;
    final hoverOverlay = overlayBase.withValues(alpha: 0.04);
    final pressOverlay = overlayBase.withValues(alpha: 0.08);
    final focusOutlineColor = theme.focusOutlineColor;

    final minHeight = _heightForSize(widget.size).clamp(48.0, double.infinity);

    return FocusableActionDetector(
      mouseCursor: widget.item.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onShowHoverHighlight: (h) => setState(() => _hovered = h),
      onShowFocusHighlight: (f) => setState(() => _focused = f),
      child: Semantics(
        button: true,
        enabled: widget.item.enabled,
        selected: selected,
        label: widget.item.label,
        child: AnimatedContainer(
          duration:
              theme.selectionAnimationDuration ??
              const Duration(milliseconds: 160),
          curve: theme.selectionAnimationCurve ?? Curves.fastOutSlowIn,
          decoration: ShapeDecoration(
            color: bgColor,
            shape: const StadiumBorder(),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: widget.item.enabled ? widget.onTap : null,
              onHighlightChanged: (v) => setState(() => _pressed = v),
              overlayColor: WidgetStatePropertyAll(
                _pressed
                    ? pressOverlay
                    : _hovered
                    ? hoverOverlay
                    : Colors.transparent,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight, minWidth: 48),
                child: Padding(
                  padding: _paddingForSize(widget.size),
                  child: _buildContent(contentColor, context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color? contentColor, BuildContext context) {
    final iconWidget = widget.item.icon != null
        ? Icon(widget.item.icon, color: contentColor)
        : null;
    final labelText = widget.item.label;

    Widget inner;
    if (labelText != null && labelText.isNotEmpty && iconWidget != null) {
      inner = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          SizedBox(width: widget.leadingGap),
          Flexible(
            child: Text(
              labelText,
              overflow: TextOverflow.ellipsis,
              style: widget.textStyle.copyWith(color: contentColor),
            ),
          ),
        ],
      );
    } else if (labelText != null && labelText.isNotEmpty) {
      inner = Text(
        labelText,
        overflow: TextOverflow.ellipsis,
        style: widget.textStyle.copyWith(color: contentColor),
        textAlign: TextAlign.center,
      );
    } else {
      inner = iconWidget ?? Icon(Icons.more_horiz, color: contentColor);
    }

    final toolTip = widget.item.tooltip;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Center(
        child: toolTip != null && (widget.item.label == null)
            ? Tooltip(
                message: toolTip,
                waitDuration: const Duration(milliseconds: 400),
                child: inner,
              )
            : inner,
      ),
    );
  }

  EdgeInsets _paddingForSize(ConnectedGroupSize size) {
    switch (size) {
      case ConnectedGroupSize.xs:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
      case ConnectedGroupSize.s:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 8);
      case ConnectedGroupSize.m:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
      case ConnectedGroupSize.l:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ConnectedGroupSize.xl:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 14);
    }
  }
}

class _OverflowMenuButton<T> extends StatelessWidget {
  const _OverflowMenuButton({
    required this.item,
    required this.entries,
    required this.size,
    required this.theme,
    required this.textStyle,
    required this.leadingGap,
    required this.onSelected,
  });

  final ConnectedButtonItem<T> item;
  final List<ConnectedMenuEntry<T>> entries;
  final ConnectedGroupSize size;
  final ConnectedButtonGroupThemeData theme;
  final TextStyle textStyle;
  final double leadingGap;
  final ValueChanged<ConnectedMenuEntry<T>> onSelected;

  EdgeInsets _paddingForSize(ConnectedGroupSize s) {
    switch (s) {
      case ConnectedGroupSize.xs:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
      case ConnectedGroupSize.s:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 8);
      case ConnectedGroupSize.m:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
      case ConnectedGroupSize.l:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ConnectedGroupSize.xl:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 14);
    }
  }

  List<Widget> _buildMenuChildren() {
    Widget buildEntry(ConnectedMenuEntry<T> e) {
      if (e.submenu != null && e.submenu!.isNotEmpty) {
        return SubmenuButton(
          leadingIcon: e.icon != null ? Icon(e.icon) : null,
          menuChildren: [for (final c in e.submenu!) buildEntry(c)],
          child: Text(e.label),
        );
      }
      return MenuItemButton(
        leadingIcon: e.icon != null ? Icon(e.icon) : null,
        onPressed: e.enabled
            ? () {
                onSelected(e);
              }
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: Text(e.label)),
            if (e.checked != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  e.checked! ? Icons.check_box : Icons.check_box_outline_blank,
                ),
              ),
          ],
        ),
      );
    }

    return [for (final e in entries) buildEntry(e)];
  }

  @override
  Widget build(BuildContext context) {
    final contentColor = theme.unselectedContentColor;
    final minHeight = _heightForSize(size).clamp(48.0, double.infinity);

    return MenuAnchor(
      builder: (context, controller, child) {
        return AnimatedContainer(
          duration:
              theme.selectionAnimationDuration ??
              const Duration(milliseconds: 160),
          curve: theme.selectionAnimationCurve ?? Curves.fastOutSlowIn,
          decoration: const ShapeDecoration(
            color: Colors.transparent,
            shape: StadiumBorder(),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () =>
                  controller.isOpen ? controller.close() : controller.open(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight, minWidth: 48),
                child: Padding(
                  padding: _paddingForSize(size),
                  child: Center(
                    child: Icon(
                      item.icon ?? Icons.more_horiz,
                      color: contentColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      menuChildren: _buildMenuChildren(),
    );
  }
}

class _SplitButtonItem<T> extends StatelessWidget {
  const _SplitButtonItem({
    required this.item,
    required this.selected,
    required this.onPrimary,
    required this.onMenuSelected,
    required this.size,
    required this.theme,
    required this.textStyle,
    required this.leadingGap,
  });

  final ConnectedButtonItem<T> item;
  final bool selected;
  final VoidCallback onPrimary;
  final ValueChanged<ConnectedMenuEntry<T>> onMenuSelected;
  final ConnectedGroupSize size;
  final ConnectedButtonGroupThemeData theme;
  final TextStyle textStyle;
  final double leadingGap;

  EdgeInsets _paddingForSize(ConnectedGroupSize s) {
    switch (s) {
      case ConnectedGroupSize.xs:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
      case ConnectedGroupSize.s:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 8);
      case ConnectedGroupSize.m:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
      case ConnectedGroupSize.l:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ConnectedGroupSize.xl:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 14);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = selected
        ? theme.selectedContainerColor
        : Colors.transparent;
    final contentColor = selected
        ? theme.selectedContentColor
        : theme.unselectedContentColor;
    final minHeight = _heightForSize(size).clamp(48.0, double.infinity);

    return AnimatedContainer(
      duration:
          theme.selectionAnimationDuration ?? const Duration(milliseconds: 160),
      curve: theme.selectionAnimationCurve ?? Curves.fastOutSlowIn,
      decoration: const ShapeDecoration(
        color: Colors.transparent,
        shape: StadiumBorder(),
      ),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: bgColor,
          shape: const StadiumBorder(),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Primary half
            Expanded(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onPrimary,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: minHeight,
                      minWidth: 48,
                    ),
                    child: Padding(
                      padding: _paddingForSize(size),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (item.icon != null)
                              Icon(item.icon, color: contentColor),
                            if (item.icon != null &&
                                (item.label?.isNotEmpty ?? false))
                              SizedBox(width: leadingGap),
                            if (item.label != null && item.label!.isNotEmpty)
                              Flexible(
                                child: Text(
                                  item.label!,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyle.copyWith(
                                    color: contentColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Divider between halves
            const VerticalDivider(width: 1, thickness: 1),
            // Chevron half
            SizedBox(
              width: 48,
              child: _OverflowMenuButton<T>(
                item: ConnectedButtonItem<T>(
                  value: item.value,
                  icon: Icons.arrow_drop_down,
                  enabled: item.enabled,
                ),
                entries: item.menu ?? const [],
                size: size,
                theme: theme,
                textStyle: textStyle,
                leadingGap: leadingGap,
                onSelected: onMenuSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper to map size to height (must match group mapping)
double _heightForSize(ConnectedGroupSize size) {
  switch (size) {
    case ConnectedGroupSize.xs:
      return 32;
    case ConnectedGroupSize.s:
      return 36;
    case ConnectedGroupSize.m:
      return 40;
    case ConnectedGroupSize.l:
      return 48;
    case ConnectedGroupSize.xl:
      return 56;
  }
}
