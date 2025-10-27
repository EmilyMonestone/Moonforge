import 'package:drift/drift.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/drift/tables/outbox_ops.dart';

part 'outbox_dao.g.dart';

/// Data Access Object for Outbox operations
@DriftAccessor(tables: [OutboxOps])
class OutboxDao extends DatabaseAccessor<AppDatabase> with _$OutboxDaoMixin {
  OutboxDao(super.db);

  /// Enqueue a new operation
  Future<int> enqueue({
    required String docPath,
    required String docId,
    required int baseRev,
    required String opType,
    required String payload,
  }) {
    return into(outboxOps).insert(
      OutboxOpsCompanion.insert(
        docPath: docPath,
        docId: docId,
        baseRev: baseRev,
        opType: opType,
        payload: payload,
        enqueuedAt: DateTime.now(),
      ),
    );
  }

  /// Get the next operation to process (oldest first)
  Future<OutboxOp?> nextOp() {
    return (select(outboxOps)
          ..orderBy([(op) => OrderingTerm.asc(op.enqueuedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Increment attempt counter for an operation
  Future<void> markAttempt(int id) async {
    final current = await (select(outboxOps)..where((op) => op.id.equals(id))).getSingleOrNull();
    if (current != null) {
      await (update(outboxOps)..where((op) => op.id.equals(id)))
          .write(OutboxOpsCompanion(attempt: Value(current.attempt + 1)));
    }
  }

  /// Remove an operation after successful sync
  Future<void> remove(int id) {
    return (delete(outboxOps)..where((op) => op.id.equals(id))).go();
  }

  /// Get all pending operations (for debugging/monitoring)
  Stream<List<OutboxOp>> watchAll() {
    return select(outboxOps).watch();
  }

  /// Get count of pending operations
  Future<int> pendingCount() async {
    final query = selectOnly(outboxOps)..addColumns([outboxOps.id.count()]);
    final result = await query.getSingle();
    return result.read(outboxOps.id.count()) ?? 0;
  }
}
