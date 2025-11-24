import 'package:moonforge/core/utils/safe_data_parser.dart';

void main() {
  final inputs = [
    1609459200,
    1609459200000,
    '1609459200',
    '1609459200000',
    '1609459200Z',
  ];
  for (final input in inputs) {
    final res = SafeDataParser.tryParseDateTime(input);
    print(
      'input: $input -> $res (${res?.toUtc().toIso8601String() ?? 'null'}) year=${res?.year}',
    );
  }
}
