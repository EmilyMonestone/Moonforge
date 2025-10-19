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
);

Map<String, dynamic> _$SessionToJson(_Session instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt?.toIso8601String(),
  'info': instance.info,
  'datetime': instance.datetime?.toIso8601String(),
  'log': instance.log,
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
}

/// Generated AggregateFieldSelector for `Session`
class SessionAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  SessionAggregateFieldSelector({required super.context, super.field});
}

/// Generated AggregateFieldSelector for `Session`
class SessionAggregateBuilderRoot extends SessionAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  SessionAggregateBuilderRoot({required super.context, super.field});
}
