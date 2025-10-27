import 'dart:convert';
import 'package:drift/drift.dart';

/// Converts List<Map<String, dynamic>> to/from JSON for Drift storage
class JsonListConverter extends TypeConverter<List<Map<String, dynamic>>?, String?> {
  const JsonListConverter();

  @override
  List<Map<String, dynamic>>? fromSql(String? fromDb) {
    if (fromDb == null) return null;
    try {
      final decoded = jsonDecode(fromDb);
      if (decoded is List) {
        return decoded.cast<Map<String, dynamic>>();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  String? toSql(List<Map<String, dynamic>>? value) {
    if (value == null) return null;
    return jsonEncode(value);
  }
}
