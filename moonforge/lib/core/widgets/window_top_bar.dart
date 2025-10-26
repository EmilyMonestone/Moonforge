import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m3e_collection/m3e_collection.dart';
import 'package:moonforge/core/models/menu_bar_actions.dart' as mb_actions;
import 'package:moonforge/core/repositories/menu_registry.dart';
import 'package:moonforge/gen/assets.gen.dart';
import 'package:window_manager/window_manager.dart';

const double kWindowCaptionHeight = 56;
const double kTitleWidth = 256;

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
    final Widget trailingWidget =
        widget.trailing ??
        (actionItems.isEmpty
            ? const SizedBox.shrink()
            : ButtonGroupM3E(
                /*                type: ButtonGroupM3EType.connected,*/
                shape: ButtonGroupM3EShape.square,
                children: [
                  for (int i = 0; i < actionItems.length; i++)
                    Tooltip(
                      message: actionItems[i].helpText ?? actionItems[i].label,
                      child: showLabels
                          ? (actionItems[i].icon != null
                                ? ButtonM3E(
                                    onPressed: () {
                                      final cb = actionItems[i].onPressed;
                                      if (cb != null) cb(context);
                                    },
                                    icon: Icon(actionItems[i].icon),
                                    label: Text(actionItems[i].label),
                                    style: ButtonM3EStyle.tonal,
                                    shape: ButtonM3EShape.square,
                                  )
                                : ButtonM3E(
                                    onPressed: () {
                                      final cb = actionItems[i].onPressed;
                                      if (cb != null) cb(context);
                                    },
                                    label: Text(actionItems[i].label),
                                    style: ButtonM3EStyle.tonal,
                                    shape: ButtonM3EShape.square,
                                  ))
                          : (actionItems[i].icon != null
                                ? IconButtonM3E(
                                    onPressed: () {
                                      final cb = actionItems[i].onPressed;
                                      if (cb != null) cb(context);
                                    },
                                    icon: Icon(actionItems[i].icon),
                                  )
                                : TextButton(
                                    onPressed: () {
                                      final cb = actionItems[i].onPressed;
                                      if (cb != null) cb(context);
                                    },
                                    child: Text(actionItems[i].label),
                                  )),
                    ),
                ],
              ));
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

    return SizedBox(
      height:
          ((kIsWeb ||
                  Platform.isAndroid ||
                  Platform.isIOS ||
                  Platform.isFuchsia) &&
              widget.leading == null &&
              widget.trailing == null)
          ? 0
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 4),
                        width: kTitleWidth,
                        child: Row(
                          children: [
                            Image.asset(
                              (Theme.of(context).brightness == Brightness.light)
                                  ? Assets
                                        .icon
                                        .moonforgeLogoDark
                                        .moonforgeLogoDark256
                                        .path
                                  : Assets
                                        .icon
                                        .moonforgeLogoLightAppiconset
                                        .moonforgeLogoLight256
                                        .path,
                              height: 40,
                            ),
                            if (widget.title != null) ...[
                              const SizedBox(width: 18),
                              widget.title!,
                            ],
                          ],
                        ),
                      ),
                      if (widget.leading != null)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: widget.leading!,
                        ),
                      const Spacer(),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: trailingWidget,
                      ),
                      if (!(kIsWeb ||
                          Platform.isAndroid ||
                          Platform.isIOS ||
                          Platform.isFuchsia ||
                          Platform.isMacOS))
                        buttons,
                    ],
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
                          child: trailingWidget,
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
