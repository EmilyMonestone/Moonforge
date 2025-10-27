import 'package:drift/drift.dart';
import 'package:moonforge/data/drift/app_database.dart';

/// Generic mixin for managing local metadata across all models
mixin LocalMetaMixin on DatabaseAccessor<AppDatabase> {
  /// Get local metadata for a document
  Future<LocalMeta?> getLocalMeta(String collection, String docId) {
    final docRef = '$collection/$docId';
    return (select(db.localMetas)..where((m) => m.docRef.equals(docRef)))
        .getSingleOrNull();
  }

  /// Check if a document has unsync'd changes
  Future<bool> isDirty(String collection, String docId) async {
    final meta = await getLocalMeta(collection, docId);
    return meta?.dirty ?? false;
  }

  /// Mark a document as dirty (has local changes)
  Future<void> markDirty(String collection, String docId) {
    final docRef = '$collection/$docId';
    return into(db.localMetas).insertOnConflictUpdate(
      LocalMetasCompanion.insert(
        docRef: docRef,
        collection: collection,
        docId: docId,
        dirty: const Value(true),
        lastSyncedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Mark a document as clean (sync'd)
  Future<void> markClean(String collection, String docId) {
    final docRef = '$collection/$docId';
    return into(db.localMetas).insertOnConflictUpdate(
      LocalMetasCompanion.insert(
        docRef: docRef,
        collection: collection,
        docId: docId,
        dirty: const Value(false),
        lastSyncedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update download status for media
  Future<void> updateDownloadStatus(
    String collection,
    String docId, {
    required String status,
    String? localPath,
    DateTime? cacheExpiry,
  }) {
    final docRef = '$collection/$docId';
    return into(db.localMetas).insertOnConflictUpdate(
      LocalMetasCompanion.insert(
        docRef: docRef,
        collection: collection,
        docId: docId,
        downloadStatus: Value(status),
        localPath: Value(localPath),
        cacheExpiry: Value(cacheExpiry),
      ),
    );
  }
}
