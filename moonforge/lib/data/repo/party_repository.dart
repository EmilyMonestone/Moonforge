import 'package:drift/drift.dart';
import 'package:moonforge/data/db/tables.dart';

import '../db/app_db.dart';

/// Repository for Party operations
class PartyRepository {
  final AppDb _db;

  PartyRepository(this._db);

  Stream<List<Party>> watchAll() => _db.partyDao.watchAll();

  /// Watch parties for a campaign
  Stream<List<Party>> watchByCampaign(String campaignId) =>
      _db.partyDao.watchByCampaign(campaignId);

  /// Get a single party by ID
  Future<Party?> getById(String id) => _db.partyDao.getById(id);

  /// Create a new party
  Future<void> create(Party party) async {
    await _db.transaction(() async {
      await _db.partyDao.upsert(
        PartiesCompanion.insert(
          id: party.id,
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
  }

  /// Update an existing party
  Future<void> update(Party party) async {
    await _db.transaction(() async {
      await _db.partyDao.upsert(
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
  }

  /// Delete a party
  Future<void> delete(String id) async {
    await _db.transaction(() async {
      await _db.partyDao.deleteById(id);

      await _db.outboxDao.enqueue(table: 'parties', rowId: id, op: 'delete');
    });
  }

  /// Custom query with custom filter, custom sort and custom limit
  Future<List<Party>> customQuery({
    Expression<bool> Function(Parties p)? filter,
    List<OrderingTerm Function(Parties p)>? sort,
    int? limit,
  }) {
    return _db.partyDao.customQuery(filter: filter, sort: sort, limit: limit);
  }
}
