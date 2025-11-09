/// Formatters for session data display
class SessionFormatters {
  SessionFormatters._();

  /// Format duration in a human-readable way
  static String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      if (minutes > 0) {
        return '$hours hour${hours > 1 ? 's' : ''} $minutes minute${minutes > 1 ? 's' : ''}';
      }
      return '$hours hour${hours > 1 ? 's' : ''}';
    } else if (duration.inMinutes > 0) {
      final minutes = duration.inMinutes;
      return '$minutes minute${minutes > 1 ? 's' : ''}';
    } else {
      final seconds = duration.inSeconds;
      return '$seconds second${seconds != 1 ? 's' : ''}';
    }
  }

  /// Format duration as short string (e.g., "2h 30m")
  static String formatDurationShort(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      if (minutes > 0) {
        return '${hours}h ${minutes}m';
      }
      return '${hours}h';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  /// Format duration as time (HH:MM:SS)
  static String formatDurationAsTime(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  /// Format session status based on datetime
  static String formatSessionStatus(DateTime? datetime) {
    if (datetime == null) return 'Unscheduled';
    
    final now = DateTime.now();
    if (datetime.isAfter(now)) {
      return 'Upcoming';
    } else {
      return 'Past';
    }
  }

  /// Format relative time until session
  static String formatTimeUntilSession(DateTime datetime) {
    final now = DateTime.now();
    final difference = datetime.difference(now);
    
    if (difference.isNegative) {
      final absDiff = difference.abs();
      if (absDiff.inDays > 0) {
        return '${absDiff.inDays} day${absDiff.inDays > 1 ? 's' : ''} ago';
      } else if (absDiff.inHours > 0) {
        return '${absDiff.inHours} hour${absDiff.inHours > 1 ? 's' : ''} ago';
      } else if (absDiff.inMinutes > 0) {
        return '${absDiff.inMinutes} minute${absDiff.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'just now';
      }
    }
    
    if (difference.inDays > 0) {
      return 'in ${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'in ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'in ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'soon';
    }
  }
}
