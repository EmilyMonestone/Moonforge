import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:moonforge/core/utils/logger.dart';

void main() {
  group('LogContext enum', () {
    test('has all expected contexts', () {
      // Verify all contexts are defined
      expect(LogContext.values, contains(LogContext.general));
      expect(LogContext.values, contains(LogContext.sync));
      expect(LogContext.values, contains(LogContext.database));
      expect(LogContext.values, contains(LogContext.auth));
      expect(LogContext.values, contains(LogContext.navigation));
      expect(LogContext.values, contains(LogContext.ui));
      expect(LogContext.values, contains(LogContext.network));
      expect(LogContext.values, contains(LogContext.data));
    });
  });

  group('ConditionalLogger', () {
    late ConditionalLogger testLogger;
    late TestLogOutput testOutput;

    setUp(() {
      testOutput = TestLogOutput();
      final baseLogger = Logger(
        printer: SimplePrinter(),
        output: testOutput,
      );
      testLogger = ConditionalLogger(baseLogger);
    });

    test('general context is enabled by default', () {
      expect(testLogger.isContextEnabled(LogContext.general), true);
    });

    test('non-general contexts are disabled by default', () {
      expect(testLogger.isContextEnabled(LogContext.sync), false);
      expect(testLogger.isContextEnabled(LogContext.database), false);
      expect(testLogger.isContextEnabled(LogContext.auth), false);
    });

    test('can enable a specific context', () {
      testLogger.enableContext(LogContext.sync);
      expect(testLogger.isContextEnabled(LogContext.sync), true);
      expect(testLogger.isContextEnabled(LogContext.database), false);
    });

    test('can disable a context', () {
      testLogger.enableContext(LogContext.sync);
      testLogger.disableContext(LogContext.sync);
      expect(testLogger.isContextEnabled(LogContext.sync), false);
    });

    test('cannot disable general context', () {
      testLogger.disableContext(LogContext.general);
      expect(testLogger.isContextEnabled(LogContext.general), true);
    });

    test('can enable multiple contexts', () {
      testLogger.enableContexts([LogContext.sync, LogContext.database]);
      expect(testLogger.isContextEnabled(LogContext.sync), true);
      expect(testLogger.isContextEnabled(LogContext.database), true);
      expect(testLogger.isContextEnabled(LogContext.auth), false);
    });

    test('can disable multiple contexts', () {
      testLogger.enableContexts([LogContext.sync, LogContext.database]);
      testLogger.disableContexts([LogContext.sync, LogContext.database]);
      expect(testLogger.isContextEnabled(LogContext.sync), false);
      expect(testLogger.isContextEnabled(LogContext.database), false);
    });

    test('enabledContexts returns unmodifiable set', () {
      testLogger.enableContext(LogContext.sync);
      final contexts = testLogger.enabledContexts;
      expect(contexts, contains(LogContext.general));
      expect(contexts, contains(LogContext.sync));
      expect(() => contexts.add(LogContext.database), throwsUnsupportedError);
    });

    test('logs general context messages by default', () {
      testLogger.i('Test message');
      expect(testOutput.messages.length, 1);
      expect(testOutput.messages[0].contains('Test message'), true);
    });

    test('does not log disabled context messages', () {
      testLogger.d('Sync message', context: LogContext.sync);
      expect(testOutput.messages.length, 0);
    });

    test('logs enabled context messages', () {
      testLogger.enableContext(LogContext.sync);
      testLogger.i('Sync message', context: LogContext.sync);
      expect(testOutput.messages.length, 1);
      expect(testOutput.messages[0].contains('Sync message'), true);
    });

    test('error messages are always logged', () {
      testLogger.e('Error message', context: LogContext.sync);
      expect(testOutput.messages.length, 1);
      expect(testOutput.messages[0].contains('Error message'), true);
    });

    test('fatal messages are always logged', () {
      testLogger.f('Fatal message', context: LogContext.database);
      expect(testOutput.messages.length, 1);
      expect(testOutput.messages[0].contains('Fatal message'), true);
    });

    test('debug messages respect context', () {
      testLogger.d('Debug message', context: LogContext.sync);
      expect(testOutput.messages.length, 0);

      testLogger.enableContext(LogContext.sync);
      testLogger.d('Debug message 2', context: LogContext.sync);
      expect(testOutput.messages.length, 1);
    });

    test('info messages respect context', () {
      testLogger.i('Info message', context: LogContext.database);
      expect(testOutput.messages.length, 0);

      testLogger.enableContext(LogContext.database);
      testLogger.i('Info message 2', context: LogContext.database);
      expect(testOutput.messages.length, 1);
    });

    test('warning messages respect context', () {
      testLogger.w('Warning message', context: LogContext.auth);
      expect(testOutput.messages.length, 0);

      testLogger.enableContext(LogContext.auth);
      testLogger.w('Warning message 2', context: LogContext.auth);
      expect(testOutput.messages.length, 1);
    });

    test('trace messages respect context', () {
      testLogger.t('Trace message', context: LogContext.network);
      expect(testOutput.messages.length, 0);

      testLogger.enableContext(LogContext.network);
      testLogger.t('Trace message 2', context: LogContext.network);
      expect(testOutput.messages.length, 1);
    });
  });

  group('Global logger instance', () {
    test('is a ConditionalLogger', () {
      expect(logger, isA<ConditionalLogger>());
    });

    test('can enable contexts on global instance', () {
      logger.enableContext(LogContext.sync);
      expect(logger.isContextEnabled(LogContext.sync), true);
      // Clean up
      logger.disableContext(LogContext.sync);
    });
  });
}

/// Test log output that captures log messages for verification
class TestLogOutput extends LogOutput {
  final List<String> messages = [];

  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      messages.add(line);
    }
  }
}
