import '../db/app_db.dart';
import '../db/tables.dart';
import 'package:drift/drift.dart';

/// Repository for Session operations
class SessionRepository {
  final AppDb _db;

  SessionRepository(this._db);

  /// Watch all sessions
  Stream<List<Session>> watchAll() => _db.sessionDao.watchAll();

  /// Get a single session by ID
  Future<Session?> getById(String id) => _db.sessionDao.getById(id);

  /// Create a new session
  Future<void> create(Session session) async {
    await _db.transaction(() async {
      await _db.sessionDao.upsert(
        SessionsCompanion.insert(
          id: session.id,
          createdAt: Value(session.createdAt ?? DateTime.now()),
          info: Value(session.info),
          datetime: Value(session.datetime),
          log: Value(session.log),
          shareToken: Value(session.shareToken),
          shareEnabled: Value(session.shareEnabled),
          shareExpiresAt: Value(session.shareExpiresAt),
          updatedAt: Value(DateTime.now()),
          rev: session.rev,
        ),
      );

      await _db.outboxDao.enqueue(
        table: 'sessions',
        rowId: session.id,
        op: 'upsert',
      );
    });
  }

  /// Update an existing session
  Future<void> update(Session session) async {
    await _db.transaction(() async {
      await _db.sessionDao.upsert(
        SessionsCompanion(
          id: Value(session.id),
          createdAt: Value(session.createdAt),
          info: Value(session.info),
          datetime: Value(session.datetime),
          log: Value(session.log),
          shareToken: Value(session.shareToken),
          shareEnabled: Value(session.shareEnabled),
          shareExpiresAt: Value(session.shareExpiresAt),
          updatedAt: Value(DateTime.now()),
          rev: Value(session.rev + 1),
        ),
      );

      await _db.outboxDao.enqueue(
        table: 'sessions',
        rowId: session.id,
        op: 'upsert',
      );
    });
  }

  /// Delete a session
  Future<void> delete(String id) async {
    await _db.transaction(() async {
      await _db.sessionDao.deleteById(id);
      
      await _db.outboxDao.enqueue(
        table: 'sessions',
        rowId: id,
        op: 'delete',
      );
    });
  }
}
