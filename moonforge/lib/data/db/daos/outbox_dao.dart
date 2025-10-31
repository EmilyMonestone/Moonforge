import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_db.dart';
import '../tables.dart';

part 'outbox_dao.g.dart';

const _uuid = Uuid();

@DriftAccessor(tables: [OutboxEntries])
class OutboxDao extends DatabaseAccessor<AppDb> with _$OutboxDaoMixin {
  OutboxDao(AppDb db) : super(db);

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
        id: _uuid.v4(),
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
}
