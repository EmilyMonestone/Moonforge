import 'dart:convert';
import 'package:drift/drift.dart';

/// Converts List<String>? to/from JSON for Drift storage
class StringListConverter extends TypeConverter<List<String>?, String?> {
  const StringListConverter();

  @override
  List<String>? fromSql(String? fromDb) {
    if (fromDb == null) return null;
    try {
      final decoded = jsonDecode(fromDb);
      if (decoded is List) {
        return decoded.cast<String>();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  String? toSql(List<String>? value) {
    if (value == null) return null;
    return jsonEncode(value);
  }
}
