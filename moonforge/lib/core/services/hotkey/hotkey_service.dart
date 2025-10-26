import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/services/hotkey/hotkey_config.dart';
import 'package:moonforge/core/utils/logger.dart';

/// HotkeyManagerService
/// ---------------------
/// Central service that registers/unregisters hotkeys at the OS level using
/// the `hotkey_manager` package. It converts simple HotkeyConfig definitions
/// (like ['ctrl','k']) into platform-aware HotKey instances and executes the
/// configured actions when they fire.
///
/// Notes
/// - Scope is set to inapp by default; you can extend this later to system.
/// - Some platforms (e.g., web) are not supported by hotkey_manager.
/// - Requires a BuildContext at trigger time for actions like navigation.
class HotkeyManagerService {
  /// Singleton instance
  static final HotkeyManagerService _instance =
      HotkeyManagerService._internal();

  /// Factory constructor to return the singleton instance
  factory HotkeyManagerService() => _instance;

  /// Private constructor
  HotkeyManagerService._internal();

  /// Map of registered hotkeys by shortcut ID
  final Map<String, HotKey> _registeredHotkeys = {};

  /// Initialize the hotkey manager.
  ///
  /// Currently clears any previously registered hotkeys to ensure a known
  /// state. Consider adding platform guards if targeting web.
  Future<void> initialize() async {
    // Must add this line to initialize the hotkey manager
    await hotKeyManager.unregisterAll();
  }

  /// Register a Shortcut configuration as an OS-level hotkey.
  ///
  /// Pass the current BuildContext so actions (like navigation) can execute
  /// safely when the hotkey is triggered.
  Future<void> registerShortcut(
    HotkeyConfig shortcut, {
    required BuildContext context,
  }) async {
    try {
      // Convert HotkeyConfig to HotKey
      final hotKey = _createHotKey(shortcut);
      if (hotKey == null) {
        logger.w(
          '[Hotkeys] Failed to create HotKey for shortcut: ${shortcut.id}',
        );
        return;
      }

      // Register the hotkey
      await hotKeyManager.register(
        hotKey,
        keyDownHandler: (hotKey) {
          logger.i(
            '[Hotkeys] Trigger: ${shortcut.id} (${shortcut.keys.join('+')})',
          );
          _executeAction(context, shortcut);
        },
      );

      // Store the registered hotkey
      _registeredHotkeys[shortcut.id] = hotKey;
    } catch (e) {
      logger.e('[Hotkeys] Error registering hotkey: $e');
    }
  }

  /// Unregister a shortcut
  Future<void> unregisterShortcut(String shortcutId) async {
    try {
      final hotKey = _registeredHotkeys[shortcutId];
      if (hotKey != null) {
        await hotKeyManager.unregister(hotKey);
        _registeredHotkeys.remove(shortcutId);
        logger.i('[Hotkeys] Unregistered hotkey: $shortcutId');
      }
    } catch (e) {
      logger.e('[Hotkeys] Error unregistering hotkey: $e');
    }
  }

  /// Unregister all shortcuts
  Future<void> unregisterAll() async {
    try {
      await hotKeyManager.unregisterAll();
      _registeredHotkeys.clear();
    } catch (e) {
      logger.e('[Hotkeys] Error unregistering all hotkeys: $e');
    }
  }

  /// Create a HotKey from a HotkeyConfig
  HotKey? _createHotKey(HotkeyConfig shortcut) {
    try {
      // Extract modifiers and trigger key
      final modifiers = <HotKeyModifier>[];
      String? triggerKey;

      for (final key in shortcut.keys) {
        switch (key.toLowerCase()) {
          case 'ctrl':
            modifiers.add(HotKeyModifier.control);
            break;
          case 'shift':
            modifiers.add(HotKeyModifier.shift);
            break;
          case 'alt':
            modifiers.add(HotKeyModifier.alt);
            break;
          case 'meta':
            modifiers.add(HotKeyModifier.meta);
            break;
          default:
            // The last non-modifier key is the trigger key
            triggerKey = key;
            break;
        }
      }

      if (triggerKey == null) {
        debugPrint(
          '[DEBUG_LOG] No trigger key found for shortcut: ${shortcut.id}',
        );
        return null;
      }

      // Convert trigger key string to PhysicalKeyboardKey
      final physicalKey = getPhysicalKeyFromString(triggerKey);
      if (physicalKey == null) {
        logger.w(
          '[Hotkeys] Failed to convert trigger key to PhysicalKeyboardKey: $triggerKey',
        );
        return null;
      }

      // Create HotKey
      return HotKey(
        key: physicalKey,
        modifiers: modifiers,
        // Use in-app scope by default, can be changed in settings
        scope: HotKeyScope.inapp,
      );
    } catch (e) {
      debugPrint('[DEBUG_LOG] Error creating HotKey: $e');
      return null;
    }
  }

