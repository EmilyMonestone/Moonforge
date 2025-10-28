import 'dart:convert';
import 'package:moonforge/core/models/data/player.dart';
import 'package:moonforge/data/drift/app_database.dart';

/// Repository for Player operations
class PlayerRepository {
  final AppDatabase _db;

  PlayerRepository(this._db);

  Stream<List<Player>> watchAll() => _db.playersDao.watchAll();

  Future<Player?> getById(String id) => _db.playersDao.getById(id);
  
  Future<List<Player>> getByIds(List<String> ids) => _db.playersDao.getByIds(ids);

  Future<void> upsertLocal(Player player) async {
    await _db.transaction(() async {
      await _db.playersDao.upsert(player, markDirty: true);
      await _db.outboxDao.enqueue(
        docPath: 'players',
        docId: player.id,
        baseRev: player.rev,
        opType: 'upsert',
        payload: jsonEncode(player.toJson()),
      );
    });
  }

  Future<void> patchLocal({
    required String id,
    required int baseRev,
    required List<Map<String, dynamic>> ops,
  }) async {
    await _db.transaction(() async {
      final current = await _db.playersDao.getById(id);
      if (current == null) return;

      Player updated = current;
      for (final op in ops) {
        updated = _applyPatchOp(updated, op);
      }

      await _db.playersDao.upsert(updated, markDirty: true);
      await _db.outboxDao.enqueue(
        docPath: 'players',
        docId: id,
        baseRev: baseRev,
        opType: 'patch',
        payload: jsonEncode({'ops': ops}),
      );
    });
  }

  Player _applyPatchOp(Player player, Map<String, dynamic> op) {
    final type = op['type'] as String;
    final field = op['field'] as String;
    final value = op['value'];

    if (type == 'set') {
      switch (field) {
        case 'name':
          return player.copyWith(name: value as String);
        case 'partyId':
          return player.copyWith(partyId: value as String?);
        case 'playerClass':
          return player.copyWith(playerClass: value as String?);
        case 'level':
          return player.copyWith(level: value as int);
        case 'species':
          return player.copyWith(species: value as String?);
        case 'info':
          return player.copyWith(info: value as String?);
      }
    }
    return player;
  }
}
