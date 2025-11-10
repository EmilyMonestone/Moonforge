import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:moonforge/core/utils/safe_data_parser.dart';

// Generic JSON <-> TEXT for Map<String,dynamic>
class MapJsonConverter extends TypeConverter<Map<String, dynamic>, String>
    with
        JsonTypeConverter2<Map<String, dynamic>, String, Map<String, dynamic>> {
  const MapJsonConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    try {
      return SafeDataParser.tryParseMap(fromDb);
    } catch (e) {
      return {};
    }
  }

  @override
  String toSql(Map<String, dynamic> value) => jsonEncode(value);

  @override
  Map<String, dynamic> toJson(Map<String, dynamic> value) => value;

  @override
  Map<String, dynamic> fromJson(Map<String, dynamic> json) => json;
}

/// Quill Delta JSON stored as TEXT, tolerant to legacy formats when reading
/// from SQL (Map, List -> wraps as {ops: [...]}, String JSON), while keeping
/// Drift's expected JSON type signature as Map<String,dynamic>.
class QuillJsonConverter extends TypeConverter<Map<String, dynamic>, String>
    with
        JsonTypeConverter2<Map<String, dynamic>, String, Map<String, dynamic>> {
  const QuillJsonConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    final decoded = jsonDecode(fromDb);
    return _normalize(decoded);
  }

  @override
  String toSql(Map<String, dynamic> value) => jsonEncode(value);

  @override
  Map<String, dynamic> toJson(Map<String, dynamic> value) => value;

  @override
  Map<String, dynamic> fromJson(Map<String, dynamic> json) => _normalize(json);

  Map<String, dynamic> _normalize(dynamic v) {
    if (v == null) return <String, dynamic>{};
    if (v is Map<String, dynamic>) return v;
    if (v is Map) return Map<String, dynamic>.from(v);
    if (v is List) return <String, dynamic>{'ops': v};
    if (v is String) {
      try {
        final d = jsonDecode(v);
        return _normalize(d);
      } catch (_) {
        return <String, dynamic>{};
      }
    }
    return <String, dynamic>{};
  }
}

// Quill Delta JSON stored as TEXT
typedef QuillDelta = Map<String, dynamic>;

const quillConv = QuillJsonConverter();

// List<String> <-> TEXT (JSON)
class StringListConverter extends TypeConverter<List<String>, String>
    with JsonTypeConverter2<List<String>, String, List<dynamic>> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    try {
      return SafeDataParser.tryParseStringList(fromDb);
    } catch (e) {
      return [];
    }
  }

  @override
  String toSql(List<String> value) => jsonEncode(value);

  @override
  List<dynamic> toJson(List<String> value) => value;

  @override
  List<String> fromJson(List<dynamic> json) {
    try {
      return SafeDataParser.tryParseStringList(json);
    } catch (e) {
      return [];
    }
  }
}

// List<Map<String,dynamic>>
class MapListConverter extends TypeConverter<List<Map<String, dynamic>>, String>
    with JsonTypeConverter2<List<Map<String, dynamic>>, String, List<dynamic>> {
  const MapListConverter();

  @override
  List<Map<String, dynamic>> fromSql(String fromDb) {
    try {
      return SafeDataParser.tryParseMapList(fromDb);
    } catch (e) {
      return [];
    }
  }

  @override
  String toSql(List<Map<String, dynamic>> value) => jsonEncode(value);

  @override
  List<dynamic> toJson(List<Map<String, dynamic>> value) => value;

  @override
  List<Map<String, dynamic>> fromJson(List<dynamic> json) {
    try {
      return SafeDataParser.tryParseMapList(json);
    } catch (e) {
      return [];
    }
  }
}
