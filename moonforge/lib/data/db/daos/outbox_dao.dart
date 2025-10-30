import 'package:drift/drift.dart';
import 'package:moonforge/data/db/app_database.dart';
import 'package:moonforge/data/db/tables/outbox.dart';

part 'outbox_dao.g.dart';

/// DAO for managing the outbox queue
@DriftAccessor(tables: [Outbox])
class OutboxDao extends DatabaseAccessor<AppDatabase> with _$OutboxDaoMixin {
  OutboxDao(super.db);

  /// Enqueue a new operation for sync
  Future<int> enqueue({
    required String collection,
    required String docId,
    required String operation,
    String? payload,
    required int baseRevision,
    String? userId,
    int priority = 0,
  }) {
    return into(outbox).insert(
      OutboxCompanion.insert(
        collection: collection,
        docId: docId,
        operation: operation,
        payload: Value(payload),
        baseRevision: baseRevision,
        enqueuedAt: DateTime.now(),
        userId: Value(userId),
        priority: Value(priority),
      ),
    );
  }

  /// Get pending operations (not acknowledged) ordered by priority and enqueue time
  Future<List<OutboxData>> getPending({int limit = 100}) {
    return (select(outbox)
          ..where((tbl) => tbl.remoteAck.isNull())
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.priority),
            (tbl) => OrderingTerm.asc(tbl.enqueuedAt),
          ])
          ..limit(limit))
        .get();
  }

  /// Mark an operation as acknowledged
  Future<bool> markAcknowledged(int id, String ackData) {
    return (update(outbox)..where((tbl) => tbl.id.equals(id)))
        .write(OutboxCompanion(remoteAck: Value(ackData)));
  }

  /// Record a failed attempt
  Future<bool> recordFailure(int id, String error) {
    return (update(outbox)..where((tbl) => tbl.id.equals(id))).write(
      OutboxCompanion(
        retryCount: Value((select(outbox)
                  ..where((tbl) => tbl.id.equals(id)))
                .map((row) => row.retryCount + 1)
                .getSingleOrNull()
                .then((value) => value ?? 1) as int),
        lastError: Value(error),
      ),
    );
  }

  /// Delete acknowledged operations older than a certain age
  Future<int> cleanupAcknowledged({Duration age = const Duration(days: 7)}) {
    final cutoff = DateTime.now().subtract(age);
    return (delete(outbox)
          ..where((tbl) =>
              tbl.remoteAck.isNotNull() & tbl.enqueuedAt.isSmallerThanValue(cutoff)))
        .go();
  }

  /// Watch pending operation count
  Stream<int> watchPendingCount() {
    final query = selectOnly(outbox)
      ..addColumns([outbox.id.count()])
      ..where(outbox.remoteAck.isNull());
    
    return query.map((row) => row.read(outbox.id.count()) ?? 0).watchSingle();
  }
}
