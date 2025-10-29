import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/core/models/menu_bar_actions.dart' as mb_actions;
import 'package:moonforge/core/repositories/menu_registry.dart';
import 'package:moonforge/core/widgets/adaptive_button_group.dart';
import 'package:moonforge/gen/assets.gen.dart';
import 'package:window_manager/window_manager.dart';

const double kWindowCaptionHeight = 56;
const double kTitleWidth = 300;

class WindowTopBar extends StatefulWidget {
  const WindowTopBar({
    super.key,
    this.title,
    this.backgroundColor = Colors.transparent,
    this.brightness,
    this.leading,
    this.trailing,
    this.showDragArea = true,
  });

  final Widget? title;
  final Color? backgroundColor;
  final Brightness? brightness;

  final Widget? leading;
  final Widget? trailing;

  final bool showDragArea;

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
    final isCompact = MediaQuery.of(context).size.width < 600;
    final actionItems =
        (MenuRegistry.resolve(context, GoRouterState.of(context).uri) ??
                const <mb_actions.MenuBarAction>[])
            .where((a) => a.onPressed != null)
            .toList();
    final showLabels = !isCompact;

    final buttons =
        (!(kIsWeb ||
            Platform.isAndroid ||
            Platform.isIOS ||
            Platform.isFuchsia ||
            Platform.isMacOS))
        ? Row(
            children: [
              // const SizedBox(
              //   width: 8,
              // ),
              WindowCaptionButton.minimize(
                brightness: widget.brightness ?? Theme.of(context).brightness,
                onPressed: () async {
                  bool isMinimized = await windowManager.isMinimized();
                  if (isMinimized) {
                    windowManager.restore();
                  } else {
                    windowManager.minimize();
                  }
                },
              ),
              FutureBuilder<bool>(
                future: windowManager.isMaximized(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.data == true) {
                    return WindowCaptionButton.unmaximize(
                      brightness:
                          widget.brightness ?? Theme.of(context).brightness,
                      onPressed: () {
                        windowManager.unmaximize();
                      },
                    );
                  }
                  return WindowCaptionButton.maximize(
                    brightness:
                        widget.brightness ?? Theme.of(context).brightness,
                    onPressed: () {
                      windowManager.maximize();
                    },
                  );
                },
              ),
              WindowCaptionButton.close(
                brightness: widget.brightness ?? Theme.of(context).brightness,
                onPressed: () {
                  windowManager.close();
                },
              ),
            ],
          )
        : Container();

    final titleWidget = Container(
      padding: const EdgeInsets.only(left: 4),
      width: kTitleWidth,
      child: Row(
        children: [
          Image.asset(
            Assets.icon.moonforgeLogoPurple.moonforgeLogoPurple256.path,
            height: 40,
          ),
          if (widget.title != null) ...[
            const SizedBox(width: 18),
            widget.title!,
          ],
        ],
      ),
    );

    return SizedBox(
      height:
          ((kIsWeb ||
                  Platform.isAndroid ||
                  Platform.isIOS ||
                  Platform.isFuchsia) &&
              widget.leading == null &&
              widget.trailing == null)
          ? 0
          : isCompact
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
                  isCompact
                      ? Column(
                          children: [
                            SizedBox(
                              height: kWindowCaptionHeight,
                              child: Row(
                                children: [
                                  titleWidget,
                                  const Spacer(),
                                  if (!(kIsWeb ||
                                      Platform.isAndroid ||
                                      Platform.isIOS ||
                                      Platform.isFuchsia ||
                                      Platform.isMacOS))
                                    buttons,
                                ],
                              ),
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
                                        child: AdaptiveButtonGroup(
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

                            // Estimate window button widths (3 buttons × 46px each)
                            const windowButtonsWidth = 138.0;
                            final availableWidth =
                                constraints.maxWidth -
                                kTitleWidth -
                                (hasWindowButtons ? windowButtonsWidth : 0);

                            // Default 50/50 split
                            final halfWidth = availableWidth / 2;

                            // Use adaptive button group when no custom trailing is provided
                            final adaptiveTrailing =
                                widget.trailing ??
                                (actionItems.isEmpty
                                    ? const SizedBox.shrink()
                                    : AdaptiveButtonGroup(
                                        actions: actionItems,
                                        showLabels: showLabels,
                                        maxWidth: halfWidth,
                                      ));

                            return Row(
                              children: [
                                titleWidget,
                                if (widget.leading != null) widget.leading!,
                                Spacer(),
                                if (widget.trailing != null ||
                                    actionItems.isNotEmpty)
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: halfWidth,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: adaptiveTrailing,
                                    ),
                                  ),
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
                                  : AdaptiveButtonGroup(
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
