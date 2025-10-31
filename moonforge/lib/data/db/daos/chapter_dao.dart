import 'package:drift/drift.dart';

import '../app_db.dart';
import '../tables.dart';

part 'chapter_dao.g.dart';

@DriftAccessor(tables: [Chapters])
class ChapterDao extends DatabaseAccessor<AppDb> with _$ChapterDaoMixin {
  ChapterDao(AppDb db) : super(db);

  Stream<List<Chapter>> watchAll() =>
      (select(chapters)..orderBy([(c) => OrderingTerm.asc(c.order)])).watch();

  Stream<List<Chapter>> watchByCampaign(String campaignId) =>
      (select(chapters)
            ..where((c) => c.campaignId.equals(campaignId))
            ..orderBy([(c) => OrderingTerm.asc(c.order)]))
          .watch();

  Future<Chapter?> getById(String id) =>
      (select(chapters)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<void> upsert(ChaptersCompanion data) async =>
      into(chapters).insertOnConflictUpdate(data);

  Future<int> deleteById(String id) =>
      (delete(chapters)..where((c) => c.id.equals(id))).go();
}
