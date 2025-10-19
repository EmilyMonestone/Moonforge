// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encounter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Encounter _$EncounterFromJson(Map<String, dynamic> json) => _Encounter(
  id: json['id'] as String,
  name: json['name'] as String,
  preset: json['preset'] as bool? ?? false,
  notes: json['notes'] as String?,
  loot: json['loot'] as String?,
  combatants: (json['combatants'] as List<dynamic>?)
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

Map<String, dynamic> _$EncounterToJson(_Encounter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'preset': instance.preset,
      'notes': instance.notes,
      'loot': instance.loot,
      'combatants': instance.combatants,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'rev': instance.rev,
    };

// **************************************************************************
// ModelBuilderGenerator
// **************************************************************************

/// Patch builder for `Encounter` model
class EncounterPatchBuilder<$$T extends Encounter?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `Encounter`
  EncounterPatchBuilder({required super.toJson, super.field});

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

  /// Update preset field `bool`
  late final PatchBuilder<bool, bool> preset = PatchBuilder(
    field: path.append('preset'),
    toJson: (value) => (value as bool),
  );

  /// Update notes field `String?`
  late final PatchBuilder<String?, String?> notes = PatchBuilder(
    field: path.append('notes'),
    toJson: (value) => (value as String?),
  );

  /// Update loot field `String?`
  late final PatchBuilder<String?, String?> loot = PatchBuilder(
    field: path.append('loot'),
    toJson: (value) => (value as String?),
  );

  /// Update combatants field `List<Map<String, dynamic>>?`
  late final ListFieldUpdate<
    List<Map<String, dynamic>>?,
    Map<String, dynamic>,
    Map<String, dynamic>
  >
  combatants = ListFieldUpdate(
    field: path.append('combatants'),
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

/// Generated FilterBuilder for `Encounter`
class EncounterFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `Encounter`
  EncounterFilterBuilder({super.field});

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

  /// Filter by preset
  late final FilterField<bool, bool> preset = FilterField<bool, bool>(
    field: path.append('preset'),
    toJson: (value) => (value as bool),
  );

  /// Filter by notes
  late final ComparableFilterField<String?> notes =
      ComparableFilterField<String?>(
        field: path.append('notes'),
        toJson: (value) => (value as String?),
      );

  /// Filter by loot
  late final ComparableFilterField<String?> loot =
      ComparableFilterField<String?>(
        field: path.append('loot'),
        toJson: (value) => (value as String?),
      );

  /// Filter by combatants
  late final ArrayFilterField<
    List<Map<String, dynamic>>?,
    Map<String, dynamic>,
    Map<String, dynamic>
  >
  combatants =
      ArrayFilterField<
        List<Map<String, dynamic>>?,
        Map<String, dynamic>,
        Map<String, dynamic>
      >(
        field: path.append('combatants'),
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

/// Generated RootFilterBuilder for `Encounter`
class EncounterFilterBuilderRoot extends EncounterFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `Encounter`
  EncounterFilterBuilderRoot();
}

/// Generated OrderByBuilder for `Encounter`
class EncounterOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  EncounterOrderByBuilder({required super.context, super.field});

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

  /// Access nested preset for ordering
  late final OrderByField<bool> preset = OrderByField<bool>(
    field: path.append('preset'),
    context: $context,
  );

  /// Access nested notes for ordering
  late final OrderByField<String?> notes = OrderByField<String?>(
    field: path.append('notes'),
    context: $context,
  );

  /// Access nested loot for ordering
  late final OrderByField<String?> loot = OrderByField<String?>(
    field: path.append('loot'),
    context: $context,
  );

  /// Access nested combatants for ordering
  late final OrderByField<List<Map<String, dynamic>>?> combatants =
      OrderByField<List<Map<String, dynamic>>?>(
        field: path.append('combatants'),
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

/// Generated AggregateFieldSelector for `Encounter`
class EncounterAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  EncounterAggregateFieldSelector({required super.context, super.field});

  /// rev field for aggregation
  late final AggregateField<int> rev = AggregateField<int>(
    field: path.append('rev'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `Encounter`
class EncounterAggregateBuilderRoot extends EncounterAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  EncounterAggregateBuilderRoot({required super.context, super.field});
}
