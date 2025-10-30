import 'package:drift/drift.dart';
import 'package:moonforge/core/utils/logger.dart';
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
    logger.d(
      'Outbox.enqueue type=$opType path=$docPath/$docId baseRev=$baseRev',
    );
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
    final current = await (select(
      outboxOps,
    )..where((op) => op.id.equals(id))).getSingleOrNull();
    if (current != null) {
      final nextAttempt = current.attempt + 1;
      logger.w('Outbox.markAttempt id=$id → attempt=$nextAttempt');
      await (update(outboxOps)..where((op) => op.id.equals(id))).write(
        OutboxOpsCompanion(attempt: Value(nextAttempt)),
      );
    } else {
      logger.w('Outbox.markAttempt called for missing id=$id');
    }
  }

  /// Remove an operation after successful sync
  Future<void> remove(int id) {
    logger.t('Outbox.remove id=$id');
    return (delete(outboxOps)..where((op) => op.id.equals(id))).go();
  }

  /// Get all pending operations (for debugging/monitoring)
  Stream<List<OutboxOp>> watchAll() {
    logger.t('Outbox.watchAll()');
    return select(outboxOps).watch();
  }

  /// Get count of pending operations
  Future<int> pendingCount() async {
    final query = selectOnly(outboxOps)..addColumns([outboxOps.id.count()]);
    final result = await query.getSingle();
    final count = result.read(outboxOps.id.count()) ?? 0;
    if (count > 0) logger.t('Outbox.pendingCount = $count');
    return count;
  }

  /// Clear all pending operations (useful for debugging/testing)
  Future<void> clearAll() async {
    final count = await pendingCount();
    if (count > 0) {
      logger.w('Outbox.clearAll() removing $count pending operations');
      await delete(outboxOps).go();
    } else {
      logger.i('Outbox.clearAll() no operations to clear');
    }
  }
}
