import 'package:flutter/material.dart';
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
          const NewCampaignRoute().go(context);
        },
      ),
      QuickAction(
        id: 'new_session',
        label: 'New Session',
        icon: Icons.event,
        tooltip: 'Schedule a new session',
        onTap: (context) {
          const SessionRoute().go(context);
        },
      ),
      QuickAction(
        id: 'new_party',
        label: 'New Party',
        icon: Icons.group,
        tooltip: 'Create a new party',
        onTap: (context) {
          const PartyRootRoute().go(context);
        },
      ),
      QuickAction(
        id: 'campaigns',
        label: 'Campaigns',
        icon: Icons.book,
        tooltip: 'View all campaigns',
        onTap: (context) {
          const CampaignRoute().go(context);
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
