// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'combatant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Combatant {

 String get id; String get name; CombatantType get type; bool get isAlly;// Combat stats
 int get currentHp; int get maxHp; int get armorClass;// Initiative
 int? get initiative; int get initiativeModifier;// Source information
 String? get entityId;// Reference to Entity (for campaign-specific monsters/NPCs)
 String? get bestiaryName;// Reference to bestiary entry
 String? get cr;// Challenge Rating (for monsters)
 int get xp;// XP value
// Conditions and notes
 List<String> get conditions; String? get notes;// Position in initiative order (managed by tracker)
 int get order;
/// Create a copy of Combatant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CombatantCopyWith<Combatant> get copyWith => _$CombatantCopyWithImpl<Combatant>(this as Combatant, _$identity);

  /// Serializes this Combatant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Combatant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isAlly, isAlly) || other.isAlly == isAlly)&&(identical(other.currentHp, currentHp) || other.currentHp == currentHp)&&(identical(other.maxHp, maxHp) || other.maxHp == maxHp)&&(identical(other.armorClass, armorClass) || other.armorClass == armorClass)&&(identical(other.initiative, initiative) || other.initiative == initiative)&&(identical(other.initiativeModifier, initiativeModifier) || other.initiativeModifier == initiativeModifier)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.bestiaryName, bestiaryName) || other.bestiaryName == bestiaryName)&&(identical(other.cr, cr) || other.cr == cr)&&(identical(other.xp, xp) || other.xp == xp)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,isAlly,currentHp,maxHp,armorClass,initiative,initiativeModifier,entityId,bestiaryName,cr,xp,const DeepCollectionEquality().hash(conditions),notes,order);

@override
String toString() {
  return 'Combatant(id: $id, name: $name, type: $type, isAlly: $isAlly, currentHp: $currentHp, maxHp: $maxHp, armorClass: $armorClass, initiative: $initiative, initiativeModifier: $initiativeModifier, entityId: $entityId, bestiaryName: $bestiaryName, cr: $cr, xp: $xp, conditions: $conditions, notes: $notes, order: $order)';
}


}

