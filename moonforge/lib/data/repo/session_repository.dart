import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:moonforge/data/db/daos/session_dao.dart';
import 'package:moonforge/data/repo/base_repository.dart';

import '../db/app_db.dart';
import '../db/tables.dart';

/// Repository for Session operations
class SessionRepository extends BaseRepository<Session, String> {
  SessionRepository(this._db);

  final AppDb _db;

  SessionDao get _dao => _db.sessionDao;

  @override
  Future<Session?> getById(String id) =>
      handleError(() => _dao.getById(id), context: 'session.getById');

  @override
  Future<List<Session>> getAll() =>
      handleError(() => _dao.watchAll().first, context: 'session.getAll');

  @override
  Stream<List<Session>> watchAll() =>
      handleStreamError(_dao.watchAll, context: 'session.watchAll');

  @override
  Future<Session> create(Session session) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
        SessionsCompanion.insert(
          id: Value(session.id),
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
    return session;
  }, context: 'session.create');

  @override
  Future<Session> update(Session session) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
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
    return session;
  }, context: 'session.update');

  @override
  Future<void> delete(String id) => handleError(() async {
    await _db.transaction(() async {
      await _dao.deleteById(id);
      await _db.outboxDao.enqueue(table: 'sessions', rowId: id, op: 'delete');
    });
  }, context: 'session.delete');

  /// Custom query passthrough
  Future<List<Session>> customQuery({
    Expression<bool> Function(Sessions s)? filter,
    List<OrderingTerm Function(Sessions s)>? sort,
    int? limit,
  }) => handleError(
    () => _dao.customQuery(filter: filter, sort: sort, limit: limit),
    context: 'session.customQuery',
  );

  @override
  Stream<Session?> watchById(String id) => handleStreamError(
    () =>
        _dao.watchAll().map((list) => list.firstWhereOrNull((s) => s.id == id)),
    context: 'session.watchById',
  );
}
