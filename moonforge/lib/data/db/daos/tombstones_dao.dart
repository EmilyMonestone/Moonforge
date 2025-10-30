import 'package:drift/drift.dart';
import 'package:moonforge/data/db/app_database.dart';
import 'package:moonforge/data/db/tables/tombstones.dart';

part 'tombstones_dao.g.dart';

/// DAO for managing tombstones (deleted document markers)
@DriftAccessor(tables: [Tombstones])
class TombstonesDao extends DatabaseAccessor<AppDatabase>
    with _$TombstonesDaoMixin {
  TombstonesDao(super.db);

  /// Add a tombstone for a deleted document
  Future<void> addTombstone({
    required String collection,
    required String docId,
    String? deletedBy,
    String? reason,
  }) {
    return into(tombstones).insertOnConflictUpdate(
      TombstonesCompanion.insert(
        collection: collection,
        docId: docId,
        deletedAt: DateTime.now(),
        deletedBy: Value(deletedBy),
        reason: Value(reason),
      ),
    );
  }

  /// Check if a document is tombstoned
  Future<bool> isTombstoned(String collection, String docId) async {
    final result = await (select(tombstones)
          ..where((tbl) =>
              tbl.collection.equals(collection) & tbl.docId.equals(docId)))
        .getSingleOrNull();
    return result != null;
  }

  /// Get tombstone
  Future<TombstoneData?> getTombstone(String collection, String docId) {
    return (select(tombstones)
          ..where((tbl) =>
              tbl.collection.equals(collection) & tbl.docId.equals(docId)))
        .getSingleOrNull();
  }

  /// Remove tombstone
  Future<int> removeTombstone(String collection, String docId) {
    return (delete(tombstones)
          ..where((tbl) =>
              tbl.collection.equals(collection) & tbl.docId.equals(docId)))
        .go();
  }

  /// Clean up old tombstones
  Future<int> cleanupOld({Duration age = const Duration(days: 30)}) {
    final cutoff = DateTime.now().subtract(age);
    return (delete(tombstones)
          ..where((tbl) => tbl.deletedAt.isSmallerThanValue(cutoff)))
        .go();
  }

  /// Get all tombstones for a collection
  Future<List<TombstoneData>> getForCollection(String collection) {
    return (select(tombstones)
          ..where((tbl) => tbl.collection.equals(collection)))
        .get();
  }
}
