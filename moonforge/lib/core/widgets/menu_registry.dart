import 'package:flutter/material.dart';
import 'package:moonforge/core/models/actions.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/l10n/app_localizations.dart';

/// Central registry for route-specific menu actions.
///
/// Rules:
/// - Keys are top-level route prefixes (e.g., '/', '/campaign', '/party').
/// - Child routes inherit from their nearest defined parent prefix.
/// - If no specific mapping exists, returns null (no menu displayed).
class MenuRegistry {
  MenuRegistry._();

  static final Map<String, List<MenuBarAction> Function(BuildContext)>
  _registry = {
    '/': _homeMenu,
    // Define other route menus here as needed. Examples (currently placeholders):
    // '/campaign': _campaignMenu,
    // '/party': _partyMenu,
    // '/settings': _settingsMenu,
  };

  /// Resolve menu items for a given [uri].
  ///
  /// Strategy: match by top-level path prefix; if no match, fall back to root.
  static List<MenuBarAction>? resolve(BuildContext context, Uri uri) {
    final segments = uri.pathSegments;
    if (segments.isEmpty) {
      return _registry['/']?.call(context);
    }
    final top = '/${segments.first}';
    final builder = _registry[top] ?? _registry['/'];
    return builder?.call(context);
  }

  /// Menu for the Home route ('/').
  static List<MenuBarAction> _homeMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return <MenuBarAction>[
      MenuBarAction(
        label: l10n.menuContinue,
        helpText: l10n.continueWhereLeft,
        icon: Icons.play_arrow_rounded,
        onPressed: (ctx) {
          // TODO: Navigate to the last visited route from persisted state
          // Example placeholder:
          // const CampaignRoute().go(ctx);
        },
      ),
      MenuBarAction(
        label: l10n.menuNewCampaign,
        helpText: l10n.createNewCampaign,
        icon: Icons.add_box_outlined,
        onPressed: (ctx) {
          // TODO: Implement creation flow; for now navigate to campaign root
          const CampaignRoute().go(ctx);
        },
      ),
      MenuBarAction(
        label: l10n.menuNewParty,
        helpText: l10n.createParty,
        icon: Icons.group_add_outlined,
        onPressed: (ctx) {
          // TODO: Implement party creation (navigate to edit/new flow)
          const PartyRootRoute().go(ctx);
        },
      ),
      MenuBarAction(
        label: l10n.menuNewMonster,
        helpText: l10n.createCustomMonster,
        icon: Icons.android_outlined,
        onPressed: (ctx) {
          // TODO: Implement custom monster creation flow
          // Example: const EntityEditRoute(entityId: 'new').go(ctx);
        },
      ),
    ];
  }

  // Example placeholders for future menus
  // static List<MenuItem> _campaignMenu(BuildContext context) => <MenuItem>[
  //   MenuBarAction(label: AppLocalizations.of(context)!.edit, icon: Icons.edit, onPressed: (ctx) {
  //     const CampaignEditRoute().go(ctx);
  //   }),
  // ];

  // static List<MenuItem> _partyMenu(BuildContext context) => <MenuItem>[];

  // static List<MenuItem> _settingsMenu(BuildContext context) => <MenuItem>[];
}
