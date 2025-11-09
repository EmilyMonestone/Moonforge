import 'package:intl/intl.dart';
import 'package:moonforge/data/db/app_db.dart';

/// Formatting utilities for entity display
class EntityFormatters {
  EntityFormatters._();

  /// Format entity kind as a human-readable label
  static String formatKind(String kind) {
    switch (kind) {
      case 'npc':
        return 'NPC';
      case 'monster':
        return 'Monster';
      case 'group':
        return 'Group';
      case 'place':
        return 'Place';
      case 'item':
        return 'Item';
      case 'handout':
        return 'Handout';
      case 'journal':
        return 'Journal';
      default:
        return kind;
    }
  }

  /// Format entity summary with ellipsis if too long
  static String formatSummary(String? summary, {int maxLength = 100}) {
    if (summary == null || summary.isEmpty) {
      return '';
    }
    if (summary.length <= maxLength) {
      return summary;
    }
    return '${summary.substring(0, maxLength)}...';
  }

  /// Format tags as a comma-separated string
  static String formatTags(List<String> tags, {int maxTags = 3}) {
    if (tags.isEmpty) {
      return '';
    }
    final displayTags = tags.take(maxTags).toList();
    final remaining = tags.length - displayTags.length;
    var result = displayTags.join(', ');
    if (remaining > 0) {
      result += ' +$remaining more';
    }
    return result;
  }

  /// Format entity created/updated date
  static String formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat.yMMMd().format(date);
    }
  }

  /// Format entity for display in lists
  static String formatEntityDisplay(Entity entity) {
    final kindLabel = formatKind(entity.kind);
    if (entity.summary != null && entity.summary!.isNotEmpty) {
      return '${entity.name} ($kindLabel) - ${formatSummary(entity.summary, maxLength: 50)}';
    }
    return '${entity.name} ($kindLabel)';
  }

  /// Format coordinates
  static String formatCoordinates(Map<String, dynamic> coords) {
    if (coords.isEmpty) {
      return '';
    }
    final lat = coords['lat'];
    final lng = coords['lng'];
    if (lat != null && lng != null) {
      return 'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}';
    }
    return coords.toString();
  }

  /// Format place type with parent place
  static String formatPlaceInfo(Entity entity) {
    final parts = <String>[];
    if (entity.placeType != null && entity.placeType!.isNotEmpty) {
      parts.add(entity.placeType!);
    }
    if (entity.parentPlaceId != null && entity.parentPlaceId!.isNotEmpty) {
      parts.add('in ${entity.parentPlaceId}');
    }
    return parts.join(' ');
  }

  /// Format members count for group entities
  static String formatMembersCount(List<String> members) {
    if (members.isEmpty) {
      return 'No members';
    }
    if (members.length == 1) {
      return '1 member';
    }
    return '${members.length} members';
  }
}
