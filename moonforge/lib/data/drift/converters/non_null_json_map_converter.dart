

import 'dart:convert';
import 'package:drift/drift.dart';

/// Converts Map<String, dynamic> to/from JSON for Drift storage
/// Guarantees non-null mapping for both Dart and SQL types.
class NonNullJsonMapConverter extends TypeConverter<Map<String, dynamic>, String> {
  const NonNullJsonMapConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    try {
      final decoded = jsonDecode(fromDb);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return const <String, dynamic>{};
    } catch (_) {
      return const <String, dynamic>{};
    }
  }

  @override
  String toSql(Map<String, dynamic> value) {
    // Ensure value is not null; fallback to empty map just in case of misuse
    return jsonEncode(value.isEmpty ? const <String, dynamic>{} : value);
  }
}
