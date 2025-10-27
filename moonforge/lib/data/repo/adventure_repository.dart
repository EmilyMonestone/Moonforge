import 'dart:convert';
import 'package:moonforge/core/models/data/adventure.dart';
import 'package:moonforge/data/drift/app_database.dart';

/// Repository for Adventure operations with optimistic writes and outbox queueing
class AdventureRepository {
  final AppDatabase _db;

  AdventureRepository(this._db);

  /// Watch all adventures as a stream (local-first, instant)
  Stream<List<Adventure>> watchAll() {
    return _db.adventuresDao.watchAll();
  }

  /// Get a single adventure by ID
  Future<Adventure?> getById(String id) {
    return _db.adventuresDao.getById(id);
  }

  /// Upsert an adventure locally and enqueue for sync
  Future<void> upsertLocal(Adventure adventure) async {
    await _db.transaction(() async {
      // Optimistic local write
      await _db.adventuresDao.upsert(adventure, markDirty: true);

      // Enqueue for sync
      await _db.outboxDao.enqueue(
        docPath: 'adventures',
        docId: adventure.id,
        baseRev: adventure.rev,
        opType: 'upsert',
        payload: jsonEncode(adventure.toJson()),
      );
    });
  }

  /// Apply a patch operation locally and enqueue for sync
  Future<void> patchLocal({
    required String id,
    required int baseRev,
    required List<Map<String, dynamic>> ops,
  }) async {
    await _db.transaction(() async {
      // Get current adventure
      final current = await _db.adventuresDao.getById(id);
      if (current == null) return;

      // Apply operations locally
      Adventure updated = current;
      for (final op in ops) {
        updated = _applyPatchOp(updated, op);
      }

      // Write optimistically
      await _db.adventuresDao.upsert(updated, markDirty: true);

      // Enqueue patch operation
      await _db.outboxDao.enqueue(
        docPath: 'adventures',
        docId: id,
        baseRev: baseRev,
        opType: 'patch',
        payload: jsonEncode({'ops': ops}),
      );
    });
  }

  Adventure _applyPatchOp(Adventure adventure, Map<String, dynamic> op) {
    final type = op['type'] as String;
    final field = op['field'] as String;
    final value = op['value'];

    switch (type) {
      case 'set':
        return _applySet(adventure, field, value);
      default:
        return adventure;
    }
  }

  Adventure _applySet(Adventure adventure, String field, dynamic value) {
    switch (field) {
      case 'name':
        return adventure.copyWith(name: value as String);
      case 'order':
        return adventure.copyWith(order: value as int);
      case 'summary':
        return adventure.copyWith(summary: value as String?);
      case 'content':
        return adventure.copyWith(content: value as String?);
      default:
        return adventure;
    }
  }
}
