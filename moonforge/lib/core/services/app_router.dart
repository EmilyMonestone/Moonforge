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
import 'package:moonforge/features/home/views/unknown_path_screen.dart';
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

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Use a shell route to host the shared layout/navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            LayoutShell(navigationShell: navigationShell),
        branches: [
          // Branch 0: Home/Auth
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'login',
                    builder: (context, state) => const LoginScreen(),
                    routes: [
                      GoRoute(
                        path: 'register',
                        builder: (context, state) => const RegisterScreen(),
                      ),
                      GoRoute(
                        path: 'forgot',
                        builder: (context, state) =>
                            const ForgotPasswordScreen(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Branch 1: Campaigns / Entities / Scenes / Encounters
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/campaigns',
                builder: (context, state) => const CampaignListScreen(),
              ),
              GoRoute(
                path: '/campaign',
                builder: (context, state) => const CampaignScreen(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => const CampaignEditScreen(),
                  ),
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const CampaignSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'analytics',
                    builder: (context, state) =>
                        const CampaignAnalyticsScreen(),
                  ),
                  GoRoute(
                    path: 'members',
                    builder: (context, state) => const CampaignMembersScreen(),
                  ),
                  GoRoute(
                    path: 'chapters',
                    builder: (context, state) => const ChapterListScreen(),
                  ),
                  GoRoute(
                    path: 'adventures',
                    builder: (context, state) => const AdventureListScreen(),
                  ),
                  GoRoute(
                    path: 'chapter/:chapterId',
                    builder: (context, state) => ChapterScreen(
                      chapterId: state.pathParameters['chapterId']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) => ChapterEditScreen(
                          chapterId: state.pathParameters['chapterId']!,
                        ),
                      ),
                      GoRoute(
                        path: 'adventure/:adventureId',
                        builder: (context, state) => AdventureScreen(
                          chapterId: state.pathParameters['chapterId']!,
                          adventureId: state.pathParameters['adventureId']!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            builder: (context, state) => AdventureEditScreen(
                              chapterId: state.pathParameters['chapterId']!,
                              adventureId: state.pathParameters['adventureId']!,
                            ),
                          ),
                          GoRoute(
                            path: 'scene/:sceneId',
                            builder: (context, state) => SceneScreen(
                              chapterId: state.pathParameters['chapterId']!,
                              adventureId: state.pathParameters['adventureId']!,
                              sceneId: state.pathParameters['sceneId']!,
                            ),
                            routes: [
                              GoRoute(
                                path: 'edit',
                                builder: (context, state) => SceneEditScreen(
                                  chapterId: state.pathParameters['chapterId']!,
                                  adventureId:
                                      state.pathParameters['adventureId']!,
                                  sceneId: state.pathParameters['sceneId']!,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'encounters',
                    builder: (context, state) => const EncounterListScreen(),
                  ),
                  GoRoute(
                    path: 'scenes',
                    builder: (context, state) => const SceneListScreen(),
                  ),
                  GoRoute(
                    path: 'scenes/templates',
                    builder: (context, state) => const SceneTemplatesScreen(),
                  ),
                  GoRoute(
                    path: 'encounter/:encounterId',
                    builder: (context, state) => EncounterScreen(
                      encounterId: state.pathParameters['encounterId']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) => EncounterEditScreen(
                          encounterId: state.pathParameters['encounterId']!,
                        ),
                      ),
                      GoRoute(
                        path: 'initiative',
                        builder: (context, state) =>
                            const InitiativeTrackerScreen(
                              initialCombatants: [],
                              encounterName: 'Initiative Tracker',
                            ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'entities',
                    builder: (context, state) => const EntityListScreen(),
                  ),
                  GoRoute(
                    path: 'entity/:entityId',
                    builder: (context, state) => EntityScreen(
                      entityId: state.pathParameters['entityId']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) => EntityEditScreen(
                          entityId: state.pathParameters['entityId']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Branch 2: Parties / Sessions
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/party',
                builder: (context, state) => const PartyListScreen(),
                routes: [
                  GoRoute(
                    path: ':partyId',
                    builder: (context, state) =>
                        PartyScreen(partyId: state.pathParameters['partyId']!),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) => PartyEditScreen(
                          partyId: state.pathParameters['partyId']!,
                        ),
                      ),
                      GoRoute(
                        path: 'member/:memberId',
                        builder: (context, state) => MemberScreen(
                          partyId: state.pathParameters['partyId']!,
                          memberId: state.pathParameters['memberId']!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            builder: (context, state) => MemberEditScreen(
                              partyId: state.pathParameters['partyId']!,
                              memberId: state.pathParameters['memberId']!,
                            ),
                          ),
                        ],
                      ),
                      GoRoute(
                        path: 'sessions',
                        builder: (context, state) => SessionListScreen(
                          partyId: state.pathParameters['partyId']!,
                        ),
                      ),
                      GoRoute(
                        path: 'session/:sessionId',
                        builder: (context, state) => SessionScreen(
                          partyId: state.pathParameters['partyId']!,
                          sessionId: state.pathParameters['sessionId']!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            builder: (context, state) => SessionEditScreen(
                              partyId: state.pathParameters['partyId']!,
                              sessionId: state.pathParameters['sessionId']!,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Branch 3: Settings / Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      // Public share (outside shell)
      GoRoute(
        path: '/share/session/:token',
        builder: (context, state) =>
            SessionPublicShareScreen(token: state.pathParameters['token']!),
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) =>
        const UnknownPathScreen(),
    debugLogDiagnostics: false,
  );
}

// Keep typed route classes to support .go()/.push() with a manual `location`.
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

class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  String get location => '/';

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  String get location => '/login';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

class RegisterRoute extends GoRouteData {
  const RegisterRoute();

  @override
  String get location => '/login/register';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RegisterScreen();
}

class ForgotPasswordRoute extends GoRouteData {
  const ForgotPasswordRoute();

  @override
  String get location => '/login/forgot';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ForgotPasswordScreen();
}

class CampaignsListRoute extends GoRouteData {
  const CampaignsListRoute();

  @override
  String get location => '/campaigns';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignListScreen();
}

class CampaignRoute extends GoRouteData {
  const CampaignRoute();

  @override
  String get location => '/campaign';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignScreen();
}

class CampaignEditRoute extends GoRouteData {
  const CampaignEditRoute();

  @override
  String get location => '/campaign/edit';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignEditScreen();
}

class CampaignSettingsRoute extends GoRouteData {
  const CampaignSettingsRoute();

  @override
  String get location => '/campaign/settings';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignSettingsScreen();
}

class CampaignAnalyticsRoute extends GoRouteData {
  const CampaignAnalyticsRoute();

  @override
  String get location => '/campaign/analytics';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignAnalyticsScreen();
}

class CampaignMembersRoute extends GoRouteData {
  const CampaignMembersRoute();

  @override
  String get location => '/campaign/members';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CampaignMembersScreen();
}

class ChaptersListRoute extends GoRouteData {
  const ChaptersListRoute();

  @override
  String get location => '/campaign/chapters';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ChapterListScreen();
}

class ChapterRoute extends GoRouteData {
  const ChapterRoute({required this.chapterId});

  final String chapterId;

  @override
  String get location => '/campaign/chapter/$chapterId';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ChapterScreen(chapterId: chapterId);
}

class ChapterEditRoute extends GoRouteData {
  const ChapterEditRoute({required this.chapterId});

  final String chapterId;

  @override
  String get location => '/campaign/chapter/$chapterId/edit';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ChapterEditScreen(chapterId: chapterId);
}

class AdventureListRoute extends GoRouteData {
  const AdventureListRoute();

  @override
  String get location => '/campaign/adventures';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AdventureListScreen();
}

class AdventureRoute extends GoRouteData {
  const AdventureRoute({required this.chapterId, required this.adventureId});

  final String chapterId;
  final String adventureId;

  @override
  String get location => '/campaign/chapter/$chapterId/adventure/$adventureId';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      AdventureScreen(chapterId: chapterId, adventureId: adventureId);
}

class AdventureEditRoute extends GoRouteData {
  const AdventureEditRoute({
    required this.chapterId,
    required this.adventureId,
  });

  final String chapterId;
  final String adventureId;

  @override
  String get location =>
      '/campaign/chapter/$chapterId/adventure/$adventureId/edit';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      AdventureEditScreen(chapterId: chapterId, adventureId: adventureId);
}

class SceneRoute extends GoRouteData {
  const SceneRoute({
    required this.chapterId,
    required this.adventureId,
    required this.sceneId,
  });

  final String chapterId;
  final String adventureId;
  final String sceneId;

  @override
  String get location =>
      '/campaign/chapter/$chapterId/adventure/$adventureId/scene/$sceneId';

  @override
  Widget build(BuildContext context, GoRouterState state) => SceneScreen(
    chapterId: chapterId,
    adventureId: adventureId,
    sceneId: sceneId,
  );
}

class SceneEditRoute extends GoRouteData {
  const SceneEditRoute({
    required this.chapterId,
    required this.adventureId,
    required this.sceneId,
  });

  final String chapterId;
  final String adventureId;
  final String sceneId;

  @override
  String get location =>
      '/campaign/chapter/$chapterId/adventure/$adventureId/scene/$sceneId/edit';

  @override
  Widget build(BuildContext context, GoRouterState state) => SceneEditScreen(
    chapterId: chapterId,
    adventureId: adventureId,
    sceneId: sceneId,
  );
}

class EncountersListRoute extends GoRouteData {
  const EncountersListRoute();

  @override
  String get location => '/campaign/encounters';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const EncounterListScreen();
}

class EncounterRoute extends GoRouteData {
  const EncounterRoute({required this.encounterId});

  final String encounterId;

  @override
  String get location => '/campaign/encounter/$encounterId';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EncounterScreen(encounterId: encounterId);
}

class EncounterEditRoute extends GoRouteData {
  const EncounterEditRoute({required this.encounterId});

  final String encounterId;

  @override
  String get location => '/campaign/encounter/$encounterId/edit';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EncounterEditScreen(encounterId: encounterId);
}

class EntitiesListRoute extends GoRouteData {
  const EntitiesListRoute();

  @override
  String get location => '/campaign/entities';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const EntityListScreen();
}

class InitiativeTrackerRoute extends GoRouteData {
  const InitiativeTrackerRoute({required this.encounterId});

  final String encounterId;

  @override
  String get location => '/campaign/encounter/$encounterId/initiative';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const InitiativeTrackerScreen(
      initialCombatants: [],
      encounterName: 'Initiative Tracker',
    );
  }
}

class EntityRoute extends GoRouteData {
  const EntityRoute({required this.entityId});

  final String entityId;

  @override
  String get location => '/campaign/entity/$entityId';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EntityScreen(entityId: entityId);
}

class EntityEditRoute extends GoRouteData {
  const EntityEditRoute({required this.entityId});

  final String entityId;

  @override
  String get location => '/campaign/entity/$entityId/edit';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EntityEditScreen(entityId: entityId);
}

class PartyRootRoute extends GoRouteData {
  const PartyRootRoute({this.id});

  final String? id; // query parameter
  @override
  String get location => '/party${id != null ? '?id=$id' : ''}';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PartyListScreen();
}

class PartyRoute extends GoRouteData {
  const PartyRoute({required this.partyId});

  final String partyId;

  @override
  String get location => '/party/$partyId';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PartyScreen(partyId: partyId);
}

class PartyEditRoute extends GoRouteData {
  const PartyEditRoute({required this.partyId});

  final String partyId;

  @override
  String get location => '/party/$partyId/edit';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PartyEditScreen(partyId: partyId);
}

class MemberRoute extends GoRouteData {
  const MemberRoute({required this.partyId, required this.memberId});

  final String partyId;
  final String memberId;

  @override
  String get location => '/party/$partyId/member/$memberId';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MemberScreen(partyId: partyId, memberId: memberId);
}

class MemberEditRoute extends GoRouteData {
  const MemberEditRoute({required this.partyId, required this.memberId});

  final String partyId;
  final String memberId;

  @override
  String get location => '/party/$partyId/member/$memberId/edit';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MemberEditScreen(partyId: partyId, memberId: memberId);
}

class SessionListRoute extends GoRouteData {
  const SessionListRoute({required this.partyId});

  final String partyId;

  @override
  String get location => '/party/$partyId/sessions';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SessionListScreen(partyId: partyId);
}

class SessionRoute extends GoRouteData {
  const SessionRoute({required this.partyId, required this.sessionId});

  final String partyId;
  final String sessionId;

  @override
  String get location => '/party/$partyId/session/$sessionId';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SessionScreen(partyId: partyId, sessionId: sessionId);
}

class SessionEditRoute extends GoRouteData {
  const SessionEditRoute({required this.partyId, required this.sessionId});

  final String partyId;
  final String sessionId;

  @override
  String get location => '/party/$partyId/session/$sessionId/edit';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SessionEditScreen(partyId: partyId, sessionId: sessionId);
}

class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  String get location => '/settings';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

class ProfileRoute extends GoRouteData {
  const ProfileRoute();

  @override
  String get location => '/profile';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileScreen();
}

class SessionPublicShareRoute extends GoRouteData {
  const SessionPublicShareRoute({required this.token});

  final String token;

  @override
  String get location => '/share/session/$token';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SessionPublicShareScreen(token: token);
}

class SceneListRoute extends GoRouteData {
  const SceneListRoute();

  @override
  String get location => '/campaign/scenes';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SceneListScreen();
}

class SceneTemplatesRoute extends GoRouteData {
  const SceneTemplatesRoute();

  @override
  String get location => '/campaign/scenes/templates';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SceneTemplatesScreen();
}
