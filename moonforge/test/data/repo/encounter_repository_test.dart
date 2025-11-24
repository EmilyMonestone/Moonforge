import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/encounter_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EncounterRepository (in-memory DB)', () {
    late AppDb db;
    late EncounterRepository repo;

    setUp(() {
      db = AppDb(NativeDatabase.memory());
      repo = EncounterRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('create -> getById -> update -> delete', () async {
      final encounter = Encounter(
        id: 'enc1',
        name: 'Battle',
        originId: 'some-origin',
        preset: false,
        notes: null,
        loot: null,
        combatants: null,
        entityIds: <String>[],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 1,
      );

      final created = await repo.create(encounter);
      expect(created.id, 'enc1');

      final fetched = await repo.getById('enc1');
      expect(fetched, isNotNull);
      expect(fetched!.name, 'Battle');

      final updated = Encounter(
        id: 'enc1',
        name: 'Battle Updated',
        originId: encounter.originId,
        preset: encounter.preset,
        notes: encounter.notes,
        loot: encounter.loot,
        combatants: encounter.combatants,
        entityIds: encounter.entityIds,
        createdAt: encounter.createdAt,
        updatedAt: DateTime.now(),
        rev: encounter.rev + 1,
      );

      final up = await repo.update(updated);
      expect(up.name, 'Battle Updated');

      await repo.delete('enc1');
      final after = await repo.getById('enc1');
      expect(after, isNull);
    });
  });
}
