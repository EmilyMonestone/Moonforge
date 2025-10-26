import 'package:flutter/material.dart';
import 'package:moonforge/core/widgets/error_boundary.dart';
import 'package:moonforge/core/widgets/surface_container.dart';

///
class TitleCard extends StatelessWidget {
  const TitleCard({
    super.key,
    this.margin,
    this.padding,
    this.backgroundType = SurfaceBackgroundType.surfaceContainer,
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
    required this.title,
    this.titleOnTap,
    this.trailing,
  });

  final String title;

  /// default [EdgeInsets.all(8.0)]
  final EdgeInsetsGeometry? margin;

  /// default [EdgeInsets.all(16.0)]
  final EdgeInsetsGeometry? padding;

  /// default [SurfaceBackgroundType.surfaceContainer]
  final SurfaceBackgroundType backgroundType;

  /// default [0]
  final double? minWidth;

  /// default [0]
  final double? minHeight;

  /// default [double.infinity]
  final double? maxWidth;

  /// default [double.infinity]
  final double? maxHeight;

  /// default [null]
  final void Function()? titleOnTap;

  ///default [null]
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = getSurfaceColor(context, backgroundType);

    Widget buildContainerContent() {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Ensure the title area takes the remaining horizontal space without
          // forcing infinite width constraints inside a Row.
          Expanded(
            child: InkWell(
              onTap: titleOnTap,
              customBorder: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: padding ?? const EdgeInsets.all(16),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      );
    }

    // Build optional finite constraints only when provided; avoid forcing
    // infinite max constraints which can break in unbounded parents (e.g. Row).
    BoxConstraints? finiteConstraints;
    final bool hasAnyConstraint =
        minWidth != null ||
        minHeight != null ||
        maxWidth != null ||
        maxHeight != null;
    if (hasAnyConstraint) {
      final double resolvedMaxWidth = (maxWidth != null && maxWidth!.isFinite)
          ? maxWidth!
          : double.infinity;
      final double resolvedMaxHeight =
          (maxHeight != null && maxHeight!.isFinite)
          ? maxHeight!
          : double.infinity;
      finiteConstraints = BoxConstraints(
        minWidth: minWidth ?? 0,
        minHeight: minHeight ?? 0,
        maxWidth: resolvedMaxWidth,
        maxHeight: resolvedMaxHeight,
      );
    }

    final Widget container = Padding(
      padding: margin ?? const EdgeInsets.all(8.0),
      child: Container(
        constraints: finiteConstraints,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: buildContainerContent(),
      ),
    );

    return ErrorBoundary(child: container);
  }
}
