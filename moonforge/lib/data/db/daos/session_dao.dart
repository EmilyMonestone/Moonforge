import 'package:drift/drift.dart';
import '../app_db.dart';
import '../tables.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [Sessions])
class SessionDao extends DatabaseAccessor<AppDb> with _$SessionDaoMixin {
  SessionDao(AppDb db) : super(db);

  Stream<List<Session>> watchAll() =>
      (select(sessions)..orderBy([(s) => OrderingTerm.desc(s.datetime)])).watch();

  Future<Session?> getById(String id) =>
      (select(sessions)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<void> upsert(SessionsCompanion data) async =>
      into(sessions).insertOnConflictUpdate(data);

  Future<int> deleteById(String id) =>
      (delete(sessions)..where((s) => s.id.equals(id))).go();
}
