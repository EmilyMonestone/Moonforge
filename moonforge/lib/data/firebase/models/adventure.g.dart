// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adventure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Adventure _$AdventureFromJson(Map<String, dynamic> json) => _Adventure(
  id: json['id'] as String,
  name: json['name'] as String,
  order: (json['order'] as num?)?.toInt() ?? 0,
  summary: json['summary'] as String?,
  content: json['content'] as String?,
  entityIds:
      (json['entityIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  rev: (json['rev'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AdventureToJson(_Adventure instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
      'summary': instance.summary,
      'content': instance.content,
      'entityIds': instance.entityIds,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'rev': instance.rev,
    };

// **************************************************************************
// ModelBuilderGenerator
// **************************************************************************

/// Patch builder for `Adventure` model
class AdventurePatchBuilder<$$T extends Adventure?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `Adventure`
  AdventurePatchBuilder({required super.toJson, super.field});

  /// Update id field `String`
  late final PatchBuilder<String, String> id = PatchBuilder(
    field: path.append('id'),
    toJson: (value) => (value as String),
  );

  /// Update name field `String`
  late final PatchBuilder<String, String> name = PatchBuilder(
    field: path.append('name'),
    toJson: (value) => (value as String),
  );

  /// Update order field `int`
  late final NumericFieldUpdate<int> order = NumericFieldUpdate(
    field: path.append('order'),
  );

  /// Update summary field `String?`
  late final PatchBuilder<String?, String?> summary = PatchBuilder(
    field: path.append('summary'),
    toJson: (value) => (value as String?),
  );

  /// Update content field `String?`
  late final PatchBuilder<String?, String?> content = PatchBuilder(
    field: path.append('content'),
    toJson: (value) => (value as String?),
  );

  /// Update entityIds field `List<String>`
  late final ListFieldUpdate<List<String>, String, String> entityIds =
      ListFieldUpdate(
        field: path.append('entityIds'),
        elementToJson: (value) => (value as String),
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

/// Generated FilterBuilder for `Adventure`
class AdventureFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `Adventure`
  AdventureFilterBuilder({super.field});

  /// Filter by id
  late final ComparableFilterField<String> id = ComparableFilterField<String>(
    field: FieldPath.documentId,
    toJson: (value) => (value as String),
  );

  /// Filter by name
  late final ComparableFilterField<String> name = ComparableFilterField<String>(
    field: path.append('name'),
    toJson: (value) => (value as String),
  );

  /// Filter by order
  late final ComparableFilterField<int> order = ComparableFilterField<int>(
    field: path.append('order'),
    toJson: (value) => (value as int),
  );

  /// Filter by summary
  late final ComparableFilterField<String?> summary =
      ComparableFilterField<String?>(
        field: path.append('summary'),
        toJson: (value) => (value as String?),
      );

  /// Filter by content
  late final ComparableFilterField<String?> content =
      ComparableFilterField<String?>(
        field: path.append('content'),
        toJson: (value) => (value as String?),
      );

  /// Filter by entityIds
  late final ArrayFilterField<List<String>, String, String> entityIds =
      ArrayFilterField<List<String>, String, String>(
        field: path.append('entityIds'),
        toJson: (value) => listToJson(value, (value) => (value as String)),
        elementToJson: (value) => (value as String),
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

/// Generated RootFilterBuilder for `Adventure`
class AdventureFilterBuilderRoot extends AdventureFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `Adventure`
  AdventureFilterBuilderRoot();
}

/// Generated OrderByBuilder for `Adventure`
class AdventureOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  AdventureOrderByBuilder({required super.context, super.field});

  /// Access nested id for ordering
  late final OrderByField<String> id = OrderByField<String>(
    field: FieldPath.documentId,
    context: $context,
  );

  /// Access nested name for ordering
  late final OrderByField<String> name = OrderByField<String>(
    field: path.append('name'),
    context: $context,
  );

  /// Access nested order for ordering
  late final OrderByField<int> order = OrderByField<int>(
    field: path.append('order'),
    context: $context,
  );

  /// Access nested summary for ordering
  late final OrderByField<String?> summary = OrderByField<String?>(
    field: path.append('summary'),
    context: $context,
  );

  /// Access nested content for ordering
  late final OrderByField<String?> content = OrderByField<String?>(
    field: path.append('content'),
    context: $context,
  );

  /// Access nested entityIds for ordering
  late final OrderByField<List<String>> entityIds = OrderByField<List<String>>(
    field: path.append('entityIds'),
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

/// Generated AggregateFieldSelector for `Adventure`
class AdventureAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  AdventureAggregateFieldSelector({required super.context, super.field});

  /// order field for aggregation
  late final AggregateField<int> order = AggregateField<int>(
    field: path.append('order'),
    context: $context,
  );

  /// rev field for aggregation
  late final AggregateField<int> rev = AggregateField<int>(
    field: path.append('rev'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `Adventure`
class AdventureAggregateBuilderRoot extends AdventureAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  AdventureAggregateBuilderRoot({required super.context, super.field});
}
