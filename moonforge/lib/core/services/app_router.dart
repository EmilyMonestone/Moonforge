import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/features/home/views/unknown_path_screen.dart';

/// Main application router using type-safe routes via go_router_builder
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: const HomeRouteData().location,
    routes: $appRoutes,
    errorBuilder: (BuildContext context, GoRouterState state) =>
        const UnknownPathScreen(),
    debugLogDiagnostics: false,
  );
}

// Legacy route aliases for backward compatibility
// These delegate to the new typed routes from router_config.dart
typedef HomeRoute = HomeRouteData;
typedef LoginRoute = LoginRouteData;
typedef RegisterRoute = RegisterRouteData;
typedef ForgotPasswordRoute = ForgotPasswordRouteData;
typedef CampaignsListRoute = CampaignsListRouteData;
typedef CampaignRoute = CampaignRouteData;
typedef CampaignEditRoute = CampaignEditRouteData;
typedef CampaignSettingsRoute = CampaignSettingsRouteData;
typedef CampaignAnalyticsRoute = CampaignAnalyticsRouteData;
typedef CampaignMembersRoute = CampaignMembersRouteData;
typedef ChaptersListRoute = ChaptersListRouteData;
typedef ChapterRoute = ChapterRouteData;
typedef ChapterEditRoute = ChapterEditRouteData;
typedef AdventureListRoute = AdventureListRouteData;
typedef AdventureRoute = AdventureRouteData;
typedef AdventureEditRoute = AdventureEditRouteData;
typedef SceneRoute = SceneRouteData;
typedef SceneEditRoute = SceneEditRouteData;
typedef EncountersListRoute = EncountersListRouteData;
typedef EncounterRoute = EncounterRouteData;
typedef EncounterEditRoute = EncounterEditRouteData;
typedef EntitiesListRoute = EntitiesListRouteData;
typedef InitiativeTrackerRoute = InitiativeTrackerRouteData;
typedef EntityRoute = EntityRouteData;
typedef EntityEditRoute = EntityEditRouteData;
typedef PartyRootRoute = PartyRootRouteData;
typedef PartyRoute = PartyRouteData;
typedef PartyEditRoute = PartyEditRouteData;
typedef MemberRoute = MemberRouteData;
typedef MemberEditRoute = MemberEditRouteData;
typedef SessionListRoute = SessionListRouteData;
typedef SessionRoute = SessionRouteData;
typedef SessionEditRoute = SessionEditRouteData;
typedef SettingsRoute = SettingsRouteData;
typedef ProfileRoute = ProfileRouteData;
typedef SessionPublicShareRoute = SessionPublicShareRouteData;
typedef SceneListRoute = ScenesListRouteData;
typedef SceneTemplatesRoute = SceneTemplatesRouteData;
