import 'package:firestore_odm/firestore_odm.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
@firestoreOdm
abstract class User with _$User {
  const factory User({
    @DocumentIdField() required String id,
    Settings? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int rev,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
@firestoreOdm
abstract class Settings with _$Settings {
  const factory Settings({
    @DocumentIdField() required String id,
    ThemeMode? themeMode,
    AppLocale? locale,
    bool? railNavExtended,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int rev,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
}

@freezed
@firestoreOdm
abstract class AppLocale with _$AppLocale {
  const factory AppLocale({
    @DocumentIdField() required String id,
    required String languageCode,
    String? countryCode,
  }) = _AppLocale;

  factory AppLocale.fromJson(Map<String, dynamic> json) =>
      _$AppLocaleFromJson(json);
}
