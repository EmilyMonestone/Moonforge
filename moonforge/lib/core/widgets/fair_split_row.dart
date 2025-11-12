import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Measures its child’s laid-out size and reports it.
class MeasureSize extends SingleChildRenderObjectWidget {
  const MeasureSize({super.key, required this.onChange, required super.child});

  final ValueChanged<Size> onChange;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderMeasureSize(onChange);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderMeasureSize renderObject,
  ) {
    renderObject.onChange = onChange;
  }
}

class RenderMeasureSize extends RenderProxyBox {
  RenderMeasureSize(this.onChange);

  ValueChanged<Size> onChange;
  Size? _prev;

  @override
  void performLayout() {
    super.performLayout();
    if (_prev != size) {
      _prev = size;
      WidgetsBinding.instance.addPostFrameCallback((_) => onChange(size));
    }
  }
}

/// FairSplitRow — two widgets side-by-side with a fair, dynamic split:
/// - If both natural widths fit: use them.
/// - If not: start at 50/50, then give leftover to the child that still needs it.
/// - Optional min widths and a gap between children.
/// - left/right are plain Widgets (no builders).
class FairSplitRow extends StatefulWidget {
  const FairSplitRow({
    super.key,
    required this.left,
    required this.right,
    this.leftForMeasure,
    this.rightForMeasure,
    this.minLeft = 0,
    this.minRight = 0,
    this.gap = 0,
  });

  /// Visible left and right content.
  final Widget left;
  final Widget right;

  /// Optional key-free versions for offstage measurement.
  /// Defaults to [left]/[right] if not provided.
  final Widget? leftForMeasure;
  final Widget? rightForMeasure;

  /// Minimum widths (floors) for the visible layout.
  final double minLeft;
  final double minRight;

  /// Spacing between the two panes in the visible layout.
  final double gap;

  @override
  State<FairSplitRow> createState() => _FairSplitRowState();
}

class _FairSplitRowState extends State<FairSplitRow> {
  double _w1 = 0, _w2 = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Available width for BOTH panes (excluding the gap).
        final aw = math.max(0, constraints.maxWidth - widget.gap).toDouble();

        final (c1, c2) = _solve(
          aw: aw,
          w1: _w1,
          w2: _w2,
          minLeft: widget.minLeft,
          minRight: widget.minRight,
        );

        // --- OFFSTAGE MEASUREMENT ---
        final measureLeft = widget.leftForMeasure ?? widget.left;
        final measureRight = widget.rightForMeasure ?? widget.right;

        final offstage = Offstage(
          offstage: true,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              // Keep constraints finite; let children pick their natural width up to aw.
              maxWidth: aw,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MeasureSize(
                  onChange: (s) {
                    if (s.width != _w1) setState(() => _w1 = s.width);
                  },
                  // Shrink-wrap so we read the actual “wants to be” width.
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [measureLeft],
                  ),
                ),
                MeasureSize(
                  onChange: (s) {
                    if (s.width != _w2) setState(() => _w2 = s.width);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [measureRight],
                  ),
                ),
              ],
            ),
          ),
        );

        // --- VISIBLE LAYOUT ---
        final visible = Row(
          children: [
            SizedBox(width: c1, child: widget.left),
            Spacer(),
            if (widget.gap > 0) ...[SizedBox(width: widget.gap), Spacer()],
            SizedBox(width: c2, child: widget.right),
          ],
        );

        return Stack(children: [offstage, visible]);
      },
    );
  }

  // Fair split solver matching your scenarios.
  (double, double) _solve({
    required double aw,
    required double w1,
    required double w2,
    required double minLeft,
    required double minRight,
  }) {
    if (aw <= 0) return (0, 0);

    // First frame: even split so UI is stable before measurements arrive.
    if (w1 == 0 && w2 == 0) {
      final half = aw / 2;
      return (half.clamp(minLeft, half), half.clamp(minRight, half));
    }

    // Floors
    w1 = math.max(w1, minLeft);
    w2 = math.max(w2, minRight);

    // Both fit: use natural widths.
    if (w1 + w2 <= aw) return (w1, w2);

    // Not enough room: start 50/50, then distribute leftover based on remaining need.
    final half = aw / 2;
    double c1 = w1.clamp(minLeft, half);
    double c2 = w2.clamp(minRight, half);

    double leftover = aw - (c1 + c2);
    if (leftover <= 0) return (c1, c2);

    final need1 = math.max(0, w1 - c1);
    final need2 = math.max(0, w2 - c2);
    final totalNeed = need1 + need2;

    if (totalNeed == 0) return (c1, c2);

    final add1 = leftover * (need1 / totalNeed);
    final add2 = leftover - add1;
    return (c1 + add1, c2 + add2);
  }
}
