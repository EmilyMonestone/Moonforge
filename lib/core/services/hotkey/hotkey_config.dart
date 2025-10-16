/// Hotkey models and persistence.
///
/// Contains:
/// - HotkeyConfig: declarative hotkey definition (id, label, keys, action).
/// - HotkeyAction/HotkeyActionType: what should happen on trigger.
/// - HotkeyConfigService: simple SharedPreferences-backed storage for user
///   configurable hotkeys, including sensible defaults.
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// A model class for storing keyboard shortcut configurations.
class HotkeyConfig {
  /// The unique identifier for the shortcut.
  final String id;

  /// The human-readable label for the shortcut.
  final String label;

  /// The keys that make up the shortcut (e.g., ['ctrl', 'p']).
  final List<String> keys;

  /// The action to perform when the shortcut is triggered.
  final HotkeyAction action;

  HotkeyConfig({
    required this.id,
    required this.label,
    required this.keys,
    required this.action,
  });

  /// Creates a copy of this HotkeyConfig with the given fields replaced with new values.
  HotkeyConfig copyWith({
    String? id,
    String? label,
    List<String>? keys,
    HotkeyAction? action,
  }) {
    return HotkeyConfig(
      id: id ?? this.id,
      label: label ?? this.label,
      keys: keys ?? this.keys,
      action: action ?? this.action,
    );
  }

  /// Converts this HotkeyConfig to a Map.
  Map<String, dynamic> toMap() {
    return {'id': id, 'label': label, 'keys': keys, 'action': action.toMap()};
  }

  /// Creates a HotkeyConfig from a Map.
  factory HotkeyConfig.fromMap(Map<String, dynamic> map) {
    return HotkeyConfig(
      id: map['id'],
      label: map['label'],
      keys: List<String>.from(map['keys']),
      action: HotkeyAction.fromMap(map['action']),
    );
  }

  /// Converts this HotkeyConfig to a JSON string.
  String toJson() => json.encode(toMap());

  /// Creates a HotkeyConfig from a JSON string.
  factory HotkeyConfig.fromJson(String source) =>
      HotkeyConfig.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HotkeyConfig(id: $id, label: $label, keys: $keys, action: $action)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! HotkeyConfig) return false;

    if (other.id != id || other.label != label || other.action != action) {
      return false;
    }

    // Compare lists manually
    if (other.keys.length != keys.length) return false;
    for (int i = 0; i < keys.length; i++) {
      if (other.keys[i] != keys[i]) return false;
    }

    return true;
  }

  @override
  int get hashCode {
    return id.hashCode ^ label.hashCode ^ keys.hashCode ^ action.hashCode;
  }
}

/// The type of action to perform when a shortcut is triggered.
enum HotkeyActionType {
  /// Open the command palette with a specific action selected.
  openCommandPalette,

  /// Navigate to a specific route.
  navigate,

  /// Execute a custom action.
  custom,
}

/// A model class for storing shortcut actions.
class HotkeyAction {
  /// The type of action to perform.
  final HotkeyActionType type;

  /// The ID of the command palette action to select (for openCommandPalette type).
  final String? commandPaletteActionId;

  /// The route to navigate to (for navigate type).
  final String? route;

  /// A custom action to execute (for custom type).
  final Function? customAction;

  HotkeyAction({
    required this.type,
    this.commandPaletteActionId,
    this.route,
    this.customAction,
  }) : assert(
         (type == HotkeyActionType.openCommandPalette &&
                 commandPaletteActionId != null) ||
             (type == HotkeyActionType.navigate && route != null) ||
             (type == HotkeyActionType.custom && customAction != null),
         'Action parameters must match the action type',
       );

  /// Creates a copy of this ShortcutAction with the given fields replaced with the new values.
  HotkeyAction copyWith({
    HotkeyActionType? type,
    String? commandPaletteActionId,
    String? route,
    Function? customAction,
  }) {
    return HotkeyAction(
      type: type ?? this.type,
      commandPaletteActionId:
          commandPaletteActionId ?? this.commandPaletteActionId,
      route: route ?? this.route,
      customAction: customAction ?? this.customAction,
    );
  }

