// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$appShellRouteData];

RouteBase get $appShellRouteData => StatefulShellRouteData.$route(
  factory: $AppShellRouteDataExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/',

          factory: _$HomeRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'login',

              factory: _$LoginRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'register',

                  factory: _$RegisterRoute._fromState,
                ),
                GoRouteData.$route(
                  path: 'forgot',

                  factory: _$ForgotPasswordRoute._fromState,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/campaign',

          factory: _$CampaignRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'edit',

              factory: _$CampaignEditRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'chapter/:chapterId',

              factory: _$ChapterRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'edit',

                  factory: _$ChapterEditRoute._fromState,
                ),
                GoRouteData.$route(
                  path: 'adventure/:adventureId',

                  factory: _$AdventureRoute._fromState,
                  routes: [
                    GoRouteData.$route(
                      path: 'edit',

                      factory: _$AdventureEditRoute._fromState,
                    ),
                    GoRouteData.$route(
                      path: 'scene/:sceneId',

                      factory: _$SceneRoute._fromState,
                      routes: [
                        GoRouteData.$route(
                          path: 'edit',

                          factory: _$SceneEditRoute._fromState,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            GoRouteData.$route(
              path: 'encounter/:encounterId',

              factory: _$EncounterRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'edit',

                  factory: _$EncounterEditRoute._fromState,
                ),
              ],
            ),
            GoRouteData.$route(
              path: 'entity/:entityId',

              factory: _$EntityRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'edit',

                  factory: _$EntityEditRoute._fromState,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/party',

          factory: _$PartyRootRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: ':partyId',

              factory: _$PartyRoute._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'edit',

                  factory: _$PartyEditRoute._fromState,
                ),
                GoRouteData.$route(
                  path: 'member/:memberId',

                  factory: _$MemberRoute._fromState,
                  routes: [
                    GoRouteData.$route(
                      path: 'edit',

                      factory: _$MemberEditRoute._fromState,
                    ),
                  ],
                ),
                GoRouteData.$route(
                  path: 'session/:sessionId',

                  factory: _$SessionRoute._fromState,
                  routes: [
                    GoRouteData.$route(
                      path: 'edit',

                      factory: _$SessionEditRoute._fromState,
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
        GoRouteData.$route(
          path: '/settings',

          factory: _$SettingsRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $AppShellRouteDataExtension on AppShellRouteData {
  static AppShellRouteData _fromState(GoRouterState state) =>
      const AppShellRouteData();
}

mixin _$HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

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

mixin _$LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

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

mixin _$RegisterRoute on GoRouteData {
  static RegisterRoute _fromState(GoRouterState state) => const RegisterRoute();

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

mixin _$ForgotPasswordRoute on GoRouteData {
  static ForgotPasswordRoute _fromState(GoRouterState state) =>
      const ForgotPasswordRoute();

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

mixin _$CampaignRoute on GoRouteData {
  static CampaignRoute _fromState(GoRouterState state) => const CampaignRoute();

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

mixin _$CampaignEditRoute on GoRouteData {
  static CampaignEditRoute _fromState(GoRouterState state) =>
      const CampaignEditRoute();

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

mixin _$ChapterRoute on GoRouteData {
  static ChapterRoute _fromState(GoRouterState state) =>
      ChapterRoute(chapterId: state.pathParameters['chapterId']!);

  ChapterRoute get _self => this as ChapterRoute;

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

mixin _$ChapterEditRoute on GoRouteData {
  static ChapterEditRoute _fromState(GoRouterState state) =>
      ChapterEditRoute(chapterId: state.pathParameters['chapterId']!);

  ChapterEditRoute get _self => this as ChapterEditRoute;

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

mixin _$AdventureRoute on GoRouteData {
  static AdventureRoute _fromState(GoRouterState state) => AdventureRoute(
    chapterId: state.pathParameters['chapterId']!,
    adventureId: state.pathParameters['adventureId']!,
  );

  AdventureRoute get _self => this as AdventureRoute;

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

mixin _$AdventureEditRoute on GoRouteData {
  static AdventureEditRoute _fromState(GoRouterState state) =>
      AdventureEditRoute(
        chapterId: state.pathParameters['chapterId']!,
        adventureId: state.pathParameters['adventureId']!,
      );

  AdventureEditRoute get _self => this as AdventureEditRoute;

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

mixin _$SceneRoute on GoRouteData {
  static SceneRoute _fromState(GoRouterState state) => SceneRoute(
    chapterId: state.pathParameters['chapterId']!,
    adventureId: state.pathParameters['adventureId']!,
    sceneId: state.pathParameters['sceneId']!,
  );

  SceneRoute get _self => this as SceneRoute;

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

mixin _$SceneEditRoute on GoRouteData {
  static SceneEditRoute _fromState(GoRouterState state) => SceneEditRoute(
    chapterId: state.pathParameters['chapterId']!,
    adventureId: state.pathParameters['adventureId']!,
    sceneId: state.pathParameters['sceneId']!,
  );

  SceneEditRoute get _self => this as SceneEditRoute;

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

mixin _$EncounterRoute on GoRouteData {
  static EncounterRoute _fromState(GoRouterState state) =>
      EncounterRoute(encounterId: state.pathParameters['encounterId']!);

  EncounterRoute get _self => this as EncounterRoute;

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

mixin _$EncounterEditRoute on GoRouteData {
  static EncounterEditRoute _fromState(GoRouterState state) =>
      EncounterEditRoute(encounterId: state.pathParameters['encounterId']!);

  EncounterEditRoute get _self => this as EncounterEditRoute;

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

mixin _$EntityRoute on GoRouteData {
  static EntityRoute _fromState(GoRouterState state) =>
      EntityRoute(entityId: state.pathParameters['entityId']!);

  EntityRoute get _self => this as EntityRoute;

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

mixin _$EntityEditRoute on GoRouteData {
  static EntityEditRoute _fromState(GoRouterState state) =>
      EntityEditRoute(entityId: state.pathParameters['entityId']!);

  EntityEditRoute get _self => this as EntityEditRoute;

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

mixin _$PartyRootRoute on GoRouteData {
  static PartyRootRoute _fromState(GoRouterState state) =>
      PartyRootRoute(id: state.uri.queryParameters['id']);

  PartyRootRoute get _self => this as PartyRootRoute;

  @override
  String get location => GoRouteData.$location(
    '/party',
    queryParams: {if (_self.id != null) 'id': _self.id},
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

mixin _$PartyRoute on GoRouteData {
  static PartyRoute _fromState(GoRouterState state) =>
      PartyRoute(partyId: state.pathParameters['partyId']!);

  PartyRoute get _self => this as PartyRoute;

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

mixin _$PartyEditRoute on GoRouteData {
  static PartyEditRoute _fromState(GoRouterState state) =>
      PartyEditRoute(partyId: state.pathParameters['partyId']!);

  PartyEditRoute get _self => this as PartyEditRoute;

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

mixin _$MemberRoute on GoRouteData {
  static MemberRoute _fromState(GoRouterState state) => MemberRoute(
    partyId: state.pathParameters['partyId']!,
    memberId: state.pathParameters['memberId']!,
  );

  MemberRoute get _self => this as MemberRoute;

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

mixin _$MemberEditRoute on GoRouteData {
  static MemberEditRoute _fromState(GoRouterState state) => MemberEditRoute(
    partyId: state.pathParameters['partyId']!,
    memberId: state.pathParameters['memberId']!,
  );

  MemberEditRoute get _self => this as MemberEditRoute;

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

mixin _$SessionRoute on GoRouteData {
  static SessionRoute _fromState(GoRouterState state) => SessionRoute(
    partyId: state.pathParameters['partyId']!,
    sessionId: state.pathParameters['sessionId']!,
  );

  SessionRoute get _self => this as SessionRoute;

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

mixin _$SessionEditRoute on GoRouteData {
  static SessionEditRoute _fromState(GoRouterState state) => SessionEditRoute(
    partyId: state.pathParameters['partyId']!,
    sessionId: state.pathParameters['sessionId']!,
  );

  SessionEditRoute get _self => this as SessionEditRoute;

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

mixin _$SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

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
