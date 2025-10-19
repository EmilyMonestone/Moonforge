// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Player _$PlayerFromJson(Map<String, dynamic> json) => _Player(
  id: json['id'] as String,
  name: json['name'] as String,
  partyId: json['partyId'] as String?,
  playerClass: json['class'] as String?,
  level: (json['level'] as num?)?.toInt() ?? 1,
  species: json['species'] as String?,
  info: json['info'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  rev: (json['rev'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PlayerToJson(_Player instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'partyId': instance.partyId,
  'class': instance.playerClass,
  'level': instance.level,
  'species': instance.species,
  'info': instance.info,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'rev': instance.rev,
};

// **************************************************************************
// ModelBuilderGenerator
// **************************************************************************

/// Patch builder for `Player` model
class PlayerPatchBuilder<$$T extends Player?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `Player`
  PlayerPatchBuilder({required super.toJson, super.field});

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

  /// Update partyId field `String?`
  late final PatchBuilder<String?, String?> partyId = PatchBuilder(
    field: path.append('partyId'),
    toJson: (value) => (value as String?),
  );

  /// Update playerClass field `String?`
  late final PatchBuilder<String?, String?> playerClass = PatchBuilder(
    field: path.append('class'),
    toJson: (value) => (value as String?),
  );

  /// Update level field `int`
  late final NumericFieldUpdate<int> level = NumericFieldUpdate(
    field: path.append('level'),
  );

  /// Update species field `String?`
  late final PatchBuilder<String?, String?> species = PatchBuilder(
    field: path.append('species'),
    toJson: (value) => (value as String?),
  );

  /// Update info field `String?`
  late final PatchBuilder<String?, String?> info = PatchBuilder(
    field: path.append('info'),
    toJson: (value) => (value as String?),
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

/// Generated FilterBuilder for `Player`
class PlayerFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `Player`
  PlayerFilterBuilder({super.field});

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

  /// Filter by partyId
  late final ComparableFilterField<String?> partyId =
      ComparableFilterField<String?>(
        field: path.append('partyId'),
        toJson: (value) => (value as String?),
      );

  /// Filter by playerClass
  late final ComparableFilterField<String?> playerClass =
      ComparableFilterField<String?>(
        field: path.append('class'),
        toJson: (value) => (value as String?),
      );

  /// Filter by level
  late final ComparableFilterField<int> level = ComparableFilterField<int>(
    field: path.append('level'),
    toJson: (value) => (value as int),
  );

  /// Filter by species
  late final ComparableFilterField<String?> species =
      ComparableFilterField<String?>(
        field: path.append('species'),
        toJson: (value) => (value as String?),
      );

  /// Filter by info
  late final ComparableFilterField<String?> info =
      ComparableFilterField<String?>(
        field: path.append('info'),
        toJson: (value) => (value as String?),
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

/// Generated RootFilterBuilder for `Player`
class PlayerFilterBuilderRoot extends PlayerFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `Player`
  PlayerFilterBuilderRoot();
}

/// Generated OrderByBuilder for `Player`
class PlayerOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  PlayerOrderByBuilder({required super.context, super.field});

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

  /// Access nested partyId for ordering
  late final OrderByField<String?> partyId = OrderByField<String?>(
    field: path.append('partyId'),
    context: $context,
  );

  /// Access nested playerClass for ordering
  late final OrderByField<String?> playerClass = OrderByField<String?>(
    field: path.append('class'),
    context: $context,
  );

  /// Access nested level for ordering
  late final OrderByField<int> level = OrderByField<int>(
    field: path.append('level'),
    context: $context,
  );

  /// Access nested species for ordering
  late final OrderByField<String?> species = OrderByField<String?>(
    field: path.append('species'),
    context: $context,
  );

  /// Access nested info for ordering
  late final OrderByField<String?> info = OrderByField<String?>(
    field: path.append('info'),
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

/// Generated AggregateFieldSelector for `Player`
class PlayerAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  PlayerAggregateFieldSelector({required super.context, super.field});

  /// level field for aggregation
  late final AggregateField<int> level = AggregateField<int>(
    field: path.append('level'),
    context: $context,
  );

  /// rev field for aggregation
  late final AggregateField<int> rev = AggregateField<int>(
    field: path.append('rev'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `Player`
class PlayerAggregateBuilderRoot extends PlayerAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  PlayerAggregateBuilderRoot({required super.context, super.field});
}
