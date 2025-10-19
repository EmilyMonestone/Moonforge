/// Moonforge Hotkey Module (barrel exports)
///
/// One import for the entire hotkey system:
///   import 'package:moonforge/core/services/hotkey/index.dart';
///
/// What this module provides
/// - Data & persistence
///   - HotkeyConfig: Declarative hotkey definition (id, label, keys, action)
///   - HotkeyAction, HotkeyActionType: What should happen on trigger
///   - HotkeyConfigService: Stores user-configurable hotkeys in SharedPreferences
/// - OS-level registration (preferred)
///   - HotkeyManagerService: Registers/unregisters hotkeys using `hotkey_manager`.
/// - Widgets
///   - HotkeyGlobalWrapper: Registers global hotkeys for the whole app
///   - PageHotkeys: Registers hotkeys while a page subtree is mounted
///   - HotkeyGlobal: Legacy Shortcuts/Actions fallback (pure in-app)
///
/// Quick start
/// 1) Wrap your top-level scaffold with HotkeyGlobalWrapper so global hotkeys
///    are registered once:
///
///    Widget build(BuildContext context) {
///      return HotkeyGlobalWrapper(
///        child: AppCommandPalette( // optional but recommended
///          child: YourAppScaffold(...),
///        ),
///      );
///    }
///
/// 2) Ensure the command palette wrapper is present if you plan to trigger it
///    from hotkeys. The default placement is in LayoutShell as AppCommandPalette.
///
/// 3) Add page-specific hotkeys only where needed:
///
///    class SettingsPage extends StatelessWidget {
///      @override
///      Widget build(BuildContext context) {
///        return PageHotkeys(
///          hotkeys: [
///            HotkeyConfig(
///              id: 'settings_refresh',
///              label: 'Refresh settings',
///              keys: ['ctrl', 'shift', 'r'],
///              action: HotkeyAction(
///                type: HotkeyActionType.custom,
///                customAction: () => _refresh(context),
///              ),
///            ),
///          ],
///          child: const SettingsView(),
///        );
///      }
///    }
///
/// Supported key notation
/// - Modifiers: 'ctrl', 'shift', 'alt', 'meta'
/// - Triggers: single letters ('k'), digits ('1'), function keys ('f1'...'f12'),
///   common names ('enter','tab','escape','arrow_left','arrow_right','arrow_up','arrow_down',
///   'home','end','page_up','page_down','space','delete','backspace').
///
/// Behavior & scope
/// - HotkeyManagerService registers with HotKeyScope.inapp by default (active while
///   the app window is focused). You can extend this to system-level later if desired.
/// - On web, `hotkey_manager` is not supported; prefer the legacy HotkeyGlobal if
///   you need purely in-app shortcuts there.
///
/// Persistence
/// - HotkeyConfigService persists a List<HotkeyConfig> to SharedPreferences and
///   exposes defaultShortcuts (Ctrl+K to open Command Palette, Ctrl+H to go home).
/// - You must call HotkeyConfigService.initialize() before reading/writing.
///
/// Navigation & palette integration
/// - Navigate actions use GoRouter (context.go(route)).
/// - Command palette actions expect the AppCommandPalette wrapper in the tree. The
///   hotkey service will request opening the palette with a given action id.
///
/// Best practices
/// - Keep global hotkeys minimal (e.g., open palette, navigate home).
/// - Use PageHotkeys for context-specific actions; set clearExisting: true if a
///   page should temporarily take exclusive control.
/// - Avoid duplicate registration: HotkeyGlobalWrapper already unregisters and
///   re-registers when needed.
/// - Do not edit generated files (*.g.dart); adjust annotations and re-generate.
/// - Do not modify app_command_palette.dart in this step unless you intend to
///   change palette behavior application-wide.
///
/// Troubleshooting
/// - If a hotkey doesn’t fire: check that the app window has focus, verify the key
///   strings are valid, and watch [DEBUG_LOG] output.
/// - On conflicts (another app using the same system-wide shortcut), prefer in-app
///   scope or choose a different combination.
///
/// Re-exports (public API of the module)
library;

export 'hotkey_config.dart';
export 'hotkey_global.dart';
export 'hotkey_global_wrapper.dart';
export 'hotkey_service.dart';
export 'page_hotkeys.dart';
