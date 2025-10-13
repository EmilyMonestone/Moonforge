import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.gr.dart';

/// Specification for a top-level destination in the app's adaptive nav
class TabSpec {
  final String label;
  final IconData icon;
  final PageRouteInfo Function() routeFactory;

  const TabSpec({
    required this.label,
    required this.icon,
    required this.routeFactory,
  });
}

/// Central list of primary destinations (in order). Keep ≤5 for phones.
/// You can add more later (overflow handled on phones).
final List<TabSpec> kPrimaryTabs = <TabSpec>[
  TabSpec(
    label: 'Home',
    icon: Icons.home_outlined,
    routeFactory: () => const HomeRoute(),
  ),
  TabSpec(
    label: 'Settings',
    icon: Icons.settings_outlined,
    routeFactory: () => const SettingsRoute(),
  ),
];
