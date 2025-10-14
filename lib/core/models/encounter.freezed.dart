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
mixin _$EncounterDoc {

@DocumentIdField() String get id; String get name; bool get preset; String? get notes; String? get loot; List<Combatant> get combatants;@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get updatedAt; int get rev;
/// Create a copy of EncounterDoc
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EncounterDocCopyWith<EncounterDoc> get copyWith => _$EncounterDocCopyWithImpl<EncounterDoc>(this as EncounterDoc, _$identity);

  /// Serializes this EncounterDoc to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EncounterDoc&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.preset, preset) || other.preset == preset)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.loot, loot) || other.loot == loot)&&const DeepCollectionEquality().equals(other.combatants, combatants)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,preset,notes,loot,const DeepCollectionEquality().hash(combatants),createdAt,updatedAt,rev);

@override
String toString() {
  return 'EncounterDoc(id: $id, name: $name, preset: $preset, notes: $notes, loot: $loot, combatants: $combatants, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class $EncounterDocCopyWith<$Res>  {
  factory $EncounterDocCopyWith(EncounterDoc value, $Res Function(EncounterDoc) _then) = _$EncounterDocCopyWithImpl;
@useResult
$Res call({
@DocumentIdField() String id, String name, bool preset, String? notes, String? loot, List<Combatant> combatants,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt, int rev
});




}
/// @nodoc
class _$EncounterDocCopyWithImpl<$Res>
    implements $EncounterDocCopyWith<$Res> {
  _$EncounterDocCopyWithImpl(this._self, this._then);

  final EncounterDoc _self;
  final $Res Function(EncounterDoc) _then;

/// Create a copy of EncounterDoc
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? preset = null,Object? notes = freezed,Object? loot = freezed,Object? combatants = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,preset: null == preset ? _self.preset : preset // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,loot: freezed == loot ? _self.loot : loot // ignore: cast_nullable_to_non_nullable
as String?,combatants: null == combatants ? _self.combatants : combatants // ignore: cast_nullable_to_non_nullable
as List<Combatant>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EncounterDoc].
extension EncounterDocPatterns on EncounterDoc {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EncounterDoc value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EncounterDoc() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EncounterDoc value)  $default,){
final _that = this;
switch (_that) {
case _EncounterDoc():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EncounterDoc value)?  $default,){
final _that = this;
switch (_that) {
case _EncounterDoc() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String name,  bool preset,  String? notes,  String? loot,  List<Combatant> combatants, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  int rev)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EncounterDoc() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String name,  bool preset,  String? notes,  String? loot,  List<Combatant> combatants, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  int rev)  $default,) {final _that = this;
switch (_that) {
case _EncounterDoc():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DocumentIdField()  String id,  String name,  bool preset,  String? notes,  String? loot,  List<Combatant> combatants, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  int rev)?  $default,) {final _that = this;
switch (_that) {
case _EncounterDoc() when $default != null:
return $default(_that.id,_that.name,_that.preset,_that.notes,_that.loot,_that.combatants,_that.createdAt,_that.updatedAt,_that.rev);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _EncounterDoc implements EncounterDoc {
  const _EncounterDoc({@DocumentIdField() required this.id, required this.name, this.preset = false, this.notes, this.loot, final  List<Combatant> combatants = const <Combatant>[], @TimestampConverter() this.createdAt, @TimestampConverter() this.updatedAt, this.rev = 0}): _combatants = combatants;
  factory _EncounterDoc.fromJson(Map<String, dynamic> json) => _$EncounterDocFromJson(json);

@override@DocumentIdField() final  String id;
@override final  String name;
@override@JsonKey() final  bool preset;
@override final  String? notes;
@override final  String? loot;
 final  List<Combatant> _combatants;
@override@JsonKey() List<Combatant> get combatants {
  if (_combatants is EqualUnmodifiableListView) return _combatants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_combatants);
}

@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? updatedAt;
@override@JsonKey() final  int rev;

/// Create a copy of EncounterDoc
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EncounterDocCopyWith<_EncounterDoc> get copyWith => __$EncounterDocCopyWithImpl<_EncounterDoc>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EncounterDocToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EncounterDoc&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.preset, preset) || other.preset == preset)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.loot, loot) || other.loot == loot)&&const DeepCollectionEquality().equals(other._combatants, _combatants)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,preset,notes,loot,const DeepCollectionEquality().hash(_combatants),createdAt,updatedAt,rev);

@override
String toString() {
  return 'EncounterDoc(id: $id, name: $name, preset: $preset, notes: $notes, loot: $loot, combatants: $combatants, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class _$EncounterDocCopyWith<$Res> implements $EncounterDocCopyWith<$Res> {
  factory _$EncounterDocCopyWith(_EncounterDoc value, $Res Function(_EncounterDoc) _then) = __$EncounterDocCopyWithImpl;
@override @useResult
$Res call({
@DocumentIdField() String id, String name, bool preset, String? notes, String? loot, List<Combatant> combatants,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt, int rev
});




}
/// @nodoc
class __$EncounterDocCopyWithImpl<$Res>
    implements _$EncounterDocCopyWith<$Res> {
  __$EncounterDocCopyWithImpl(this._self, this._then);

  final _EncounterDoc _self;
  final $Res Function(_EncounterDoc) _then;

/// Create a copy of EncounterDoc
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? preset = null,Object? notes = freezed,Object? loot = freezed,Object? combatants = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_EncounterDoc(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,preset: null == preset ? _self.preset : preset // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,loot: freezed == loot ? _self.loot : loot // ignore: cast_nullable_to_non_nullable
as String?,combatants: null == combatants ? _self._combatants : combatants // ignore: cast_nullable_to_non_nullable
as List<Combatant>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
