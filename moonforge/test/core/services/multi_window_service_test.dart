import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/services/multi_window_service.dart';

void main() {
  group('MultiWindowService', () {
    test('instance is singleton', () {
      final instance1 = MultiWindowService.instance;
      final instance2 = MultiWindowService.instance;
      expect(instance1, same(instance2));
    });

    test('isSupported returns correct value for platform', () {
      final service = MultiWindowService.instance;
      // This will vary by platform, but we can check it doesn't throw
      expect(service.isSupported, isA<bool>());
    });
  });
}
