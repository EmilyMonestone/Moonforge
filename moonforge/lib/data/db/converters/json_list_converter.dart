import 'dart:convert';

import 'package:drift/drift.dart';

/// Type converter for JSON array of strings
class JsonListConverter extends TypeConverter<List<String>, String> {
  const JsonListConverter();

  @override
  List<String> fromSql(String fromDb) {
    try {
      final decoded = jsonDecode(fromDb);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  String toSql(List<String> value) {
    return jsonEncode(value);
  }
}
