import 'package:command_palette/command_palette.dart' as cp;
import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';

/// Moonforge App Command Palette wrapper.
///
/// Provides a centralized place to define command palette actions for
/// navigation, quick-create, and deep-linking into the app by IDs.
class CommandPalette extends StatefulWidget {
  final Widget child;

  const CommandPalette({super.key, required this.child});

  @override
  State<CommandPalette> createState() => _CommandPaletteState();
}

/// Global key to access the AppCommandPalette state.
final GlobalKey<_CommandPaletteState> appCommandPaletteKey =
    GlobalKey<_CommandPaletteState>();

/// Programmatically execute a command palette action by ID.
void openCommandPalette(String actionId) {
  appCommandPaletteKey.currentState?.openWithAction(actionId);
}

class _CommandPaletteState extends State<CommandPalette> {
  static _CommandPaletteState? _instance;

  late List<cp.CommandPaletteAction> _actions;

  @override
  void initState() {
    super.initState();
    _instance = this;
    _actions = _buildActions();
  }

  @override
  void dispose() {
    if (identical(_instance, this)) {
      _instance = null;
    }
    super.dispose();
  }

  /// Execute an action by its id.
  void openWithAction(String actionId) {
    try {
      final action = _actions.firstWhere(
        (a) => a.id == actionId,
        orElse: () {
          _showSnack('Action not found: $actionId', Colors.red);
          throw Exception('Action not found: $actionId');
        },
      );

      if (action.onSelect != null) {
        action.onSelect!.call();
      } else {
        // For nested actions we simply inform the user; UI will show when palette is opened.
        _showSnack('Open the palette and select: ${action.label}', Colors.blue);
      }
    } catch (e) {
      _showSnack('Error executing command: $e', Colors.red);
    }
  }

