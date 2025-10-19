import 'package:flutter/material.dart';
import 'package:moonforge/core/services/hotkey/hotkey_config.dart';
import 'package:moonforge/core/services/hotkey/hotkey_service.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Provides global hotkeys for the entire app using HotkeyManagerService.
///
/// Place this high in the widget tree (e.g., around your App Scaffold) so
/// shortcuts are registered once and remain active while the app is running.
class HotkeyGlobalWrapper extends StatefulWidget {
  final Widget child;

  const HotkeyGlobalWrapper({super.key, required this.child});

  @override
  State<HotkeyGlobalWrapper> createState() => _HotkeyGlobalWrapperState();
}

class _HotkeyGlobalWrapperState extends State<HotkeyGlobalWrapper> {
  final HotkeyConfigService _shortcutService = HotkeyConfigService();
  final HotkeyManagerService _hotkeyService = HotkeyManagerService();
  late List<HotkeyConfig> _shortcuts;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    logger.d('[Hotkeys] HotkeyGlobalWrapper.initState');

    // Add listener to track focus changes
    _focusNode.addListener(_onFocusChange);

    // Initialize hotkey manager
    WidgetsFlutterBinding.ensureInitialized();
    _initializeHotkeys();

    // Request focus when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      logger.d(
        '[Hotkeys] HotkeyGlobalWrapper post-frame callback - requesting focus',
      );
      _focusNode.requestFocus();
    });
  }

  /// Initialize hotkeys
  Future<void> _initializeHotkeys() async {
    try {
      // Initialize services
      await _hotkeyService.initialize();
      await _shortcutService.initialize();

      // Load shortcuts
      _shortcuts = _shortcutService.getShortcuts();
      if (_shortcuts.isEmpty) {
        _shortcuts = _shortcutService.defaultShortcuts;
        await _shortcutService.saveShortcuts(_shortcuts);
      }

      debugPrint('[DEBUG_LOG] Loaded ${_shortcuts.length} shortcuts');

      // We'll register the hotkeys in the build method when we have a BuildContext
    } catch (e) {
      debugPrint('[DEBUG_LOG] Error initializing hotkeys: $e');
    }
  }

  void _onFocusChange() {
    logger.d(
      '[Hotkeys] HotkeyGlobalWrapper focus changed - hasFocus: ${_focusNode.hasFocus}',
    );
  }

  @override
  void dispose() {
    logger.d('[Hotkeys] HotkeyGlobalWrapper.dispose');

    // Unregister all hotkeys
    _hotkeyService
        .unregisterAll()
        .then((_) {
          logger.d('[Hotkeys] All hotkeys unregistered');
        })
        .catchError((error) {
          logger.e('[Hotkeys] Error unregistering hotkeys: $error');
        });

    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('[Hotkeys] HotkeyGlobalWrapper.build');

    // Register hotkeys with the HotkeyManagerService
    _registerHotkeys(context);

    return widget.child;
  }

  /// Register hotkeys with the HotkeyService
  void _registerHotkeys(BuildContext context) {
    // Unregister all existing hotkeys first to avoid duplicates
    _hotkeyService
        .unregisterAll()
        .then((_) {
          logger.d(
            '[Hotkeys] Unregistered existing hotkeys before registering new ones',
          );

          // Register each shortcut
          for (final shortcut in _shortcuts) {
            _hotkeyService
                .registerShortcut(shortcut, context: context)
                .then((_) {
                  logger.i(
                    '[Hotkeys] Registered hotkey: ${shortcut.id} (${shortcut.keys.join('+')})',
                  );
                })
                .catchError((error) {
                  logger.e(
                    '[Hotkeys] Error registering hotkey ${shortcut.id}: $error',
                  );
                });
          }
        })
        .catchError((error) {
          logger.e('[Hotkeys] Error unregistering existing hotkeys: $error');
        });
  }

  // This method has been replaced by the HotkeyService._createHotKey method

  // These methods and classes have been replaced by the HotkeyService
}
