// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'encounter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Encounter {

@DocumentIdField() String get id; String get name; bool get preset; String? get notes; String? get loot; List<Map<String, dynamic>>? get combatants; DateTime? get createdAt; DateTime? get updatedAt; int get rev;
/// Create a copy of Encounter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EncounterCopyWith<Encounter> get copyWith => _$EncounterCopyWithImpl<Encounter>(this as Encounter, _$identity);

  /// Serializes this Encounter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Encounter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.preset, preset) || other.preset == preset)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.loot, loot) || other.loot == loot)&&const DeepCollectionEquality().equals(other.combatants, combatants)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,preset,notes,loot,const DeepCollectionEquality().hash(combatants),createdAt,updatedAt,rev);

@override
String toString() {
  return 'Encounter(id: $id, name: $name, preset: $preset, notes: $notes, loot: $loot, combatants: $combatants, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class $EncounterCopyWith<$Res>  {
  factory $EncounterCopyWith(Encounter value, $Res Function(Encounter) _then) = _$EncounterCopyWithImpl;
@useResult
$Res call({
@DocumentIdField() String id, String name, bool preset, String? notes, String? loot, List<Map<String, dynamic>>? combatants, DateTime? createdAt, DateTime? updatedAt, int rev
});




}
/// @nodoc
class _$EncounterCopyWithImpl<$Res>
    implements $EncounterCopyWith<$Res> {
  _$EncounterCopyWithImpl(this._self, this._then);

  final Encounter _self;
  final $Res Function(Encounter) _then;

/// Create a copy of Encounter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? preset = null,Object? notes = freezed,Object? loot = freezed,Object? combatants = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,preset: null == preset ? _self.preset : preset // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,loot: freezed == loot ? _self.loot : loot // ignore: cast_nullable_to_non_nullable
as String?,combatants: freezed == combatants ? _self.combatants : combatants // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Encounter].
extension EncounterPatterns on Encounter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Encounter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Encounter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Encounter value)  $default,){
final _that = this;
switch (_that) {
case _Encounter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Encounter value)?  $default,){
final _that = this;
switch (_that) {
case _Encounter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String name,  bool preset,  String? notes,  String? loot,  List<Map<String, dynamic>>? combatants,  DateTime? createdAt,  DateTime? updatedAt,  int rev)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Encounter() when $default != null:
return $default(_that.id,_that.name,_that.preset,_that.notes,_that.loot,_that.combatants,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String name,  bool preset,  String? notes,  String? loot,  List<Map<String, dynamic>>? combatants,  DateTime? createdAt,  DateTime? updatedAt,  int rev)  $default,) {final _that = this;
switch (_that) {
case _Encounter():
return $default(_that.id,_that.name,_that.preset,_that.notes,_that.loot,_that.combatants,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DocumentIdField()  String id,  String name,  bool preset,  String? notes,  String? loot,  List<Map<String, dynamic>>? combatants,  DateTime? createdAt,  DateTime? updatedAt,  int rev)?  $default,) {final _that = this;
switch (_that) {
case _Encounter() when $default != null:
return $default(_that.id,_that.name,_that.preset,_that.notes,_that.loot,_that.combatants,_that.createdAt,_that.updatedAt,_that.rev);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Encounter implements Encounter {
  const _Encounter({@DocumentIdField() required this.id, required this.name, this.preset = false, this.notes, this.loot, final  List<Map<String, dynamic>>? combatants, this.createdAt, this.updatedAt, this.rev = 0}): _combatants = combatants;
  factory _Encounter.fromJson(Map<String, dynamic> json) => _$EncounterFromJson(json);

@override@DocumentIdField() final  String id;
@override final  String name;
@override@JsonKey() final  bool preset;
@override final  String? notes;
@override final  String? loot;
 final  List<Map<String, dynamic>>? _combatants;
@override List<Map<String, dynamic>>? get combatants {
  final value = _combatants;
  if (value == null) return null;
  if (_combatants is EqualUnmodifiableListView) return _combatants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  int rev;

/// Create a copy of Encounter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EncounterCopyWith<_Encounter> get copyWith => __$EncounterCopyWithImpl<_Encounter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EncounterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Encounter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.preset, preset) || other.preset == preset)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.loot, loot) || other.loot == loot)&&const DeepCollectionEquality().equals(other._combatants, _combatants)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,preset,notes,loot,const DeepCollectionEquality().hash(_combatants),createdAt,updatedAt,rev);

@override
String toString() {
  return 'Encounter(id: $id, name: $name, preset: $preset, notes: $notes, loot: $loot, combatants: $combatants, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class _$EncounterCopyWith<$Res> implements $EncounterCopyWith<$Res> {
  factory _$EncounterCopyWith(_Encounter value, $Res Function(_Encounter) _then) = __$EncounterCopyWithImpl;
@override @useResult
$Res call({
@DocumentIdField() String id, String name, bool preset, String? notes, String? loot, List<Map<String, dynamic>>? combatants, DateTime? createdAt, DateTime? updatedAt, int rev
});




}
/// @nodoc
class __$EncounterCopyWithImpl<$Res>
    implements _$EncounterCopyWith<$Res> {
  __$EncounterCopyWithImpl(this._self, this._then);

  final _Encounter _self;
  final $Res Function(_Encounter) _then;

/// Create a copy of Encounter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? preset = null,Object? notes = freezed,Object? loot = freezed,Object? combatants = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_Encounter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,preset: null == preset ? _self.preset : preset // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,loot: freezed == loot ? _self.loot : loot // ignore: cast_nullable_to_non_nullable
as String?,combatants: freezed == combatants ? _self._combatants : combatants // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
