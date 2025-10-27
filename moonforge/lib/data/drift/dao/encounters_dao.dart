import 'package:drift/drift.dart';
import 'package:moonforge/core/models/data/encounter.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/drift/dao/local_meta_mixin.dart';
import 'package:moonforge/data/drift/tables/encounters.dart';
import 'package:moonforge/data/drift/tables/local_metas.dart';

part 'encounters_dao.g.dart';

@DriftAccessor(tables: [Encounters, LocalMetas])
class EncountersDao extends DatabaseAccessor<AppDatabase>
    with _$EncountersDaoMixin, LocalMetaMixin {
  EncountersDao(super.db);

  static const String collectionName = 'encounters';

  Stream<List<Encounter>> watchAll() => select(encounters).watch();

  Future<Encounter?> getById(String id) =>
      (select(encounters)..where((e) => e.id.equals(id))).getSingleOrNull();

  Future<void> upsert(Encounter encounter, {bool markDirty = false}) {
    return transaction(() async {
      await into(encounters).insert(
        EncountersCompanion.insert(
          id: encounter.id,
          name: encounter.name,
          preset: Value(encounter.preset),
          notes: Value(encounter.notes),
          loot: Value(encounter.loot),
          combatants: Value(encounter.combatants),
          createdAt: Value(encounter.createdAt),
          updatedAt: Value(encounter.updatedAt),
          rev: Value(encounter.rev),
        ),
        mode: InsertMode.insertOrReplace,
      );
      if (markDirty) await this.markDirty(collectionName, encounter.id);
    });
  }

  Future<void> setClean(String id, int newRev) {
    return transaction(() async {
      await (update(encounters)..where((e) => e.id.equals(id)))
          .write(EncountersCompanion(rev: Value(newRev)));
      await markClean(collectionName, id);
    });
  }
}
