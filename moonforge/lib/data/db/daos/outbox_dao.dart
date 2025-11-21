import 'package:drift/drift.dart';

import '../app_db.dart';
import '../tables.dart';

part 'outbox_dao.g.dart';

@DriftAccessor(tables: [OutboxEntries])
class OutboxDao extends DatabaseAccessor<AppDb> with _$OutboxDaoMixin {
  OutboxDao(super.db);

  Stream<List<OutboxEntry>> watchAll() => (select(
    outboxEntries,
  )..orderBy([(o) => OrderingTerm.asc(o.changedAt)])).watch();

  Future<List<OutboxEntry>> getAllPending() => (select(
    outboxEntries,
  )..orderBy([(o) => OrderingTerm.asc(o.changedAt)])).get();

  /// Returns the number of pending outbox entries
  Future<int> pendingCount() async {
    final rows = await (select(outboxEntries)).get();
    return rows.length;
  }

  Future<void> enqueue({
    required String table,
    required String rowId,
    required String op,
    String? payload,
  }) async {
    await into(outboxEntries).insert(
      OutboxEntriesCompanion.insert(
        table: table,
        rowId: rowId,
        op: op,
        changedAt: DateTime.now(),
        payload: Value(payload),
      ),
    );
  }

  Future<int> removeById(String id) =>
      (delete(outboxEntries)..where((o) => o.id.equals(id))).go();

  /// Custom query with custom filter, custom sort and custom limit
  Future<List<OutboxEntry>> customQuery({
    Expression<bool> Function(OutboxEntries o)? filter,
    List<OrderingTerm Function(OutboxEntries o)>? sort,
    int? limit,
  }) {
    final query = select(outboxEntries);

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
