import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:moonforge/data/db/daos/adventure_dao.dart';
import 'package:moonforge/data/repo/base_repository.dart';

import '../db/app_db.dart';
import '../db/tables.dart';

/// Repository for Adventure operations
class AdventureRepository extends BaseRepository<Adventure, String> {
  AdventureRepository(this._db);

  final AppDb _db;

  AdventureDao get _dao => _db.adventureDao;

  @override
  Future<Adventure?> getById(String id) =>
      handleError(() => _dao.getById(id), context: 'adventure.getById');

  @override
  Future<List<Adventure>> getAll() =>
      handleError(() => _dao.watchAll().first, context: 'adventure.getAll');

  @override
  Future<Adventure> create(Adventure adventure) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
        AdventuresCompanion.insert(
          id: Value(adventure.id),
          chapterId: adventure.chapterId,
          name: adventure.name,
          order: adventure.order,
          summary: Value(adventure.summary),
          content: Value(adventure.content),
          entityIds: adventure.entityIds,
          createdAt: Value(adventure.createdAt ?? DateTime.now()),
          updatedAt: Value(DateTime.now()),
          rev: adventure.rev,
        ),
      );
      await _db.outboxDao.enqueue(
        table: 'adventures',
        rowId: adventure.id,
        op: 'upsert',
      );
    });
    return adventure;
  }, context: 'adventure.create');

  @override
  Future<Adventure> update(Adventure adventure) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
        AdventuresCompanion(
          id: Value(adventure.id),
          chapterId: Value(adventure.chapterId),
          name: Value(adventure.name),
          order: Value(adventure.order),
          summary: Value(adventure.summary),
          content: Value(adventure.content),
          entityIds: Value(adventure.entityIds),
          updatedAt: Value(DateTime.now()),
          rev: Value(adventure.rev + 1),
        ),
      );
      await _db.outboxDao.enqueue(
        table: 'adventures',
        rowId: adventure.id,
        op: 'upsert',
      );
    });
    return adventure;
  }, context: 'adventure.update');

  @override
  Future<void> delete(String id) => handleError(() async {
    await _db.transaction(() async {
      await _dao.deleteById(id);
      await _db.outboxDao.enqueue(table: 'adventures', rowId: id, op: 'delete');
    });
  }, context: 'adventure.delete');

  @override
  Stream<Adventure?> watchById(String id) => handleStreamError(
    () => _dao.watchAll().map(
      (list) => list.firstWhereOrNull((adv) => adv.id == id),
    ),
    context: 'adventure.watchById',
  );

  @override
  Stream<List<Adventure>> watchAll() =>
      handleStreamError(_dao.watchAll, context: 'adventure.watchAll');

  /// Watch adventures for a specific chapter.
  Stream<List<Adventure>> watchByChapter(String chapterId) => handleStreamError(
    () => _dao.watchByChapter(chapterId),
    context: 'adventure.watchByChapter',
  );

  /// Fetch adventures for a chapter ordered by `order`.
  Future<List<Adventure>> getByChapter(String chapterId) => handleError(
    () => _dao.customQuery(
      filter: (a) => a.chapterId.equals(chapterId),
      sort: [(a) => OrderingTerm.asc(a.order)],
    ),
    context: 'adventure.getByChapter',
  );

  Future<int> countByChapter(String chapterId) => handleError(
    () => _dao.countByChapter(chapterId),
    context: 'adventure.countByChapter',
  );

  /// Optimistic local upsert (no rev bump).
  Future<void> upsertLocal(Adventure adventure) => handleError(() async {
    await _dao.upsert(
      AdventuresCompanion(
        id: Value(adventure.id),
        chapterId: Value(adventure.chapterId),
        name: Value(adventure.name),
        order: Value(adventure.order),
        summary: Value(adventure.summary),
        content: Value(adventure.content),
        entityIds: Value(adventure.entityIds),
        createdAt: Value(adventure.createdAt ?? DateTime.now()),
        updatedAt: Value(DateTime.now()),
        rev: Value(adventure.rev),
      ),
    );
    await _db.outboxDao.enqueue(
      table: 'adventures',
      rowId: adventure.id,
      op: 'upsert',
    );
  }, context: 'adventure.upsertLocal');

  /// Custom query passthrough for advanced filters.
  Future<List<Adventure>> customQuery({
    Expression<bool> Function(Adventures a)? filter,
    List<OrderingTerm Function(Adventures a)>? sort,
    int? limit,
  }) => handleError(
    () => _dao.customQuery(filter: filter, sort: sort, limit: limit),
    context: 'adventure.customQuery',
  );
}
