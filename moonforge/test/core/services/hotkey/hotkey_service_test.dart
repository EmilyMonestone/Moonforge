import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/services/hotkey/hotkey_config.dart';
import 'package:moonforge/core/services/hotkey/hotkey_service.dart';

void main() {
  group('HotkeyManagerService', () {
    late HotkeyManagerService service;

    setUp(() {
      service = HotkeyManagerService();
    });

    test('singleton instance should be the same', () {
      final instance1 = HotkeyManagerService();
      final instance2 = HotkeyManagerService();
      expect(instance1, same(instance2));
    });

    test('initialize should complete without throwing on web', () async {
      // On web, initialize should be a no-op and not throw
      await expectLater(service.initialize(), completes);
    });

    testWidgets('registerShortcut should complete without throwing on web',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              final shortcut = HotkeyConfig(
                id: 'test_shortcut',
                label: 'Test Shortcut',
                keys: ['ctrl', 'k'],
                action: HotkeyAction(
                  type: HotkeyActionType.navigate,
                  route: '/',
                ),
              );

              // On web, registerShortcut should be a no-op and not throw
              service.registerShortcut(shortcut, context: context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ));

      await tester.pumpAndSettle();
      // Test passes if no exception is thrown
    });

    test('unregisterShortcut should complete without throwing on web',
        () async {
      // On web, unregisterShortcut should be a no-op and not throw
      await expectLater(service.unregisterShortcut('test_shortcut'), completes);
    });

    test('unregisterAll should complete without throwing on web', () async {
      // On web, unregisterAll should be a no-op and not throw
      await expectLater(service.unregisterAll(), completes);
    });

    group('getPhysicalKeyFromString', () {
      test('returns correct key for letters', () {
        expect(service.getPhysicalKeyFromString('a'), isNotNull);
        expect(service.getPhysicalKeyFromString('z'), isNotNull);
        expect(service.getPhysicalKeyFromString('k'), isNotNull);
      });

      test('returns correct key for numbers', () {
        expect(service.getPhysicalKeyFromString('0'), isNotNull);
        expect(service.getPhysicalKeyFromString('9'), isNotNull);
      });

      test('returns correct key for function keys', () {
        expect(service.getPhysicalKeyFromString('f1'), isNotNull);
        expect(service.getPhysicalKeyFromString('f12'), isNotNull);
      });

      test('returns correct key for special keys', () {
        expect(service.getPhysicalKeyFromString('enter'), isNotNull);
        expect(service.getPhysicalKeyFromString('escape'), isNotNull);
        expect(service.getPhysicalKeyFromString('space'), isNotNull);
      });

      test('returns null for unknown keys', () {
        expect(service.getPhysicalKeyFromString('invalid_key'), isNull);
      });
    });
  });
}
