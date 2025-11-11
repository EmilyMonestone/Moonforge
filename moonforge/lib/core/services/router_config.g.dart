// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router_config.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get \$appRoutes => [
      \$appShellRouteData,
      \$sessionPublicShareRouteData,
    ];

RouteBase get \$appShellRouteData => StatefulShellRouteData.\$route(
      factory: \$AppShellRouteDataExtension._fromState,
      branches: [
        StatefulShellBranchData.\$branch(
          routes: [
            GoRouteData.\$route(
              path: '/',
              factory: \$HomeRouteDataExtension._fromState,
              routes: [
                GoRouteData.\$route(
                  path: 'login',
                  factory: \$LoginRouteDataExtension._fromState,
                  routes: [
                    GoRouteData.\$route(
                      path: 'register',
                      factory: \$RegisterRouteDataExtension._fromState,
                    ),
                    GoRouteData.\$route(
                      path: 'forgot',
                      factory: \$ForgotPasswordRouteDataExtension._fromState,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.\$branch(
          routes: [
            GoRouteData.\$route(
              path: '/campaigns',
              factory: \$CampaignsListRouteDataExtension._fromState,
            ),
            GoRouteData.\$route(
              path: '/campaign',
              factory: \$CampaignRouteDataExtension._fromState,
              routes: [
                GoRouteData.\$route(
                  path: 'edit',
                  factory: \$CampaignEditRouteDataExtension._fromState,
                ),
                GoRouteData.\$route(
                  path: 'settings',
                  factory: \$CampaignSettingsRouteDataExtension._fromState,
                ),
                GoRouteData.\$route(
                  path: 'analytics',
                  factory: \$CampaignAnalyticsRouteDataExtension._fromState,
                ),
                GoRouteData.\$route(
                  path: 'members',
                  factory: \$CampaignMembersRouteDataExtension._fromState,
                ),
                GoRouteData.\$route(
                  path: 'chapters',
                  factory: \$ChaptersListRouteDataExtension._fromState,
                ),
                GoRouteData.\$route(
                  path: 'adventures',
                  factory: \$AdventureListRouteDataExtension._fromState,
                ),
                GoRouteData.\$route(
                  path: 'chapter/:chapterId',
                  factory: \$ChapterRouteDataExtension._fromState,
                  routes: [
                    GoRouteData.\$route(
                      path: 'edit',
                      factory: \$ChapterEditRouteDataExtension._fromState,
                    ),
                    GoRouteData.\$route(
                      path: 'adventure/:adventureId',
                      factory: \$AdventureRouteDataExtension._fromState,
                      routes: [
                        GoRouteData.\$route(
                          path: 'edit',
                          factory: \$AdventureEditRouteDataExtension._fromState,
                        ),
                        GoRouteData.\$route(
                          path: 'scene/:sceneId',
                          factory: \$SceneRouteDataExtension._fromState,
                          routes: [
                            GoRouteData.\$route(
                              path: 'edit',
                              factory: \$SceneEditRouteDataExtension._fromState,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                GoRouteData.\$route(
                  path: 'encounters',
                  factory: \$EncountersListRouteDataExtension._fromState,
                ),
                GoRouteData.\$route(
                  path: 'scenes',
                  factory: \$ScenesListRouteDataExtension._fromState,
                ),
                GoRouteData.\$route(
                  path: 'scenes/templates',
                  factory: \$SceneTemplatesRouteDataExtension._fromState,
                ),
                GoRouteData.\$route(
                  path: 'encounter/:encounterId',
                  factory: \$EncounterRouteDataExtension._fromState,
                  routes: [
                    GoRouteData.\$route(
                      path: 'edit',
                      factory: \$EncounterEditRouteDataExtension._fromState,
                    ),
                    GoRouteData.\$route(
                      path: 'initiative',
                      factory: \$InitiativeTrackerRouteDataExtension._fromState,
                    ),
                  ],
                ),
                GoRouteData.\$route(
                  path: 'entities',
                  factory: \$EntitiesListRouteDataExtension._fromState,
                ),
                GoRouteData.\$route(
                  path: 'entity/:entityId',
                  factory: \$EntityRouteDataExtension._fromState,
                  routes: [
                    GoRouteData.\$route(
                      path: 'edit',
                      factory: \$EntityEditRouteDataExtension._fromState,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.\$branch(
          routes: [
            GoRouteData.\$route(
              path: '/party',
              factory: \$PartyRootRouteDataExtension._fromState,
              routes: [
                GoRouteData.\$route(
                  path: ':partyId',
                  factory: \$PartyRouteDataExtension._fromState,
                  routes: [
                    GoRouteData.\$route(
                      path: 'edit',
                      factory: \$PartyEditRouteDataExtension._fromState,
                    ),
                    GoRouteData.\$route(
                      path: 'member/:memberId',
                      factory: \$MemberRouteDataExtension._fromState,
                      routes: [
                        GoRouteData.\$route(
                          path: 'edit',
                          factory: \$MemberEditRouteDataExtension._fromState,
                        ),
                      ],
                    ),
                    GoRouteData.\$route(
                      path: 'sessions',
                      factory: \$SessionListRouteDataExtension._fromState,
                    ),
                    GoRouteData.\$route(
                      path: 'session/:sessionId',
                      factory: \$SessionRouteDataExtension._fromState,
                      routes: [
                        GoRouteData.\$route(
                          path: 'edit',
                          factory: \$SessionEditRouteDataExtension._fromState,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.\$branch(
          routes: [
            GoRouteData.\$route(
              path: '/settings',
              factory: \$SettingsRouteDataExtension._fromState,
            ),
            GoRouteData.\$route(
              path: '/profile',
              factory: \$ProfileRouteDataExtension._fromState,
            ),
          ],
        ),
      ],
    );

RouteBase get \$sessionPublicShareRouteData => GoRouteData.\$route(
      path: '/share/session/:token',
      factory: \$SessionPublicShareRouteDataExtension._fromState,
    );

extension \$AppShellRouteDataExtension on AppShellRouteData {
  static AppShellRouteData _fromState(GoRouterState state) =>
      const AppShellRouteData();
}

extension \$HomeRouteDataExtension on HomeRouteData {
  static HomeRouteData _fromState(GoRouterState state) =>
      const HomeRouteData();

  String get location => GoRouteData.\$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$LoginRouteDataExtension on LoginRouteData {
  static LoginRouteData _fromState(GoRouterState state) =>
      const LoginRouteData();

  String get location => GoRouteData.\$location(
        '/login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$RegisterRouteDataExtension on RegisterRouteData {
  static RegisterRouteData _fromState(GoRouterState state) =>
      const RegisterRouteData();

  String get location => GoRouteData.\$location(
        '/login/register',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$ForgotPasswordRouteDataExtension on ForgotPasswordRouteData {
  static ForgotPasswordRouteData _fromState(GoRouterState state) =>
      const ForgotPasswordRouteData();

  String get location => GoRouteData.\$location(
        '/login/forgot',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$CampaignsListRouteDataExtension on CampaignsListRouteData {
  static CampaignsListRouteData _fromState(GoRouterState state) =>
      const CampaignsListRouteData();

  String get location => GoRouteData.\$location(
        '/campaigns',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$CampaignRouteDataExtension on CampaignRouteData {
  static CampaignRouteData _fromState(GoRouterState state) =>
      const CampaignRouteData();

  String get location => GoRouteData.\$location(
        '/campaign',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$CampaignEditRouteDataExtension on CampaignEditRouteData {
  static CampaignEditRouteData _fromState(GoRouterState state) =>
      const CampaignEditRouteData();

  String get location => GoRouteData.\$location(
        '/campaign/edit',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$CampaignSettingsRouteDataExtension on CampaignSettingsRouteData {
  static CampaignSettingsRouteData _fromState(GoRouterState state) =>
      const CampaignSettingsRouteData();

  String get location => GoRouteData.\$location(
        '/campaign/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$CampaignAnalyticsRouteDataExtension on CampaignAnalyticsRouteData {
  static CampaignAnalyticsRouteData _fromState(GoRouterState state) =>
      const CampaignAnalyticsRouteData();

  String get location => GoRouteData.\$location(
        '/campaign/analytics',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$CampaignMembersRouteDataExtension on CampaignMembersRouteData {
  static CampaignMembersRouteData _fromState(GoRouterState state) =>
      const CampaignMembersRouteData();

  String get location => GoRouteData.\$location(
        '/campaign/members',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$ChaptersListRouteDataExtension on ChaptersListRouteData {
  static ChaptersListRouteData _fromState(GoRouterState state) =>
      const ChaptersListRouteData();

  String get location => GoRouteData.\$location(
        '/campaign/chapters',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$AdventureListRouteDataExtension on AdventureListRouteData {
  static AdventureListRouteData _fromState(GoRouterState state) =>
      const AdventureListRouteData();

  String get location => GoRouteData.\$location(
        '/campaign/adventures',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$ChapterRouteDataExtension on ChapterRouteData {
  static ChapterRouteData _fromState(GoRouterState state) => ChapterRouteData(
        chapterId: state.pathParameters['chapterId']!,
      );

  String get location => GoRouteData.\$location(
        '/campaign/chapter/\${Uri.encodeComponent(chapterId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$ChapterEditRouteDataExtension on ChapterEditRouteData {
  static ChapterEditRouteData _fromState(GoRouterState state) =>
      ChapterEditRouteData(
        chapterId: state.pathParameters['chapterId']!,
      );

  String get location => GoRouteData.\$location(
        '/campaign/chapter/\${Uri.encodeComponent(chapterId)}/edit',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$AdventureRouteDataExtension on AdventureRouteData {
  static AdventureRouteData _fromState(GoRouterState state) =>
      AdventureRouteData(
        chapterId: state.pathParameters['chapterId']!,
        adventureId: state.pathParameters['adventureId']!,
      );

  String get location => GoRouteData.\$location(
        '/campaign/chapter/\${Uri.encodeComponent(chapterId)}/adventure/\${Uri.encodeComponent(adventureId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$AdventureEditRouteDataExtension on AdventureEditRouteData {
  static AdventureEditRouteData _fromState(GoRouterState state) =>
      AdventureEditRouteData(
        chapterId: state.pathParameters['chapterId']!,
        adventureId: state.pathParameters['adventureId']!,
      );

  String get location => GoRouteData.\$location(
        '/campaign/chapter/\${Uri.encodeComponent(chapterId)}/adventure/\${Uri.encodeComponent(adventureId)}/edit',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$SceneRouteDataExtension on SceneRouteData {
  static SceneRouteData _fromState(GoRouterState state) => SceneRouteData(
        chapterId: state.pathParameters['chapterId']!,
        adventureId: state.pathParameters['adventureId']!,
        sceneId: state.pathParameters['sceneId']!,
      );

  String get location => GoRouteData.\$location(
        '/campaign/chapter/\${Uri.encodeComponent(chapterId)}/adventure/\${Uri.encodeComponent(adventureId)}/scene/\${Uri.encodeComponent(sceneId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$SceneEditRouteDataExtension on SceneEditRouteData {
  static SceneEditRouteData _fromState(GoRouterState state) =>
      SceneEditRouteData(
        chapterId: state.pathParameters['chapterId']!,
        adventureId: state.pathParameters['adventureId']!,
        sceneId: state.pathParameters['sceneId']!,
      );

  String get location => GoRouteData.\$location(
        '/campaign/chapter/\${Uri.encodeComponent(chapterId)}/adventure/\${Uri.encodeComponent(adventureId)}/scene/\${Uri.encodeComponent(sceneId)}/edit',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$EncountersListRouteDataExtension on EncountersListRouteData {
  static EncountersListRouteData _fromState(GoRouterState state) =>
      const EncountersListRouteData();

  String get location => GoRouteData.\$location(
        '/campaign/encounters',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$ScenesListRouteDataExtension on ScenesListRouteData {
  static ScenesListRouteData _fromState(GoRouterState state) =>
      const ScenesListRouteData();

  String get location => GoRouteData.\$location(
        '/campaign/scenes',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$SceneTemplatesRouteDataExtension on SceneTemplatesRouteData {
  static SceneTemplatesRouteData _fromState(GoRouterState state) =>
      const SceneTemplatesRouteData();

  String get location => GoRouteData.\$location(
        '/campaign/scenes/templates',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$EncounterRouteDataExtension on EncounterRouteData {
  static EncounterRouteData _fromState(GoRouterState state) =>
      EncounterRouteData(
        encounterId: state.pathParameters['encounterId']!,
      );

  String get location => GoRouteData.\$location(
        '/campaign/encounter/\${Uri.encodeComponent(encounterId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$EncounterEditRouteDataExtension on EncounterEditRouteData {
  static EncounterEditRouteData _fromState(GoRouterState state) =>
      EncounterEditRouteData(
        encounterId: state.pathParameters['encounterId']!,
      );

  String get location => GoRouteData.\$location(
        '/campaign/encounter/\${Uri.encodeComponent(encounterId)}/edit',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$InitiativeTrackerRouteDataExtension on InitiativeTrackerRouteData {
  static InitiativeTrackerRouteData _fromState(GoRouterState state) =>
      InitiativeTrackerRouteData(
        encounterId: state.pathParameters['encounterId']!,
      );

  String get location => GoRouteData.\$location(
        '/campaign/encounter/\${Uri.encodeComponent(encounterId)}/initiative',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$EntitiesListRouteDataExtension on EntitiesListRouteData {
  static EntitiesListRouteData _fromState(GoRouterState state) =>
      const EntitiesListRouteData();

  String get location => GoRouteData.\$location(
        '/campaign/entities',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$EntityRouteDataExtension on EntityRouteData {
  static EntityRouteData _fromState(GoRouterState state) => EntityRouteData(
        entityId: state.pathParameters['entityId']!,
      );

  String get location => GoRouteData.\$location(
        '/campaign/entity/\${Uri.encodeComponent(entityId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$EntityEditRouteDataExtension on EntityEditRouteData {
  static EntityEditRouteData _fromState(GoRouterState state) =>
      EntityEditRouteData(
        entityId: state.pathParameters['entityId']!,
      );

  String get location => GoRouteData.\$location(
        '/campaign/entity/\${Uri.encodeComponent(entityId)}/edit',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$PartyRootRouteDataExtension on PartyRootRouteData {
  static PartyRootRouteData _fromState(GoRouterState state) =>
      const PartyRootRouteData();

  String get location => GoRouteData.\$location(
        '/party',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$PartyRouteDataExtension on PartyRouteData {
  static PartyRouteData _fromState(GoRouterState state) => PartyRouteData(
        partyId: state.pathParameters['partyId']!,
      );

  String get location => GoRouteData.\$location(
        '/party/\${Uri.encodeComponent(partyId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$PartyEditRouteDataExtension on PartyEditRouteData {
  static PartyEditRouteData _fromState(GoRouterState state) =>
      PartyEditRouteData(
        partyId: state.pathParameters['partyId']!,
      );

  String get location => GoRouteData.\$location(
        '/party/\${Uri.encodeComponent(partyId)}/edit',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$MemberRouteDataExtension on MemberRouteData {
  static MemberRouteData _fromState(GoRouterState state) => MemberRouteData(
        partyId: state.pathParameters['partyId']!,
        memberId: state.pathParameters['memberId']!,
      );

  String get location => GoRouteData.\$location(
        '/party/\${Uri.encodeComponent(partyId)}/member/\${Uri.encodeComponent(memberId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$MemberEditRouteDataExtension on MemberEditRouteData {
  static MemberEditRouteData _fromState(GoRouterState state) =>
      MemberEditRouteData(
        partyId: state.pathParameters['partyId']!,
        memberId: state.pathParameters['memberId']!,
      );

  String get location => GoRouteData.\$location(
        '/party/\${Uri.encodeComponent(partyId)}/member/\${Uri.encodeComponent(memberId)}/edit',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$SessionListRouteDataExtension on SessionListRouteData {
  static SessionListRouteData _fromState(GoRouterState state) =>
      SessionListRouteData(
        partyId: state.pathParameters['partyId']!,
      );

  String get location => GoRouteData.\$location(
        '/party/\${Uri.encodeComponent(partyId)}/sessions',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$SessionRouteDataExtension on SessionRouteData {
  static SessionRouteData _fromState(GoRouterState state) => SessionRouteData(
        partyId: state.pathParameters['partyId']!,
        sessionId: state.pathParameters['sessionId']!,
      );

  String get location => GoRouteData.\$location(
        '/party/\${Uri.encodeComponent(partyId)}/session/\${Uri.encodeComponent(sessionId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$SessionEditRouteDataExtension on SessionEditRouteData {
  static SessionEditRouteData _fromState(GoRouterState state) =>
      SessionEditRouteData(
        partyId: state.pathParameters['partyId']!,
        sessionId: state.pathParameters['sessionId']!,
      );

  String get location => GoRouteData.\$location(
        '/party/\${Uri.encodeComponent(partyId)}/session/\${Uri.encodeComponent(sessionId)}/edit',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$SettingsRouteDataExtension on SettingsRouteData {
  static SettingsRouteData _fromState(GoRouterState state) =>
      const SettingsRouteData();

  String get location => GoRouteData.\$location(
        '/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$ProfileRouteDataExtension on ProfileRouteData {
  static ProfileRouteData _fromState(GoRouterState state) =>
      const ProfileRouteData();

  String get location => GoRouteData.\$location(
        '/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension \$SessionPublicShareRouteDataExtension
    on SessionPublicShareRouteData {
  static SessionPublicShareRouteData _fromState(GoRouterState state) =>
      SessionPublicShareRouteData(
        token: state.pathParameters['token']!,
      );

  String get location => GoRouteData.\$location(
        '/share/session/\${Uri.encodeComponent(token)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
