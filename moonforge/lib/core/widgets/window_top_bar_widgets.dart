import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart';
import 'package:moonforge/core/models/menu_bar_actions.dart' as mb_actions;
import 'package:moonforge/core/widgets/fair_split_row.dart';
import 'package:moonforge/core/widgets/window_top_bar.dart' show kTitleWidth;
import 'package:window_manager/window_manager.dart';

/// Small widget that renders platform window buttons (min/max/close) when
/// running on desktop platforms. Mirrors logic previously in WindowTopBar.
class WindowButtonGroup extends StatelessWidget {
  final Brightness? brightness;

  const WindowButtonGroup({super.key, this.brightness});

  bool get _isDesktop {
    return !(kIsWeb ||
        Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isFuchsia ||
        Platform.isMacOS);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDesktop) return const SizedBox.shrink();

    return Row(
      children: [
        const SizedBox(width: 16),
        WindowCaptionButton.minimize(
          brightness: brightness ?? Theme.of(context).brightness,
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
                brightness: brightness ?? Theme.of(context).brightness,
                onPressed: () {
                  windowManager.unmaximize();
                },
              );
            }
            return WindowCaptionButton.maximize(
              brightness: brightness ?? Theme.of(context).brightness,
              onPressed: () {
                windowManager.maximize();
              },
            );
          },
        ),
        WindowCaptionButton.close(
          brightness: brightness ?? Theme.of(context).brightness,
          onPressed: () {
            windowManager.close();
          },
        ),
      ],
    );
  }
}

/// Builds a ButtonGroupM3E from MenuBarAction items (mapping to ButtonGroupM3EAction)
class ActionGroupM3E extends StatelessWidget {
  final List<mb_actions.MenuBarAction> actions;
  final bool showLabels;

  const ActionGroupM3E({
    super.key,
    required this.actions,
    required this.showLabels,
  });

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();

    final mapped = <ButtonGroupM3EAction>[
      for (final action in actions)
        ButtonGroupM3EAction(
          label: (!showLabels && action.icon != null)
              ? const SizedBox.shrink()
              : Text(action.label),
          icon: action.icon == null
              ? null
              : Tooltip(
                  message: action.helpText ?? action.label,
                  child: Icon(action.icon),
                ),
          onPressed: action.onPressed == null
              ? null
              : () => action.onPressed!(context),
        ),
    ];

    return ButtonGroupM3E(
      actions: mapped,
      shape: ButtonGroupM3EShape.square,
      style: ButtonM3EStyle.tonal,
      expanded: true,
      linearMainAxisAlignment: MainAxisAlignment.end,
    );
  }
}

/// Center area widget used for wide layout. It receives leading/trailing and
/// adapts layout with FairSplitRow or alignment depending on availability.
class WindowCenterArea extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final List<mb_actions.MenuBarAction> actionItems;
  final bool showLabels;

  const WindowCenterArea({
    super.key,
    this.leading,
    this.trailing,
    required this.actionItems,
    required this.showLabels,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available width for breadcrumbs and buttons
        final hasWindowButtons =
            !(kIsWeb ||
                Platform.isAndroid ||
                Platform.isIOS ||
                Platform.isFuchsia ||
                Platform.isMacOS);
        const windowButtonsWidth = (3 * 46) + 16;
        final availableWidth =
            constraints.maxWidth -
            kTitleWidth -
            (hasWindowButtons ? windowButtonsWidth : 0);

        final adaptiveTrailing =
            trailing ??
            (actionItems.isEmpty
                ? const SizedBox.shrink()
                : ActionGroupM3E(actions: actionItems, showLabels: showLabels));

        final hasLeading = leading != null;
        final hasTrailing = trailing != null || actionItems.isNotEmpty;

        Widget centerArea = const SizedBox.shrink();
        if (availableWidth > 0) {
          if (hasLeading && hasTrailing) {
            centerArea = SizedBox(
              width: availableWidth,
              child: FairSplitRow(
                left: leading!,
                right: adaptiveTrailing,
                minLeft: 100,
                minRight: 100,
              ),
            );
          } else if (hasLeading) {
            centerArea = SizedBox(
              width: availableWidth,
              child: Align(alignment: Alignment.centerLeft, child: leading!),
            );
          } else if (hasTrailing) {
            centerArea = SizedBox(
              width: availableWidth,
              child: Align(
                alignment: Alignment.centerRight,
                child: adaptiveTrailing,
              ),
            );
          }
        }

        return centerArea;
      },
    );
  }
}