  /// Converts this ShortcutAction to a Map.
  Map<String, dynamic> toMap() {
    return {
      'type': type.index,
      'commandPaletteActionId': commandPaletteActionId,
      'route': route,
      // Note: customAction cannot be serialized, so it's not included in the map
    };
  }

  /// Creates a ShortcutAction from a Map.
  factory HotkeyAction.fromMap(Map<String, dynamic> map) {
    return HotkeyAction(
      type: HotkeyActionType.values[map['type']],
      commandPaletteActionId: map['commandPaletteActionId'],
      route: map['route'],
      // Note: customAction cannot be deserialized, so it's not included
    );
  }

  @override
  String toString() {
    return 'ShortcutAction(type: $type, commandPaletteActionId: $commandPaletteActionId, route: $route)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HotkeyAction &&
        other.type == type &&
        other.commandPaletteActionId == commandPaletteActionId &&
        other.route == route;
  }

  @override
  int get hashCode {
    return type.hashCode ^ commandPaletteActionId.hashCode ^ route.hashCode;
  }
}

/// Persists user-configurable hotkeys and provides defaults.
///
/// Uses SharedPreferences for simple persistence. This service does not
/// register OS-level hotkeys; see HotkeyManagerService for that.
class HotkeyConfigService {
  static const String _prefKey = 'shortcuts';
  late final SharedPreferences prefs;

  /// Initializes HotkeyConfigService with SharedPreferences instance.
  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  /// Gets all shortcut configurations.
  List<HotkeyConfig> getShortcuts() {
    final List<String> shortcutsJson = prefs.getStringList(_prefKey) ?? [];
    return shortcutsJson.map((json) => HotkeyConfig.fromJson(json)).toList();
  }

  /// Saves all shortcut configurations.
  Future<void> saveShortcuts(List<HotkeyConfig> shortcuts) async {
    await prefs.setStringList(
      _prefKey,
      shortcuts.map((shortcut) => shortcut.toJson()).toList(),
    );
  }

  /// Gets a shortcut configuration by ID.
  HotkeyConfig? getShortcutById(String id) {
    final shortcuts = getShortcuts();
    return shortcuts.firstWhere(
      (shortcut) => shortcut.id == id,
      orElse: () => throw Exception('Shortcut not found: $id'),
    );
  }

  /// Updates a shortcut configuration.
  Future<void> updateShortcut(HotkeyConfig shortcut) async {
    final shortcuts = getShortcuts();
    final index = shortcuts.indexWhere((s) => s.id == shortcut.id);
    if (index >= 0) {
      shortcuts[index] = shortcut;
      await saveShortcuts(shortcuts);
    } else {
      throw Exception('Shortcut not found: ${shortcut.id}');
    }
  }

  /// Adds a new shortcut configuration.
  Future<void> addShortcut(HotkeyConfig shortcut) async {
    final shortcuts = getShortcuts();
    shortcuts.add(shortcut);
    await saveShortcuts(shortcuts);
  }

  /// Removes a shortcut configuration.
  Future<void> removeShortcut(String id) async {
    final shortcuts = getShortcuts();
    shortcuts.removeWhere((shortcut) => shortcut.id == id);
    await saveShortcuts(shortcuts);
  }

  /// Resets all shortcut configurations to their default values.
  Future<void> resetToDefaults() async {
    await saveShortcuts(defaultShortcuts);
  }

  /// Gets the default shortcut configurations.
  List<HotkeyConfig> get defaultShortcuts => [
    HotkeyConfig(
      id: 'open_command_palette',
      label: 'Open Command Palette',
      keys: ['ctrl', 'k'],
      action: HotkeyAction(
        type: HotkeyActionType.openCommandPalette,
        commandPaletteActionId: 'default',
      ),
    ),
    HotkeyConfig(
      id: 'navigate_home',
      label: 'Go to Home',
      keys: ['ctrl', 'h'],
      action: HotkeyAction(type: HotkeyActionType.navigate, route: '/'),
    ),
  ];
}
