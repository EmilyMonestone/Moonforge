import 'package:flutter/material.dart';
import 'package:moonforge/layout/breakpoints.dart';

class TwoPaneLayout extends StatefulWidget {
  const TwoPaneLayout({
    super.key,
    required this.master,
    required this.detail,
    this.showDetail = false,
    this.splitRatio = 0.4,
    this.gap = 1,
    this.useBottomSheetOnCompact = true,
    this.onCloseDetail,
    this.sheetSettings,
  });

  final Widget master;
  final Widget detail;
  final bool showDetail;
  final double splitRatio; // 0..1 fraction for master width
  final double gap;

  /// When true (default), on compact screens the detail shows as a modal
  /// bottom sheet instead of navigating away.
  final bool useBottomSheetOnCompact;

  /// Called when the bottom sheet is dismissed by the user.
  final VoidCallback? onCloseDetail;

  /// Optional settings for the bottom sheet appearance/behavior.
  final BottomSheetSettings? sheetSettings;

  @override
  State<TwoPaneLayout> createState() => _TwoPaneLayoutState();
}

class _TwoPaneLayoutState extends State<TwoPaneLayout>
    with WidgetsBindingObserver {
  bool _sheetOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Defer checking to next frame to avoid triggering sheet during build
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncSheet());
  }

  @override
  void didUpdateWidget(covariant TwoPaneLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showDetail != widget.showDetail ||
        oldWidget.useBottomSheetOnCompact != widget.useBottomSheetOnCompact ||
        oldWidget.detail.runtimeType != widget.detail.runtimeType) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _syncSheet());
    }
  }

  @override
  void didChangeMetrics() {
    // Screen size/orientation changed
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncSheet());
    super.didChangeMetrics();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Let sheet dismiss naturally when widget disposes
    super.dispose();
  }

  bool get _isTwoPaneWide {
    final width = MediaQuery.sizeOf(context).width;
    return AppSizeClass.prefersTwoPane(width);
  }

  bool get _shouldShowBottomSheet =>
      widget.useBottomSheetOnCompact && widget.showDetail && !_isTwoPaneWide;

  Future<void> _syncSheet() async {
    if (!mounted) return;
    if (_shouldShowBottomSheet) {
      if (!_sheetOpen) {
        _sheetOpen = true;
        final settings = widget.sheetSettings ?? const BottomSheetSettings();
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: settings.isScrollControlled,
          useSafeArea: settings.useSafeArea,
          enableDrag: settings.enableDrag,
          showDragHandle: settings.showDragHandle,
          backgroundColor: settings.backgroundColor,
          barrierColor: settings.barrierColor,
          elevation: settings.elevation,
          constraints: settings.constraints,
          isDismissible: settings.isDismissible,
          shape: settings.shape,
          clipBehavior: settings.clipBehavior,
          builder: (ctx) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: settings.initialChildSize,
              minChildSize: settings.minChildSize,
              maxChildSize: settings.maxChildSize,
              builder: (context, scrollController) {
                return Material(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: widget.detail,
                  ),
                );
              },
            );
          },
        );
        // Sheet dismissed
        if (mounted) {
          setState(() => _sheetOpen = false);
          widget.onCloseDetail?.call();
        }
      }
    } else {
      // Close sheet if open (e.g., showDetail=false or resized to wide)
      if (_sheetOpen) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        if (mounted) setState(() => _sheetOpen = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final showSideBySide =
        AppSizeClass.prefersTwoPane(width) && widget.showDetail;

    if (showSideBySide) {
      return Row(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width * widget.splitRatio),
            child: SizedBox(
              width: width * widget.splitRatio,
              child: widget.master,
            ),
          ),
          VerticalDivider(width: widget.gap),
          Expanded(child: widget.detail),
        ],
      );
    }

    // Single-pane mode (compact): we still render the master; detail is provided
    // via a modal bottom sheet if requested and managed by _syncSheet().
    return widget.master;
  }
}

class BottomSheetSettings {
  const BottomSheetSettings({
    this.isScrollControlled = true,
    this.useSafeArea = true,
    this.enableDrag = true,
    this.showDragHandle = true,
    this.backgroundColor,
    this.barrierColor,
    this.elevation,
    this.constraints,
    this.isDismissible = true,
    this.shape,
    this.clipBehavior,
    this.initialChildSize = 0.8,
    this.minChildSize = 0.4,
    this.maxChildSize = 0.95,
  });

  final bool isScrollControlled;
  final bool useSafeArea;
  final bool enableDrag;
  final bool showDragHandle;
  final Color? backgroundColor;
  final Color? barrierColor;
  final double? elevation;
  final BoxConstraints? constraints;
  final bool isDismissible;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
}
