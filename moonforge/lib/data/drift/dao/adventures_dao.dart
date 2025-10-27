import 'package:drift/drift.dart';
import 'package:moonforge/core/models/data/adventure.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/drift/dao/local_meta_mixin.dart';
import 'package:moonforge/data/drift/tables/adventures.dart';
import 'package:moonforge/data/drift/tables/local_metas.dart';

part 'adventures_dao.g.dart';

/// Data Access Object for Adventure operations
@DriftAccessor(tables: [Adventures, LocalMetas])
class AdventuresDao extends DatabaseAccessor<AppDatabase>
    with _$AdventuresDaoMixin, LocalMetaMixin {
  AdventuresDao(super.db);

  static const String collectionName = 'adventures';

  /// Watch all adventures as a stream
  Stream<List<Adventure>> watchAll() {
    return select(adventures).watch();
  }

  /// Get a single adventure by ID
  Future<Adventure?> getById(String id) {
    return (select(adventures)..where((a) => a.id.equals(id))).getSingleOrNull();
  }

  /// Upsert an adventure and optionally mark it as dirty
  Future<void> upsert(Adventure adventure, {bool markDirty = false}) {
    return transaction(() async {
      await into(adventures).insert(
        AdventuresCompanion.insert(
          id: adventure.id,
          name: adventure.name,
          order: Value(adventure.order),
          summary: Value(adventure.summary),
          content: Value(adventure.content),
          createdAt: Value(adventure.createdAt),
          updatedAt: Value(adventure.updatedAt),
          rev: Value(adventure.rev),
        ),
        mode: InsertMode.insertOrReplace,
      );
      
      if (markDirty) {
        await this.markDirty(collectionName, adventure.id);
      }
    });
  }

  /// Mark an adventure as clean and update its revision
  Future<void> setClean(String id, int newRev) {
    return transaction(() async {
      await (update(adventures)..where((a) => a.id.equals(id)))
          .write(AdventuresCompanion(rev: Value(newRev)));
      
      await markClean(collectionName, id);
    });
  }
}
