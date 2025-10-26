import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/services/dnd_monster_sync_service.dart';
import 'package:moonforge/core/services/persistence_service.dart';

void main() {
  group('DndMonsterSyncService', () {
    late DndMonsterSyncService service;

    setUpAll(() async {
      // Initialize persistence service for tests
      await PersistenceService.init();
    });

    setUp(() {
      service = DndMonsterSyncService();
    });

    tearDown(() async {
      // Clear cache after each test
      await service.clearCache();
    });

    group('convertToEntity', () {
      test('converts basic monster data to Entity', () {
        final monsterData = {
          'name': 'Aarakocra Aeromancer',
          'cr': '4',
          'type': 'elemental',
          'size': ['M'],
        };

        final entity = service.convertToEntity(monsterData, 'test-id');

        expect(entity.id, equals('test-id'));
        expect(entity.kind, equals('monster'));
        expect(entity.name, equals('Aarakocra Aeromancer'));
        expect(entity.summary, contains('CR 4'));
        expect(entity.summary, contains('M'));
        expect(entity.summary, contains('elemental'));
        expect(entity.statblock, equals(monsterData));
        expect(entity.tags, contains('dnd-5e-2024'));
        expect(entity.tags, contains('xmm'));
      });

      test('handles monster with complex type', () {
        final monsterData = {
          'name': 'Test Monster',
          'cr': '1',
          'type': {'type': 'humanoid', 'tags': ['elf']},
          'size': ['S'],
        };

        final entity = service.convertToEntity(monsterData, 'test-id-2');

        expect(entity.name, equals('Test Monster'));
        expect(entity.summary, contains('humanoid'));
      });

      test('handles monster with missing fields', () {
        final monsterData = {
          'name': 'Minimal Monster',
        };

        final entity = service.convertToEntity(monsterData, 'test-id-3');

        expect(entity.name, equals('Minimal Monster'));
        expect(entity.kind, equals('monster'));
        expect(entity.statblock, equals(monsterData));
      });

      test('handles unknown monster name', () {
        final monsterData = <String, dynamic>{};

        final entity = service.convertToEntity(monsterData, 'test-id-4');

        expect(entity.name, equals('Unknown Monster'));
        expect(entity.kind, equals('monster'));
      });
    });

    group('cache management', () {
      test('getCachedMonsters returns null when no cache exists', () {
        final cached = service.getCachedMonsters();
        expect(cached, isNull);
      });

      test('getCacheInfo returns null when no cache exists', () {
        final info = service.getCacheInfo();
        expect(info, isNull);
      });

      test('clearCache removes cached data', () async {
        // First, manually add some cache data
        final persistence = PersistenceService();
        await persistence.write('dnd_5e_monsters_cache', [
          {'name': 'Test Monster'}
        ]);
        await persistence.write('dnd_5e_monsters_cache_timestamp',
            DateTime.now().millisecondsSinceEpoch);

        // Verify cache exists
        expect(service.getCachedMonsters(), isNotNull);

        // Clear cache
        await service.clearCache();

        // Verify cache is cleared
        expect(service.getCachedMonsters(), isNull);
      });
    });

    group('syncMonsters', () {
      test('successfully fetches and caches monsters', () async {
        // This is an integration test that requires network access
        // Skip in CI environments if needed
        final monsters = await service.syncMonsters();

        expect(monsters, isNotEmpty);
        expect(monsters.first, isA<Map<String, dynamic>>());
        expect(monsters.first.containsKey('name'), isTrue);

        // Verify data was cached
        final cached = service.getCachedMonsters();
        expect(cached, isNotNull);
        expect(cached!.length, equals(monsters.length));

        // Verify cache info
        final info = service.getCacheInfo();
        expect(info, isNotNull);
        expect(info!['monster_count'], equals(monsters.length));
        expect(info['is_valid'], isTrue);
      }, skip: 'Requires network access - run manually');
    });
  });
}
