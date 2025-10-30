import '../db/app_db.dart';
import '../db/tables.dart';
import 'package:drift/drift.dart';

/// Repository for Adventure operations
class AdventureRepository {
  final AppDb _db;

  AdventureRepository(this._db);

  /// Watch adventures for a chapter
  Stream<List<Adventure>> watchByChapter(String chapterId) => 
    _db.adventureDao.watchByChapter(chapterId);

  /// Get a single adventure by ID
  Future<Adventure?> getById(String id) => _db.adventureDao.getById(id);

  /// Create a new adventure
  Future<void> create(Adventure adventure) async {
    await _db.transaction(() async {
      await _db.adventureDao.upsert(
        AdventuresCompanion.insert(
          id: adventure.id,
          chapterId: adventure.chapterId,
          name: adventure.name,
          order: adventure.order,
          summary: Value(adventure.summary),
          content: Value(adventure.content),
          entityIds: adventure.entityIds,
          createdAt: Value(adventure.createdAt ?? DateTime.now()),
          updatedAt: Value(DateTime.now()),
          rev: adventure.rev,
        ),
      );

      await _db.outboxDao.enqueue(
        table: 'adventures',
        rowId: adventure.id,
        op: 'upsert',
      );
    });
  }

  /// Update an existing adventure
  Future<void> update(Adventure adventure) async {
    await _db.transaction(() async {
      await _db.adventureDao.upsert(
        AdventuresCompanion(
          id: Value(adventure.id),
          chapterId: Value(adventure.chapterId),
          name: Value(adventure.name),
          order: Value(adventure.order),
          summary: Value(adventure.summary),
          content: Value(adventure.content),
          entityIds: Value(adventure.entityIds),
          updatedAt: Value(DateTime.now()),
          rev: Value(adventure.rev + 1),
        ),
      );

      await _db.outboxDao.enqueue(
        table: 'adventures',
        rowId: adventure.id,
        op: 'upsert',
      );
    });
  }

  /// Delete an adventure
  Future<void> delete(String id) async {
    await _db.transaction(() async {
      await _db.adventureDao.deleteById(id);
      
      await _db.outboxDao.enqueue(
        table: 'adventures',
        rowId: id,
        op: 'delete',
      );
    });
  }
}
