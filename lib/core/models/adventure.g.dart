// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adventure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdventureDoc _$AdventureDocFromJson(Map<String, dynamic> json) =>
    _AdventureDoc(
      id: json['id'] as String,
      name: json['name'] as String,
      order: (json['order'] as num?)?.toInt() ?? 0,
      summary: json['summary'] as String?,
      content: json['content'] == null
          ? null
          : RichTextDoc.fromJson(json['content'] as Map<String, dynamic>),
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
      rev: (json['rev'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AdventureDocToJson(_AdventureDoc instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
      'summary': instance.summary,
      'content': instance.content?.toJson(),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'rev': instance.rev,
    };

// **************************************************************************
// ModelBuilderGenerator
// **************************************************************************

/// Patch builder for `AdventureDoc` model
class AdventureDocPatchBuilder<$$T extends AdventureDoc?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `AdventureDoc`
  AdventureDocPatchBuilder({required super.toJson, super.field});

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

  /// Update content field `RichTextDoc?`
  late final RichTextDocPatchBuilder<RichTextDoc?> content =
      RichTextDocPatchBuilder(
        field: path.append('content'),
        toJson: (value) =>
            (value == null ? null : value!.toJson() as Map<String, dynamic>?),
      );

  /// Update createdAt field `DateTime?`
  late final PatchBuilder<DateTime?, Object?> createdAt = PatchBuilder(
    field: path.append('createdAt'),
    toJson: const TimestampConverter().toJson,
  );

  /// Update updatedAt field `DateTime?`
  late final PatchBuilder<DateTime?, Object?> updatedAt = PatchBuilder(
    field: path.append('updatedAt'),
    toJson: const TimestampConverter().toJson,
  );

  /// Update rev field `int`
  late final NumericFieldUpdate<int> rev = NumericFieldUpdate(
    field: path.append('rev'),
  );
}

/// Generated FilterBuilder for `AdventureDoc`
class AdventureDocFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `AdventureDoc`
  AdventureDocFilterBuilder({super.field});

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
  late final RichTextDocFilterBuilder content = RichTextDocFilterBuilder(
    field: path.append('content'),
  );

  /// Filter by createdAt
  late final FilterField<DateTime?, Object?> createdAt =
      FilterField<DateTime?, Object?>(
        field: path.append('createdAt'),
        toJson: (value) => const TimestampConverter().toJson(value),
      );

  /// Filter by updatedAt
  late final FilterField<DateTime?, Object?> updatedAt =
      FilterField<DateTime?, Object?>(
        field: path.append('updatedAt'),
        toJson: (value) => const TimestampConverter().toJson(value),
      );

  /// Filter by rev
  late final ComparableFilterField<int> rev = ComparableFilterField<int>(
    field: path.append('rev'),
    toJson: (value) => (value as int),
  );
}

/// Generated RootFilterBuilder for `AdventureDoc`
class AdventureDocFilterBuilderRoot extends AdventureDocFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `AdventureDoc`
  AdventureDocFilterBuilderRoot();
}

/// Generated OrderByBuilder for `AdventureDoc`
class AdventureDocOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  AdventureDocOrderByBuilder({required super.context, super.field});

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
  late final RichTextDocOrderByBuilder content = RichTextDocOrderByBuilder(
    field: path.append('content'),
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

/// Generated AggregateFieldSelector for `AdventureDoc`
class AdventureDocAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  AdventureDocAggregateFieldSelector({required super.context, super.field});

  /// order field for aggregation
  late final AggregateField<int> order = AggregateField<int>(
    field: path.append('order'),
    context: $context,
  );

  /// content field for aggregation
  late final RichTextDocAggregateFieldSelector content =
      RichTextDocAggregateFieldSelector(
        field: path.append('content'),
        context: $context,
      );

  /// rev field for aggregation
  late final AggregateField<int> rev = AggregateField<int>(
    field: path.append('rev'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `AdventureDoc`
class AdventureDocAggregateBuilderRoot
    extends AdventureDocAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  AdventureDocAggregateBuilderRoot({required super.context, super.field});
}
