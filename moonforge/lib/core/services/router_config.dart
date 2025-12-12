import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/features/adventure/views/adventure_edit_view.dart';
import 'package:moonforge/features/adventure/views/adventure_list_view.dart';
import 'package:moonforge/features/adventure/views/adventure_view.dart';
import 'package:moonforge/features/auth/views/forgot_password_view.dart';
import 'package:moonforge/features/auth/views/login_view.dart';
import 'package:moonforge/features/auth/views/profile_view.dart';
import 'package:moonforge/features/auth/views/register_view.dart';
import 'package:moonforge/features/campaign/views/campaign_analytics_view.dart';
import 'package:moonforge/features/campaign/views/campaign_edit_view.dart';
import 'package:moonforge/features/campaign/views/campaign_list_view.dart';
import 'package:moonforge/features/campaign/views/campaign_members_view.dart';
import 'package:moonforge/features/campaign/views/campaign_settings_view.dart';
import 'package:moonforge/features/campaign/views/campaign_view.dart';
import 'package:moonforge/features/chapter/views/chapter_edit_view.dart';
import 'package:moonforge/features/chapter/views/chapter_list_view.dart';
import 'package:moonforge/features/chapter/views/chapter_view.dart';
import 'package:moonforge/features/encounters/views/encounter_edit_view.dart';
import 'package:moonforge/features/encounters/views/encounter_list_view.dart';
import 'package:moonforge/features/encounters/views/encounter_view.dart';
import 'package:moonforge/features/encounters/views/initiative_tracker_view.dart';
import 'package:moonforge/features/entities/views/entity_edit_view.dart';
import 'package:moonforge/features/entities/views/entity_list_view.dart';
import 'package:moonforge/features/entities/views/entity_view.dart';
import 'package:moonforge/features/home/views/home_view.dart';
import 'package:moonforge/features/open5e_browser/views/open5e_browser_view.dart';
import 'package:moonforge/features/parties/views/member_edit_view.dart';
import 'package:moonforge/features/parties/views/member_view.dart';
import 'package:moonforge/features/parties/views/party_edit_view.dart';
import 'package:moonforge/features/parties/views/party_list_view.dart';
import 'package:moonforge/features/parties/views/party_view.dart';
import 'package:moonforge/features/scene/views/scene_edit_view.dart';
import 'package:moonforge/features/scene/views/scene_list_view.dart';
import 'package:moonforge/features/scene/views/scene_templates_view.dart';
import 'package:moonforge/features/scene/views/scene_view.dart';
import 'package:moonforge/features/session/views/session_edit_view.dart';
import 'package:moonforge/features/session/views/session_list_view.dart';
import 'package:moonforge/features/session/views/session_public_share_view.dart';
import 'package:moonforge/features/session/views/session_view.dart';
import 'package:moonforge/features/settings/views/settings_view.dart';
import 'package:moonforge/layout/layout_shell.dart';

part 'router_config.g.dart';

