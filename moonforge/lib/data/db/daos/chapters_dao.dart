import 'package:drift/drift.dart';
import 'package:moonforge/data/db/app_database.dart';
import 'package:moonforge/data/db/tables/chapters.dart';
import 'package:moonforge/data/models/chapter.dart' as model;

part 'chapters_dao.g.dart';

/// DAO for chapters table
@DriftAccessor(tables: [Chapters])
class ChaptersDao extends DatabaseAccessor<AppDatabase>
    with _$ChaptersDaoMixin {
  ChaptersDao(super.db);

  /// Watch all chapters for a campaign
  Stream<List<model.Chapter>> watchByCampaign(String campaignId) {
    return (select(chapters)
          ..where((tbl) =>
              tbl.campaignId.equals(campaignId) & tbl.isDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.orderIndex)]))
        .watch()
        .map((rows) => rows.map(_rowToModel).toList());
  }

  /// Watch a single chapter
  Stream<model.Chapter?> watchOne(String id) {
    return (select(chapters)..where((tbl) => tbl.id.equals(id)))
        .watchSingleOrNull()
        .map((row) => row != null ? _rowToModel(row) : null);
  }

  /// Get a chapter by ID
  Future<model.Chapter?> getById(String id) async {
    final row = await (select(chapters)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _rowToModel(row) : null;
  }

  /// Insert or update a chapter
  Future<void> upsert(model.Chapter chapter, {bool markDirty = false}) {
    return into(chapters).insertOnConflictUpdate(
      ChaptersCompanion.insert(
        id: chapter.id,
        campaignId: chapter.campaignId,
        name: chapter.name,
        description: chapter.description,
        content: Value(chapter.content),
        orderIndex: Value(chapter.orderIndex),
        createdAt: Value(chapter.createdAt),
        updatedAt: Value(chapter.updatedAt),
        rev: Value(chapter.rev),
        isDeleted: Value(chapter.isDeleted),
        isDirty: Value(markDirty),
      ),
    );
  }

  /// Soft delete a chapter
  Future<void> softDelete(String id) {
    return (update(chapters)..where((tbl) => tbl.id.equals(id))).write(
      const ChaptersCompanion(
        isDeleted: Value(true),
        isDirty: Value(true),
      ),
    );
  }

  /// Convert database row to model
  model.Chapter _rowToModel(ChapterData row) {
    return model.Chapter(
      id: row.id,
      campaignId: row.campaignId,
      name: row.name,
      description: row.description,
      content: row.content,
      orderIndex: row.orderIndex,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      rev: row.rev,
      isDeleted: row.isDeleted,
    );
  }
}
