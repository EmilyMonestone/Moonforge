import 'dart:convert';
import 'dart:math';

/// Utility class for generating secure share tokens.
class ShareTokenUtils {
  static final _random = Random.secure();

  /// Generates a cryptographically secure random token.
  /// Returns a 64-character hexadecimal string (32 bytes).
  static String generateToken() {
    final bytes = List<int>.generate(32, (_) => _random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll(RegExp(r'[=_-]'), '');
  }

  /// Checks if a share token is valid (not expired).
  static bool isTokenValid(bool shareEnabled, DateTime? expiresAt) {
    if (!shareEnabled) return false;
    if (expiresAt == null) return true;
    return DateTime.now().isBefore(expiresAt);
  }
}