  /// Get PhysicalKeyboardKey from string
  PhysicalKeyboardKey? getPhysicalKeyFromString(String key) {
    // Handle single character keys
    if (key.length == 1) {
      // For letters
      if (RegExp(r'[a-zA-Z]').hasMatch(key)) {
        final char = key.toUpperCase();
        switch (char) {
          case 'A':
            return PhysicalKeyboardKey.keyA;
          case 'B':
            return PhysicalKeyboardKey.keyB;
          case 'C':
            return PhysicalKeyboardKey.keyC;
          case 'D':
            return PhysicalKeyboardKey.keyD;
          case 'E':
            return PhysicalKeyboardKey.keyE;
          case 'F':
            return PhysicalKeyboardKey.keyF;
          case 'G':
            return PhysicalKeyboardKey.keyG;
          case 'H':
            return PhysicalKeyboardKey.keyH;
          case 'I':
            return PhysicalKeyboardKey.keyI;
          case 'J':
            return PhysicalKeyboardKey.keyJ;
          case 'K':
            return PhysicalKeyboardKey.keyK;
          case 'L':
            return PhysicalKeyboardKey.keyL;
          case 'M':
            return PhysicalKeyboardKey.keyM;
          case 'N':
            return PhysicalKeyboardKey.keyN;
          case 'O':
            return PhysicalKeyboardKey.keyO;
          case 'P':
            return PhysicalKeyboardKey.keyP;
          case 'Q':
            return PhysicalKeyboardKey.keyQ;
          case 'R':
            return PhysicalKeyboardKey.keyR;
          case 'S':
            return PhysicalKeyboardKey.keyS;
          case 'T':
            return PhysicalKeyboardKey.keyT;
          case 'U':
            return PhysicalKeyboardKey.keyU;
          case 'V':
            return PhysicalKeyboardKey.keyV;
          case 'W':
            return PhysicalKeyboardKey.keyW;
          case 'X':
            return PhysicalKeyboardKey.keyX;
          case 'Y':
            return PhysicalKeyboardKey.keyY;
          case 'Z':
            return PhysicalKeyboardKey.keyZ;
        }
      }

      // For numbers
      if (RegExp(r'[0-9]').hasMatch(key)) {
        switch (key) {
          case '0':
            return PhysicalKeyboardKey.digit0;
          case '1':
            return PhysicalKeyboardKey.digit1;
          case '2':
            return PhysicalKeyboardKey.digit2;
          case '3':
            return PhysicalKeyboardKey.digit3;
          case '4':
            return PhysicalKeyboardKey.digit4;
          case '5':
            return PhysicalKeyboardKey.digit5;
          case '6':
            return PhysicalKeyboardKey.digit6;
          case '7':
            return PhysicalKeyboardKey.digit7;
          case '8':
            return PhysicalKeyboardKey.digit8;
          case '9':
            return PhysicalKeyboardKey.digit9;
        }
      }
    }

    // Handle named keys
    switch (key.toLowerCase()) {
      case 'f1':
        return PhysicalKeyboardKey.f1;
      case 'f2':
        return PhysicalKeyboardKey.f2;
      case 'f3':
        return PhysicalKeyboardKey.f3;
      case 'f4':
        return PhysicalKeyboardKey.f4;
      case 'f5':
        return PhysicalKeyboardKey.f5;
      case 'f6':
        return PhysicalKeyboardKey.f6;
      case 'f7':
        return PhysicalKeyboardKey.f7;
      case 'f8':
        return PhysicalKeyboardKey.f8;
      case 'f9':
        return PhysicalKeyboardKey.f9;
      case 'f10':
        return PhysicalKeyboardKey.f10;
      case 'f11':
        return PhysicalKeyboardKey.f11;
      case 'f12':
        return PhysicalKeyboardKey.f12;
      case 'enter':
        return PhysicalKeyboardKey.enter;
      case 'space':
        return PhysicalKeyboardKey.space;
      case 'tab':
        return PhysicalKeyboardKey.tab;
      case 'escape':
        return PhysicalKeyboardKey.escape;
      case 'backspace':
        return PhysicalKeyboardKey.backspace;
      case 'delete':
        return PhysicalKeyboardKey.delete;
      case 'home':
        return PhysicalKeyboardKey.home;
      case 'end':
        return PhysicalKeyboardKey.end;
      case 'page_up':
        return PhysicalKeyboardKey.pageUp;
      case 'page_down':
        return PhysicalKeyboardKey.pageDown;
      case 'up':
      case 'arrow_up':
        return PhysicalKeyboardKey.arrowUp;
      case 'down':
      case 'arrow_down':
        return PhysicalKeyboardKey.arrowDown;
      case 'left':
      case 'arrow_left':
        return PhysicalKeyboardKey.arrowLeft;
      case 'right':
      case 'arrow_right':
        return PhysicalKeyboardKey.arrowRight;
    }

    logger.w('[Hotkeys] Unknown key: $key');
    return null;
  }

