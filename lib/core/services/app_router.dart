import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/features/adventure/views/adventure_edit_screen.dart';
import 'package:moonforge/features/adventure/views/adventure_screen.dart';
import 'package:moonforge/features/auth/views/login_screen.dart';
import 'package:moonforge/features/auth/views/register_screen.dart';
import 'package:moonforge/features/auth/views/forgot_password_screen.dart';
import 'package:moonforge/features/campaign/views/campaign_edit_screen.dart';
import 'package:moonforge/features/campaign/views/campaign_screen.dart';
import 'package:moonforge/features/chapter/views/chapter_edit_screen.dart';
import 'package:moonforge/features/chapter/views/chapter_screen.dart';
import 'package:moonforge/features/encounters/views/encounter_edit_screen.dart';
import 'package:moonforge/features/encounters/views/encounter_screen.dart';
import 'package:moonforge/features/entities/views/entity_edit_screen.dart';
import 'package:moonforge/features/entities/views/entity_screen.dart';
import 'package:moonforge/features/home/views/home_screen.dart';
import 'package:moonforge/features/home/views/unknown_path_screen.dart';
import 'package:moonforge/features/parties/views/member_edit_screen.dart';
import 'package:moonforge/features/parties/views/member_screen.dart';
import 'package:moonforge/features/parties/views/party_edit_screen.dart';
import 'package:moonforge/features/parties/views/party_screen.dart';
import 'package:moonforge/features/scene/views/scene_edit_screen.dart';
import 'package:moonforge/features/scene/views/scene_screen.dart';
import 'package:moonforge/features/session/views/session_edit_screen.dart';
import 'package:moonforge/features/session/views/session_screen.dart';
import 'package:moonforge/features/settings/views/settings_screen.dart';
import 'package:moonforge/layout/layout_shell.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) {
              return LayoutShell(navigationShell: navigationShell);
            },
        branches: <StatefulShellBranch>[
          // Home branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/',
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'login',
                    builder: (context, state) => const LoginScreen(),
                    routes: <RouteBase>[
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
          // Campaign branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/campaign',
                builder: (BuildContext context, GoRouterState state) =>
                    const CampaignScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => const CampaignEditScreen(),
                  ),
                  GoRoute(
                    path: 'chapter/:chapterId',
                    builder: (context, state) => ChapterScreen(
                      chapterId: state.pathParameters['chapterId']!,
                    ),
                    routes: <RouteBase>[
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
                        routes: <RouteBase>[
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
                            routes: <RouteBase>[
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
                    path: 'encounter/:encounterId',
                    builder: (context, state) => EncounterScreen(
                      encounterId: state.pathParameters['encounterId']!,
                    ),
                    routes: <RouteBase>[
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) => EncounterEditScreen(
                          encounterId: state.pathParameters['encounterId']!,
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'entity/:entityId',
                    builder: (context, state) => EntityScreen(
                      entityId: state.pathParameters['entityId']!,
                    ),
                    routes: <RouteBase>[
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
          // Party branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/party',
                builder: (BuildContext context, GoRouterState state) =>
                    PartyScreen(partyId: state.uri.queryParameters['id'] ?? ''),
                routes: <RouteBase>[
                  GoRoute(
                    path: ':partyId',
                    builder: (context, state) =>
                        PartyScreen(partyId: state.pathParameters['partyId']!),
                    routes: <RouteBase>[
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
                        routes: <RouteBase>[
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
                        path: 'session/:sessionId',
                        builder: (context, state) => SessionScreen(
                          partyId: state.pathParameters['partyId']!,
                          sessionId: state.pathParameters['sessionId']!,
                        ),
                        routes: <RouteBase>[
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
          // Settings branch
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/settings',
                builder: (BuildContext context, GoRouterState state) =>
                    const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) =>
        const UnknownPathScreen(),
    debugLogDiagnostics: false,
  );
}
