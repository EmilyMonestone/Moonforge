import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/features/adventure/views/adventure_edit_screen.dart';
import 'package:moonforge/features/adventure/views/adventure_list_screen.dart';
import 'package:moonforge/features/adventure/views/adventure_screen.dart';
import 'package:moonforge/features/auth/views/forgot_password_screen.dart';
import 'package:moonforge/features/auth/views/login_screen.dart';
import 'package:moonforge/features/auth/views/profile_screen.dart';
import 'package:moonforge/features/auth/views/register_screen.dart';
import 'package:moonforge/features/campaign/views/campaign_analytics_screen.dart';
import 'package:moonforge/features/campaign/views/campaign_edit_screen.dart';
import 'package:moonforge/features/campaign/views/campaign_list_screen.dart';
import 'package:moonforge/features/campaign/views/campaign_members_screen.dart';
import 'package:moonforge/features/campaign/views/campaign_screen.dart';
import 'package:moonforge/features/campaign/views/campaign_settings_screen.dart';
import 'package:moonforge/features/chapter/views/chapter_edit_screen.dart';
import 'package:moonforge/features/chapter/views/chapter_list_screen.dart';
import 'package:moonforge/features/chapter/views/chapter_screen.dart';
import 'package:moonforge/features/encounters/views/encounter_edit_screen.dart';
import 'package:moonforge/features/encounters/views/encounter_list_screen.dart';
import 'package:moonforge/features/encounters/views/encounter_screen.dart';
import 'package:moonforge/features/encounters/views/initiative_tracker_screen.dart';
import 'package:moonforge/features/entities/views/entity_edit_screen.dart';
import 'package:moonforge/features/entities/views/entity_list_screen.dart';
import 'package:moonforge/features/entities/views/entity_screen.dart';
import 'package:moonforge/features/home/views/home_screen.dart';
import 'package:moonforge/features/parties/views/member_edit_screen.dart';
import 'package:moonforge/features/parties/views/member_screen.dart';
import 'package:moonforge/features/parties/views/party_edit_screen.dart';
import 'package:moonforge/features/parties/views/party_list_screen.dart';
import 'package:moonforge/features/parties/views/party_screen.dart';
import 'package:moonforge/features/scene/views/scene_edit_screen.dart';
import 'package:moonforge/features/scene/views/scene_list_screen.dart';
import 'package:moonforge/features/scene/views/scene_screen.dart';
import 'package:moonforge/features/scene/views/scene_templates_screen.dart';
import 'package:moonforge/features/session/views/session_edit_screen.dart';
import 'package:moonforge/features/session/views/session_list_screen.dart';
import 'package:moonforge/features/session/views/session_public_share_screen.dart';
import 'package:moonforge/features/session/views/session_screen.dart';
import 'package:moonforge/features/settings/views/settings_screen.dart';
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
class HomeRouteData extends GoRouteData with _$HomeRouteData {
  const HomeRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

@immutable
class LoginRouteData extends GoRouteData with _$LoginRouteData {
  const LoginRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

@immutable
class RegisterRouteData extends GoRouteData with _$RegisterRouteData {
  const RegisterRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RegisterScreen();
}

@immutable
class ForgotPasswordRouteData extends GoRouteData with _$ForgotPasswordRouteData {
  const ForgotPasswordRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ForgotPasswordScreen();
}

// Campaign Branch Routes
@immutable
class CampaignsListRouteData extends GoRouteData with _$CampaignsListRouteData {
  const CampaignsListRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignListScreen();
}

@immutable
class CampaignRouteData extends GoRouteData with _$CampaignRouteData {
  const CampaignRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignScreen();
}

@immutable
class CampaignEditRouteData extends GoRouteData with _$CampaignEditRouteData {
  const CampaignEditRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignEditScreen();
}

@immutable
class CampaignSettingsRouteData extends GoRouteData with _$CampaignSettingsRouteData {
  const CampaignSettingsRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignSettingsScreen();
}

@immutable
class CampaignAnalyticsRouteData extends GoRouteData with _$CampaignAnalyticsRouteData {
  const CampaignAnalyticsRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignAnalyticsScreen();
}

@immutable
class CampaignMembersRouteData extends GoRouteData with _$CampaignMembersRouteData {
  const CampaignMembersRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignMembersScreen();
}

@immutable
class ChaptersListRouteData extends GoRouteData with _$ChaptersListRouteData {
  const ChaptersListRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ChapterListScreen();
}

@immutable
class ChapterRouteData extends GoRouteData with _$ChapterRouteData {
  const ChapterRouteData({required this.chapterId});

  final String chapterId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ChapterScreen(chapterId: chapterId);
}

@immutable
class ChapterEditRouteData extends GoRouteData with _$ChapterEditRouteData {
  const ChapterEditRouteData({required this.chapterId});

  final String chapterId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ChapterEditScreen(chapterId: chapterId);
}

@immutable
class AdventureListRouteData extends GoRouteData with _$AdventureListRouteData {
  const AdventureListRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AdventureListScreen();
}

@immutable
class AdventureRouteData extends GoRouteData with _$AdventureRouteData {
  const AdventureRouteData({
    required this.chapterId,
    required this.adventureId,
  });

  final String chapterId;
  final String adventureId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      AdventureScreen(chapterId: chapterId, adventureId: adventureId);
}

@immutable
class AdventureEditRouteData extends GoRouteData with _$AdventureEditRouteData {
  const AdventureEditRouteData({
    required this.chapterId,
    required this.adventureId,
  });

