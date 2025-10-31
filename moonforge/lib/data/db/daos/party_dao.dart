import 'package:drift/drift.dart';

import '../app_db.dart';
import '../tables.dart';

part 'party_dao.g.dart';

@DriftAccessor(tables: [Parties])
class PartyDao extends DatabaseAccessor<AppDb> with _$PartyDaoMixin {
  PartyDao(AppDb db) : super(db);

  Stream<List<Party>> watchAll() =>
      (select(parties)..orderBy([(p) => OrderingTerm.asc(p.name)])).watch();

  Stream<List<Party>> watchByCampaign(String campaignId) =>
      (select(parties)
            ..where((p) => p.campaignId.equals(campaignId))
            ..orderBy([(p) => OrderingTerm.asc(p.name)]))
          .watch();

  Future<Party?> getById(String id) =>
      (select(parties)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<void> upsert(PartiesCompanion data) async =>
      into(parties).insertOnConflictUpdate(data);

  Future<int> deleteById(String id) =>
      (delete(parties)..where((p) => p.id.equals(id))).go();
}