/// Main shell route with 4 branches: Home, Campaign, Party, Settings
@TypedStatefulShellRoute<AppShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    // Branch 0: Home/Auth
    TypedStatefulShellBranch<HomeBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<HomeRouteData>(
          path: '/',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<LoginRouteData>(
              path: 'login',
              routes: <TypedRoute<RouteData>>[
                TypedGoRoute<RegisterRouteData>(path: 'register'),
                TypedGoRoute<ForgotPasswordRouteData>(path: 'forgot'),
              ],
            ),
          ],
        ),
      ],
    ),
    // Branch 1: Campaigns / Entities / Scenes / Encounters
    TypedStatefulShellBranch<CampaignBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<CampaignsListRouteData>(path: '/campaigns'),
        TypedGoRoute<CampaignRouteData>(
          path: '/campaign',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<CampaignEditRouteData>(path: 'edit'),
            TypedGoRoute<CampaignSettingsRouteData>(path: 'settings'),
            TypedGoRoute<CampaignAnalyticsRouteData>(path: 'analytics'),
            TypedGoRoute<CampaignMembersRouteData>(path: 'members'),
            TypedGoRoute<ChaptersListRouteData>(path: 'chapters'),
            TypedGoRoute<AdventureListRouteData>(path: 'adventures'),
            TypedGoRoute<ChapterRouteData>(
              path: 'chapter/:chapterId',
              routes: <TypedRoute<RouteData>>[
                TypedGoRoute<ChapterEditRouteData>(path: 'edit'),
                TypedGoRoute<AdventureRouteData>(
                  path: 'adventure/:adventureId',
                  routes: <TypedRoute<RouteData>>[
                    TypedGoRoute<AdventureEditRouteData>(path: 'edit'),
                    TypedGoRoute<SceneRouteData>(
                      path: 'scene/:sceneId',
                      routes: <TypedRoute<RouteData>>[
                        TypedGoRoute<SceneEditRouteData>(path: 'edit'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            TypedGoRoute<EncountersListRouteData>(path: 'encounters'),
            TypedGoRoute<ScenesListRouteData>(path: 'scenes'),
            TypedGoRoute<SceneTemplatesRouteData>(path: 'scenes/templates'),
            TypedGoRoute<EncounterRouteData>(
              path: 'encounter/:encounterId',
              routes: <TypedRoute<RouteData>>[
                TypedGoRoute<EncounterEditRouteData>(path: 'edit'),
                TypedGoRoute<InitiativeTrackerRouteData>(path: 'initiative'),
              ],
            ),
            TypedGoRoute<EntitiesListRouteData>(path: 'entities'),
            TypedGoRoute<EntityRouteData>(
              path: 'entity/:entityId',
              routes: <TypedRoute<RouteData>>[
                TypedGoRoute<EntityEditRouteData>(path: 'edit'),
              ],
            ),
          ],
        ),
      ],
    ),
    // Branch 2: Parties / Sessions
    TypedStatefulShellBranch<PartyBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<PartyRootRouteData>(
          path: '/party',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<PartyRouteData>(
              path: ':partyId',
              routes: <TypedRoute<RouteData>>[
                TypedGoRoute<PartyEditRouteData>(path: 'edit'),
                TypedGoRoute<MemberRouteData>(
                  path: 'member/:memberId',
                  routes: <TypedRoute<RouteData>>[
                    TypedGoRoute<MemberEditRouteData>(path: 'edit'),
                  ],
                ),
                TypedGoRoute<SessionListRouteData>(path: 'sessions'),
                TypedGoRoute<SessionRouteData>(
                  path: 'session/:sessionId',
                  routes: <TypedRoute<RouteData>>[
                    TypedGoRoute<SessionEditRouteData>(path: 'edit'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    // Branch 3: Settings / Profile
    TypedStatefulShellBranch<SettingsBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<SettingsRouteData>(path: '/settings'),
        TypedGoRoute<ProfileRouteData>(path: '/profile'),
        TypedGoRoute<Open5eBrowserRouteData>(path: '/open5e-browser'),
      ],
    ),
  ],
)
@immutable
class AppShellRouteData extends StatefulShellRouteData {
  const AppShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return LayoutShell(navigationShell: navigationShell);
  }
}

// Branch Data Classes
@immutable
class HomeBranchData extends StatefulShellBranchData {
  const HomeBranchData();
}

@immutable
class CampaignBranchData extends StatefulShellBranchData {
  const CampaignBranchData();
}

@immutable
class PartyBranchData extends StatefulShellBranchData {
  const PartyBranchData();
}

@immutable
class SettingsBranchData extends StatefulShellBranchData {
  const SettingsBranchData();
}

// Home Branch Routes
@immutable
class HomeRouteData extends GoRouteData with $HomeRouteData {
  const HomeRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeView();
}

@immutable
class LoginRouteData extends GoRouteData with $LoginRouteData {
  const LoginRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginView();
}

@immutable
class RegisterRouteData extends GoRouteData with $RegisterRouteData {
  const RegisterRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RegisterView();
}

@immutable
class ForgotPasswordRouteData extends GoRouteData
    with $ForgotPasswordRouteData {
  const ForgotPasswordRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ForgotPasswordView();
}

// Campaign Branch Routes
@immutable
class CampaignsListRouteData extends GoRouteData with $CampaignsListRouteData {
  const CampaignsListRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignListView();
}

@immutable
class CampaignRouteData extends GoRouteData with $CampaignRouteData {
  const CampaignRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignView();
}

@immutable
class CampaignEditRouteData extends GoRouteData with $CampaignEditRouteData {
  const CampaignEditRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignEditView();
}

@immutable
class CampaignSettingsRouteData extends GoRouteData
    with $CampaignSettingsRouteData {
  const CampaignSettingsRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignSettingsView();
}

@immutable
class CampaignAnalyticsRouteData extends GoRouteData
    with $CampaignAnalyticsRouteData {
  const CampaignAnalyticsRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignAnalyticsView();
}

@immutable
class CampaignMembersRouteData extends GoRouteData
    with $CampaignMembersRouteData {
  const CampaignMembersRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignMembersView();
}

@immutable
class ChaptersListRouteData extends GoRouteData with $ChaptersListRouteData {
  const ChaptersListRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ChapterListView();
}

@immutable
class ChapterRouteData extends GoRouteData with $ChapterRouteData {
  const ChapterRouteData({required this.chapterId});

  final String chapterId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ChapterView(chapterId: chapterId);
}

@immutable
class ChapterEditRouteData extends GoRouteData with $ChapterEditRouteData {
  const ChapterEditRouteData({required this.chapterId});

  final String chapterId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ChapterEditView(chapterId: chapterId);
}

@immutable
class AdventureListRouteData extends GoRouteData with $AdventureListRouteData {
  const AdventureListRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AdventureListView();
}

@immutable
class AdventureRouteData extends GoRouteData with $AdventureRouteData {
  const AdventureRouteData({
    required this.chapterId,
    required this.adventureId,
  });

  final String chapterId;
  final String adventureId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      AdventureView(chapterId: chapterId, adventureId: adventureId);
}

@immutable
class AdventureEditRouteData extends GoRouteData with $AdventureEditRouteData {
  const AdventureEditRouteData({
    required this.chapterId,
    required this.adventureId,
  });

  final String chapterId;
  final String adventureId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      AdventureEditView(chapterId: chapterId, adventureId: adventureId);
}

@immutable
class SceneRouteData extends GoRouteData with $SceneRouteData {
  const SceneRouteData({
    required this.chapterId,
    required this.adventureId,
    required this.sceneId,
  });

  final String chapterId;
  final String adventureId;
  final String sceneId;

  @override
  Widget build(BuildContext context, GoRouterState state) => SceneView(
    chapterId: chapterId,
    adventureId: adventureId,
    sceneId: sceneId,
  );
}

@immutable
class SceneEditRouteData extends GoRouteData with $SceneEditRouteData {
  const SceneEditRouteData({
    required this.chapterId,
    required this.adventureId,
    required this.sceneId,
  });

  final String chapterId;
  final String adventureId;
  final String sceneId;

  @override
  Widget build(BuildContext context, GoRouterState state) => SceneEditView(
    chapterId: chapterId,
    adventureId: adventureId,
    sceneId: sceneId,
  );
}

@immutable
class EncountersListRouteData extends GoRouteData
    with $EncountersListRouteData {
  const EncountersListRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const EncounterListView();
}

@immutable
class ScenesListRouteData extends GoRouteData with $ScenesListRouteData {
  const ScenesListRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SceneListView();
}

@immutable
class SceneTemplatesRouteData extends GoRouteData
    with $SceneTemplatesRouteData {
  const SceneTemplatesRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SceneTemplatesView();
}

@immutable
class EncounterRouteData extends GoRouteData with $EncounterRouteData {
  const EncounterRouteData({required this.encounterId});

  final String encounterId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EncounterView(encounterId: encounterId);
}

@immutable
class EncounterEditRouteData extends GoRouteData with $EncounterEditRouteData {
  const EncounterEditRouteData({required this.encounterId});

  final String encounterId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EncounterEditView(encounterId: encounterId);
}

@immutable
class InitiativeTrackerRouteData extends GoRouteData
    with $InitiativeTrackerRouteData {
  const InitiativeTrackerRouteData({required this.encounterId});

  final String encounterId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const InitiativeTrackerView(
      initialCombatants: [],
      encounterName: 'Initiative Tracker',
    );
  }
}

@immutable
class EntitiesListRouteData extends GoRouteData with $EntitiesListRouteData {
  const EntitiesListRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const EntityListView();
}

@immutable
class EntityRouteData extends GoRouteData with $EntityRouteData {
  const EntityRouteData({required this.entityId});

  final String entityId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EntityView(entityId: entityId);
}

@immutable
class EntityEditRouteData extends GoRouteData with $EntityEditRouteData {
  const EntityEditRouteData({required this.entityId});

  final String entityId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EntityEditView(entityId: entityId);
}

// Party Branch Routes
@immutable
class PartyRootRouteData extends GoRouteData with $PartyRootRouteData {
  const PartyRootRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PartyListView();
}

@immutable
class PartyRouteData extends GoRouteData with $PartyRouteData {
  const PartyRouteData({required this.partyId});

  final String partyId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PartyView(partyId: partyId);
}

@immutable
class PartyEditRouteData extends GoRouteData with $PartyEditRouteData {
  const PartyEditRouteData({required this.partyId});

  final String partyId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PartyEditView(partyId: partyId);
}

@immutable
class MemberRouteData extends GoRouteData with $MemberRouteData {
  const MemberRouteData({required this.partyId, required this.memberId});

  final String partyId;
  final String memberId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MemberView(partyId: partyId, memberId: memberId);
}

@immutable
class MemberEditRouteData extends GoRouteData with $MemberEditRouteData {
  const MemberEditRouteData({required this.partyId, required this.memberId});

  final String partyId;
  final String memberId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MemberEditView(partyId: partyId, memberId: memberId);
}

@immutable
class SessionListRouteData extends GoRouteData with $SessionListRouteData {
  const SessionListRouteData({required this.partyId});

  final String partyId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SessionListView(partyId: partyId);
}

@immutable
class SessionRouteData extends GoRouteData with $SessionRouteData {
  const SessionRouteData({required this.partyId, required this.sessionId});

  final String partyId;
  final String sessionId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SessionView(partyId: partyId, sessionId: sessionId);
}

@immutable
class SessionEditRouteData extends GoRouteData with $SessionEditRouteData {
  const SessionEditRouteData({required this.partyId, required this.sessionId});

  final String partyId;
  final String sessionId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SessionEditView(partyId: partyId, sessionId: sessionId);
}

// Settings Branch Routes
@immutable
class SettingsRouteData extends GoRouteData with $SettingsRouteData {
  const SettingsRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsView();
}

@immutable
class ProfileRouteData extends GoRouteData with $ProfileRouteData {
  const ProfileRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileView();
}

@immutable
class Open5eBrowserRouteData extends GoRouteData
    with $Open5eBrowserRouteData {
  const Open5eBrowserRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const Open5eBrowserView();
}

// Public routes (outside shell)
@TypedGoRoute<SessionPublicShareRouteData>(path: '/share/session/:token')
@immutable
class SessionPublicShareRouteData extends GoRouteData
    with $SessionPublicShareRouteData {
  const SessionPublicShareRouteData({required this.token});

  final String token;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SessionPublicShareView(token: token);
}
