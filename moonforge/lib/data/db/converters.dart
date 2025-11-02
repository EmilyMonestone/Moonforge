import 'dart:convert';

import 'package:drift/drift.dart';

// Generic JSON <-> TEXT for Map<String,dynamic>
class MapJsonConverter extends TypeConverter<Map<String, dynamic>, String>
    with
        JsonTypeConverter2<Map<String, dynamic>, String, Map<String, dynamic>> {
  const MapJsonConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) =>
      jsonDecode(fromDb) as Map<String, dynamic>;

  @override
  String toSql(Map<String, dynamic> value) => jsonEncode(value);

  @override
  Map<String, dynamic> toJson(Map<String, dynamic> value) => value;

  @override
  Map<String, dynamic> fromJson(Map<String, dynamic> json) => json;
}

// List<String> <-> TEXT (JSON)
class StringListConverter extends TypeConverter<List<String>, String>
    with JsonTypeConverter2<List<String>, String, List<dynamic>> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as List).cast<String>();

  @override
  String toSql(List<String> value) => jsonEncode(value);

  @override
  List<dynamic> toJson(List<String> value) => value;

  @override
  List<String> fromJson(List<dynamic> json) =>
      json.map((e) => e.toString()).toList();
}

// Quill Delta JSON stored as TEXT
typedef QuillDelta = Map<String, dynamic>;
const quillConv = MapJsonConverter();

// List<Map<String,dynamic>>
class MapListConverter extends TypeConverter<List<Map<String, dynamic>>, String>
    with JsonTypeConverter2<List<Map<String, dynamic>>, String, List<dynamic>> {
  const MapListConverter();

  @override
  List<Map<String, dynamic>> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as List)
          .cast<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

  @override
  String toSql(List<Map<String, dynamic>> value) => jsonEncode(value);

  @override
  List<dynamic> toJson(List<Map<String, dynamic>> value) => value;

  @override
  List<Map<String, dynamic>> fromJson(List<dynamic> json) =>
      json.map((e) => Map<String, dynamic>.from(e as Map)).toList();
}
