import 'package:flutter/material.dart';
import 'package:moonforge/core/models/menu_bar_actions.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/features/adventure/utils/create_adventure.dart'
    as adventure_utils;
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/campaign/utils/create_campaign.dart';
import 'package:moonforge/features/chapter/utils/create_adventure_in_chapter.dart';
import 'package:moonforge/features/chapter/utils/create_chapter.dart'
    as chapter_utils;
import 'package:moonforge/features/chapter/utils/create_scene_in_chapter.dart';
import 'package:moonforge/features/encounters/utils/create_encounter.dart'
    as encounter_utils;
import 'package:moonforge/features/entities/utils/create_entity.dart'
    as entity_utils;
import 'package:moonforge/features/scene/utils/create_scene.dart'
    as scene_utils;
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
    '/campaign': _campaignMenu,
    // Define other route menus here as needed. Examples (currently placeholders):
    // '/party': _partyMenu,
    // '/settings': _settingsMenu,
  };

  /// Resolve menu items for a given [uri].
  ///
  /// Strategy: match by top-level path prefix or specific route patterns.
  /// Special handling for scene routes to provide scene-specific menus.
  static List<MenuBarAction>? resolve(BuildContext context, Uri uri) {
    final segments = uri.pathSegments;
    if (segments.isEmpty) {
      return _registry['/']?.call(context);
    }

    // Check for scene route pattern: /campaign/chapter/.../adventure/.../scene/...
    if (segments.length >= 6 &&
        segments[0] == 'campaign' &&
        segments[1] == 'chapter' &&
        segments[3] == 'adventure' &&
        segments[5] == 'scene') {
      return _sceneMenu(context);
    }

    // Check for adventure route pattern: /campaign/chapter/:chapterId/adventure/:adventureId
    if (segments.length >= 4 &&
        segments[0] == 'campaign' &&
        segments[1] == 'chapter' &&
        segments[3] == 'adventure') {
      return _adventureMenu(context);
    }

    // Check for chapter context: /campaign/chapter/:chapterId
    if (segments.length >= 2 &&
        segments[0] == 'campaign' &&
        segments[1] == 'chapter') {
      final chapterId = segments[2];
      return _chapterMenu(context, chapterId);
    }

    final top = '/${segments.first}';
    final builder = _registry[top] ?? _registry['/'];
    return builder?.call(context);
  }

  // ------ Menus ------

  /// Menu for the Home route ('/').
  static List<MenuBarAction> _homeMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return <MenuBarAction>[
      continueWhereLeft(l10n),
      newCampaign(l10n, context),
      newParty(l10n),
      newEntity(l10n),
    ];
  }

  /// Menu for the Campaign route ('/campaign').
  static List<MenuBarAction> _campaignMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return <MenuBarAction>[
      continueWhereLeft(l10n),
      newChapter(l10n),
      newAdventure(l10n),
      newScene(l10n),
      newEncounter(l10n),
      newEntity(l10n),
    ];
  }

  /// Menu for the Chapter route ('/campaign/chapter/:chapterId').
  static List<MenuBarAction> _chapterMenu(
    BuildContext context,
    String chapterId,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return <MenuBarAction>[
      continueWhereLeft(l10n),
      newAdventureInChapter(l10n, chapterId),
      newSceneInChapter(l10n, chapterId),
      newEntity(l10n),
    ];
  }

  /// Menu for the Adventure route ('/campaign/chapter/:chapterId/adventure/:adventureId').
  static List<MenuBarAction> _adventureMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return <MenuBarAction>[
      continueWhereLeft(l10n),
      newScene(l10n),
      newEncounter(l10n),
    ];
  }

  // ------ MenuBarActions ------

  /// Menu for Scene routes ('/campaign/chapter/.../adventure/.../scene/...').
  static List<MenuBarAction> _sceneMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return <MenuBarAction>[newEntity(l10n)];
  }

  static MenuBarAction continueWhereLeft(AppLocalizations l10n) {
    return MenuBarAction(
      label: l10n.menuContinue,
      helpText: l10n.continueWhereLeft,
      icon: Icons.play_arrow_rounded,
      onPressed: (ctx) {
        // TODO: Navigate to the last visited route from persisted state
      },
    );
  }

  static MenuBarAction newCampaign(
    AppLocalizations l10n,
    BuildContext context,
  ) {
    return MenuBarAction(
      label: l10n.menuNewCampaign,
      helpText: l10n.createNewCampaign,
      icon: Icons.add_box_outlined,
      onPressed: (ctx) {
        createCampaignAndOpenEditor(context);
      },
    );
  }

  static MenuBarAction newParty(AppLocalizations l10n) {
    return MenuBarAction(
      label: l10n.menuNewParty,
      helpText: l10n.createParty,
      icon: Icons.group_add_outlined,
      onPressed: (ctx) {
        // TODO: Implement party creation (navigate to edit/new flow)
        const PartyRootRoute().go(ctx);
      },
    );
  }

  static MenuBarAction newEntity(AppLocalizations l10n) {
    return MenuBarAction(
      label: l10n.createEntity,
      icon: Icons.category_outlined,
      onPressed: (ctx) {
        final campaign = Provider.of<CampaignProvider>(
          ctx,
          listen: false,
        ).currentCampaign;
        if (campaign == null) {
          notification.info(ctx, title: Text(l10n.noCampaignSelected));
          return;
        }
        entity_utils.createEntity(ctx, campaign);
      },
    );
  }

  static MenuBarAction newChapter(AppLocalizations l10n) {
    return MenuBarAction(
      label: l10n.createChapter,
      icon: Icons.library_books_outlined,
      onPressed: (ctx) {
        final campaign = Provider.of<CampaignProvider>(
          ctx,
          listen: false,
        ).currentCampaign;
        if (campaign == null) {
          notification.info(ctx, title: Text(l10n.noCampaignSelected));
          return;
        }
        chapter_utils.createChapter(ctx, campaign);
      },
    );
  }

  static MenuBarAction newAdventure(AppLocalizations l10n) {
    return MenuBarAction(
      label: l10n.createAdventure,
      icon: Icons.auto_stories_outlined,
      onPressed: (ctx) {
        final campaign = Provider.of<CampaignProvider>(
          ctx,
          listen: false,
        ).currentCampaign;
        if (campaign == null) {
          notification.info(ctx, title: Text(l10n.noCampaignSelected));
          return;
        }
        adventure_utils.createAdventure(ctx, campaign);
      },
    );
  }

  static MenuBarAction newScene(AppLocalizations l10n) {
    return MenuBarAction(
      label: l10n.createScene,
      icon: Icons.movie_outlined,
      onPressed: (ctx) {
        final campaign = Provider.of<CampaignProvider>(
          ctx,
          listen: false,
        ).currentCampaign;
        if (campaign == null) {
          notification.info(ctx, title: Text(l10n.noCampaignSelected));
          return;
        }
        scene_utils.createScene(ctx, campaign);
      },
    );
  }

  static MenuBarAction newAdventureInChapter(
    AppLocalizations l10n,
    String chapterId,
  ) {
    return MenuBarAction(
      label: l10n.createAdventure,
      icon: Icons.auto_stories_outlined,
      onPressed: (ctx) {
        final campaign = Provider.of<CampaignProvider>(
          ctx,
          listen: false,
        ).currentCampaign;
        if (campaign == null) {
          notification.info(ctx, title: Text(l10n.noCampaignSelected));
          return;
        }
        createAdventureInChapter(ctx, campaign, chapterId);
      },
    );
  }

  static MenuBarAction newSceneInChapter(
    AppLocalizations l10n,
    String chapterId,
  ) {
    return MenuBarAction(
      label: l10n.createScene,
      icon: Icons.movie_outlined,
      onPressed: (ctx) {
        final campaign = Provider.of<CampaignProvider>(
          ctx,
          listen: false,
        ).currentCampaign;
        if (campaign == null) {
          notification.info(ctx, title: Text(l10n.noCampaignSelected));
          return;
        }
        createSceneInChapter(ctx, campaign, chapterId);
      },
    );
  }

  static MenuBarAction newEncounter(AppLocalizations l10n) {
    return MenuBarAction(
      label: l10n.createEncounter,
      icon: Icons.shield_outlined,
      onPressed: (ctx) {
        final campaign = Provider.of<CampaignProvider>(
          ctx,
          listen: false,
        ).currentCampaign;
        if (campaign == null) {
          notification.info(ctx, title: Text(l10n.noCampaignSelected));
          return;
        }
        encounter_utils.createEncounter(ctx, campaign);
      },
    );
  }
}
