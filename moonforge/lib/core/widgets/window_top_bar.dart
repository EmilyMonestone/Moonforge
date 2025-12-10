import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/core/models/menu_bar_actions.dart' as mb_actions;
import 'package:moonforge/core/repositories/menu_registry.dart';
import 'package:moonforge/core/widgets/navigation_history_controls.dart';
import 'package:moonforge/core/widgets/window_top_bar_widgets.dart';
import 'package:moonforge/gen/assets.gen.dart';
import 'package:window_manager/window_manager.dart';

const double kWindowCaptionHeight = 56;
const double kTitleWidth = 316;

class WindowTopBar extends StatefulWidget {
  const WindowTopBar({
    super.key,
    this.title,
    this.backgroundColor = Colors.transparent,
    this.brightness,
    this.leading,
    this.trailing,
    this.showDragArea = true,
    this.isCompact = false,
  });

  final Widget? title;
  final Color? backgroundColor;
  final Brightness? brightness;

  final Widget? leading;
  final Widget? trailing;

  final bool showDragArea;
  final bool isCompact;

  @override
  State<WindowTopBar> createState() => _WindowTopBarState();
}

class _WindowTopBarState extends State<WindowTopBar> with WindowListener {
  @override
  void initState() {
    if (!(kIsWeb ||
        Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isFuchsia ||
        Platform.isMacOS)) {
      windowManager.addListener(this);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (!(kIsWeb ||
        Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isFuchsia ||
        Platform.isMacOS)) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actionItems =
        (MenuRegistry.resolve(context, GoRouterState.of(context).uri) ??
                const <mb_actions.MenuBarAction>[])
            .where((a) => a.onPressed != null)
            .toList();
    final showLabels = !widget.isCompact;

    final buttons = WindowButtonGroup(brightness: widget.brightness);

    final titleWidget = Container(
      padding: const EdgeInsets.only(left: 4),
      width: kTitleWidth,
      child: Row(
        children: [
          SizedBox(width: 16),
          Image.asset(
            Assets.icon.moonforgeLogoPurple.moonforgeLogoPurple256.path,
            height: 40,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth <= 0) {
                    return const SizedBox(width: 8);
                  }
                  return ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                    child: NavigationHistoryControls(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );

    final topBarContent = SizedBox(
      height:
          ((kIsWeb ||
                  Platform.isAndroid ||
                  Platform.isIOS ||
                  Platform.isFuchsia) &&
              widget.leading == null &&
              widget.trailing == null)
          ? 0
          : widget.isCompact
          ? kWindowCaptionHeight * 2
          : kWindowCaptionHeight,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color:
              widget.backgroundColor ??
              ((widget.brightness ?? Theme.of(context).brightness) ==
                      Brightness.dark
                  ? const Color(0xff1C1C1C)
                  : Colors.transparent),
        ),
        child: widget.showDragArea
            ? Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DragToMoveArea(
                          child: SizedBox(
                            height: double.infinity,
                            child: Container(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  widget.isCompact
                      ? Column(
                          children: [
                            if (!(kIsWeb ||
                                Platform.isAndroid ||
                                Platform.isIOS ||
                                Platform.isFuchsia ||
                                Platform.isMacOS))
                              SizedBox(
                                height: kWindowCaptionHeight,
                                child: buttons,
                              ),
                            SizedBox(
                              height: kWindowCaptionHeight,
                              child: Row(
                                children: [
                                  if (widget.leading != null) widget.leading!,
                                  const Spacer(),
                                  // Constrain actions to available width and handle overflow
                                  if (widget.trailing != null)
                                    Flexible(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: widget.trailing!,
                                      ),
                                    )
                                  else if (actionItems.isNotEmpty)
                                    Flexible(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: ActionGroupM3E(
                                          actions: actionItems,
                                          showLabels: showLabels,
                                        ),
                                      ),
                                    )
                                  else
                                    const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ],
                        )
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            // Calculate available width for breadcrumbs and buttons
                            final hasWindowButtons =
                                !(kIsWeb ||
                                    Platform.isAndroid ||
                                    Platform.isIOS ||
                                    Platform.isFuchsia ||
                                    Platform.isMacOS);

                            // Estimate window button widths (3 buttons × 46px each + 16px padding)
                            const windowButtonsWidth = (3 * 46) + 16;
                            // WindowCenterArea handles available width allocation.

                            // Build center area using WindowCenterArea (it handles layout)
                            final Widget centerArea = Expanded(
                              child: WindowCenterArea(
                                leading: widget.leading,
                                trailing: widget.trailing,
                                actionItems: actionItems,
                                showLabels: showLabels,
                              ),
                            );

                            return Row(
                              children: [
                                titleWidget,
                                centerArea,
                                if (hasWindowButtons) buttons,
                              ],
                            );
                          },
                        ),
                ],
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Column(
                      children: [
                        if (widget.leading != null)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: widget.leading!,
                          ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child:
                              widget.trailing ??
                              (actionItems.isEmpty
                                  ? const SizedBox.shrink()
                                  : ActionGroupM3E(
                                      actions: actionItems,
                                      showLabels: showLabels,
                                    )),
                        ),
                      ],
                    ),
                    !(kIsWeb ||
                            Platform.isAndroid ||
                            Platform.isIOS ||
                            Platform.isFuchsia ||
                            Platform.isMacOS)
                        ? buttons
                        : Container(),
                  ],
                ),
              ),
      ),
    );

    return Platform.isAndroid
        ? SafeArea(
            top: true,
            bottom: false,
            left: false,
            right: false,
            child: topBarContent,
          )
        : topBarContent;
  }

  @override
  void onWindowMaximize() {
    setState(() {});
  }

  @override
  void onWindowUnmaximize() {
    setState(() {});
  }
}