  final String chapterId;
  final String adventureId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      AdventureEditScreen(chapterId: chapterId, adventureId: adventureId);
}

@immutable
class SceneRouteData extends GoRouteData with _$SceneRouteData {
  const SceneRouteData({
    required this.chapterId,
    required this.adventureId,
    required this.sceneId,
  });

  final String chapterId;
  final String adventureId;
  final String sceneId;

  @override
  Widget build(BuildContext context, GoRouterState state) => SceneScreen(
        chapterId: chapterId,
        adventureId: adventureId,
        sceneId: sceneId,
      );
}

@immutable
class SceneEditRouteData extends GoRouteData with _$SceneEditRouteData {
  const SceneEditRouteData({
    required this.chapterId,
    required this.adventureId,
    required this.sceneId,
  });

  final String chapterId;
  final String adventureId;
  final String sceneId;

  @override
  Widget build(BuildContext context, GoRouterState state) => SceneEditScreen(
        chapterId: chapterId,
        adventureId: adventureId,
        sceneId: sceneId,
      );
}

@immutable
class EncountersListRouteData extends GoRouteData with _$EncountersListRouteData {
  const EncountersListRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const EncounterListScreen();
}

@immutable
class ScenesListRouteData extends GoRouteData with _$ScenesListRouteData {
  const ScenesListRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SceneListScreen();
}

@immutable
class SceneTemplatesRouteData extends GoRouteData with _$SceneTemplatesRouteData {
  const SceneTemplatesRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SceneTemplatesScreen();
}

@immutable
class EncounterRouteData extends GoRouteData with _$EncounterRouteData {
  const EncounterRouteData({required this.encounterId});

  final String encounterId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EncounterScreen(encounterId: encounterId);
}

@immutable
class EncounterEditRouteData extends GoRouteData with _$EncounterEditRouteData {
  const EncounterEditRouteData({required this.encounterId});

  final String encounterId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EncounterEditScreen(encounterId: encounterId);
}

@immutable
class InitiativeTrackerRouteData extends GoRouteData with _$InitiativeTrackerRouteData {
  const InitiativeTrackerRouteData({required this.encounterId});

  final String encounterId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const InitiativeTrackerScreen(
      initialCombatants: [],
      encounterName: 'Initiative Tracker',
    );
  }
}

@immutable
class EntitiesListRouteData extends GoRouteData with _$EntitiesListRouteData {
  const EntitiesListRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const EntityListScreen();
}

@immutable
class EntityRouteData extends GoRouteData with _$EntityRouteData {
  const EntityRouteData({required this.entityId});

  final String entityId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EntityScreen(entityId: entityId);
}

@immutable
class EntityEditRouteData extends GoRouteData with _$EntityEditRouteData {
  const EntityEditRouteData({required this.entityId});

  final String entityId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EntityEditScreen(entityId: entityId);
}

// Party Branch Routes
@immutable
class PartyRootRouteData extends GoRouteData with _$PartyRootRouteData {
  const PartyRootRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PartyListScreen();
}

@immutable
class PartyRouteData extends GoRouteData with _$PartyRouteData {
  const PartyRouteData({required this.partyId});

  final String partyId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PartyScreen(partyId: partyId);
}

@immutable
class PartyEditRouteData extends GoRouteData with _$PartyEditRouteData {
  const PartyEditRouteData({required this.partyId});

  final String partyId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PartyEditScreen(partyId: partyId);
}

@immutable
class MemberRouteData extends GoRouteData with _$MemberRouteData {
  const MemberRouteData({required this.partyId, required this.memberId});

  final String partyId;
  final String memberId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MemberScreen(partyId: partyId, memberId: memberId);
}

@immutable
class MemberEditRouteData extends GoRouteData with _$MemberEditRouteData {
  const MemberEditRouteData({required this.partyId, required this.memberId});

  final String partyId;
  final String memberId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MemberEditScreen(partyId: partyId, memberId: memberId);
}

@immutable
class SessionListRouteData extends GoRouteData with _$SessionListRouteData {
  const SessionListRouteData({required this.partyId});

  final String partyId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SessionListScreen(partyId: partyId);
}

@immutable
class SessionRouteData extends GoRouteData with _$SessionRouteData {
  const SessionRouteData({required this.partyId, required this.sessionId});

  final String partyId;
  final String sessionId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SessionScreen(partyId: partyId, sessionId: sessionId);
}

@immutable
class SessionEditRouteData extends GoRouteData with _$SessionEditRouteData {
  const SessionEditRouteData({required this.partyId, required this.sessionId});

  final String partyId;
  final String sessionId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SessionEditScreen(partyId: partyId, sessionId: sessionId);
}

// Settings Branch Routes
@immutable
class SettingsRouteData extends GoRouteData with _$SettingsRouteData {
  const SettingsRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

@immutable
class ProfileRouteData extends GoRouteData with _$ProfileRouteData {
  const ProfileRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileScreen();
}

// Public routes (outside shell)
@TypedGoRoute<SessionPublicShareRouteData>(path: '/share/session/:token')
@immutable
class SessionPublicShareRouteData extends GoRouteData with _$SessionPublicShareRouteData {
  const SessionPublicShareRouteData({required this.token});

  final String token;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SessionPublicShareScreen(token: token);
}
