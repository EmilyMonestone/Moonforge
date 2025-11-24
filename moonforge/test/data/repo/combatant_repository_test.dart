import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/combatant_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CombatantRepository (in-memory DB)', () {
    late AppDb db;
    late CombatantRepository repo;

    setUp(() {
      db = AppDb(NativeDatabase.memory());
      repo = CombatantRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('create -> getById -> update -> delete', () async {
      // Create an encounter first (FK)
      await db
          .into(db.encounters)
          .insert(
            EncountersCompanion.insert(
              name: 'FK Encounter',
              originId: 'origin',
              preset: false,
              entityIds: <String>[],
              rev: 1,
            ),
          );
      final encId = (await db.select(db.encounters).get()).first.id;

      final combatant = Combatant(
        id: 'cb1',
        encounterId: encId,
        name: 'Orc',
        type: 'monster',
        isAlly: false,
        currentHp: 10,
        maxHp: 10,
        armorClass: 12,
        initiative: null,
        initiativeModifier: 0,
        entityId: null,
        bestiaryName: null,
        cr: null,
        xp: 0,
        conditions: <String>[],
        notes: null,
        order: 1,
      );

      final created = await repo.create(combatant);
      expect(created.id, 'cb1');

      final fetched = await repo.getById('cb1');
      expect(fetched, isNotNull);
      expect(fetched!.name, 'Orc');

      final updated = Combatant(
        id: 'cb1',
        encounterId: encId,
        name: 'Orc Chief',
        type: combatant.type,
        isAlly: combatant.isAlly,
        currentHp: combatant.currentHp,
        maxHp: combatant.maxHp,
        armorClass: combatant.armorClass,
        initiative: combatant.initiative,
        initiativeModifier: combatant.initiativeModifier,
        entityId: combatant.entityId,
        bestiaryName: combatant.bestiaryName,
        cr: combatant.cr,
        xp: combatant.xp,
        conditions: combatant.conditions,
        notes: combatant.notes,
        order: combatant.order,
      );

      final up = await repo.update(updated);
      expect(up.name, 'Orc Chief');

      await repo.delete('cb1');
      final after = await repo.getById('cb1');
      expect(after, isNull);
    });
  });
}
