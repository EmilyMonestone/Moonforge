import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart' show BuildContextM3EX;
import 'package:moonforge/core/widgets/error_boundary.dart';

/// Enum representing different types of surface background colors.
/// This enum is used to specify the type of surface background color
/// to be used in the `SurfaceContainer` widget.
/// Each type corresponds to a specific color from the Material Design color scheme.
enum SurfaceBackgroundType {
  surface,
  surfaceDim,
  surfaceBright,
  surfaceContainer,
  surfaceContainerHigh,
  surfaceContainerHighest,
  surfaceContainerLow,
  surfaceContainerLowest,
  surfaceTint,
}

Color getSurfaceColor(BuildContext context, SurfaceBackgroundType type) {
  switch (type) {
    case SurfaceBackgroundType.surface:
      return Theme.of(context).colorScheme.surface;
    case SurfaceBackgroundType.surfaceDim:
      return Theme.of(context).colorScheme.surfaceDim;
    case SurfaceBackgroundType.surfaceBright:
      return Theme.of(context).colorScheme.surfaceBright;
    case SurfaceBackgroundType.surfaceContainer:
      return Theme.of(context).colorScheme.surfaceContainer;
    case SurfaceBackgroundType.surfaceContainerHigh:
      return Theme.of(context).colorScheme.surfaceContainerHigh;
    case SurfaceBackgroundType.surfaceContainerHighest:
      return Theme.of(context).colorScheme.surfaceContainerHighest;
    case SurfaceBackgroundType.surfaceContainerLow:
      return Theme.of(context).colorScheme.surfaceContainerLow;
    case SurfaceBackgroundType.surfaceContainerLowest:
      return Theme.of(context).colorScheme.surfaceContainerLowest;
    case SurfaceBackgroundType.surfaceTint:
      return Theme.of(context).colorScheme.surfaceTint;
  }
}

/// A container widget that provides a surface-like appearance with optional title and padding.
///
/// This widget is designed to be used as a surface container in the app, providing a consistent look and feel.
/// /// It supports different background types, padding, and optional title with tap handling.
/// /// The container can also be scrollable if needed.
/// Parameters:
/// - [child]: The main content of the container.
/// - [margin]: The margin around the container. Default is [EdgeInsets.all(8.0)].
/// - [padding]: The padding inside the container. Default is [EdgeInsets.all(16.0)].
/// - [backgroundType]: The type of background color to use. Default is [SurfaceBackgroundType.surfaceContainer].
/// - [minWidth]: The minimum width of the container. Default is [0].
/// - [minHeight]: The minimum height of the container. Default is [0].
/// - [maxWidth]: The maximum width of the container. Default is [ double.infinity].
/// - [maxHeight]: The maximum height of the container. Default is [double.infinity].
/// - [withScroll]: Whether the container should be scrollable. Default is [true].
/// - [title]: An optional title widget that appears at the top of the container.
/// - [paddingTitle]: The padding for the title widget. Default is [EdgeInsets.fromLTRB(16, 16, 16, 8)].
/// - [titleOnTap]: A callback function that is called when the title is tapped. Default is [null].
///
/// Simple Usage:
/// ```dart
/// SurfaceContainer(
///  child: Text('Hello, World!'),
///  backgroundType: SurfaceBackgroundType.surfaceContainerHigh,
///  )
///  ```
class SurfaceContainer extends StatelessWidget {
  const SurfaceContainer({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.backgroundType = SurfaceBackgroundType.surfaceContainer,
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
    this.withScroll = true,
    this.title,
    this.paddingTitle,
    this.titleOnTap,
  });

  final Widget child;

  /// default [EdgeInsets.all(8.0)]
  final EdgeInsetsGeometry? margin;

  /// default [EdgeInsets.all(16.0)]
  /// when [title] is not null, default [EdgeInsets.fromLTRB(16, 8, 16, 16)]
  final EdgeInsetsGeometry? padding;

  /// default [EdgeInsets.fromLTRB(16, 16, 16, 8)]
  final EdgeInsetsGeometry? paddingTitle;

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

  /// default [true]
  final bool withScroll;

  /// default [null]
  final Widget? title;

  /// default [null]
  final void Function()? titleOnTap;

  @override
  Widget build(BuildContext context) {
    Color bgColor = getSurfaceColor(context, backgroundType);

    Widget buildContainerContent() {
      if (title == null) {
        return Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: child,
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize:
              MainAxisSize.min, // Force column to only take needed space
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: InkWell(
                onTap: titleOnTap,
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: context.m3e.shapes.square.md.topLeft,
                    topRight: context.m3e.shapes.square.md.topRight,
                  ),
                ),
                child: Padding(
                  padding:
                      paddingTitle ?? const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: title,
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: padding ?? const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: child,
            ),
          ],
        );
      }
    }

    Widget container = Padding(
      padding: margin ?? const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidth ?? 0,
          minHeight: minHeight ?? 0,
          maxWidth: maxWidth ?? double.infinity,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.all(
              context.m3e.shapes.square.md.topLeft,
            ),
          ),
          child: buildContainerContent(),
        ),
      ),
    );

    if (withScroll) {
      return ErrorBoundary(child: SingleChildScrollView(child: container));
    }
    return ErrorBoundary(child: container);
  }
}
