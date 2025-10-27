import 'dart:convert';
import 'package:moonforge/core/models/data/session.dart';
import 'package:moonforge/data/drift/app_database.dart';

/// Repository for Session operations
/// Note: Session doesn't have rev field, so no CAS sync
class SessionRepository {
  final AppDatabase _db;

  SessionRepository(this._db);

  Stream<List<Session>> watchAll() => _db.sessionsDao.watchAll();

  Future<Session?> getById(String id) => _db.sessionsDao.getById(id);

  Future<void> upsertLocal(Session session) async {
    await _db.transaction(() async {
      await _db.sessionsDao.upsert(session, markDirty: true);
      await _db.outboxDao.enqueue(
        docPath: 'sessions',
        docId: session.id,
        baseRev: 0, // Session has no rev field
        opType: 'upsert',
        payload: jsonEncode(session.toJson()),
      );
    });
  }
}