  void _showSnack(String message, Color color) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  Future<String?> _promptForInput({
    required String title,
    String? hintText,
  }) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hintText),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  List<cp.CommandPaletteAction> _buildActions() {
    final List<cp.CommandPaletteAction> actions = [
      // Navigation
      cp.CommandPaletteAction.single(
        id: 'nav_home',
        label: 'Home',
        description: 'Go to Home',
        shortcut: const ['ctrl', 'h'],
        leading: const Icon(Icons.home_outlined),
        onSelect: () => const HomeRoute().go(context),
      ),
      cp.CommandPaletteAction.single(
        id: 'nav_campaign',
        label: 'Campaign',
        description: 'Go to Campaign',
        shortcut: const ['ctrl', 'shift', 'c'],
        leading: const Icon(Icons.book_outlined),
        onSelect: () => const CampaignRoute().go(context),
      ),
      cp.CommandPaletteAction.single(
        id: 'nav_party',
        label: 'Party',
        description: 'Go to Party',
        shortcut: const ['ctrl', 'shift', 'p'],
        leading: const Icon(Icons.group_outlined),
        onSelect: () => const PartyRootRoute().go(context),
      ),
      cp.CommandPaletteAction.single(
        id: 'nav_settings',
        label: 'Settings',
        description: 'Go to Settings',
        shortcut: const ['ctrl', 'comma'],
        leading: const Icon(Icons.settings_outlined),
        onSelect: () => const SettingsRoute().go(context),
      ),

      // Create / Edit
      cp.CommandPaletteAction.single(
        id: 'create_campaign',
        label: 'Create or Edit Campaign',
        description: 'Open Campaign editor',
        shortcut: const ['ctrl', 'n', 'c'],
        leading: const Icon(Icons.add_box_outlined),
        onSelect: () => const CampaignEditRoute().go(context),
      ),
      cp.CommandPaletteAction.single(
        id: 'create_encounter',
        label: 'Create Encounter (requires ID prompt)',
        description: 'Open Encounter editor by ID',
        leading: const Icon(Icons.sports_kabaddi_outlined),
        onSelect: () async {
          final id = await _promptForInput(title: 'Encounter ID');
          if (id != null && id.isNotEmpty) {
            EncounterEditRoute(encounterId: id).go(context);
          }
        },
      ),
      cp.CommandPaletteAction.single(
        id: 'create_entity',
        label: 'Create Entity (requires ID prompt)',
        description: 'Open Entity editor by ID',
        leading: const Icon(Icons.extension_outlined),
        onSelect: () async {
          final id = await _promptForInput(title: 'Entity ID');
          if (id != null && id.isNotEmpty) {
            EntityEditRoute(entityId: id).go(context);
          }
        },
      ),
      cp.CommandPaletteAction.nested(
        id: 'create_story',
        label: 'Create Story Item…',
        description: 'Create Chapter, Adventure or Scene',
        leading: const Icon(Icons.add_outlined),
        childrenActions: [
          cp.CommandPaletteAction.single(
            id: 'create_chapter',
            label: 'Create Chapter (ID)',
            description: 'Open Chapter editor by Chapter ID',
            onSelect: () async {
              final chapterId = await _promptForInput(title: 'Chapter ID');
              if (chapterId != null && chapterId.isNotEmpty) {
                ChapterEditRoute(chapterId: chapterId).go(context);
              }
            },
          ),
          cp.CommandPaletteAction.single(
            id: 'create_adventure',
            label: 'Create Adventure (Chapter ID + Adventure ID)',
            description: 'Open Adventure editor',
            onSelect: () async {
              final chapterId = await _promptForInput(title: 'Chapter ID');
              if (chapterId == null || chapterId.isEmpty) return;
              final adventureId = await _promptForInput(title: 'Adventure ID');
              if (adventureId == null || adventureId.isEmpty) return;
              AdventureEditRoute(
                chapterId: chapterId,
                adventureId: adventureId,
              ).go(context);
            },
          ),
          cp.CommandPaletteAction.single(
            id: 'create_scene',
            label: 'Create Scene (Chapter ID + Adventure ID + Scene ID)',
            description: 'Open Scene editor',
            onSelect: () async {
              final chapterId = await _promptForInput(title: 'Chapter ID');
              if (chapterId == null || chapterId.isEmpty) return;
              final adventureId = await _promptForInput(title: 'Adventure ID');
              if (adventureId == null || adventureId.isEmpty) return;
              final sceneId = await _promptForInput(title: 'Scene ID');
              if (sceneId == null || sceneId.isEmpty) return;
              SceneEditRoute(
                chapterId: chapterId,
                adventureId: adventureId,
                sceneId: sceneId,
              ).go(context);
            },
          ),
        ],
      ),

      // Search / Navigate by ID
      cp.CommandPaletteAction.nested(
        id: 'goto',
        label: 'Go to…',
        description: 'Open items by ID',
        leading: const Icon(Icons.search_outlined),
        childrenActions: [
          cp.CommandPaletteAction.single(
            id: 'goto_chapter',
            label: 'Go to Chapter (ID)',
            onSelect: () async {
              final chapterId = await _promptForInput(title: 'Chapter ID');
              if (chapterId != null && chapterId.isNotEmpty) {
                ChapterRoute(chapterId: chapterId).go(context);
              }
            },
          ),
          cp.CommandPaletteAction.single(
            id: 'goto_adventure',
            label: 'Go to Adventure (Chapter ID + Adventure ID)',
            onSelect: () async {
              final chapterId = await _promptForInput(title: 'Chapter ID');
              if (chapterId == null || chapterId.isEmpty) return;
              final adventureId = await _promptForInput(title: 'Adventure ID');
              if (adventureId == null || adventureId.isEmpty) return;
              AdventureRoute(
                chapterId: chapterId,
                adventureId: adventureId,
              ).go(context);
            },
          ),
          cp.CommandPaletteAction.single(
            id: 'goto_scene',
            label: 'Go to Scene (Chapter ID + Adventure ID + Scene ID)',
            onSelect: () async {
              final chapterId = await _promptForInput(title: 'Chapter ID');
              if (chapterId == null || chapterId.isEmpty) return;
              final adventureId = await _promptForInput(title: 'Adventure ID');
              if (adventureId == null || adventureId.isEmpty) return;
              final sceneId = await _promptForInput(title: 'Scene ID');
              if (sceneId == null || sceneId.isEmpty) return;
              SceneRoute(
                chapterId: chapterId,
                adventureId: adventureId,
                sceneId: sceneId,
              ).go(context);
            },
          ),
          cp.CommandPaletteAction.single(
            id: 'goto_entity',
            label: 'Go to Entity (ID)',
            onSelect: () async {
              final entityId = await _promptForInput(title: 'Entity ID');
              if (entityId != null && entityId.isNotEmpty) {
                EntityRoute(entityId: entityId).go(context);
              }
            },
          ),
          cp.CommandPaletteAction.single(
            id: 'goto_encounter',
            label: 'Go to Encounter (ID)',
            onSelect: () async {
              final encounterId = await _promptForInput(title: 'Encounter ID');
              if (encounterId != null && encounterId.isNotEmpty) {
                EncounterRoute(encounterId: encounterId).go(context);
              }
            },
          ),
          cp.CommandPaletteAction.single(
            id: 'goto_party',
            label: 'Go to Party (ID)',
            onSelect: () async {
              final partyId = await _promptForInput(title: 'Party ID');
              if (partyId != null && partyId.isNotEmpty) {
                PartyRoute(partyId: partyId).go(context);
              }
            },
          ),
          cp.CommandPaletteAction.single(
            id: 'goto_session',
            label: 'Go to Session (Party ID + Session ID)',
            onSelect: () async {
              final partyId = await _promptForInput(title: 'Party ID');
              if (partyId == null || partyId.isEmpty) return;
              final sessionId = await _promptForInput(title: 'Session ID');
              if (sessionId == null || sessionId.isEmpty) return;
              SessionRoute(partyId: partyId, sessionId: sessionId).go(context);
            },
          ),
        ],
      ),
    ];

    return actions;
  }

  @override
  Widget build(BuildContext context) {
    _actions = _buildActions();
    return cp.CommandPalette(
      config: cp.CommandPaletteConfig(
        style: cp.CommandPaletteStyle(
          actionColor: Theme.of(context).colorScheme.surfaceContainerLow,
          selectedColor: Theme.of(context).colorScheme.surfaceContainerHigh,
          actionDescriptionTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
          commandPaletteBarrierColor: Colors.black54,
          instructionColor: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        instructionConfig: const cp.CommandPaletteInstructionConfig(
          showInstructions: true,
          confirmLabel: 'Confirm',
          selectLabel: 'Select',
          navigationLabel: 'Navigate',
          cancelSelectedLabel: 'Cancel',
          closeLabel: 'Close',
        ),
        hintText: 'Search or type a command…',
      ),
      actions: _actions,
      child: widget.child,
    );
  }
}
