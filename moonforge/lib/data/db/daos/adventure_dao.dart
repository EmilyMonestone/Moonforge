import 'package:drift/drift.dart';

import '../app_db.dart';
import '../tables.dart';

part 'adventure_dao.g.dart';

@DriftAccessor(tables: [Adventures])
class AdventureDao extends DatabaseAccessor<AppDb> with _$AdventureDaoMixin {
  AdventureDao(super.db);

  Stream<List<Adventure>> watchAll() =>
      (select(adventures)..orderBy([(a) => OrderingTerm.asc(a.order)])).watch();

  Stream<List<Adventure>> watchByChapter(String chapterId) =>
      (select(adventures)
            ..where((a) => a.chapterId.equals(chapterId))
            ..orderBy([(a) => OrderingTerm.asc(a.order)]))
          .watch();

  Future<Adventure?> getById(String id) =>
      (select(adventures)..where((a) => a.id.equals(id))).getSingleOrNull();

  Future<void> upsert(AdventuresCompanion data) async =>
      into(adventures).insertOnConflictUpdate(data);

  Future<int> deleteById(String id) =>
      (delete(adventures)..where((a) => a.id.equals(id))).go();

  /// Custom query with custom filter, custom sort and custom limit
  Future<List<Adventure>> customQuery({
    Expression<bool> Function(Adventures a)? filter,
    List<OrderingTerm Function(Adventures a)>? sort,
    int? limit,
  }) {
    final query = select(adventures);

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
