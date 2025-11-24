import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:moonforge/data/db/daos/chapter_dao.dart';
import 'package:moonforge/data/repo/base_repository.dart';

import '../db/app_db.dart';
import '../db/tables.dart';

/// Repository for Chapter operations
class ChapterRepository extends BaseRepository<Chapter, String> {
  ChapterRepository(this._db);

  final AppDb _db;

  ChapterDao get _dao => _db.chapterDao;

  @override
  Future<Chapter?> getById(String id) =>
      handleError(() => _dao.getById(id), context: 'chapter.getById');

  @override
  Future<List<Chapter>> getAll() =>
      handleError(() => _dao.customQuery(), context: 'chapter.getAll');

  @override
  Stream<List<Chapter>> watchAll() =>
      handleStreamError(_dao.watchAll, context: 'chapter.watchAll');

  /// Watch chapters for a campaign
  Stream<List<Chapter>> watchByCampaign(String campaignId) => handleStreamError(
    () => _dao.watchByCampaign(campaignId),
    context: 'chapter.watchByCampaign',
  );

  /// Get chapters for a campaign (ordered by order)
  Future<List<Chapter>> getByCampaign(String campaignId) => handleError(
    () => _dao.getByCampaign(campaignId),
    context: 'chapter.getByCampaign',
  );

  @override
  Future<Chapter> create(Chapter chapter) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
        ChaptersCompanion.insert(
          id: Value(chapter.id),
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
    return chapter;
  }, context: 'chapter.create');

  @override
  Future<Chapter> update(Chapter chapter) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
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
    return chapter;
  }, context: 'chapter.update');

  @override
  Future<void> delete(String id) => handleError(() async {
    await _db.transaction(() async {
      await _dao.deleteById(id);
      await _db.outboxDao.enqueue(table: 'chapters', rowId: id, op: 'delete');
    });
  }, context: 'chapter.delete');

  @override
  Stream<Chapter?> watchById(String id) => handleStreamError(
    () =>
        _dao.watchAll().map((list) => list.firstWhereOrNull((c) => c.id == id)),
    context: 'chapter.watchById',
  );

  /// Custom query passthrough
  Future<List<Chapter>> customQuery({
    Expression<bool> Function(Chapters c)? filter,
    List<OrderingTerm Function(Chapters c)>? sort,
    int? limit,
  }) => handleError(
    () => _dao.customQuery(filter: filter, sort: sort, limit: limit),
    context: 'chapter.customQuery',
  );
}
