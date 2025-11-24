import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:moonforge/data/db/daos/party_dao.dart';
import 'package:moonforge/data/repo/base_repository.dart';

import '../db/app_db.dart';
import '../db/tables.dart';

class PartyRepository extends BaseRepository<Party, String> {
  PartyRepository(this._db);

  final AppDb _db;

  PartyDao get _dao => _db.partyDao;

  @override
  Future<Party?> getById(String id) =>
      handleError(() => _dao.getById(id), context: 'party.getById');

  @override
  Future<List<Party>> getAll() =>
      handleError(() => _dao.watchAll().first, context: 'party.getAll');

  @override
  Stream<List<Party>> watchAll() =>
      handleStreamError(_dao.watchAll, context: 'party.watchAll');

  Stream<List<Party>> watchByCampaign(String campaignId) => handleStreamError(
    () => _dao.watchByCampaign(campaignId),
    context: 'party.watchByCampaign',
  );

  Future<List<Party>> getByCampaign(String campaignId) => handleError(
    () => _dao.customQuery(filter: (p) => p.campaignId.equals(campaignId)),
    context: 'party.getByCampaign',
  );

  @override
  Stream<Party?> watchById(String id) => handleStreamError(
    () =>
        _dao.watchAll().map((list) => list.firstWhereOrNull((p) => p.id == id)),
    context: 'party.watchById',
  );

  @override
  Future<Party> create(Party party) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
        PartiesCompanion.insert(
          id: Value(party.id),
          campaignId: party.campaignId,
          name: party.name,
          summary: Value(party.summary),
          memberEntityIds: Value(party.memberEntityIds),
          createdAt: Value(party.createdAt ?? DateTime.now()),
          updatedAt: Value(DateTime.now()),
          rev: party.rev,
        ),
      );
      await _db.outboxDao.enqueue(
        table: 'parties',
        rowId: party.id,
        op: 'upsert',
      );
    });
    return party;
  }, context: 'party.create');

  @override
  Future<Party> update(Party party) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
        PartiesCompanion(
          id: Value(party.id),
          campaignId: Value(party.campaignId),
          name: Value(party.name),
          summary: Value(party.summary),
          memberEntityIds: Value(party.memberEntityIds),
          updatedAt: Value(DateTime.now()),
          rev: Value(party.rev + 1),
        ),
      );
      await _db.outboxDao.enqueue(
        table: 'parties',
        rowId: party.id,
        op: 'upsert',
      );
    });
    return party;
  }, context: 'party.update');

  @override
  Future<void> delete(String id) => handleError(() async {
    await _db.transaction(() async {
      await _dao.deleteById(id);
      await _db.outboxDao.enqueue(table: 'parties', rowId: id, op: 'delete');
    });
  }, context: 'party.delete');

  Future<List<Party>> customQuery({
    Expression<bool> Function(Parties p)? filter,
    List<OrderingTerm Function(Parties p)>? sort,
    int? limit,
  }) => handleError(
    () => _dao.customQuery(filter: filter, sort: sort, limit: limit),
    context: 'party.customQuery',
  );
}
