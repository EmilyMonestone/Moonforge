// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  settings: json['settings'] == null
      ? null
      : Settings.fromJson(json['settings'] as Map<String, dynamic>),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  rev: (json['rev'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'settings': instance.settings?.toJson(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'rev': instance.rev,
};

_Settings _$SettingsFromJson(Map<String, dynamic> json) => _Settings(
  id: json['id'] as String,
  themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']),
  locale: json['locale'] == null
      ? null
      : AppLocale.fromJson(json['locale'] as Map<String, dynamic>),
  railNavExtended: json['railNavExtended'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  rev: (json['rev'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SettingsToJson(_Settings instance) => <String, dynamic>{
  'id': instance.id,
  'themeMode': _$ThemeModeEnumMap[instance.themeMode],
  'locale': instance.locale?.toJson(),
  'railNavExtended': instance.railNavExtended,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'rev': instance.rev,
};

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

_AppLocale _$AppLocaleFromJson(Map<String, dynamic> json) => _AppLocale(
  id: json['id'] as String,
  languageCode: json['languageCode'] as String,
  countryCode: json['countryCode'] as String?,
);

Map<String, dynamic> _$AppLocaleToJson(_AppLocale instance) =>
    <String, dynamic>{
      'id': instance.id,
      'languageCode': instance.languageCode,
      'countryCode': instance.countryCode,
    };

// **************************************************************************
// ModelBuilderGenerator
// **************************************************************************

/// Patch builder for `User` model
class UserPatchBuilder<$$T extends User?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `User`
  UserPatchBuilder({required super.toJson, super.field});

  /// Update id field `String`
  late final PatchBuilder<String, String> id = PatchBuilder(
    field: path.append('id'),
    toJson: (value) => (value as String),
  );

  /// Update settings field `Settings?`
  late final SettingsPatchBuilder<Settings?> settings = SettingsPatchBuilder(
    field: path.append('settings'),
    toJson: (value) =>
        (value == null ? null : value!.toJson() as Map<String, dynamic>?),
  );

  /// Update createdAt field `DateTime?`
  late final DateTimeFieldUpdate<DateTime?> createdAt = DateTimeFieldUpdate(
    field: path.append('createdAt'),
  );

  /// Update updatedAt field `DateTime?`
  late final DateTimeFieldUpdate<DateTime?> updatedAt = DateTimeFieldUpdate(
    field: path.append('updatedAt'),
  );

  /// Update rev field `int`
  late final NumericFieldUpdate<int> rev = NumericFieldUpdate(
    field: path.append('rev'),
  );
}

/// Generated FilterBuilder for `User`
class UserFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `User`
  UserFilterBuilder({super.field});

  /// Filter by id
  late final ComparableFilterField<String> id = ComparableFilterField<String>(
    field: FieldPath.documentId,
    toJson: (value) => (value as String),
  );

  /// Filter by settings
  late final SettingsFilterBuilder settings = SettingsFilterBuilder(
    field: path.append('settings'),
  );

  /// Filter by createdAt
  late final ComparableFilterField<DateTime?> createdAt =
      ComparableFilterField<DateTime?>(
        field: path.append('createdAt'),
        toJson: (value) =>
            value == null ? null : const DateTimeConverter().toJson(value!),
      );

  /// Filter by updatedAt
  late final ComparableFilterField<DateTime?> updatedAt =
      ComparableFilterField<DateTime?>(
        field: path.append('updatedAt'),
        toJson: (value) =>
            value == null ? null : const DateTimeConverter().toJson(value!),
      );

  /// Filter by rev
  late final ComparableFilterField<int> rev = ComparableFilterField<int>(
    field: path.append('rev'),
    toJson: (value) => (value as int),
  );
}

/// Generated RootFilterBuilder for `User`
class UserFilterBuilderRoot extends UserFilterBuilder with FilterBuilderRoot {
  /// Creates a root filter selector for `User`
  UserFilterBuilderRoot();
}

/// Generated OrderByBuilder for `User`
class UserOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  UserOrderByBuilder({required super.context, super.field});

  /// Access nested id for ordering
  late final OrderByField<String> id = OrderByField<String>(
    field: FieldPath.documentId,
    context: $context,
  );

  /// Access nested settings for ordering
  late final SettingsOrderByBuilder settings = SettingsOrderByBuilder(
    field: path.append('settings'),
    context: $context,
  );

  /// Access nested createdAt for ordering
  late final OrderByField<DateTime?> createdAt = OrderByField<DateTime?>(
    field: path.append('createdAt'),
    context: $context,
  );

  /// Access nested updatedAt for ordering
  late final OrderByField<DateTime?> updatedAt = OrderByField<DateTime?>(
    field: path.append('updatedAt'),
    context: $context,
  );

  /// Access nested rev for ordering
  late final OrderByField<int> rev = OrderByField<int>(
    field: path.append('rev'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `User`
class UserAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  UserAggregateFieldSelector({required super.context, super.field});

  /// settings field for aggregation
  late final SettingsAggregateFieldSelector settings =
      SettingsAggregateFieldSelector(
        field: path.append('settings'),
        context: $context,
      );

  /// rev field for aggregation
  late final AggregateField<int> rev = AggregateField<int>(
    field: path.append('rev'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `User`
class UserAggregateBuilderRoot extends UserAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  UserAggregateBuilderRoot({required super.context, super.field});
}

/// Patch builder for `Settings` model
class SettingsPatchBuilder<$$T extends Settings?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `Settings`
  SettingsPatchBuilder({required super.toJson, super.field});

  /// Update id field `String`
  late final PatchBuilder<String, String> id = PatchBuilder(
    field: path.append('id'),
    toJson: (value) => (value as String),
  );

  /// Update themeMode field `ThemeMode?`
  late final PatchBuilder<ThemeMode?, String?> themeMode = PatchBuilder(
    field: path.append('themeMode'),
    toJson: (value) => value == null
        ? null
        : ({
                ThemeMode.system: 'system',
                ThemeMode.light: 'light',
                ThemeMode.dark: 'dark',
              }[value!]
              as String),
  );

  /// Update locale field `AppLocale?`
  late final AppLocalePatchBuilder<AppLocale?> locale = AppLocalePatchBuilder(
    field: path.append('locale'),
    toJson: (value) =>
        (value == null ? null : value!.toJson() as Map<String, dynamic>?),
  );

  /// Update railNavExtended field `bool?`
  late final PatchBuilder<bool?, bool?> railNavExtended = PatchBuilder(
    field: path.append('railNavExtended'),
    toJson: (value) => (value as bool?),
  );

  /// Update createdAt field `DateTime?`
  late final DateTimeFieldUpdate<DateTime?> createdAt = DateTimeFieldUpdate(
    field: path.append('createdAt'),
  );

  /// Update updatedAt field `DateTime?`
  late final DateTimeFieldUpdate<DateTime?> updatedAt = DateTimeFieldUpdate(
    field: path.append('updatedAt'),
  );

  /// Update rev field `int`
  late final NumericFieldUpdate<int> rev = NumericFieldUpdate(
    field: path.append('rev'),
  );
}

/// Generated FilterBuilder for `Settings`
class SettingsFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `Settings`
  SettingsFilterBuilder({super.field});

  /// Filter by id
  late final ComparableFilterField<String> id = ComparableFilterField<String>(
    field: FieldPath.documentId,
    toJson: (value) => (value as String),
  );

  /// Filter by themeMode
  late final ComparableFilterField<ThemeMode?> themeMode =
      ComparableFilterField<ThemeMode?>(
        field: path.append('themeMode'),
        toJson: (value) => value == null
            ? null
            : ({
                    ThemeMode.system: 'system',
                    ThemeMode.light: 'light',
                    ThemeMode.dark: 'dark',
                  }[value!]
                  as String),
      );

  /// Filter by locale
  late final AppLocaleFilterBuilder locale = AppLocaleFilterBuilder(
    field: path.append('locale'),
  );

  /// Filter by railNavExtended
  late final FilterField<bool?, bool?> railNavExtended =
      FilterField<bool?, bool?>(
        field: path.append('railNavExtended'),
        toJson: (value) => (value as bool?),
      );

  /// Filter by createdAt
  late final ComparableFilterField<DateTime?> createdAt =
      ComparableFilterField<DateTime?>(
        field: path.append('createdAt'),
        toJson: (value) =>
            value == null ? null : const DateTimeConverter().toJson(value!),
      );

  /// Filter by updatedAt
  late final ComparableFilterField<DateTime?> updatedAt =
      ComparableFilterField<DateTime?>(
        field: path.append('updatedAt'),
        toJson: (value) =>
            value == null ? null : const DateTimeConverter().toJson(value!),
      );

  /// Filter by rev
  late final ComparableFilterField<int> rev = ComparableFilterField<int>(
    field: path.append('rev'),
    toJson: (value) => (value as int),
  );
}

/// Generated RootFilterBuilder for `Settings`
class SettingsFilterBuilderRoot extends SettingsFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `Settings`
  SettingsFilterBuilderRoot();
}

/// Generated OrderByBuilder for `Settings`
class SettingsOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  SettingsOrderByBuilder({required super.context, super.field});

  /// Access nested id for ordering
  late final OrderByField<String> id = OrderByField<String>(
    field: FieldPath.documentId,
    context: $context,
  );

  /// Access nested themeMode for ordering
  late final OrderByField<ThemeMode?> themeMode = OrderByField<ThemeMode?>(
    field: path.append('themeMode'),
    context: $context,
    defaultValue: ThemeMode.system,
  );

  /// Access nested locale for ordering
  late final AppLocaleOrderByBuilder locale = AppLocaleOrderByBuilder(
    field: path.append('locale'),
    context: $context,
  );

  /// Access nested railNavExtended for ordering
  late final OrderByField<bool?> railNavExtended = OrderByField<bool?>(
    field: path.append('railNavExtended'),
    context: $context,
  );

  /// Access nested createdAt for ordering
  late final OrderByField<DateTime?> createdAt = OrderByField<DateTime?>(
    field: path.append('createdAt'),
    context: $context,
  );

  /// Access nested updatedAt for ordering
  late final OrderByField<DateTime?> updatedAt = OrderByField<DateTime?>(
    field: path.append('updatedAt'),
    context: $context,
  );

  /// Access nested rev for ordering
  late final OrderByField<int> rev = OrderByField<int>(
    field: path.append('rev'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `Settings`
class SettingsAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  SettingsAggregateFieldSelector({required super.context, super.field});

  /// locale field for aggregation
  late final AppLocaleAggregateFieldSelector locale =
      AppLocaleAggregateFieldSelector(
        field: path.append('locale'),
        context: $context,
      );

  /// rev field for aggregation
  late final AggregateField<int> rev = AggregateField<int>(
    field: path.append('rev'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `Settings`
class SettingsAggregateBuilderRoot extends SettingsAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  SettingsAggregateBuilderRoot({required super.context, super.field});
}

/// Patch builder for `AppLocale` model
class AppLocalePatchBuilder<$$T extends AppLocale?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `AppLocale`
  AppLocalePatchBuilder({required super.toJson, super.field});

  /// Update id field `String`
  late final PatchBuilder<String, String> id = PatchBuilder(
    field: path.append('id'),
    toJson: (value) => (value as String),
  );

  /// Update languageCode field `String`
  late final PatchBuilder<String, String> languageCode = PatchBuilder(
    field: path.append('languageCode'),
    toJson: (value) => (value as String),
  );

  /// Update countryCode field `String?`
  late final PatchBuilder<String?, String?> countryCode = PatchBuilder(
    field: path.append('countryCode'),
    toJson: (value) => (value as String?),
  );
}

/// Generated FilterBuilder for `AppLocale`
class AppLocaleFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `AppLocale`
  AppLocaleFilterBuilder({super.field});

  /// Filter by id
  late final ComparableFilterField<String> id = ComparableFilterField<String>(
    field: FieldPath.documentId,
    toJson: (value) => (value as String),
  );

  /// Filter by languageCode
  late final ComparableFilterField<String> languageCode =
      ComparableFilterField<String>(
        field: path.append('languageCode'),
        toJson: (value) => (value as String),
      );

  /// Filter by countryCode
  late final ComparableFilterField<String?> countryCode =
      ComparableFilterField<String?>(
        field: path.append('countryCode'),
        toJson: (value) => (value as String?),
      );
}

/// Generated RootFilterBuilder for `AppLocale`
class AppLocaleFilterBuilderRoot extends AppLocaleFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `AppLocale`
  AppLocaleFilterBuilderRoot();
}

/// Generated OrderByBuilder for `AppLocale`
class AppLocaleOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  AppLocaleOrderByBuilder({required super.context, super.field});

  /// Access nested id for ordering
  late final OrderByField<String> id = OrderByField<String>(
    field: FieldPath.documentId,
    context: $context,
  );

  /// Access nested languageCode for ordering
  late final OrderByField<String> languageCode = OrderByField<String>(
    field: path.append('languageCode'),
    context: $context,
  );

  /// Access nested countryCode for ordering
  late final OrderByField<String?> countryCode = OrderByField<String?>(
    field: path.append('countryCode'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `AppLocale`
class AppLocaleAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  AppLocaleAggregateFieldSelector({required super.context, super.field});
}

/// Generated AggregateFieldSelector for `AppLocale`
class AppLocaleAggregateBuilderRoot extends AppLocaleAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  AppLocaleAggregateBuilderRoot({required super.context, super.field});
}
