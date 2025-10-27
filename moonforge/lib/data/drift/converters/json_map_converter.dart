import 'dart:convert';
import 'package:drift/drift.dart';

/// Converts Map<String, dynamic> to/from JSON for Drift storage
class JsonMapConverter extends TypeConverter<Map<String, dynamic>?, String?> {
  const JsonMapConverter();

  @override
  Map<String, dynamic>? fromSql(String? fromDb) {
    if (fromDb == null) return null;
    try {
      final decoded = jsonDecode(fromDb);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  String? toSql(Map<String, dynamic>? value) {
    if (value == null) return null;
    return jsonEncode(value);
  }
}
