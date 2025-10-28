// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Scene _$SceneFromJson(Map<String, dynamic> json) => _Scene(
  id: json['id'] as String,
  title: json['title'] as String,
  order: (json['order'] as num?)?.toInt() ?? 0,
  summary: json['summary'] as String?,
  content: json['content'] as String?,
  mentions: (json['mentions'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  mediaRefs: (json['mediaRefs'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  entityIds:
      (json['entityIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  rev: (json['rev'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SceneToJson(_Scene instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'order': instance.order,
  'summary': instance.summary,
  'content': instance.content,
  'mentions': instance.mentions,
  'mediaRefs': instance.mediaRefs,
  'entityIds': instance.entityIds,
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'rev': instance.rev,
};

// **************************************************************************
// ModelBuilderGenerator
// **************************************************************************

/// Patch builder for `Scene` model
class ScenePatchBuilder<$$T extends Scene?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `Scene`
  ScenePatchBuilder({required super.toJson, super.field});

  /// Update id field `String`
  late final PatchBuilder<String, String> id = PatchBuilder(
    field: path.append('id'),
    toJson: (value) => (value as String),
  );

  /// Update title field `String`
  late final PatchBuilder<String, String> title = PatchBuilder(
    field: path.append('title'),
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

  /// Update mentions field `List<Map<String, dynamic>>?`
  late final ListFieldUpdate<
    List<Map<String, dynamic>>?,
    Map<String, dynamic>,
    Map<String, dynamic>
  >
  mentions = ListFieldUpdate(
    field: path.append('mentions'),
    elementToJson: (value) => mapToJson(
      value,
      (value) => (value as String),
      (value) => (value as dynamic),
    ),
  );

  /// Update mediaRefs field `List<Map<String, dynamic>>?`
  late final ListFieldUpdate<
    List<Map<String, dynamic>>?,
    Map<String, dynamic>,
    Map<String, dynamic>
  >
  mediaRefs = ListFieldUpdate(
    field: path.append('mediaRefs'),
    elementToJson: (value) => mapToJson(
      value,
      (value) => (value as String),
      (value) => (value as dynamic),
    ),
  );

  /// Update entityIds field `List<String>`
  late final ListFieldUpdate<List<String>, String, String> entityIds =
      ListFieldUpdate(
        field: path.append('entityIds'),
        elementToJson: (value) => (value as String),
      );

  /// Update updatedAt field `DateTime?`
  late final DateTimeFieldUpdate<DateTime?> updatedAt = DateTimeFieldUpdate(
    field: path.append('updatedAt'),
  );

  /// Update createdAt field `DateTime?`
  late final DateTimeFieldUpdate<DateTime?> createdAt = DateTimeFieldUpdate(
    field: path.append('createdAt'),
  );

  /// Update rev field `int`
  late final NumericFieldUpdate<int> rev = NumericFieldUpdate(
    field: path.append('rev'),
  );
}

/// Generated FilterBuilder for `Scene`
class SceneFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `Scene`
  SceneFilterBuilder({super.field});

  /// Filter by id
  late final ComparableFilterField<String> id = ComparableFilterField<String>(
    field: FieldPath.documentId,
    toJson: (value) => (value as String),
  );

  /// Filter by title
  late final ComparableFilterField<String> title =
      ComparableFilterField<String>(
        field: path.append('title'),
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

  /// Filter by mentions
  late final ArrayFilterField<
    List<Map<String, dynamic>>?,
    Map<String, dynamic>,
    Map<String, dynamic>
  >
  mentions =
      ArrayFilterField<
        List<Map<String, dynamic>>?,
        Map<String, dynamic>,
        Map<String, dynamic>
      >(
        field: path.append('mentions'),
        toJson: (value) => value == null
            ? null
            : listToJson(
                value!,
                (value) => mapToJson(
                  value,
                  (value) => (value as String),
                  (value) => (value as dynamic),
                ),
              ),
        elementToJson: (value) => mapToJson(
          value,
          (value) => (value as String),
          (value) => (value as dynamic),
        ),
      );

  /// Filter by mediaRefs
  late final ArrayFilterField<
    List<Map<String, dynamic>>?,
    Map<String, dynamic>,
    Map<String, dynamic>
  >
  mediaRefs =
      ArrayFilterField<
        List<Map<String, dynamic>>?,
        Map<String, dynamic>,
        Map<String, dynamic>
      >(
        field: path.append('mediaRefs'),
        toJson: (value) => value == null
            ? null
            : listToJson(
                value!,
                (value) => mapToJson(
                  value,
                  (value) => (value as String),
                  (value) => (value as dynamic),
                ),
              ),
        elementToJson: (value) => mapToJson(
          value,
          (value) => (value as String),
          (value) => (value as dynamic),
        ),
      );

  /// Filter by entityIds
  late final ArrayFilterField<List<String>, String, String> entityIds =
      ArrayFilterField<List<String>, String, String>(
        field: path.append('entityIds'),
        toJson: (value) => listToJson(value, (value) => (value as String)),
        elementToJson: (value) => (value as String),
      );

  /// Filter by updatedAt
  late final ComparableFilterField<DateTime?> updatedAt =
      ComparableFilterField<DateTime?>(
        field: path.append('updatedAt'),
        toJson: (value) =>
            value == null ? null : const DateTimeConverter().toJson(value!),
      );

  /// Filter by createdAt
  late final ComparableFilterField<DateTime?> createdAt =
      ComparableFilterField<DateTime?>(
        field: path.append('createdAt'),
        toJson: (value) =>
            value == null ? null : const DateTimeConverter().toJson(value!),
      );

  /// Filter by rev
  late final ComparableFilterField<int> rev = ComparableFilterField<int>(
    field: path.append('rev'),
    toJson: (value) => (value as int),
  );
}

/// Generated RootFilterBuilder for `Scene`
class SceneFilterBuilderRoot extends SceneFilterBuilder with FilterBuilderRoot {
  /// Creates a root filter selector for `Scene`
  SceneFilterBuilderRoot();
}

/// Generated OrderByBuilder for `Scene`
class SceneOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  SceneOrderByBuilder({required super.context, super.field});

  /// Access nested id for ordering
  late final OrderByField<String> id = OrderByField<String>(
    field: FieldPath.documentId,
    context: $context,
  );

  /// Access nested title for ordering
  late final OrderByField<String> title = OrderByField<String>(
    field: path.append('title'),
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

  /// Access nested mentions for ordering
  late final OrderByField<List<Map<String, dynamic>>?> mentions =
      OrderByField<List<Map<String, dynamic>>?>(
        field: path.append('mentions'),
        context: $context,
      );

  /// Access nested mediaRefs for ordering
  late final OrderByField<List<Map<String, dynamic>>?> mediaRefs =
      OrderByField<List<Map<String, dynamic>>?>(
        field: path.append('mediaRefs'),
        context: $context,
      );

  /// Access nested entityIds for ordering
  late final OrderByField<List<String>> entityIds = OrderByField<List<String>>(
    field: path.append('entityIds'),
    context: $context,
  );

  /// Access nested updatedAt for ordering
  late final OrderByField<DateTime?> updatedAt = OrderByField<DateTime?>(
    field: path.append('updatedAt'),
    context: $context,
  );

  /// Access nested createdAt for ordering
  late final OrderByField<DateTime?> createdAt = OrderByField<DateTime?>(
    field: path.append('createdAt'),
    context: $context,
  );

  /// Access nested rev for ordering
  late final OrderByField<int> rev = OrderByField<int>(
    field: path.append('rev'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `Scene`
class SceneAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  SceneAggregateFieldSelector({required super.context, super.field});

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

/// Generated AggregateFieldSelector for `Scene`
class SceneAggregateBuilderRoot extends SceneAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  SceneAggregateBuilderRoot({required super.context, super.field});
}
