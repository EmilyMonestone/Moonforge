import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/features/home/controllers/home_controller.dart';

class _FakePersistence implements PersistenceService {
  final Map<String, dynamic> store = {};

  @override
  GetStorage get box => throw UnimplementedError();

  @override
  Future<void> erase({String? boxName}) async {
    store.clear();
  }

  @override
  bool hasData(String key, {String? boxName}) => store.containsKey(key);

  @override
  void listenKey(
    String key,
    void Function(dynamic p1) callback, {
    String? boxName,
  }) {}

  @override
  T? read<T>(String key, {String? boxName}) {
    return store[key] as T?;
  }

  @override
  Future<void> remove(String key, {String? boxName}) async {
    store.remove(key);
  }

  @override
  Future<void> write(String key, value, {String? boxName}) async {
    store[key] = value;
  }
}

void main() {
  group('HomeController legacy timestamp parsing', () {
    test('Parses ISO8601 timestamp', () async {
      final fake = _FakePersistence();
      final controller = HomeController(persistence: fake);
      await fake.write('home_refresh_timestamp', '2025-11-09T12:34:56.789Z');
      final ts = controller.getLastRefreshTime();
      expect(ts, isNotNull);
      expect(ts!.year, 2025);
      expect(ts.month, 11);
    });

    test('Parses pure numeric seconds', () async {
      final fake = _FakePersistence();
      final controller = HomeController(persistence: fake);
      await fake.write('home_refresh_timestamp', '1761490548');
      final ts = controller.getLastRefreshTime();
      expect(ts, isNotNull);
      expect(ts!.millisecondsSinceEpoch, 1761490548 * 1000);
    });

    test('Parses numeric seconds with trailing Z', () async {
      final fake = _FakePersistence();
      final controller = HomeController(persistence: fake);
      await fake.write('home_refresh_timestamp', '1761490548Z');
      final ts = controller.getLastRefreshTime();
      expect(ts, isNotNull);
      expect(ts!.millisecondsSinceEpoch, 1761490548 * 1000);
    });
  });
}
