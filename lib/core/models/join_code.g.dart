// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JoinCode _$JoinCodeFromJson(Map<String, dynamic> json) => _JoinCode(
  id: json['id'] as String,
  cid: json['cid'] as String,
  sid: json['sid'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  ttl: json['ttl'] == null ? null : DateTime.parse(json['ttl'] as String),
);

Map<String, dynamic> _$JoinCodeToJson(_JoinCode instance) => <String, dynamic>{
  'id': instance.id,
  'cid': instance.cid,
  'sid': instance.sid,
  'createdAt': instance.createdAt?.toIso8601String(),
  'ttl': instance.ttl?.toIso8601String(),
};

// **************************************************************************
// ModelBuilderGenerator
// **************************************************************************

/// Patch builder for `JoinCode` model
class JoinCodePatchBuilder<$$T extends JoinCode?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `JoinCode`
  JoinCodePatchBuilder({required super.toJson, super.field});

  /// Update id field `String`
  late final PatchBuilder<String, String> id = PatchBuilder(
    field: path.append('id'),
    toJson: (value) => (value as String),
  );

  /// Update cid field `String`
  late final PatchBuilder<String, String> cid = PatchBuilder(
    field: path.append('cid'),
    toJson: (value) => (value as String),
  );

  /// Update sid field `String?`
  late final PatchBuilder<String?, String?> sid = PatchBuilder(
    field: path.append('sid'),
    toJson: (value) => (value as String?),
  );

  /// Update createdAt field `DateTime?`
  late final DateTimeFieldUpdate<DateTime?> createdAt = DateTimeFieldUpdate(
    field: path.append('createdAt'),
  );

  /// Update ttl field `DateTime?`
  late final DateTimeFieldUpdate<DateTime?> ttl = DateTimeFieldUpdate(
    field: path.append('ttl'),
  );
}

/// Generated FilterBuilder for `JoinCode`
class JoinCodeFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `JoinCode`
  JoinCodeFilterBuilder({super.field});

  /// Filter by id
  late final ComparableFilterField<String> id = ComparableFilterField<String>(
    field: FieldPath.documentId,
    toJson: (value) => (value as String),
  );

  /// Filter by cid
  late final ComparableFilterField<String> cid = ComparableFilterField<String>(
    field: path.append('cid'),
    toJson: (value) => (value as String),
  );

  /// Filter by sid
  late final ComparableFilterField<String?> sid =
      ComparableFilterField<String?>(
        field: path.append('sid'),
        toJson: (value) => (value as String?),
      );

  /// Filter by createdAt
  late final ComparableFilterField<DateTime?> createdAt =
      ComparableFilterField<DateTime?>(
        field: path.append('createdAt'),
        toJson: (value) =>
            value == null ? null : const DateTimeConverter().toJson(value!),
      );

  /// Filter by ttl
  late final ComparableFilterField<DateTime?> ttl =
      ComparableFilterField<DateTime?>(
        field: path.append('ttl'),
        toJson: (value) =>
            value == null ? null : const DateTimeConverter().toJson(value!),
      );
}

/// Generated RootFilterBuilder for `JoinCode`
class JoinCodeFilterBuilderRoot extends JoinCodeFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `JoinCode`
  JoinCodeFilterBuilderRoot();
}

/// Generated OrderByBuilder for `JoinCode`
class JoinCodeOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  JoinCodeOrderByBuilder({required super.context, super.field});

  /// Access nested id for ordering
  late final OrderByField<String> id = OrderByField<String>(
    field: FieldPath.documentId,
    context: $context,
  );

  /// Access nested cid for ordering
  late final OrderByField<String> cid = OrderByField<String>(
    field: path.append('cid'),
    context: $context,
  );

  /// Access nested sid for ordering
  late final OrderByField<String?> sid = OrderByField<String?>(
    field: path.append('sid'),
    context: $context,
  );

  /// Access nested createdAt for ordering
  late final OrderByField<DateTime?> createdAt = OrderByField<DateTime?>(
    field: path.append('createdAt'),
    context: $context,
  );

  /// Access nested ttl for ordering
  late final OrderByField<DateTime?> ttl = OrderByField<DateTime?>(
    field: path.append('ttl'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `JoinCode`
class JoinCodeAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  JoinCodeAggregateFieldSelector({required super.context, super.field});
}

/// Generated AggregateFieldSelector for `JoinCode`
class JoinCodeAggregateBuilderRoot extends JoinCodeAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  JoinCodeAggregateBuilderRoot({required super.context, super.field});
}
