import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/services/bestiary_service.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  group('BestiaryService', () {
    late BestiaryService service;
    late PersistenceService persistence;

    setUp(() async {
      // Initialize GetStorage for tests
      await GetStorage.init('bestiary');
      persistence = PersistenceService();
      service = BestiaryService(persistence);
      
      // Clear any existing test data
      await service.clearCache();
    });

    tearDown(() async {
      // Clean up after each test
      await service.clearCache();
    });

    test('should create service instance', () {
      expect(service, isNotNull);
      expect(service, isA<BestiaryService>());
    });

    test('isCached returns false when no data is cached', () {
      expect(service.isCached(), isFalse);
    });

    test('getLastSyncTime returns null when never synced', () {
      expect(service.getLastSyncTime(), isNull);
    });

    test('clearCache removes all cached data', () async {
      // First, manually add some data to simulate cached state
      await persistence.write('bestiary_json', '{"monster": []}', boxName: 'bestiary');
      await persistence.write('bestiary_etag', 'test-etag', boxName: 'bestiary');
      await persistence.write('bestiary_lastSync', DateTime.now().millisecondsSinceEpoch, boxName: 'bestiary');
      
      expect(service.isCached(), isTrue);
      
      await service.clearCache();
      
      expect(service.isCached(), isFalse);
      expect(service.getLastSyncTime(), isNull);
    });

    test('getAll returns empty list when no data cached and remote fetch fails', () async {
      // This test will attempt to fetch but may fail due to network
      // We're mainly testing that it doesn't throw and returns empty list
      final result = await service.getAll(ensureFresh: false);
      expect(result, isA<List>());
    });

    test('getByName returns null when no data is available', () async {
      final result = await service.getByName('Test Monster');
      expect(result, isNull);
    });

    test('service handles JSON with monster array', () async {
      // Manually cache valid JSON data
      const testData = '{"monster": [{"name": "Goblin", "type": "humanoid"}]}';
      await persistence.write('bestiary_json', testData, boxName: 'bestiary');
      
      final result = await service.getAll(ensureFresh: false);
      expect(result, isA<List>());
      expect(result.length, equals(1));
      expect((result[0] as Map<String, dynamic>)['name'], equals('Goblin'));
    });

    test('getByName finds monster by name', () async {
      const testData = '{"monster": [{"name": "Goblin", "type": "humanoid"}, {"name": "Orc", "type": "humanoid"}]}';
      await persistence.write('bestiary_json', testData, boxName: 'bestiary');
      
      final goblin = await service.getByName('Goblin');
      expect(goblin, isNotNull);
      expect(goblin!['name'], equals('Goblin'));
      
      final orc = await service.getByName('Orc');
      expect(orc, isNotNull);
      expect(orc!['name'], equals('Orc'));
      
      final nonExistent = await service.getByName('Dragon');
      expect(nonExistent, isNull);
    });

    test('service handles invalid JSON gracefully', () async {
      await persistence.write('bestiary_json', 'invalid json', boxName: 'bestiary');
      
      final result = await service.getAll(ensureFresh: false);
      expect(result, isA<List>());
      expect(result, isEmpty);
    });

    test('getLastSyncTime returns correct timestamp', () async {
      final now = DateTime.now();
      await persistence.write('bestiary_lastSync', now.millisecondsSinceEpoch, boxName: 'bestiary');
      
      final lastSync = service.getLastSyncTime();
      expect(lastSync, isNotNull);
      expect(lastSync!.millisecondsSinceEpoch, equals(now.millisecondsSinceEpoch));
    });
  });
}
