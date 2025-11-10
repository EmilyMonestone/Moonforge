import 'package:drift/drift.dart';

import '../app_db.dart';
import '../tables.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [Sessions])
class SessionDao extends DatabaseAccessor<AppDb> with _$SessionDaoMixin {
  SessionDao(super.db);

  Stream<List<Session>> watchAll() => (select(
    sessions,
  )..orderBy([(s) => OrderingTerm.desc(s.datetime)])).watch();

  Future<List<Session>> getAll() =>
      (select(sessions)..orderBy([(s) => OrderingTerm.desc(s.datetime)])).get();

  Future<Session?> getById(String id) =>
      (select(sessions)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<void> upsert(SessionsCompanion data) async =>
      into(sessions).insertOnConflictUpdate(data);

  Future<int> deleteById(String id) =>
      (delete(sessions)..where((s) => s.id.equals(id))).go();

  /// Custom query with custom filter, custom sort and custom limit
  Future<List<Session>> customQuery({
    Expression<bool> Function(Sessions s)? filter,
    List<OrderingTerm Function(Sessions s)>? sort,
    int? limit,
  }) {
    final query = select(sessions);

    if (filter != null) {
      query.where(filter);
    }

    if (sort != null && sort.isNotEmpty) {
      query.orderBy(sort);
    }

    if (limit != null) {
      query.limit(limit);
    }

    return query.get();
  }
}
