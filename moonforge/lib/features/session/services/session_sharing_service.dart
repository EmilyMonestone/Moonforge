import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/session_repository.dart';
import 'session_service.dart';

/// Service for managing session sharing and permissions
class SessionSharingService {
  final SessionRepository _repository;

  SessionSharingService(this._repository);

  /// Enable sharing for a session with optional expiration
  Future<String> enableSharing(
    Session session, {
    DateTime? expiresAt,
  }) async {
    String? token = session.shareToken;
    
    // Generate new token if not exists
    if (token == null || token.isEmpty) {
      token = SessionService.generateShareToken();
    }

    final updatedSession = session.copyWith(
      shareToken: token,
      shareEnabled: true,
      shareExpiresAt: expiresAt,
    );
    
    await _repository.update(updatedSession);
    return token;
  }

  /// Disable sharing for a session
  Future<void> disableSharing(Session session) async {
    final updatedSession = session.copyWith(
      shareEnabled: false,
    );
    await _repository.update(updatedSession);
  }

  /// Regenerate share token
  Future<String> regenerateToken(Session session) async {
    final newToken = SessionService.generateShareToken();
    final updatedSession = session.copyWith(
      shareToken: newToken,
      shareEnabled: true,
    );
    await _repository.update(updatedSession);
    return newToken;
  }

  /// Revoke share access by disabling and clearing token
  Future<void> revokeAccess(Session session) async {
    final updatedSession = session.copyWith(
      shareEnabled: false,
      shareToken: null,
      shareExpiresAt: null,
    );
    await _repository.update(updatedSession);
  }

  /// Check if sharing is enabled and not expired
  bool canAccess(Session session) {
    if (!session.shareEnabled) return false;
    if (session.shareToken == null || session.shareToken!.isEmpty) {
      return false;
    }
    if (session.shareExpiresAt != null) {
      return DateTime.now().isBefore(session.shareExpiresAt!);
    }
    return true;
  }

  /// Get session by share token
  Future<Session?> getSessionByToken(String token) async {
    final sessions = await _repository.customQuery(
      filter: (s) => s.shareToken.equals(token),
      limit: 1,
    );
    
    if (sessions.isEmpty) return null;
    
    final session = sessions.first;
    
    // Check if share is valid
    if (!canAccess(session)) return null;
    
    return session;
  }

  /// Get share URL for a session
  String getShareUrl(Session session, String baseUrl) {
    if (session.shareToken == null) return '';
    return '$baseUrl/share/session/${session.shareToken}';
  }

  /// Update share expiration
  Future<void> updateExpiration(
    Session session,
    DateTime? expiresAt,
  ) async {
    final updatedSession = session.copyWith(
      shareExpiresAt: expiresAt,
    );
    await _repository.update(updatedSession);
  }

  /// Get all shared sessions
  Future<List<Session>> getSharedSessions() async {
    return await _repository.customQuery(
      filter: (s) => s.shareEnabled.equals(true),
      sort: [(s) => OrderingTerm.desc(s.datetime)],
    );
  }

  /// Check if share will expire soon (within 24 hours)
  bool isExpiringSoon(Session session) {
    if (session.shareExpiresAt == null) return false;
    final now = DateTime.now();
    final expiresIn = session.shareExpiresAt!.difference(now);
    return expiresIn.isNegative || expiresIn.inHours < 24;
  }
}
