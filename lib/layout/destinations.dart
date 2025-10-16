import 'package:flutter/material.dart';

/// Specification for a top-level destination in the app's adaptive nav
class TabSpec {
  final String label;
  final IconData icon;
  final String location;

  const TabSpec({
    required this.label,
    required this.icon,
    required this.location,
  });
}

final List<TabSpec> kPrimaryTabs = <TabSpec>[
  TabSpec(label: 'Home', icon: Icons.home_outlined, location: '/'),
  TabSpec(label: 'Campaign', icon: Icons.book_outlined, location: '/campaign'),
  TabSpec(label: 'Party', icon: Icons.group_outlined, location: '/party'),
  TabSpec(
    label: 'Settings',
    icon: Icons.settings_outlined,
    location: '/settings',
  ),
];
