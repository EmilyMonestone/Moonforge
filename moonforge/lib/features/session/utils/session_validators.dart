import 'package:moonforge/data/db/app_db.dart';

/// Validators for session data
class SessionValidators {
  SessionValidators._();

  /// Validate session datetime
  static String? validateDateTime(DateTime? datetime) {
    if (datetime == null) {
      return 'Session date and time is required';
    }
    return null;
  }

  /// Validate share token
  static String? validateShareToken(String? token) {
    if (token == null || token.isEmpty) {
      return 'Share token is required';
    }
    if (token.length < 16) {
      return 'Share token must be at least 16 characters';
    }
    return null;
  }

  /// Validate session before creation
  static List<String> validateSession(Session session) {
    final errors = <String>[];

    // Session ID validation
    if (session.id.isEmpty) {
      errors.add('Session ID is required');
    }

    // If sharing is enabled, validate share settings
    if (session.shareEnabled) {
      if (session.shareToken == null || session.shareToken!.isEmpty) {
        errors.add('Share token is required when sharing is enabled');
      }

      if (session.shareExpiresAt != null) {
        if (session.shareExpiresAt!.isBefore(DateTime.now())) {
          errors.add('Share expiration date must be in the future');
        }
      }
    }

    return errors;
  }

  /// Validate share expiration date
  static String? validateShareExpiration(DateTime? expiresAt) {
    if (expiresAt != null && expiresAt.isBefore(DateTime.now())) {
      return 'Expiration date must be in the future';
    }
    return null;
  }

  /// Check if session data is valid for sharing
  static bool isValidForSharing(Session session) {
    if (!session.shareEnabled) return false;
    if (session.shareToken == null || session.shareToken!.isEmpty) {
      return false;
    }
    if (session.shareExpiresAt != null &&
        session.shareExpiresAt!.isBefore(DateTime.now())) {
      return false;
    }
    return true;
  }
}
