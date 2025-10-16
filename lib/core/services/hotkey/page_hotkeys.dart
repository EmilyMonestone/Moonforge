import 'package:flutter/material.dart';
import 'package:moonforge/core/services/hotkey/hotkey_config.dart';
import 'package:moonforge/core/services/hotkey/hotkey_service.dart';
import 'package:moonforge/core/utils/logger.dart';

/// PageHotkeys registers a set of hotkeys only while the subtree is mounted.
///
/// Use this widget at the top of a page/screen to add page-specific hotkeys
/// without affecting global ones. When the widget is disposed, the registered
/// hotkeys are automatically unregistered.
///
/// Example:
///   return PageHotkeys(
///     hotkeys: [
///       HotkeyConfig(
///         id: 'my_page_action',
///         label: 'Do something on this page',
///         keys: ['ctrl', 'shift', 'p'],
///         action: HotkeyAction(
///           type: HotkeyActionType.custom,
///           customAction: () => doSomething(),
///         ),
///       ),
///     ],
///     child: MyPage(),
///   );
class PageHotkeys extends StatefulWidget {
  final List<HotkeyConfig> hotkeys;
  final Widget child;

  /// If true, existing hotkeys are cleared before registering these.
  /// Leave false to keep global hotkeys active alongside page-specific ones.
  final bool clearExisting;

  const PageHotkeys({
    super.key,
    required this.hotkeys,
    required this.child,
    this.clearExisting = false,
  });

  @override
  State<PageHotkeys> createState() => _PageHotkeysState();
}

class _PageHotkeysState extends State<PageHotkeys> {
  final HotkeyManagerService _manager = HotkeyManagerService();
  final List<String> _registeredIds = [];

  @override
  void initState() {
    super.initState();
    logger.d(
      '[Hotkeys] PageHotkeys.initState (hotkeys: ${widget.hotkeys.length}, clearExisting: ${widget.clearExisting})',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _register());
  }

  @override
  void didUpdateWidget(covariant PageHotkeys oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hotkeys != widget.hotkeys ||
        oldWidget.clearExisting != widget.clearExisting) {
      logger.d(
        '[Hotkeys] PageHotkeys.didUpdateWidget -> will re-register (hotkeys: ${widget.hotkeys.length}, clearExisting: ${widget.clearExisting})',
      );
      _reRegister();
    }
  }

  @override
  void dispose() {
    _unregisterRegistered();
    super.dispose();
  }

  Future<void> _register() async {
    logger.d('[Hotkeys] PageHotkeys._register start');
    if (widget.clearExisting) {
      logger.d('[Hotkeys] PageHotkeys clearing existing hotkeys');
      await _manager.unregisterAll();
    }
    for (final hk in widget.hotkeys) {
      logger.i(
        '[Hotkeys] PageHotkeys registering: ${hk.id} (${hk.keys.join('+')})',
      );
      await _manager.registerShortcut(hk, context: context);
      _registeredIds.add(hk.id);
    }
    logger.d(
      '[Hotkeys] PageHotkeys._register done (count: ${_registeredIds.length})',
    );
  }

  Future<void> _reRegister() async {
    logger.d('[Hotkeys] PageHotkeys._reRegister');
    await _unregisterRegistered();
    await _register();
  }

  Future<void> _unregisterRegistered() async {
    logger.d(
      '[Hotkeys] PageHotkeys._unregisterRegistered (ids: ${_registeredIds.join(', ')})',
    );
    for (final id in _registeredIds) {
      await _manager.unregisterShortcut(id);
    }
    _registeredIds.clear();
    logger.d('[Hotkeys] PageHotkeys._unregisterRegistered done');
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
