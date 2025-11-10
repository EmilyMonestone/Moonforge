import 'package:drift/drift.dart';

import '../db/app_db.dart';
import '../db/tables.dart';

/// Repository for Chapter operations
class ChapterRepository {
  final AppDb _db;

  ChapterRepository(this._db);

  Stream<List<Chapter>> watchAll() => _db.chapterDao.watchAll();

  Future<List<Chapter>> getAll() => _db.chapterDao.getAll();

  /// Watch chapters for a campaign
  Stream<List<Chapter>> watchByCampaign(String campaignId) =>
      _db.chapterDao.watchByCampaign(campaignId);

  /// Get chapters for a campaign (ordered by order)
  Future<List<Chapter>> getByCampaign(String campaignId) =>
      _db.chapterDao.getByCampaign(campaignId);

  /// Get a single chapter by ID
  Future<Chapter?> getById(String id) => _db.chapterDao.getById(id);

  /// Create a new chapter
  Future<void> create(Chapter chapter) async {
    await _db.transaction(() async {
      await _db.chapterDao.upsert(
        ChaptersCompanion.insert(
          id: chapter.id,
          campaignId: chapter.campaignId,
          name: chapter.name,
          order: chapter.order,
          summary: Value(chapter.summary),
          content: Value(chapter.content),
          entityIds: chapter.entityIds,
          createdAt: Value(chapter.createdAt ?? DateTime.now()),
          updatedAt: Value(DateTime.now()),
          rev: chapter.rev,
        ),
      );

      await _db.outboxDao.enqueue(
        table: 'chapters',
        rowId: chapter.id,
        op: 'upsert',
      );
    });
  }

  /// Update an existing chapter
  Future<void> update(Chapter chapter) async {
    await _db.transaction(() async {
      await _db.chapterDao.upsert(
        ChaptersCompanion(
          id: Value(chapter.id),
          campaignId: Value(chapter.campaignId),
          name: Value(chapter.name),
          order: Value(chapter.order),
          summary: Value(chapter.summary),
          content: Value(chapter.content),
          entityIds: Value(chapter.entityIds),
          updatedAt: Value(DateTime.now()),
          rev: Value(chapter.rev + 1),
        ),
      );

      await _db.outboxDao.enqueue(
        table: 'chapters',
        rowId: chapter.id,
        op: 'upsert',
      );
    });
  }

  /// Optimistic local upsert (no rev bump here)
  Future<void> upsertLocal(Chapter chapter) async {
    await _db.chapterDao.upsert(
      ChaptersCompanion(
        id: Value(chapter.id),
        campaignId: Value(chapter.campaignId),
        name: Value(chapter.name),
        order: Value(chapter.order),
        summary: Value(chapter.summary),
        content: Value(chapter.content),
        entityIds: Value(chapter.entityIds),
        createdAt: Value(chapter.createdAt ?? DateTime.now()),
        updatedAt: Value(DateTime.now()),
        rev: Value(chapter.rev),
      ),
    );
    await _db.outboxDao.enqueue(
      table: 'chapters',
      rowId: chapter.id,
      op: 'upsert',
    );
  }

  /// Delete a chapter
  Future<void> delete(String id) async {
    await _db.transaction(() async {
      await _db.chapterDao.deleteById(id);

      await _db.outboxDao.enqueue(table: 'chapters', rowId: id, op: 'delete');
    });
  }

  /// Custom query with custom filter, custom sort and custom limit
  Future<List<Chapter>> customQuery({
    Expression<bool> Function(Chapters c)? filter,
    List<OrderingTerm Function(Chapters c)>? sort,
    int? limit,
  }) {
    return _db.chapterDao.customQuery(filter: filter, sort: sort, limit: limit);
  }
}
