import 'package:drift/drift.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/drift/tables/storage_queue.dart';

part 'storage_queue_dao.g.dart';

/// Data Access Object for Storage Queue operations
@DriftAccessor(tables: [StorageQueue])
class StorageQueueDao extends DatabaseAccessor<AppDatabase>
    with _$StorageQueueDaoMixin {
  StorageQueueDao(super.db);

  /// Enqueue a download operation
  Future<int> enqueueDownload({
    required String storagePath,
    String? assetId,
    String? localPath,
    int? fileSize,
    String? mimeType,
    int priority = 0,
  }) {
    return into(storageQueue).insert(
      StorageQueueCompanion.insert(
        storagePath: storagePath,
        assetId: Value(assetId),
        opType: 'download',
        localPath: Value(localPath),
        fileSize: Value(fileSize),
        mimeType: Value(mimeType),
        enqueuedAt: DateTime.now(),
        priority: Value(priority),
      ),
    );
  }

  /// Enqueue an upload operation
  Future<int> enqueueUpload({
    required String storagePath,
    required String localPath,
    String? assetId,
    int? fileSize,
    String? mimeType,
    int priority = 0,
  }) {
    return into(storageQueue).insert(
      StorageQueueCompanion.insert(
        storagePath: storagePath,
        assetId: Value(assetId),
        opType: 'upload',
        localPath: Value(localPath),
        fileSize: Value(fileSize),
        mimeType: Value(mimeType),
        enqueuedAt: DateTime.now(),
        priority: Value(priority),
      ),
    );
  }

  /// Get next pending operation (highest priority first, then FIFO)
  Future<StorageQueueData?> nextOp() {
    return (select(storageQueue)
          ..where((op) => op.status.equals('pending'))
          ..orderBy([
            (op) => OrderingTerm.desc(op.priority),
            (op) => OrderingTerm.asc(op.enqueuedAt),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Update operation status
  Future<void> updateStatus(int id, String status, {String? errorMessage}) {
    return (update(storageQueue)..where((op) => op.id.equals(id))).write(
      StorageQueueCompanion(
        status: Value(status),
        errorMessage: Value(errorMessage),
        startedAt: status == 'in_progress' ? Value(DateTime.now()) : const Value.absent(),
        completedAt: status == 'completed' || status == 'failed'
            ? Value(DateTime.now())
            : const Value.absent(),
      ),
    );
  }

  /// Update progress
  Future<void> updateProgress(int id, int progress) {
    return (update(storageQueue)..where((op) => op.id.equals(id)))
        .write(StorageQueueCompanion(progress: Value(progress)));
  }

  /// Mark attempt
  Future<void> markAttempt(int id) async {
    final current = await (select(storageQueue)..where((op) => op.id.equals(id))).getSingleOrNull();
    if (current != null) {
      await (update(storageQueue)..where((op) => op.id.equals(id))).write(
        StorageQueueCompanion(attempt: Value(current.attempt + 1)),
      );
    }
  }

  /// Remove operation
  Future<void> remove(int id) {
    return (delete(storageQueue)..where((op) => op.id.equals(id))).go();
  }

  /// Get all pending operations
  Stream<List<StorageQueueData>> watchPending() {
    return (select(storageQueue)..where((op) => op.status.equals('pending')))
        .watch();
  }

  /// Get count of pending operations
  Future<int> pendingCount() async {
    final query = selectOnly(storageQueue)
      ..addColumns([storageQueue.id.count()])
      ..where(storageQueue.status.equals('pending'));
    final result = await query.getSingle();
    return result.read(storageQueue.id.count()) ?? 0;
  }

  /// Get operations for a specific asset
  Future<List<StorageQueueData>> getByAssetId(String assetId) {
    return (select(storageQueue)..where((op) => op.assetId.equals(assetId)))
        .get();
  }
}
