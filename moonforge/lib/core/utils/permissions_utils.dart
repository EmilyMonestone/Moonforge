import 'package:moonforge/data/db/app_db.dart';

/// Utility class for checking user permissions in campaigns.
class PermissionsUtils {
  /// Checks if the given user is the DM (owner) of the campaign.
  static bool isDM(Campaign campaign, String? userId) {
    if (userId == null) return false;
    return campaign.ownerUid == userId;
  }

  /// Checks if the given user is a member (player) of the campaign.
  static bool isPlayer(Campaign campaign, String? userId) {
    if (userId == null) return false;
    return campaign.memberUids?.contains(userId) ?? false;
  }

  /// Checks if the given user has access to the campaign (DM or player).
  static bool hasAccess(Campaign campaign, String? userId) {
    return isDM(campaign, userId) || isPlayer(campaign, userId);
  }
}
