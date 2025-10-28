// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaAsset _$MediaAssetFromJson(Map<String, dynamic> json) => _MediaAsset(
  id: json['id'] as String,
  filename: json['filename'] as String,
  size: (json['size'] as num).toInt(),
  mime: json['mime'] as String,
  captions: (json['captions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  alt: json['alt'] as String?,
  variants: (json['variants'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  rev: (json['rev'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MediaAssetToJson(_MediaAsset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'size': instance.size,
      'mime': instance.mime,
      'captions': instance.captions,
      'alt': instance.alt,
      'variants': instance.variants,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'rev': instance.rev,
    };

// **************************************************************************
// ModelBuilderGenerator
// **************************************************************************

/// Patch builder for `MediaAsset` model
class MediaAssetPatchBuilder<$$T extends MediaAsset?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `MediaAsset`
  MediaAssetPatchBuilder({required super.toJson, super.field});

  /// Update id field `String`
  late final PatchBuilder<String, String> id = PatchBuilder(
    field: path.append('id'),
    toJson: (value) => (value as String),
  );

  /// Update filename field `String`
  late final PatchBuilder<String, String> filename = PatchBuilder(
    field: path.append('filename'),
    toJson: (value) => (value as String),
  );

  /// Update size field `int`
  late final NumericFieldUpdate<int> size = NumericFieldUpdate(
    field: path.append('size'),
  );

  /// Update mime field `String`
  late final PatchBuilder<String, String> mime = PatchBuilder(
    field: path.append('mime'),
    toJson: (value) => (value as String),
  );

  /// Update captions field `List<String>?`
  late final ListFieldUpdate<List<String>?, String, String> captions =
      ListFieldUpdate(
        field: path.append('captions'),
        elementToJson: (value) => (value as String),
      );

  /// Update alt field `String?`
  late final PatchBuilder<String?, String?> alt = PatchBuilder(
    field: path.append('alt'),
    toJson: (value) => (value as String?),
  );

  /// Update variants field `List<Map<String, dynamic>>?`
  late final ListFieldUpdate<
    List<Map<String, dynamic>>?,
    Map<String, dynamic>,
    Map<String, dynamic>
  >
  variants = ListFieldUpdate(
    field: path.append('variants'),
    elementToJson: (value) => mapToJson(
      value,
      (value) => (value as String),
      (value) => (value as dynamic),
    ),
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

/// Generated FilterBuilder for `MediaAsset`
class MediaAssetFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `MediaAsset`
  MediaAssetFilterBuilder({super.field});

  /// Filter by id
  late final ComparableFilterField<String> id = ComparableFilterField<String>(
    field: FieldPath.documentId,
    toJson: (value) => (value as String),
  );

  /// Filter by filename
  late final ComparableFilterField<String> filename =
      ComparableFilterField<String>(
        field: path.append('filename'),
        toJson: (value) => (value as String),
      );

  /// Filter by size
  late final ComparableFilterField<int> size = ComparableFilterField<int>(
    field: path.append('size'),
    toJson: (value) => (value as int),
  );

  /// Filter by mime
  late final ComparableFilterField<String> mime = ComparableFilterField<String>(
    field: path.append('mime'),
    toJson: (value) => (value as String),
  );

  /// Filter by captions
  late final ArrayFilterField<List<String>?, String, String> captions =
      ArrayFilterField<List<String>?, String, String>(
        field: path.append('captions'),
        toJson: (value) => value == null
            ? null
            : listToJson(value!, (value) => (value as String)),
        elementToJson: (value) => (value as String),
      );

  /// Filter by alt
  late final ComparableFilterField<String?> alt =
      ComparableFilterField<String?>(
        field: path.append('alt'),
        toJson: (value) => (value as String?),
      );

  /// Filter by variants
  late final ArrayFilterField<
    List<Map<String, dynamic>>?,
    Map<String, dynamic>,
    Map<String, dynamic>
  >
  variants =
      ArrayFilterField<
        List<Map<String, dynamic>>?,
        Map<String, dynamic>,
        Map<String, dynamic>
      >(
        field: path.append('variants'),
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

/// Generated RootFilterBuilder for `MediaAsset`
class MediaAssetFilterBuilderRoot extends MediaAssetFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `MediaAsset`
  MediaAssetFilterBuilderRoot();
}

/// Generated OrderByBuilder for `MediaAsset`
class MediaAssetOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  MediaAssetOrderByBuilder({required super.context, super.field});

  /// Access nested id for ordering
  late final OrderByField<String> id = OrderByField<String>(
    field: FieldPath.documentId,
    context: $context,
  );

  /// Access nested filename for ordering
  late final OrderByField<String> filename = OrderByField<String>(
    field: path.append('filename'),
    context: $context,
  );

  /// Access nested size for ordering
  late final OrderByField<int> size = OrderByField<int>(
    field: path.append('size'),
    context: $context,
  );

  /// Access nested mime for ordering
  late final OrderByField<String> mime = OrderByField<String>(
    field: path.append('mime'),
    context: $context,
  );

  /// Access nested captions for ordering
  late final OrderByField<List<String>?> captions = OrderByField<List<String>?>(
    field: path.append('captions'),
    context: $context,
  );

  /// Access nested alt for ordering
  late final OrderByField<String?> alt = OrderByField<String?>(
    field: path.append('alt'),
    context: $context,
  );

  /// Access nested variants for ordering
  late final OrderByField<List<Map<String, dynamic>>?> variants =
      OrderByField<List<Map<String, dynamic>>?>(
        field: path.append('variants'),
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

/// Generated AggregateFieldSelector for `MediaAsset`
class MediaAssetAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  MediaAssetAggregateFieldSelector({required super.context, super.field});

  /// size field for aggregation
  late final AggregateField<int> size = AggregateField<int>(
    field: path.append('size'),
    context: $context,
  );

  /// rev field for aggregation
  late final AggregateField<int> rev = AggregateField<int>(
    field: path.append('rev'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `MediaAsset`
class MediaAssetAggregateBuilderRoot extends MediaAssetAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  MediaAssetAggregateBuilderRoot({required super.context, super.field});
}
