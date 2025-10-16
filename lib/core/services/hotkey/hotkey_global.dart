import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moonforge/core/services/hotkey/hotkey_config.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Legacy Shortcuts/Actions-based global hotkeys (in-app only).
///
/// Prefer using HotkeyGlobalWrapper + HotkeyManagerService for OS-level
/// registration. Keep this as a fallback if Shortcuts/Actions are desired
/// or when hotkey_manager is not supported.
class HotkeyGlobal extends StatefulWidget {
  final Widget child;

  const HotkeyGlobal({super.key, required this.child});

  @override
  State<HotkeyGlobal> createState() => _HotkeyGlobalState();
}

class _HotkeyGlobalState extends State<HotkeyGlobal> {
  final HotkeyConfigService _shortcutService = HotkeyConfigService();
  late List<HotkeyConfig> _shortcuts;

  @override
  void initState() {
    super.initState();
    _shortcuts = _shortcutService.getShortcuts();
    if (_shortcuts.isEmpty) {
      _shortcuts = _shortcutService.defaultShortcuts;
      _shortcutService.saveShortcuts(_shortcuts);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a map of shortcuts to intents
    final Map<ShortcutActivator, Intent> shortcuts = {};

    for (final shortcut in _shortcuts) {
      final activator = _buildShortcutActivator(shortcut.keys);
      if (activator != null) {
        shortcuts[activator] = ShortcutIntent(shortcut);
      }
    }

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: <Type, Action<Intent>>{
          ShortcutIntent: ShortcutAction(
            openCommandPalette: _openCommandPalette,
            navigate: _navigate,
          ),
        },
        child: widget.child,
      ),
    );
  }

  /// Builds a ShortcutActivator from a list of key strings.
  ShortcutActivator? _buildShortcutActivator(List<String> keys) {
    if (keys.isEmpty) return null;

    final Set<LogicalKeyboardKey> logicalKeys = {};
    String? triggerKey;

    for (final key in keys) {
      switch (key.toLowerCase()) {
        case 'ctrl':
          logicalKeys.add(LogicalKeyboardKey.control);
          break;
        case 'shift':
          logicalKeys.add(LogicalKeyboardKey.shift);
          break;
        case 'alt':
          logicalKeys.add(LogicalKeyboardKey.alt);
          break;
        case 'meta':
          logicalKeys.add(LogicalKeyboardKey.meta);
          break;
        default:
          // The last non-modifier key is the trigger key
          triggerKey = key;
          break;
      }
    }

    if (triggerKey == null) return null;

    // Convert the trigger key string to a LogicalKeyboardKey
    LogicalKeyboardKey? triggerLogicalKey;
    if (triggerKey.length == 1) {
      // For single character keys, use the character code
      triggerLogicalKey = LogicalKeyboardKey(
        triggerKey.toUpperCase().codeUnitAt(0),
      );
    } else {
      // For named keys, try to find the corresponding LogicalKeyboardKey
      switch (triggerKey.toLowerCase()) {
        case 'f1':
          triggerLogicalKey = LogicalKeyboardKey.f1;
          break;
        case 'f2':
          triggerLogicalKey = LogicalKeyboardKey.f2;
          break;
        case 'f3':
          triggerLogicalKey = LogicalKeyboardKey.f3;
          break;
        case 'f4':
          triggerLogicalKey = LogicalKeyboardKey.f4;
          break;
        case 'f5':
          triggerLogicalKey = LogicalKeyboardKey.f5;
          break;
        case 'f6':
          triggerLogicalKey = LogicalKeyboardKey.f6;
          break;
        case 'f7':
          triggerLogicalKey = LogicalKeyboardKey.f7;
          break;
        case 'f8':
          triggerLogicalKey = LogicalKeyboardKey.f8;
          break;
        case 'f9':
          triggerLogicalKey = LogicalKeyboardKey.f9;
          break;
        case 'f10':
          triggerLogicalKey = LogicalKeyboardKey.f10;
          break;
        case 'f11':
          triggerLogicalKey = LogicalKeyboardKey.f11;
          break;
        case 'f12':
          triggerLogicalKey = LogicalKeyboardKey.f12;
          break;
        case 'enter':
          triggerLogicalKey = LogicalKeyboardKey.enter;
          break;
        case 'space':
          triggerLogicalKey = LogicalKeyboardKey.space;
          break;
        case 'tab':
          triggerLogicalKey = LogicalKeyboardKey.tab;
          break;
        case 'escape':
          triggerLogicalKey = LogicalKeyboardKey.escape;
          break;
        case 'backspace':
          triggerLogicalKey = LogicalKeyboardKey.backspace;
          break;
        case 'delete':
          triggerLogicalKey = LogicalKeyboardKey.delete;
          break;
        case 'home':
          triggerLogicalKey = LogicalKeyboardKey.home;
          break;
        case 'end':
          triggerLogicalKey = LogicalKeyboardKey.end;
          break;
        case 'page_up':
          triggerLogicalKey = LogicalKeyboardKey.pageUp;
          break;
        case 'page_down':
          triggerLogicalKey = LogicalKeyboardKey.pageDown;
          break;
        case 'arrow_left':
          triggerLogicalKey = LogicalKeyboardKey.arrowLeft;
          break;
        case 'arrow_right':
          triggerLogicalKey = LogicalKeyboardKey.arrowRight;
          break;
        case 'arrow_up':
          triggerLogicalKey = LogicalKeyboardKey.arrowUp;
          break;
        case 'arrow_down':
          triggerLogicalKey = LogicalKeyboardKey.arrowDown;
          break;
        default:
          // Try to use the key as is
          triggerLogicalKey = LogicalKeyboardKey(
            triggerKey.toUpperCase().codeUnitAt(0),
          );
          break;
      }
    }

    logicalKeys.add(triggerLogicalKey);
    return LogicalKeySet.fromSet(logicalKeys);
  }

  /// Opens the command palette with the specified action.
  void _openCommandPalette(BuildContext context, String actionId) {
    // TODO(Junie): Wire this to CommandPalette programmatic open if available.
    logger.i(
      '[Hotkeys] Request to open Command Palette with actionId: $actionId',
    );
  }

  /// Navigates to the specified route.
  void _navigate(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }
}

/// An intent that represents a shortcut action.
class ShortcutIntent extends Intent {
  final HotkeyConfig shortcut;

  const ShortcutIntent(this.shortcut);
}

/// An action that handles shortcut intents.
class ShortcutAction extends Action<ShortcutIntent> {
  final void Function(BuildContext, String) openCommandPalette;
  final void Function(BuildContext, String) navigate;

  ShortcutAction({required this.openCommandPalette, required this.navigate});

  @override
  Object? invoke(ShortcutIntent intent) {
    final context = primaryFocus?.context;
    if (context == null) return null;

    switch (intent.shortcut.action.type) {
      case HotkeyActionType.openCommandPalette:
        if (intent.shortcut.action.commandPaletteActionId != null) {
          openCommandPalette(
            context,
            intent.shortcut.action.commandPaletteActionId!,
          );
        }
        break;
      case HotkeyActionType.navigate:
        if (intent.shortcut.action.route != null) {
          navigate(context, intent.shortcut.action.route!);
        }
        break;
      case HotkeyActionType.custom:
        // Custom actions are not supported in this implementation
        break;
    }

    return null;
  }
}
