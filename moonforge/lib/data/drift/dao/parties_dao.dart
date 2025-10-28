import 'package:drift/drift.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/drift/dao/local_meta_mixin.dart';
import 'package:moonforge/data/drift/tables/local_metas.dart';
import 'package:moonforge/data/drift/tables/parties.dart';
import 'package:moonforge/data/firebase/models/party.dart';

part 'parties_dao.g.dart';

@DriftAccessor(tables: [Parties, LocalMetas])
class PartiesDao extends DatabaseAccessor<AppDatabase>
    with _$PartiesDaoMixin, LocalMetaMixin {
  PartiesDao(super.db);

  static const String collectionName = 'parties';

  Stream<List<Party>> watchAll() => select(parties).watch();

  Future<Party?> getById(String id) =>
      (select(parties)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<void> upsert(Party party, {bool markDirty = false}) {
    return transaction(() async {
      await into(parties).insert(
        PartiesCompanion.insert(
          id: party.id,
          name: party.name,
          summary: Value(party.summary),
          memberEntityIds: Value(party.memberEntityIds),
          createdAt: Value(party.createdAt),
          updatedAt: Value(party.updatedAt),
          rev: Value(party.rev),
        ),
        mode: InsertMode.insertOrReplace,
      );
      if (markDirty) await this.markDirty(collectionName, party.id);
    });
  }

  Future<void> setClean(String id, int newRev) {
    return transaction(() async {
      await (update(parties)..where((p) => p.id.equals(id))).write(
        PartiesCompanion(rev: Value(newRev)),
      );
      await markClean(collectionName, id);
    });
  }
}
