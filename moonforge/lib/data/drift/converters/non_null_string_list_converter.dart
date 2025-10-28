import 'dart:convert';
import 'package:drift/drift.dart';

/// Converts List<String> to/from JSON for Drift storage
/// Guarantees non-null mapping for both Dart and SQL types.
class NonNullStringListConverter extends TypeConverter<List<String>, String> {
  const NonNullStringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    try {
      final decoded = jsonDecode(fromDb);
      if (decoded is List) {
        return decoded.cast<String>();
      }
      return const <String>[];
    } catch (_) {
      return const <String>[];
    }
  }

  @override
  String toSql(List<String> value) {
    return jsonEncode(value);
  }
}
