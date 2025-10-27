import 'dart:convert';
import 'package:moonforge/core/models/data/chapter.dart';
import 'package:moonforge/data/drift/app_database.dart';

/// Repository for Chapter operations
class ChapterRepository {
  final AppDatabase _db;

  ChapterRepository(this._db);

  Stream<List<Chapter>> watchAll() => _db.chaptersDao.watchAll();

  Future<Chapter?> getById(String id) => _db.chaptersDao.getById(id);

  Future<void> upsertLocal(Chapter chapter) async {
    await _db.transaction(() async {
      await _db.chaptersDao.upsert(chapter, markDirty: true);
      await _db.outboxDao.enqueue(
        docPath: 'chapters',
        docId: chapter.id,
        baseRev: chapter.rev,
        opType: 'upsert',
        payload: jsonEncode(chapter.toJson()),
      );
    });
  }

  Future<void> patchLocal({
    required String id,
    required int baseRev,
    required List<Map<String, dynamic>> ops,
  }) async {
    await _db.transaction(() async {
      final current = await _db.chaptersDao.getById(id);
      if (current == null) return;

      Chapter updated = current;
      for (final op in ops) {
        updated = _applyPatchOp(updated, op);
      }

      await _db.chaptersDao.upsert(updated, markDirty: true);
      await _db.outboxDao.enqueue(
        docPath: 'chapters',
        docId: id,
        baseRev: baseRev,
        opType: 'patch',
        payload: jsonEncode({'ops': ops}),
      );
    });
  }

  Chapter _applyPatchOp(Chapter chapter, Map<String, dynamic> op) {
    final type = op['type'] as String;
    final field = op['field'] as String;
    final value = op['value'];

    if (type == 'set') {
      switch (field) {
        case 'name':
          return chapter.copyWith(name: value as String);
        case 'order':
          return chapter.copyWith(order: value as int);
        case 'summary':
          return chapter.copyWith(summary: value as String?);
        case 'content':
          return chapter.copyWith(content: value as String?);
      }
    }
    return chapter;
  }
}
