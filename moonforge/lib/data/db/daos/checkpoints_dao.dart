import 'package:drift/drift.dart';
import 'package:moonforge/data/db/app_database.dart';
import 'package:moonforge/data/db/tables/checkpoints.dart';

part 'checkpoints_dao.g.dart';

/// DAO for managing sync checkpoints
@DriftAccessor(tables: [Checkpoints])
class CheckpointsDao extends DatabaseAccessor<AppDatabase>
    with _$CheckpointsDaoMixin {
  CheckpointsDao(super.db);

  /// Get checkpoint for a collection and user
  Future<CheckpointData?> getCheckpoint(String collection, String? userId) {
    return (select(checkpoints)
          ..where((tbl) =>
              tbl.collection.equals(collection) &
              (userId == null
                  ? tbl.userId.isNull()
                  : tbl.userId.equals(userId))))
        .getSingleOrNull();
  }

  /// Update checkpoint
  Future<void> updateCheckpoint({
    required String collection,
    String? userId,
    required String cursor,
    String? metadata,
  }) {
    return into(checkpoints).insertOnConflictUpdate(
      CheckpointsCompanion.insert(
        collection: collection,
        userId: Value(userId),
        lastCursor: Value(cursor),
        lastSyncAt: Value(DateTime.now()),
        metadata: Value(metadata),
      ),
    );
  }

  /// Delete checkpoint
  Future<int> deleteCheckpoint(String collection, String? userId) {
    return (delete(checkpoints)
          ..where((tbl) =>
              tbl.collection.equals(collection) &
              (userId == null
                  ? tbl.userId.isNull()
                  : tbl.userId.equals(userId))))
        .go();
  }

  /// Watch checkpoint for a collection
  Stream<CheckpointData?> watchCheckpoint(String collection, String? userId) {
    return (select(checkpoints)
          ..where((tbl) =>
              tbl.collection.equals(collection) &
              (userId == null
                  ? tbl.userId.isNull()
                  : tbl.userId.equals(userId))))
        .watchSingleOrNull();
  }
}
