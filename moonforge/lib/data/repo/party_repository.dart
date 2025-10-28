import 'dart:convert';
import 'package:moonforge/core/models/data/party.dart';
import 'package:moonforge/data/drift/app_database.dart';

/// Repository for Party operations
class PartyRepository {
  final AppDatabase _db;

  PartyRepository(this._db);

  Stream<List<Party>> watchAll() => _db.partiesDao.watchAll();

  Future<Party?> getById(String id) => _db.partiesDao.getById(id);

  Future<void> upsertLocal(Party party) async {
    await _db.transaction(() async {
      await _db.partiesDao.upsert(party, markDirty: true);
      await _db.outboxDao.enqueue(
        docPath: 'parties',
        docId: party.id,
        baseRev: party.rev,
        opType: 'upsert',
        payload: jsonEncode(party.toJson()),
      );
    });
  }

  Future<void> patchLocal({
    required String id,
    required int baseRev,
    required List<Map<String, dynamic>> ops,
  }) async {
    await _db.transaction(() async {
      final current = await _db.partiesDao.getById(id);
      if (current == null) return;

      Party updated = current;
      for (final op in ops) {
        updated = _applyPatchOp(updated, op);
      }

      await _db.partiesDao.upsert(updated, markDirty: true);
      await _db.outboxDao.enqueue(
        docPath: 'parties',
        docId: id,
        baseRev: baseRev,
        opType: 'patch',
        payload: jsonEncode({'ops': ops}),
      );
    });
  }

  Party _applyPatchOp(Party party, Map<String, dynamic> op) {
    final type = op['type'] as String;
    final field = op['field'] as String;
    final value = op['value'];

    if (type == 'set') {
      switch (field) {
        case 'name':
          return party.copyWith(name: value as String);
        case 'summary':
          return party.copyWith(summary: value as String?);
        case 'memberEntityIds':
          return party.copyWith(memberEntityIds: (value as List?)?.cast<String>());
      }
    }
    return party;
  }
}
