import 'package:drift/drift.dart';
import 'package:moonforge/core/models/data/chapter.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/drift/dao/local_meta_mixin.dart';
import 'package:moonforge/data/drift/tables/chapters.dart';
import 'package:moonforge/data/drift/tables/local_metas.dart';

part 'chapters_dao.g.dart';

@DriftAccessor(tables: [Chapters, LocalMetas])
class ChaptersDao extends DatabaseAccessor<AppDatabase>
    with _$ChaptersDaoMixin, LocalMetaMixin {
  ChaptersDao(super.db);

  static const String collectionName = 'chapters';

  Stream<List<Chapter>> watchAll() => select(chapters).watch();

  Future<Chapter?> getById(String id) =>
      (select(chapters)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<void> upsert(Chapter chapter, {bool markDirty = false}) {
    return transaction(() async {
      await into(chapters).insertOnConflictUpdate(chapter);
      if (markDirty) await this.markDirty(collectionName, chapter.id);
    });
  }

  Future<void> setClean(String id, int newRev) {
    return transaction(() async {
      await (update(chapters)..where((c) => c.id.equals(id)))
          .write(ChaptersCompanion(rev: Value(newRev)));
      await markClean(collectionName, id);
    });
  }
}