  /// Navigate using typed routes when possible; fallback to raw path.
  void _navigateTyped(BuildContext context, String route) {
    try {
      // Simple exact matches
      switch (route) {
        case '/':
          const HomeRoute().go(context);
          return;
        case '/login':
          const LoginRoute().go(context);
          return;
        case '/login/register':
          const RegisterRoute().go(context);
          return;
        case '/login/forgot':
          const ForgotPasswordRoute().go(context);
          return;
        case '/campaign':
          const CampaignRoute().go(context);
          return;
        case '/campaign/edit':
          const CampaignEditRoute().go(context);
          return;
        case '/party':
          const PartyRootRoute().go(context);
          return;
        case '/settings':
          const SettingsRoute().go(context);
          return;
      }

      // Entity routes
      final entityEdit = RegExp(r'^/campaign/entity/([^/]+)/edit$');
      final entity = RegExp(r'^/campaign/entity/([^/]+)$');
      final entityEditMatch = entityEdit.firstMatch(route);
      if (entityEditMatch != null) {
        EntityEditRoute(entityId: entityEditMatch.group(1)!).go(context);
        return;
      }
      final entityMatch = entity.firstMatch(route);
      if (entityMatch != null) {
        EntityRoute(entityId: entityMatch.group(1)!).go(context);
        return;
      }

      // Encounter routes
      final encounterEdit = RegExp(r'^/campaign/encounter/([^/]+)/edit$');
      final encounter = RegExp(r'^/campaign/encounter/([^/]+)$');
      final encounterEditMatch = encounterEdit.firstMatch(route);
      if (encounterEditMatch != null) {
        EncounterEditRoute(
          encounterId: encounterEditMatch.group(1)!,
        ).go(context);
        return;
      }
      final encounterMatch = encounter.firstMatch(route);
      if (encounterMatch != null) {
        EncounterRoute(encounterId: encounterMatch.group(1)!).go(context);
        return;
      }

      // Chapter/Adventure/Scene (+ edit) routes
      final chapterEdit = RegExp(r'^/campaign/chapter/([^/]+)/edit$');
      final chapter = RegExp(r'^/campaign/chapter/([^/]+)$');
      final adventureEdit = RegExp(
        r'^/campaign/chapter/([^/]+)/adventure/([^/]+)/edit$',
      );
      final adventure = RegExp(
        r'^/campaign/chapter/([^/]+)/adventure/([^/]+)$',
      );
      final sceneEdit = RegExp(
        r'^/campaign/chapter/([^/]+)/adventure/([^/]+)/scene/([^/]+)/edit$',
      );
      final scene = RegExp(
        r'^/campaign/chapter/([^/]+)/adventure/([^/]+)/scene/([^/]+)$',
      );

      final mChapterEdit = chapterEdit.firstMatch(route);
      if (mChapterEdit != null) {
        ChapterEditRoute(chapterId: mChapterEdit.group(1)!).go(context);
        return;
      }
      final mChapter = chapter.firstMatch(route);
      if (mChapter != null) {
        ChapterRoute(chapterId: mChapter.group(1)!).go(context);
        return;
      }
      final mAdventureEdit = adventureEdit.firstMatch(route);
      if (mAdventureEdit != null) {
        AdventureEditRoute(
          chapterId: mAdventureEdit.group(1)!,
          adventureId: mAdventureEdit.group(2)!,
        ).go(context);
        return;
      }
      final mAdventure = adventure.firstMatch(route);
      if (mAdventure != null) {
        AdventureRoute(
          chapterId: mAdventure.group(1)!,
          adventureId: mAdventure.group(2)!,
        ).go(context);
        return;
      }
      final mSceneEdit = sceneEdit.firstMatch(route);
      if (mSceneEdit != null) {
        SceneEditRoute(
          chapterId: mSceneEdit.group(1)!,
          adventureId: mSceneEdit.group(2)!,
          sceneId: mSceneEdit.group(3)!,
        ).go(context);
        return;
      }
      final mScene = scene.firstMatch(route);
      if (mScene != null) {
        SceneRoute(
          chapterId: mScene.group(1)!,
          adventureId: mScene.group(2)!,
          sceneId: mScene.group(3)!,
        ).go(context);
        return;
      }

      // Party/member/session (+ edit)
      final party = RegExp(r'^/party/([^/]+)$');
      final memberEdit = RegExp(r'^/party/([^/]+)/member/([^/]+)/edit$');
      final member = RegExp(r'^/party/([^/]+)/member/([^/]+)$');
      final sessionEdit = RegExp(r'^/party/([^/]+)/session/([^/]+)/edit$');
      final session = RegExp(r'^/party/([^/]+)/session/([^/]+)$');

      final mParty = party.firstMatch(route);
      if (mParty != null) {
        PartyRoute(partyId: mParty.group(1)!).go(context);
        return;
      }
      final mMemberEdit = memberEdit.firstMatch(route);
      if (mMemberEdit != null) {
        MemberEditRoute(
          partyId: mMemberEdit.group(1)!,
          memberId: mMemberEdit.group(2)!,
        ).go(context);
        return;
      }
      final mMember = member.firstMatch(route);
      if (mMember != null) {
        MemberRoute(
          partyId: mMember.group(1)!,
          memberId: mMember.group(2)!,
        ).go(context);
        return;
      }
      final mSessionEdit = sessionEdit.firstMatch(route);
      if (mSessionEdit != null) {
        SessionEditRoute(
          partyId: mSessionEdit.group(1)!,
          sessionId: mSessionEdit.group(2)!,
        ).go(context);
        return;
      }
      final mSession = session.firstMatch(route);
      if (mSession != null) {
        SessionRoute(
          partyId: mSession.group(1)!,
          sessionId: mSession.group(2)!,
        ).go(context);
        return;
      }

      // Fallback to raw go for unknown routes
      // This preserves behavior for deep links or not-yet-updated paths
      context.go(route);
    } catch (e) {
      logger.e('[Hotkeys] Typed navigation error: $e; falling back to raw go');
      context.go(route);
    }
  }