/// @nodoc
abstract mixin class $CombatantCopyWith<$Res>  {
  factory $CombatantCopyWith(Combatant value, $Res Function(Combatant) _then) = _$CombatantCopyWithImpl;
@useResult
$Res call({
 String id, String name, CombatantType type, bool isAlly, int currentHp, int maxHp, int armorClass, int? initiative, int initiativeModifier, String? entityId, String? bestiaryName, String? cr, int xp, List<String> conditions, String? notes, int order
});




}
/// @nodoc
class _$CombatantCopyWithImpl<$Res>
    implements $CombatantCopyWith<$Res> {
  _$CombatantCopyWithImpl(this._self, this._then);

  final Combatant _self;
  final $Res Function(Combatant) _then;

/// Create a copy of Combatant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? isAlly = null,Object? currentHp = null,Object? maxHp = null,Object? armorClass = null,Object? initiative = freezed,Object? initiativeModifier = null,Object? entityId = freezed,Object? bestiaryName = freezed,Object? cr = freezed,Object? xp = null,Object? conditions = null,Object? notes = freezed,Object? order = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CombatantType,isAlly: null == isAlly ? _self.isAlly : isAlly // ignore: cast_nullable_to_non_nullable
as bool,currentHp: null == currentHp ? _self.currentHp : currentHp // ignore: cast_nullable_to_non_nullable
as int,maxHp: null == maxHp ? _self.maxHp : maxHp // ignore: cast_nullable_to_non_nullable
as int,armorClass: null == armorClass ? _self.armorClass : armorClass // ignore: cast_nullable_to_non_nullable
as int,initiative: freezed == initiative ? _self.initiative : initiative // ignore: cast_nullable_to_non_nullable
as int?,initiativeModifier: null == initiativeModifier ? _self.initiativeModifier : initiativeModifier // ignore: cast_nullable_to_non_nullable
as int,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,bestiaryName: freezed == bestiaryName ? _self.bestiaryName : bestiaryName // ignore: cast_nullable_to_non_nullable
as String?,cr: freezed == cr ? _self.cr : cr // ignore: cast_nullable_to_non_nullable
as String?,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<String>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Combatant].
extension CombatantPatterns on Combatant {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Combatant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Combatant() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Combatant value)  $default,){
final _that = this;
switch (_that) {
case _Combatant():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Combatant value)?  $default,){
final _that = this;
switch (_that) {
case _Combatant() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  CombatantType type,  bool isAlly,  int currentHp,  int maxHp,  int armorClass,  int? initiative,  int initiativeModifier,  String? entityId,  String? bestiaryName,  String? cr,  int xp,  List<String> conditions,  String? notes,  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Combatant() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.isAlly,_that.currentHp,_that.maxHp,_that.armorClass,_that.initiative,_that.initiativeModifier,_that.entityId,_that.bestiaryName,_that.cr,_that.xp,_that.conditions,_that.notes,_that.order);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  CombatantType type,  bool isAlly,  int currentHp,  int maxHp,  int armorClass,  int? initiative,  int initiativeModifier,  String? entityId,  String? bestiaryName,  String? cr,  int xp,  List<String> conditions,  String? notes,  int order)  $default,) {final _that = this;
switch (_that) {
case _Combatant():
return $default(_that.id,_that.name,_that.type,_that.isAlly,_that.currentHp,_that.maxHp,_that.armorClass,_that.initiative,_that.initiativeModifier,_that.entityId,_that.bestiaryName,_that.cr,_that.xp,_that.conditions,_that.notes,_that.order);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  CombatantType type,  bool isAlly,  int currentHp,  int maxHp,  int armorClass,  int? initiative,  int initiativeModifier,  String? entityId,  String? bestiaryName,  String? cr,  int xp,  List<String> conditions,  String? notes,  int order)?  $default,) {final _that = this;
switch (_that) {
case _Combatant() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.isAlly,_that.currentHp,_that.maxHp,_that.armorClass,_that.initiative,_that.initiativeModifier,_that.entityId,_that.bestiaryName,_that.cr,_that.xp,_that.conditions,_that.notes,_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Combatant implements Combatant {
  const _Combatant({required this.id, required this.name, required this.type, this.isAlly = true, this.currentHp = 0, this.maxHp = 0, this.armorClass = 10, this.initiative, this.initiativeModifier = 0, this.entityId, this.bestiaryName, this.cr, this.xp = 0, final  List<String> conditions = const [], this.notes, this.order = 0}): _conditions = conditions;
  factory _Combatant.fromJson(Map<String, dynamic> json) => _$CombatantFromJson(json);

@override final  String id;
@override final  String name;
@override final  CombatantType type;
@override@JsonKey() final  bool isAlly;
// Combat stats
@override@JsonKey() final  int currentHp;
@override@JsonKey() final  int maxHp;
@override@JsonKey() final  int armorClass;
// Initiative
@override final  int? initiative;
@override@JsonKey() final  int initiativeModifier;
// Source information
@override final  String? entityId;
// Reference to Entity (for campaign-specific monsters/NPCs)
@override final  String? bestiaryName;
// Reference to bestiary entry
@override final  String? cr;
// Challenge Rating (for monsters)
@override@JsonKey() final  int xp;
// XP value
// Conditions and notes
 final  List<String> _conditions;
// XP value
// Conditions and notes
@override@JsonKey() List<String> get conditions {
  if (_conditions is EqualUnmodifiableListView) return _conditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conditions);
}

@override final  String? notes;
// Position in initiative order (managed by tracker)
@override@JsonKey() final  int order;

/// Create a copy of Combatant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CombatantCopyWith<_Combatant> get copyWith => __$CombatantCopyWithImpl<_Combatant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CombatantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Combatant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.isAlly, isAlly) || other.isAlly == isAlly)&&(identical(other.currentHp, currentHp) || other.currentHp == currentHp)&&(identical(other.maxHp, maxHp) || other.maxHp == maxHp)&&(identical(other.armorClass, armorClass) || other.armorClass == armorClass)&&(identical(other.initiative, initiative) || other.initiative == initiative)&&(identical(other.initiativeModifier, initiativeModifier) || other.initiativeModifier == initiativeModifier)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.bestiaryName, bestiaryName) || other.bestiaryName == bestiaryName)&&(identical(other.cr, cr) || other.cr == cr)&&(identical(other.xp, xp) || other.xp == xp)&&const DeepCollectionEquality().equals(other._conditions, _conditions)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,isAlly,currentHp,maxHp,armorClass,initiative,initiativeModifier,entityId,bestiaryName,cr,xp,const DeepCollectionEquality().hash(_conditions),notes,order);

@override
String toString() {
  return 'Combatant(id: $id, name: $name, type: $type, isAlly: $isAlly, currentHp: $currentHp, maxHp: $maxHp, armorClass: $armorClass, initiative: $initiative, initiativeModifier: $initiativeModifier, entityId: $entityId, bestiaryName: $bestiaryName, cr: $cr, xp: $xp, conditions: $conditions, notes: $notes, order: $order)';
}


}

/// @nodoc
abstract mixin class _$CombatantCopyWith<$Res> implements $CombatantCopyWith<$Res> {
  factory _$CombatantCopyWith(_Combatant value, $Res Function(_Combatant) _then) = __$CombatantCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, CombatantType type, bool isAlly, int currentHp, int maxHp, int armorClass, int? initiative, int initiativeModifier, String? entityId, String? bestiaryName, String? cr, int xp, List<String> conditions, String? notes, int order
});




}
/// @nodoc
class __$CombatantCopyWithImpl<$Res>
    implements _$CombatantCopyWith<$Res> {
  __$CombatantCopyWithImpl(this._self, this._then);

  final _Combatant _self;
  final $Res Function(_Combatant) _then;

/// Create a copy of Combatant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? isAlly = null,Object? currentHp = null,Object? maxHp = null,Object? armorClass = null,Object? initiative = freezed,Object? initiativeModifier = null,Object? entityId = freezed,Object? bestiaryName = freezed,Object? cr = freezed,Object? xp = null,Object? conditions = null,Object? notes = freezed,Object? order = null,}) {
  return _then(_Combatant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CombatantType,isAlly: null == isAlly ? _self.isAlly : isAlly // ignore: cast_nullable_to_non_nullable
as bool,currentHp: null == currentHp ? _self.currentHp : currentHp // ignore: cast_nullable_to_non_nullable
as int,maxHp: null == maxHp ? _self.maxHp : maxHp // ignore: cast_nullable_to_non_nullable
as int,armorClass: null == armorClass ? _self.armorClass : armorClass // ignore: cast_nullable_to_non_nullable
as int,initiative: freezed == initiative ? _self.initiative : initiative // ignore: cast_nullable_to_non_nullable
as int?,initiativeModifier: null == initiativeModifier ? _self.initiativeModifier : initiativeModifier // ignore: cast_nullable_to_non_nullable
as int,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,bestiaryName: freezed == bestiaryName ? _self.bestiaryName : bestiaryName // ignore: cast_nullable_to_non_nullable
as String?,cr: freezed == cr ? _self.cr : cr // ignore: cast_nullable_to_non_nullable
as String?,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,conditions: null == conditions ? _self._conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<String>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
