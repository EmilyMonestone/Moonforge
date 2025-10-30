import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/models/outbox_operation.dart';

/// Base repository with common CRUD operations for Isar collections
abstract class BaseRepository<T> {
  final Isar isar;
  final String collectionName;

  BaseRepository(this.isar, this.collectionName);

  /// Get the Isar collection for this entity type
  IsarCollection<T> get collection;

  /// Get entity ID as a string
  String getEntityId(T entity);

  /// Check if entity is deleted
  bool isDeleted(T entity);

  /// Set entity as deleted
  void setDeleted(T entity, bool value);

  /// Set entity updated timestamp
  void setUpdatedAt(T entity, DateTime time);

  /// Set entity sync status
  void setSyncStatus(T entity, String status);

  /// Set last synced timestamp
  void setLastSyncedAt(T entity, DateTime time);

  /// Get entity updated timestamp
  DateTime? getUpdatedAt(T entity);

  /// Get entity sync status
  String getSyncStatus(T entity);

  /// Get entity revision number
  int getRev(T entity);

  /// Convert entity to Firestore format
  Map<String, dynamic> toFirestore(T entity);

  /// Watch all non-deleted entities
  Stream<List<T>> watchAll() {
    // Watch all entities, filtering by deleted = false
    return collection
        .filter()
        .deletedEqualTo(false)
        .watch(fireImmediately: true);
  }

  /// Get entity by string ID
  Future<T?> getById(String id) async {
    return await collection.filter().idEqualTo(id).findFirst();
  }

  /// Upsert entity and enqueue for sync
  Future<void> upsert(T entity) async {
    await isar.writeTxn(() async {
      setUpdatedAt(entity, DateTime.now());
      setSyncStatus(entity, 'pending');

      await collection.put(entity);

      await _enqueueSync(
        collection: collectionName,
        docId: getEntityId(entity),
        opType: 'upsert',
        payload: jsonEncode(toFirestore(entity)),
        baseRev: getRev(entity),
      );
    });
    logger.d('$collectionName ${getEntityId(entity)} upserted and enqueued');
  }

  /// Soft delete entity
  Future<void> delete(String id) async {
    await isar.writeTxn(() async {
      final entity = await getById(id);
      if (entity == null) return;

      setDeleted(entity, true);
      setUpdatedAt(entity, DateTime.now());
      setSyncStatus(entity, 'pending');

      await collection.put(entity);

      await _enqueueSync(
        collection: collectionName,
        docId: id,
        opType: 'delete',
        payload: jsonEncode({'deleted': true}),
        baseRev: getRev(entity),
      );
    });
    logger.d('$collectionName $id marked as deleted');
  }

  /// Apply remote update from Firestore
  Future<void> applyRemoteUpdate(T remoteEntity) async {
    await isar.writeTxn(() async {
      final local = await getById(getEntityId(remoteEntity));

      // Apply if local doesn't exist, is synced, or remote is newer
      if (local == null ||
          getSyncStatus(local) == 'synced' ||
          _isRemoteNewer(local, remoteEntity)) {
        setSyncStatus(remoteEntity, 'synced');
        setLastSyncedAt(remoteEntity, DateTime.now());
        await collection.put(remoteEntity);
        logger.d('Applied remote update for $collectionName ${getEntityId(remoteEntity)}');
      } else {
        logger.w(
          'Skipped remote update for $collectionName ${getEntityId(remoteEntity)} - local changes pending',
        );
      }
    });
  }

  /// Check if remote entity is newer than local
  bool _isRemoteNewer(T local, T remote) {
    final localTime = getUpdatedAt(local);
    final remoteTime = getUpdatedAt(remote);
    if (remoteTime == null) return false;
    if (localTime == null) return true;
    return remoteTime.isAfter(localTime);
  }

  /// Enqueue sync operation
  Future<void> _enqueueSync({
    required String collection,
    required String docId,
    required String opType,
    required String payload,
    required int baseRev,
  }) async {
    final outboxOp = OutboxOperation()
      ..collection = collection
      ..docId = docId
      ..opType = opType
      ..payload = payload
      ..baseRev = baseRev
      ..createdAt = DateTime.now()
      ..status = 'pending';

    await isar.outboxOperations.put(outboxOp);
  }
}