  /// Execute the action associated with a shortcut
  void _executeAction(BuildContext context, HotkeyConfig shortcut) {
    logger.d('[Hotkeys] Executing action for shortcut: ${shortcut.id}');

    // Try to show a snackbar to indicate that the action is being executed
    // Wrap in try-catch to handle case when ScaffoldMessenger is not available
    try {
      // Check if the context is still valid and has a ScaffoldMessenger ancestor
      if (context.mounted) {
        // Use a safer approach to check for ScaffoldMessenger
        final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
        if (scaffoldMessenger != null) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Executing action for shortcut: ${shortcut.id}'),
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          logger.w('[Hotkeys] ScaffoldMessenger not available for snackbar');
        }
      } else {
        logger.w('[Hotkeys] Context is no longer mounted');
      }
    } catch (e) {
      // Just log the error and continue with the action
      logger.w('[Hotkeys] Error showing snackbar: $e');
    }

    switch (shortcut.action.type) {
      case HotkeyActionType.openCommandPalette:
        logger.d(
          '[Hotkeys] openCommandPalette action: ${shortcut.action.commandPaletteActionId}',
        );
        final actionId = shortcut.action.commandPaletteActionId;
        if (actionId != null) {
          // Programmatic palette open is not wired here; log for now.
          logger.i('[Hotkeys] Open Command Palette action: $actionId');
        } else {
          logger.e('[Hotkeys] commandPaletteActionId is null');
        }
        break;
      case HotkeyActionType.navigate:
        logger.d('[Hotkeys] navigate action route: ${shortcut.action.route}');
        if (shortcut.action.route != null) {
          _navigateTyped(context, shortcut.action.route!);
        } else {
          logger.e('[Hotkeys] route is null');
        }
        break;
      case HotkeyActionType.custom:
        logger.d('[Hotkeys] custom action');
        // Execute the custom action if available
        shortcut.action.customAction?.call();
        break;
    }

