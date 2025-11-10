import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/core/services/app_router.dart';

/// A quick action that can be performed from the dashboard
class QuickAction {
  final String id;
  final String label;
  final IconData icon;
  final void Function(BuildContext context) onTap;
  final String? tooltip;

  const QuickAction({
    required this.id,
    required this.label,
    required this.icon,
    required this.onTap,
    this.tooltip,
  });
}

/// Service for managing quick actions and frequently used operations
class QuickActionsService {
  /// Get default quick actions for the dashboard
  List<QuickAction> getDefaultActions() {
    return [
      QuickAction(
        id: 'new_campaign',
        label: 'New Campaign',
        icon: Icons.add_circle_outline,
        tooltip: 'Create a new campaign',
        onTap: (context) {
          context.go(const CampaignEditRoute().location);
        },
      ),
      QuickAction(
        id: 'campaigns',
        label: 'Campaigns',
        icon: Icons.book,
        tooltip: 'View all campaigns',
        onTap: (context) {
          context.go(const CampaignRoute().location);
        },
      ),
      QuickAction(
        id: 'parties',
        label: 'Parties',
        icon: Icons.group,
        tooltip: 'View all parties',
        onTap: (context) {
          context.go(const PartyRootRoute().location);
        },
      ),
      QuickAction(
        id: 'settings',
        label: 'Settings',
        icon: Icons.settings,
        tooltip: 'App settings',
        onTap: (context) {
          context.go(const SettingsRoute().location);
        },
      ),
    ];
  }

  /// Get context-aware quick actions based on recent usage
  /// This is a placeholder for future enhancement
  List<QuickAction> getContextualActions(BuildContext context) {
    // For now, return default actions
    // In the future, this could be personalized based on user behavior
    return getDefaultActions();
  }
}
