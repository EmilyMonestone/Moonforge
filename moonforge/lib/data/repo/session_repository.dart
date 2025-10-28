import 'dart:convert';

import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/firebase/models/session.dart';

/// Repository for Session operations
/// Now includes rev field for CAS (Compare-And-Set) sync
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
        baseRev: session.rev,
        opType: 'upsert',
        payload: jsonEncode(session.toJson()),
      );
    });
  }

  /// Called by sync engine after successful Firestore write
  Future<void> setClean(String id, int rev) async {
    await _db.sessionsDao.setClean(id, rev);
  }
}
