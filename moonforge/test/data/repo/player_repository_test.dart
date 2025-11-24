import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/player_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlayerRepository (in-memory DB)', () {
    late AppDb db;
    late PlayerRepository repo;

    setUp(() {
      db = AppDb(NativeDatabase.memory());
      repo = PlayerRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('create -> getById -> update -> delete', () async {
      // create campaign for FK
      await db
          .into(db.campaigns)
          .insert(
            CampaignsCompanion.insert(
              name: 'camp',
              description: 'desc',
              entityIds: <String>[],
              rev: 1,
            ),
          );

      final campaignId = (await db.select(db.campaigns).get()).first.id;

      // build a valid Player using companion insert to satisfy DB constraints
      final player = Player(
        id: 'player1',
        campaignId: campaignId,
        playerUid: null,
        name: 'Hero',
        className: 'Fighter',
        subclass: null,
        level: 1,
        race: null,
        background: null,
        alignment: null,
        str: 10,
        dex: 10,
        con: 10,
        intl: 10,
        wis: 10,
        cha: 10,
        hpMax: 10,
        hpCurrent: 10,
        hpTemp: null,
        ac: null,
        proficiencyBonus: null,
        speed: null,
        savingThrowProficiencies: null,
        skillProficiencies: null,
        languages: null,
        equipment: null,
        features: null,
        spells: null,
        notes: null,
        bio: null,
        ddbCharacterId: null,
        lastDdbSync: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 1,
        deleted: false,
      );

      final created = await repo.create(player);
      expect(created.id, 'player1');

      final fetched = await repo.getById('player1');
      expect(fetched, isNotNull);
      expect(fetched!.name, 'Hero');

      final updated = Player(
        id: 'player1',
        campaignId: campaignId,
        playerUid: null,
        name: 'Hero Updated',
        className: 'Fighter',
        subclass: null,
        level: 2,
        race: null,
        background: null,
        alignment: null,
        str: 10,
        dex: 10,
        con: 10,
        intl: 10,
        wis: 10,
        cha: 10,
        hpMax: 10,
        hpCurrent: 10,
        hpTemp: null,
        ac: null,
        proficiencyBonus: null,
        speed: null,
        savingThrowProficiencies: null,
        skillProficiencies: null,
        languages: null,
        equipment: null,
        features: null,
        spells: null,
        notes: null,
        bio: null,
        ddbCharacterId: null,
        lastDdbSync: null,
        createdAt: created.createdAt,
        updatedAt: DateTime.now(),
        rev: created.rev + 1,
        deleted: created.deleted,
      );

      final up = await repo.update(updated);
      expect(up.name, 'Hero Updated');

      await repo.delete('player1');
      final after = await repo.getById('player1');
      // Players are soft-deleted
      expect(after, isNotNull);
      expect(after!.deleted, isTrue);
    });
  });
}
