// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router_config.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $appShellRouteData,
  $sessionPublicShareRouteData,
];

RouteBase get $appShellRouteData => StatefulShellRouteData.$RouteData(
  factory: $AppShellRouteDataExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$RouteData(
          path: '/',
          factory: $HomeRouteData._fromState,
          routes: [
            GoRouteData.$RouteData(
              path: 'login',
              factory: $LoginRouteData._fromState,
              routes: [
                GoRouteData.$RouteData(
                  path: 'register',
                  factory: $RegisterRouteData._fromState,
                ),
                GoRouteData.$RouteData(
                  path: 'forgot',
                  factory: $ForgotPasswordRouteData._fromState,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$RouteData(
          path: '/campaigns',
          factory: $CampaignsListRouteData._fromState,
        ),
        GoRouteData.$RouteData(
          path: '/campaign',
          factory: $CampaignRouteData._fromState,
          routes: [
            GoRouteData.$RouteData(
              path: 'edit',
              factory: $CampaignEditRouteData._fromState,
            ),
            GoRouteData.$RouteData(
              path: 'settings',
              factory: $CampaignSettingsRouteData._fromState,
            ),
            GoRouteData.$RouteData(
              path: 'analytics',
              factory: $CampaignAnalyticsRouteData._fromState,
            ),
            GoRouteData.$RouteData(
              path: 'members',
              factory: $CampaignMembersRouteData._fromState,
            ),
            GoRouteData.$RouteData(
              path: 'chapters',
              factory: $ChaptersListRouteData._fromState,
            ),
            GoRouteData.$RouteData(
              path: 'adventures',
              factory: $AdventureListRouteData._fromState,
            ),
            GoRouteData.$RouteData(
              path: 'chapter/:chapterId',
              factory: $ChapterRouteData._fromState,
              routes: [
                GoRouteData.$RouteData(
                  path: 'edit',
                  factory: $ChapterEditRouteData._fromState,
                ),
                GoRouteData.$RouteData(
                  path: 'adventure/:adventureId',
                  factory: $AdventureRouteData._fromState,
                  routes: [
                    GoRouteData.$RouteData(
                      path: 'edit',
                      factory: $AdventureEditRouteData._fromState,
                    ),
                    GoRouteData.$RouteData(
                      path: 'scene/:sceneId',
                      factory: $SceneRouteData._fromState,
                      routes: [
                        GoRouteData.$RouteData(
                          path: 'edit',
                          factory: $SceneEditRouteData._fromState,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            GoRouteData.$RouteData(
              path: 'encounters',
              factory: $EncountersListRouteData._fromState,
            ),
            GoRouteData.$RouteData(
              path: 'scenes',
              factory: $ScenesListRouteData._fromState,
            ),
            GoRouteData.$RouteData(
              path: 'scenes/templates',
              factory: $SceneTemplatesRouteData._fromState,
            ),
            GoRouteData.$RouteData(
              path: 'encounter/:encounterId',
              factory: $EncounterRouteData._fromState,
              routes: [
                GoRouteData.$RouteData(
                  path: 'edit',
                  factory: $EncounterEditRouteData._fromState,
                ),
                GoRouteData.$RouteData(
                  path: 'initiative',
                  factory: $InitiativeTrackerRouteData._fromState,
                ),
              ],
            ),
            GoRouteData.$RouteData(
              path: 'entities',
              factory: $EntitiesListRouteData._fromState,
            ),
            GoRouteData.$RouteData(
              path: 'entity/:entityId',
              factory: $EntityRouteData._fromState,
              routes: [
                GoRouteData.$RouteData(
                  path: 'edit',
                  factory: $EntityEditRouteData._fromState,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$RouteData(
          path: '/party',
          factory: $PartyRootRouteData._fromState,
          routes: [
            GoRouteData.$RouteData(
              path: ':partyId',
              factory: $PartyRouteData._fromState,
              routes: [
                GoRouteData.$RouteData(
                  path: 'edit',
                  factory: $PartyEditRouteData._fromState,
                ),
                GoRouteData.$RouteData(
                  path: 'member/:memberId',
                  factory: $MemberRouteData._fromState,
                  routes: [
                    GoRouteData.$RouteData(
                      path: 'edit',
                      factory: $MemberEditRouteData._fromState,
                    ),
                  ],
                ),
                GoRouteData.$RouteData(
                  path: 'sessions',
                  factory: $SessionListRouteData._fromState,
                ),
                GoRouteData.$RouteData(
                  path: 'session/:sessionId',
                  factory: $SessionRouteData._fromState,
                  routes: [
                    GoRouteData.$RouteData(
                      path: 'edit',
                      factory: $SessionEditRouteData._fromState,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$RouteData(
          path: '/settings',
          factory: $SettingsRouteData._fromState,
        ),
        GoRouteData.$RouteData(
          path: '/profile',
          factory: $ProfileRouteData._fromState,
        ),
      ],
    ),
  ],
);

extension $AppShellRouteDataExtension on AppShellRouteData {
  static AppShellRouteData _fromState(GoRouterState state) =>
      const AppShellRouteData();
}

mixin $HomeRouteData on GoRouteData {
  static HomeRouteData _fromState(GoRouterState state) => const HomeRouteData();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LoginRouteData on GoRouteData {
  static LoginRouteData _fromState(GoRouterState state) =>
      const LoginRouteData();

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RegisterRouteData on GoRouteData {
  static RegisterRouteData _fromState(GoRouterState state) =>
      const RegisterRouteData();

  @override
  String get location => GoRouteData.$location('/login/register');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ForgotPasswordRouteData on GoRouteData {
  static ForgotPasswordRouteData _fromState(GoRouterState state) =>
      const ForgotPasswordRouteData();

  @override
  String get location => GoRouteData.$location('/login/forgot');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CampaignsListRouteData on GoRouteData {
  static CampaignsListRouteData _fromState(GoRouterState state) =>
      const CampaignsListRouteData();

  @override
  String get location => GoRouteData.$location('/campaigns');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CampaignRouteData on GoRouteData {
  static CampaignRouteData _fromState(GoRouterState state) =>
      const CampaignRouteData();

  @override
  String get location => GoRouteData.$location('/campaign');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CampaignEditRouteData on GoRouteData {
  static CampaignEditRouteData _fromState(GoRouterState state) =>
      const CampaignEditRouteData();

  @override
  String get location => GoRouteData.$location('/campaign/edit');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CampaignSettingsRouteData on GoRouteData {
  static CampaignSettingsRouteData _fromState(GoRouterState state) =>
      const CampaignSettingsRouteData();

  @override
  String get location => GoRouteData.$location('/campaign/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CampaignAnalyticsRouteData on GoRouteData {
  static CampaignAnalyticsRouteData _fromState(GoRouterState state) =>
      const CampaignAnalyticsRouteData();

  @override
  String get location => GoRouteData.$location('/campaign/analytics');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CampaignMembersRouteData on GoRouteData {
  static CampaignMembersRouteData _fromState(GoRouterState state) =>
      const CampaignMembersRouteData();

  @override
  String get location => GoRouteData.$location('/campaign/members');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ChaptersListRouteData on GoRouteData {
  static ChaptersListRouteData _fromState(GoRouterState state) =>
      const ChaptersListRouteData();

  @override
  String get location => GoRouteData.$location('/campaign/chapters');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AdventureListRouteData on GoRouteData {
  static AdventureListRouteData _fromState(GoRouterState state) =>
      const AdventureListRouteData();

  @override
  String get location => GoRouteData.$location('/campaign/adventures');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ChapterRouteData on GoRouteData {
  static ChapterRouteData _fromState(GoRouterState state) =>
      ChapterRouteData(chapterId: state.pathParameters['chapterId']!);

  ChapterRouteData get _self => this as ChapterRouteData;

  @override
  String get location => GoRouteData.$location(
    '/campaign/chapter/${Uri.encodeComponent(_self.chapterId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ChapterEditRouteData on GoRouteData {
  static ChapterEditRouteData _fromState(GoRouterState state) =>
      ChapterEditRouteData(chapterId: state.pathParameters['chapterId']!);

  ChapterEditRouteData get _self => this as ChapterEditRouteData;

  @override
  String get location => GoRouteData.$location(
    '/campaign/chapter/${Uri.encodeComponent(_self.chapterId)}/edit',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AdventureRouteData on GoRouteData {
  static AdventureRouteData _fromState(GoRouterState state) =>
      AdventureRouteData(
        chapterId: state.pathParameters['chapterId']!,
        adventureId: state.pathParameters['adventureId']!,
      );

  AdventureRouteData get _self => this as AdventureRouteData;

  @override
  String get location => GoRouteData.$location(
    '/campaign/chapter/${Uri.encodeComponent(_self.chapterId)}/adventure/${Uri.encodeComponent(_self.adventureId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AdventureEditRouteData on GoRouteData {
  static AdventureEditRouteData _fromState(GoRouterState state) =>
      AdventureEditRouteData(
        chapterId: state.pathParameters['chapterId']!,
        adventureId: state.pathParameters['adventureId']!,
      );

  AdventureEditRouteData get _self => this as AdventureEditRouteData;

  @override
  String get location => GoRouteData.$location(
    '/campaign/chapter/${Uri.encodeComponent(_self.chapterId)}/adventure/${Uri.encodeComponent(_self.adventureId)}/edit',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SceneRouteData on GoRouteData {
  static SceneRouteData _fromState(GoRouterState state) => SceneRouteData(
    chapterId: state.pathParameters['chapterId']!,
    adventureId: state.pathParameters['adventureId']!,
    sceneId: state.pathParameters['sceneId']!,
  );

  SceneRouteData get _self => this as SceneRouteData;

  @override
  String get location => GoRouteData.$location(
    '/campaign/chapter/${Uri.encodeComponent(_self.chapterId)}/adventure/${Uri.encodeComponent(_self.adventureId)}/scene/${Uri.encodeComponent(_self.sceneId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SceneEditRouteData on GoRouteData {
  static SceneEditRouteData _fromState(GoRouterState state) =>
      SceneEditRouteData(
        chapterId: state.pathParameters['chapterId']!,
        adventureId: state.pathParameters['adventureId']!,
        sceneId: state.pathParameters['sceneId']!,
      );

  SceneEditRouteData get _self => this as SceneEditRouteData;

  @override
  String get location => GoRouteData.$location(
    '/campaign/chapter/${Uri.encodeComponent(_self.chapterId)}/adventure/${Uri.encodeComponent(_self.adventureId)}/scene/${Uri.encodeComponent(_self.sceneId)}/edit',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $EncountersListRouteData on GoRouteData {
  static EncountersListRouteData _fromState(GoRouterState state) =>
      const EncountersListRouteData();

  @override
  String get location => GoRouteData.$location('/campaign/encounters');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ScenesListRouteData on GoRouteData {
  static ScenesListRouteData _fromState(GoRouterState state) =>
      const ScenesListRouteData();

  @override
  String get location => GoRouteData.$location('/campaign/scenes');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SceneTemplatesRouteData on GoRouteData {
  static SceneTemplatesRouteData _fromState(GoRouterState state) =>
      const SceneTemplatesRouteData();

  @override
  String get location => GoRouteData.$location('/campaign/scenes/templates');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $EncounterRouteData on GoRouteData {
  static EncounterRouteData _fromState(GoRouterState state) =>
      EncounterRouteData(encounterId: state.pathParameters['encounterId']!);

  EncounterRouteData get _self => this as EncounterRouteData;

  @override
  String get location => GoRouteData.$location(
    '/campaign/encounter/${Uri.encodeComponent(_self.encounterId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $EncounterEditRouteData on GoRouteData {
  static EncounterEditRouteData _fromState(GoRouterState state) =>
      EncounterEditRouteData(encounterId: state.pathParameters['encounterId']!);

  EncounterEditRouteData get _self => this as EncounterEditRouteData;

  @override
  String get location => GoRouteData.$location(
    '/campaign/encounter/${Uri.encodeComponent(_self.encounterId)}/edit',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $InitiativeTrackerRouteData on GoRouteData {
  static InitiativeTrackerRouteData _fromState(GoRouterState state) =>
      InitiativeTrackerRouteData(
        encounterId: state.pathParameters['encounterId']!,
      );

  InitiativeTrackerRouteData get _self => this as InitiativeTrackerRouteData;

  @override
  String get location => GoRouteData.$location(
    '/campaign/encounter/${Uri.encodeComponent(_self.encounterId)}/initiative',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $EntitiesListRouteData on GoRouteData {
  static EntitiesListRouteData _fromState(GoRouterState state) =>
      const EntitiesListRouteData();

  @override
  String get location => GoRouteData.$location('/campaign/entities');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $EntityRouteData on GoRouteData {
  static EntityRouteData _fromState(GoRouterState state) =>
      EntityRouteData(entityId: state.pathParameters['entityId']!);

  EntityRouteData get _self => this as EntityRouteData;

  @override
  String get location => GoRouteData.$location(
    '/campaign/entity/${Uri.encodeComponent(_self.entityId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $EntityEditRouteData on GoRouteData {
  static EntityEditRouteData _fromState(GoRouterState state) =>
      EntityEditRouteData(entityId: state.pathParameters['entityId']!);

  EntityEditRouteData get _self => this as EntityEditRouteData;

  @override
  String get location => GoRouteData.$location(
    '/campaign/entity/${Uri.encodeComponent(_self.entityId)}/edit',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PartyRootRouteData on GoRouteData {
  static PartyRootRouteData _fromState(GoRouterState state) =>
      const PartyRootRouteData();

  @override
  String get location => GoRouteData.$location('/party');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PartyRouteData on GoRouteData {
  static PartyRouteData _fromState(GoRouterState state) =>
      PartyRouteData(partyId: state.pathParameters['partyId']!);

  PartyRouteData get _self => this as PartyRouteData;

  @override
  String get location =>
      GoRouteData.$location('/party/${Uri.encodeComponent(_self.partyId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PartyEditRouteData on GoRouteData {
  static PartyEditRouteData _fromState(GoRouterState state) =>
      PartyEditRouteData(partyId: state.pathParameters['partyId']!);

  PartyEditRouteData get _self => this as PartyEditRouteData;

  @override
  String get location => GoRouteData.$location(
    '/party/${Uri.encodeComponent(_self.partyId)}/edit',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MemberRouteData on GoRouteData {
  static MemberRouteData _fromState(GoRouterState state) => MemberRouteData(
    partyId: state.pathParameters['partyId']!,
    memberId: state.pathParameters['memberId']!,
  );

  MemberRouteData get _self => this as MemberRouteData;

  @override
  String get location => GoRouteData.$location(
    '/party/${Uri.encodeComponent(_self.partyId)}/member/${Uri.encodeComponent(_self.memberId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MemberEditRouteData on GoRouteData {
  static MemberEditRouteData _fromState(GoRouterState state) =>
      MemberEditRouteData(
        partyId: state.pathParameters['partyId']!,
        memberId: state.pathParameters['memberId']!,
      );

  MemberEditRouteData get _self => this as MemberEditRouteData;

  @override
  String get location => GoRouteData.$location(
    '/party/${Uri.encodeComponent(_self.partyId)}/member/${Uri.encodeComponent(_self.memberId)}/edit',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SessionListRouteData on GoRouteData {
  static SessionListRouteData _fromState(GoRouterState state) =>
      SessionListRouteData(partyId: state.pathParameters['partyId']!);

  SessionListRouteData get _self => this as SessionListRouteData;

  @override
  String get location => GoRouteData.$location(
    '/party/${Uri.encodeComponent(_self.partyId)}/sessions',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SessionRouteData on GoRouteData {
  static SessionRouteData _fromState(GoRouterState state) => SessionRouteData(
    partyId: state.pathParameters['partyId']!,
    sessionId: state.pathParameters['sessionId']!,
  );

  SessionRouteData get _self => this as SessionRouteData;

  @override
  String get location => GoRouteData.$location(
    '/party/${Uri.encodeComponent(_self.partyId)}/session/${Uri.encodeComponent(_self.sessionId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SessionEditRouteData on GoRouteData {
  static SessionEditRouteData _fromState(GoRouterState state) =>
      SessionEditRouteData(
        partyId: state.pathParameters['partyId']!,
        sessionId: state.pathParameters['sessionId']!,
      );

  SessionEditRouteData get _self => this as SessionEditRouteData;

  @override
  String get location => GoRouteData.$location(
    '/party/${Uri.encodeComponent(_self.partyId)}/session/${Uri.encodeComponent(_self.sessionId)}/edit',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRouteData on GoRouteData {
  static SettingsRouteData _fromState(GoRouterState state) =>
      const SettingsRouteData();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProfileRouteData on GoRouteData {
  static ProfileRouteData _fromState(GoRouterState state) =>
      const ProfileRouteData();

  @override
  String get location => GoRouteData.$location('/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $sessionPublicShareRouteData => GoRouteData.$RouteData(
  path: '/share/session/:token',
  factory: $SessionPublicShareRouteData._fromState,
);

mixin $SessionPublicShareRouteData on GoRouteData {
  static SessionPublicShareRouteData _fromState(GoRouterState state) =>
      SessionPublicShareRouteData(token: state.pathParameters['token']!);

  SessionPublicShareRouteData get _self => this as SessionPublicShareRouteData;

  @override
  String get location => GoRouteData.$location(
    '/share/session/${Uri.encodeComponent(_self.token)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
