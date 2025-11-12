import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/core/design/domain_visuals.dart';
import 'package:moonforge/core/models/domain_type.dart';
import 'package:moonforge/core/models/menu_bar_actions.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/core/services/router_config.dart';
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
import 'package:moonforge/features/encounters/utils/create_encounter_in_adventure.dart';
import 'package:moonforge/features/encounters/utils/create_encounter_in_chapter.dart';
import 'package:moonforge/features/encounters/utils/create_encounter_in_scene.dart';
import 'package:moonforge/features/entities/utils/create_entity.dart'
    as entity_utils;
import 'package:moonforge/features/entities/utils/create_entity_in_adventure.dart';
import 'package:moonforge/features/entities/utils/create_entity_in_chapter.dart';
import 'package:moonforge/features/entities/utils/create_entity_in_scene.dart';
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
    if (segments.length >= 3 &&
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
      browseCampaigns(l10n),
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
      browseEntities(l10n),
      newChapter(l10n),
      newAdventure(l10n),
      newScene(l10n),
      browseEncounters(l10n),
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
      newEntity(l10n),
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

  static MenuBarAction browseCampaigns(AppLocalizations l10n) {
    return MenuBarAction(
      label: l10n.campaigns,
      helpText: 'Browse all campaigns',
      icon: Icons.folder_outlined,
      onPressed: (ctx) {
        const CampaignsListRouteData().go(ctx);
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
        const PartyRootRouteData().go(ctx);
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

        // Determine context by current route to link to correct parent
        final loc = GoRouterState.of(ctx).uri;
        final segs = loc.pathSegments;
        if (segs.length >= 6 &&
            segs[0] == 'campaign' &&
            segs[1] == 'chapter' &&
            segs[3] == 'adventure' &&
            segs[5] == 'scene') {
          final sceneId = segs[6];
          // Prefer the most specific parent: Scene
          createEntityInScene(ctx, campaign, sceneId);
          return;
        }
        if (segs.length >= 4 &&
            segs[0] == 'campaign' &&
            segs[1] == 'chapter' &&
            segs[3] == 'adventure') {
          final adventureId = segs[4];
          createEntityInAdventure(ctx, campaign, adventureId);
          return;
        }
        if (segs.length >= 3 && segs[0] == 'campaign' && segs[1] == 'chapter') {
          final chapterId = segs[2];
          createEntityInChapter(ctx, campaign, chapterId);
          return;
        }

        // Fallback: create as campaign-level entity
        entity_utils.createEntity(ctx, campaign);
      },
    );
  }

  static MenuBarAction browseEntities(AppLocalizations l10n) {
    return MenuBarAction(
      label: l10n.browseEntities,
      helpText: l10n.browseAllEntities,
      icon: Icons.list_alt_outlined,
      onPressed: (ctx) {
        const EntitiesListRouteData().go(ctx);
      },
    );
  }

  static MenuBarAction newChapter(AppLocalizations l10n) {
    return MenuBarAction(
      label: l10n.createChapter,
      icon: DomainType.chapter.icon,
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
      icon: DomainType.adventure.icon,
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
      icon: DomainType.adventure.icon,
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

  static MenuBarAction browseEncounters(AppLocalizations l10n) {
    return MenuBarAction(
      label: 'Browse Encounters',
      helpText: 'View all encounters in the campaign',
      icon: Icons.list_outlined,
      onPressed: (ctx) {
        const EncountersListRouteData().go(ctx);
      },
    );
  }

  static MenuBarAction newEncounter(AppLocalizations l10n) {
    return MenuBarAction(
      label: l10n.createEncounter,
      icon: DomainType.encounter.icon,
      onPressed: (ctx) {
        final campaign = Provider.of<CampaignProvider>(
          ctx,
          listen: false,
        ).currentCampaign;
        if (campaign == null) {
          notification.info(ctx, title: Text(l10n.noCampaignSelected));
          return;
        }

        final loc = GoRouterState.of(ctx).uri;
        final segs = loc.pathSegments;
        if (segs.length >= 6 &&
            segs[0] == 'campaign' &&
            segs[1] == 'chapter' &&
            segs[3] == 'adventure' &&
            segs[5] == 'scene') {
          final chapterId = segs[2];
          final adventureId = segs[4];
          final sceneId = segs[6];
          createEncounterInScene(
            ctx,
            campaign,
            chapterId,
            adventureId,
            sceneId,
          );
          return;
        }
        if (segs.length >= 4 &&
            segs[0] == 'campaign' &&
            segs[1] == 'chapter' &&
            segs[3] == 'adventure') {
          final chapterId = segs[2];
          final adventureId = segs[4];
          createEncounterInAdventure(ctx, campaign, chapterId, adventureId);
          return;
        }
        if (segs.length >= 3 && segs[0] == 'campaign' && segs[1] == 'chapter') {
          final chapterId = segs[2];
          createEncounterInChapter(ctx, campaign, chapterId);
          return;
        }

        // Fallback (campaign-level)
        encounter_utils.createEncounter(ctx, campaign);
      },
    );
  }
}
