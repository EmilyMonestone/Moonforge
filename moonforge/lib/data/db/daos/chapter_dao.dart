import 'package:drift/drift.dart';

import '../app_db.dart';
import '../tables.dart';

part 'chapter_dao.g.dart';

@DriftAccessor(tables: [Chapters])
class ChapterDao extends DatabaseAccessor<AppDb> with _$ChapterDaoMixin {
  ChapterDao(super.db);

  Stream<List<Chapter>> watchAll() =>
      (select(chapters)..orderBy([(c) => OrderingTerm.asc(c.order)])).watch();

  Stream<List<Chapter>> watchByCampaign(String campaignId) =>
      (select(chapters)
            ..where((c) => c.campaignId.equals(campaignId))
            ..orderBy([(c) => OrderingTerm.asc(c.order)]))
          .watch();

  Future<List<Chapter>> getByCampaign(String campaignId) =>
      (select(chapters)
            ..where((c) => c.campaignId.equals(campaignId))
            ..orderBy([(c) => OrderingTerm.asc(c.order)]))
          .get();

  Future<Chapter?> getById(String id) =>
      (select(chapters)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<void> upsert(ChaptersCompanion data) async =>
      into(chapters).insertOnConflictUpdate(data);

  Future<int> deleteById(String id) =>
      (delete(chapters)..where((c) => c.id.equals(id))).go();

  /// Custom query with custom filter, custom sort and custom limit
  Future<List<Chapter>> customQuery({
    Expression<bool> Function(Chapters c)? filter,
    List<OrderingTerm Function(Chapters c)>? sort,
    int? limit,
  }) {
    final query = select(chapters);

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
