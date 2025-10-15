import 'package:auto_route/auto_route.dart';
import 'package:moonforge/core/services/app_router.gr.dart';

// no-op change to trigger build_runner

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material(); //.cupertino, .adaptive ..etc

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/',
      page: LayoutShell.page,
      //initial: true,
      children: [
        // Tabs
        AutoRoute(
          path: '',
          initial: true,
          page: HomeRoute.page,
          children: [
            // Feature routes inside Home tab
            AutoRoute(path: 'campaign', page: CampaignRoute.page),
            AutoRoute(path: 'campaign/edit', page: CampaignEditRoute.page),
            AutoRoute(
              path: 'campaign/chapter/:chapterId',
              page: ChapterRoute.page,
            ),
            AutoRoute(
              path: 'campaign/chapter/:chapterId/edit',
              page: ChapterEditRoute.page,
            ),
            AutoRoute(
              path: 'campaign/chapter/:chapterId/adventure/:adventureId',
              page: AdventureRoute.page,
            ),
            AutoRoute(
              path: 'campaign/chapter/:chapterId/adventure/:adventureId/edit',
              page: AdventureEditRoute.page,
            ),
            AutoRoute(
              path:
                  'campaign/chapter/:chapterId/adventure/:adventureId/scene/:sceneId',
              page: SceneRoute.page,
            ),
            AutoRoute(
              path:
                  'campaign/chapter/:chapterId/adventure/:adventureId/scene/:sceneId/edit',
              page: SceneEditRoute.page,
            ),
            AutoRoute(
              path: 'campaign/encounter/:encounterId',
              page: EncounterRoute.page,
            ),
            AutoRoute(
              path: 'campaign/encounter/:encounterId/edit',
              page: EncounterEditRoute.page,
            ),
            AutoRoute(
              path: 'campaign/entity/:entityId',
              page: EntityRoute.page,
            ),
            AutoRoute(
              path: 'campaign/entity/:entityId/edit',
              page: EntityEditRoute.page,
            ),

            AutoRoute(
              path: 'party/:partyId',
              page: PartyRoute.page,
              children: [
                AutoRoute(path: 'member/:memberId', page: MemberRoute.page),
                AutoRoute(
                  path: 'member/:memberId/edit',
                  page: MemberEditRoute.page,
                ),
                AutoRoute(path: 'session/:sessionId', page: SessionRoute.page),
                AutoRoute(
                  path: 'session/:sessionId/edit',
                  page: SessionEditRoute.page,
                ),
              ],
            ),

            AutoRoute(path: 'login', page: LoginRoute.page),
          ],
        ),
        AutoRoute(path: 'settings', page: SettingsRoute.page),
      ],
    ),

    // Unknown/fallback — keep last at top level
    AutoRoute(path: '*', page: UnknownPathRoute.page),
  ];

  @override
  List<AutoRouteGuard> get guards => [
    // optionally add root guards here
  ];
}
