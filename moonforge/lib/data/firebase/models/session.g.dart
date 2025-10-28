// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Session _$SessionFromJson(Map<String, dynamic> json) => _Session(
  id: json['id'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  info: json['info'] as String?,
  datetime: json['datetime'] == null
      ? null
      : DateTime.parse(json['datetime'] as String),
  log: json['log'] as String?,
  shareToken: json['shareToken'] as String?,
  shareEnabled: json['shareEnabled'] as bool? ?? false,
  shareExpiresAt: json['shareExpiresAt'] == null
      ? null
      : DateTime.parse(json['shareExpiresAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  rev: (json['rev'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SessionToJson(_Session instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt?.toIso8601String(),
  'info': instance.info,
  'datetime': instance.datetime?.toIso8601String(),
  'log': instance.log,
  'shareToken': instance.shareToken,
  'shareEnabled': instance.shareEnabled,
  'shareExpiresAt': instance.shareExpiresAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'rev': instance.rev,
};

// **************************************************************************
// ModelBuilderGenerator
// **************************************************************************

/// Patch builder for `Session` model
class SessionPatchBuilder<$$T extends Session?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `Session`
  SessionPatchBuilder({required super.toJson, super.field});

  /// Update id field `String`
  late final PatchBuilder<String, String> id = PatchBuilder(
    field: path.append('id'),
    toJson: (value) => (value as String),
  );

  /// Update createdAt field `DateTime?`
  late final DateTimeFieldUpdate<DateTime?> createdAt = DateTimeFieldUpdate(
    field: path.append('createdAt'),
  );

  /// Update info field `String?`
  late final PatchBuilder<String?, String?> info = PatchBuilder(
    field: path.append('info'),
    toJson: (value) => (value as String?),
  );

  /// Update datetime field `DateTime?`
  late final DateTimeFieldUpdate<DateTime?> datetime = DateTimeFieldUpdate(
    field: path.append('datetime'),
  );

  /// Update log field `String?`
  late final PatchBuilder<String?, String?> log = PatchBuilder(
    field: path.append('log'),
    toJson: (value) => (value as String?),
  );

  /// Update shareToken field `String?`
  late final PatchBuilder<String?, String?> shareToken = PatchBuilder(
    field: path.append('shareToken'),
    toJson: (value) => (value as String?),
  );

  /// Update shareEnabled field `bool`
  late final PatchBuilder<bool, bool> shareEnabled = PatchBuilder(
    field: path.append('shareEnabled'),
    toJson: (value) => (value as bool),
  );

  /// Update shareExpiresAt field `DateTime?`
  late final DateTimeFieldUpdate<DateTime?> shareExpiresAt =
      DateTimeFieldUpdate(field: path.append('shareExpiresAt'));

  /// Update updatedAt field `DateTime?`
  late final DateTimeFieldUpdate<DateTime?> updatedAt = DateTimeFieldUpdate(
    field: path.append('updatedAt'),
  );

  /// Update rev field `int`
  late final NumericFieldUpdate<int> rev = NumericFieldUpdate(
    field: path.append('rev'),
  );
}

/// Generated FilterBuilder for `Session`
class SessionFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `Session`
  SessionFilterBuilder({super.field});

  /// Filter by id
  late final ComparableFilterField<String> id = ComparableFilterField<String>(
    field: FieldPath.documentId,
    toJson: (value) => (value as String),
  );

  /// Filter by createdAt
  late final ComparableFilterField<DateTime?> createdAt =
      ComparableFilterField<DateTime?>(
        field: path.append('createdAt'),
        toJson: (value) =>
            value == null ? null : const DateTimeConverter().toJson(value!),
      );

  /// Filter by info
  late final ComparableFilterField<String?> info =
      ComparableFilterField<String?>(
        field: path.append('info'),
        toJson: (value) => (value as String?),
      );

  /// Filter by datetime
  late final ComparableFilterField<DateTime?> datetime =
      ComparableFilterField<DateTime?>(
        field: path.append('datetime'),
        toJson: (value) =>
            value == null ? null : const DateTimeConverter().toJson(value!),
      );

  /// Filter by log
  late final ComparableFilterField<String?> log =
      ComparableFilterField<String?>(
        field: path.append('log'),
        toJson: (value) => (value as String?),
      );

  /// Filter by shareToken
  late final ComparableFilterField<String?> shareToken =
      ComparableFilterField<String?>(
        field: path.append('shareToken'),
        toJson: (value) => (value as String?),
      );

  /// Filter by shareEnabled
  late final FilterField<bool, bool> shareEnabled = FilterField<bool, bool>(
    field: path.append('shareEnabled'),
    toJson: (value) => (value as bool),
  );

  /// Filter by shareExpiresAt
  late final ComparableFilterField<DateTime?> shareExpiresAt =
      ComparableFilterField<DateTime?>(
        field: path.append('shareExpiresAt'),
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

/// Generated RootFilterBuilder for `Session`
class SessionFilterBuilderRoot extends SessionFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `Session`
  SessionFilterBuilderRoot();
}

/// Generated OrderByBuilder for `Session`
class SessionOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  SessionOrderByBuilder({required super.context, super.field});

  /// Access nested id for ordering
  late final OrderByField<String> id = OrderByField<String>(
    field: FieldPath.documentId,
    context: $context,
  );

  /// Access nested createdAt for ordering
  late final OrderByField<DateTime?> createdAt = OrderByField<DateTime?>(
    field: path.append('createdAt'),
    context: $context,
  );

  /// Access nested info for ordering
  late final OrderByField<String?> info = OrderByField<String?>(
    field: path.append('info'),
    context: $context,
  );

  /// Access nested datetime for ordering
  late final OrderByField<DateTime?> datetime = OrderByField<DateTime?>(
    field: path.append('datetime'),
    context: $context,
  );

  /// Access nested log for ordering
  late final OrderByField<String?> log = OrderByField<String?>(
    field: path.append('log'),
    context: $context,
  );

  /// Access nested shareToken for ordering
  late final OrderByField<String?> shareToken = OrderByField<String?>(
    field: path.append('shareToken'),
    context: $context,
  );

  /// Access nested shareEnabled for ordering
  late final OrderByField<bool> shareEnabled = OrderByField<bool>(
    field: path.append('shareEnabled'),
    context: $context,
  );

  /// Access nested shareExpiresAt for ordering
  late final OrderByField<DateTime?> shareExpiresAt = OrderByField<DateTime?>(
    field: path.append('shareExpiresAt'),
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

/// Generated AggregateFieldSelector for `Session`
class SessionAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  SessionAggregateFieldSelector({required super.context, super.field});

  /// rev field for aggregation
  late final AggregateField<int> rev = AggregateField<int>(
    field: path.append('rev'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `Session`
class SessionAggregateBuilderRoot extends SessionAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  SessionAggregateBuilderRoot({required super.context, super.field});
}
