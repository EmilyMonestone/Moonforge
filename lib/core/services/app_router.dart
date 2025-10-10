import 'package:auto_route/auto_route.dart';
import 'package:moonforge/core/services/app_router.gr.dart';

// no-op change to trigger build_runner

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material(); //.cupertino, .adaptive ..etc

  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '*', page: UnknownPathRoute.page),
    AutoRoute(path: '', initial: true, page: HomeRoute.page),
    AutoRoute(path: '/campaign/:campaignId', page: CampaignRoute.page),
    AutoRoute(path: '/campaign/:campaignId/edit', page: CampaignEditRoute.page),
    AutoRoute(
      path: '/campaign/:campaignId/chapter/:chapterId',
      page: ChapterRoute.page,
    ),
    AutoRoute(
      path: '/campaign/:campaignId/chapter/:chapterId/edit',
      page: ChapterEditRoute.page,
    ),
    AutoRoute(
      path: '/campaign/:campaignId/chapter/:chapterId/adventure/:adventureId',
      page: AdventureRoute.page,
    ),
    AutoRoute(
      path:
          '/campaign/:campaignId/chapter/:chapterId/adventure/:adventureId/edit',
      page: AdventureEditRoute.page,
    ),
    AutoRoute(
      path:
          '/campaign/:campaignId/chapter/:chapterId/adventure/:adventureId/scene/:sceneId',
      page: SceneRoute.page,
    ),
    AutoRoute(
      path:
          '/campaign/:campaignId/chapter/:chapterId/adventure/:adventureId/scene/:sceneId/edit',
      page: SceneEditRoute.page,
    ),
    AutoRoute(
      path: '/campaign/:campaignId/encoutner/:encoutnerId',
      page: EncounterRoute.page,
    ),
    AutoRoute(
      path: '/campaign/:campaignId/encoutner/:encoutnerId/edit',
      page: EncounterEditRoute.page,
    ),
    AutoRoute(
      path: '/campaign/:campaignId/entity/:entityId',
      page: EntityRoute.page,
    ),
    AutoRoute(
      path: '/campaign/:campaignId/entity/:entityId/edit',
      page: EntityEditRoute.page,
    ),
    AutoRoute(path: '/party/:partyId', page: PartyRoute.page),
    AutoRoute(path: '/party/:partyId/edit', page: PartyEditRoute.page),
    AutoRoute(path: '/party/:partyId/member/:memberId', page: MemberRoute.page),
    AutoRoute(
      path: '/party/:partyId/member/:memberId/edit',
      page: MemberEditRoute.page,
    ),
    AutoRoute(
      path: '/party/:partyId/session/:sessionId',
      page: SessionRoute.page,
    ),
    AutoRoute(
      path: '/party/:partyId/session/:sessionId/edit',
      page: SessionEditRoute.page,
    ),
    AutoRoute(path: '/login', page: LoginRoute.page),
    AutoRoute(path: '/register', page: RegisterRoute.page),
    AutoRoute(path: '/settings', page: SettingsRoute.page),
  ];

  @override
  List<AutoRouteGuard> get guards => [
    // optionally add root guards here
  ];
}