    logger.d('[Hotkeys] Action executed for shortcut: ${shortcut.id}');
  }

  /// Convert HotKey to a list of key strings
  List<String> hotKeyToKeysList(HotKey hotKey) {
    final List<String> keys = [];

    // Add modifiers
    for (final modifier in hotKey.modifiers ?? []) {
      switch (modifier) {
        case HotKeyModifier.control:
          keys.add('ctrl');
          break;
        case HotKeyModifier.shift:
          keys.add('shift');
          break;
        case HotKeyModifier.alt:
          keys.add('alt');
          break;
        case HotKeyModifier.meta:
          keys.add('meta');
          break;
        default:
          break;
      }
    }

    // Add trigger key
    final triggerKey = getStringFromKeyboardKey(hotKey.key);
    if (triggerKey != null) {
      keys.add(triggerKey);
    }

    return keys;
  }

  /// Get string representation of a KeyboardKey
  String? getStringFromKeyboardKey(KeyboardKey key) {
    // Try to get a simple string representation of the key
    try {
      // Get the key label or description
      String keyString = key.toString();

      // Extract the key name from the string representation
      if (keyString.contains("'")) {
        // Extract the part between single quotes
        final start = keyString.indexOf("'") + 1;
        final end = keyString.lastIndexOf("'");
        if (start < end) {
          keyString = keyString.substring(start, end);
        }
      }

      // Convert to our standard key format
      keyString = keyString.toLowerCase();

      // Handle special cases
      if (keyString.contains('control')) return 'ctrl';
      if (keyString.contains('shift')) return 'shift';
      if (keyString.contains('alt')) return 'alt';
      if (keyString.contains('meta') ||
          keyString.contains('command') ||
          keyString.contains('super')) {
        return 'meta';
      }

      // Handle arrow keys
      if (keyString.contains('arrow')) {
        if (keyString.contains('up')) return 'up';
        if (keyString.contains('down')) return 'down';
        if (keyString.contains('left')) return 'left';
        if (keyString.contains('right')) return 'right';
        // Remove 'arrow' prefix if present
        return keyString.replaceAll('arrow', '');
      }

      // Handle function keys
      if (keyString.contains('f') &&
          keyString.length <= 3 &&
          RegExp(r'f\d+').hasMatch(keyString)) {
        return keyString; // Already in the right format (f1, f2, etc.)
      }

      // Handle letter keys
      if (keyString.startsWith('key ') && keyString.length > 4) {
        return keyString.substring(keyString.length - 1);
      }

      // Handle digit keys
      if (keyString.startsWith('digit ') && keyString.length > 6) {
        return keyString.substring(keyString.length - 1);
      }

      // Handle other common keys
      switch (keyString) {
        case 'return':
        case 'enter':
          return 'enter';
        case 'space':
          return 'space';
        case 'tab':
          return 'tab';
        case 'escape':
          return 'escape';
        case 'backspace':
          return 'backspace';
        case 'delete':
          return 'delete';
        case 'home':
          return 'home';
        case 'end':
          return 'end';
        case 'page up':
          return 'page_up';
        case 'page down':
          return 'page_down';
      }

      // For other keys, use the key string as is
      return keyString;
    } catch (e) {
      debugPrint('[DEBUG_LOG] Error getting string for key: $e');
      return null;
    }
  }
}
