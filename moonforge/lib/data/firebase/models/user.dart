import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    Settings? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int rev,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
abstract class Settings with _$Settings {
  const factory Settings({
    required String id,
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
abstract class AppLocale with _$AppLocale {
  const factory AppLocale({
    required String id,
    required String languageCode,
    String? countryCode,
  }) = _AppLocale;

  factory AppLocale.fromJson(Map<String, dynamic> json) =>
      _$AppLocaleFromJson(json);
}
