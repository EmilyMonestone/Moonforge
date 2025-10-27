import 'package:drift/drift.dart';
import 'package:moonforge/core/models/data/session.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/drift/dao/local_meta_mixin.dart';
import 'package:moonforge/data/drift/tables/sessions.dart';
import 'package:moonforge/data/drift/tables/local_metas.dart';

part 'sessions_dao.g.dart';

@DriftAccessor(tables: [Sessions, LocalMetas])
class SessionsDao extends DatabaseAccessor<AppDatabase>
    with _$SessionsDaoMixin, LocalMetaMixin {
  SessionsDao(super.db);

  static const String collectionName = 'sessions';

  Stream<List<Session>> watchAll() => select(sessions).watch();

  Future<Session?> getById(String id) =>
      (select(sessions)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<void> upsert(Session session, {bool markDirty = false}) {
    return transaction(() async {
      await into(sessions).insert(session, mode: InsertMode.insertOrReplace);
      if (markDirty) await this.markDirty(collectionName, session.id);
    });
  }

  // Note: Session doesn't have rev field, so no setClean needed
}
