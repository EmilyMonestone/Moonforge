import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/widgets/navigation_history_service.dart';
import 'package:moonforge/features/home/views/unknown_path_view.dart';

/// Main application router using type-safe routes via go_router_builder
class AppRouter {
  AppRouter._();

  static final NavigationHistoryService navigationHistory =
      NavigationHistoryService();

  static final GoRouter router = GoRouter(
    initialLocation: const HomeRouteData().location,
    routes: $appRoutes,
    errorBuilder: (BuildContext context, GoRouterState state) =>
        const UnknownPathView(),
    debugLogDiagnostics: false,
    observers: [],
  );
}
