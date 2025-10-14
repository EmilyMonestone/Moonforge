// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Player {

@DocumentIdField() String get id; String get name; String? get partyId; String? get playerClass; int get level; String? get species; String? get info;// quill delta json
 DateTime? get createdAt; DateTime? get updatedAt; int get rev;
/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerCopyWith<Player> get copyWith => _$PlayerCopyWithImpl<Player>(this as Player, _$identity);

  /// Serializes this Player to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Player&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.partyId, partyId) || other.partyId == partyId)&&(identical(other.playerClass, playerClass) || other.playerClass == playerClass)&&(identical(other.level, level) || other.level == level)&&(identical(other.species, species) || other.species == species)&&(identical(other.info, info) || other.info == info)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,partyId,playerClass,level,species,info,createdAt,updatedAt,rev);

@override
String toString() {
  return 'Player(id: $id, name: $name, partyId: $partyId, playerClass: $playerClass, level: $level, species: $species, info: $info, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class $PlayerCopyWith<$Res>  {
  factory $PlayerCopyWith(Player value, $Res Function(Player) _then) = _$PlayerCopyWithImpl;
@useResult
$Res call({
@DocumentIdField() String id, String name, String? partyId, String? playerClass, int level, String? species, String? info, DateTime? createdAt, DateTime? updatedAt, int rev
});




}
/// @nodoc
class _$PlayerCopyWithImpl<$Res>
    implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._self, this._then);

  final Player _self;
  final $Res Function(Player) _then;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? partyId = freezed,Object? playerClass = freezed,Object? level = null,Object? species = freezed,Object? info = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,partyId: freezed == partyId ? _self.partyId : partyId // ignore: cast_nullable_to_non_nullable
as String?,playerClass: freezed == playerClass ? _self.playerClass : playerClass // ignore: cast_nullable_to_non_nullable
as String?,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,species: freezed == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as String?,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Player].
extension PlayerPatterns on Player {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Player value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Player() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Player value)  $default,){
final _that = this;
switch (_that) {
case _Player():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Player value)?  $default,){
final _that = this;
switch (_that) {
case _Player() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String name,  String? partyId,  String? playerClass,  int level,  String? species,  String? info,  DateTime? createdAt,  DateTime? updatedAt,  int rev)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that.id,_that.name,_that.partyId,_that.playerClass,_that.level,_that.species,_that.info,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String name,  String? partyId,  String? playerClass,  int level,  String? species,  String? info,  DateTime? createdAt,  DateTime? updatedAt,  int rev)  $default,) {final _that = this;
switch (_that) {
case _Player():
return $default(_that.id,_that.name,_that.partyId,_that.playerClass,_that.level,_that.species,_that.info,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DocumentIdField()  String id,  String name,  String? partyId,  String? playerClass,  int level,  String? species,  String? info,  DateTime? createdAt,  DateTime? updatedAt,  int rev)?  $default,) {final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that.id,_that.name,_that.partyId,_that.playerClass,_that.level,_that.species,_that.info,_that.createdAt,_that.updatedAt,_that.rev);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Player implements Player {
  const _Player({@DocumentIdField() required this.id, required this.name, this.partyId, this.playerClass, this.level = 1, this.species, this.info, this.createdAt, this.updatedAt, this.rev = 0});
  factory _Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

@override@DocumentIdField() final  String id;
@override final  String name;
@override final  String? partyId;
@override final  String? playerClass;
@override@JsonKey() final  int level;
@override final  String? species;
@override final  String? info;
// quill delta json
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  int rev;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerCopyWith<_Player> get copyWith => __$PlayerCopyWithImpl<_Player>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Player&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.partyId, partyId) || other.partyId == partyId)&&(identical(other.playerClass, playerClass) || other.playerClass == playerClass)&&(identical(other.level, level) || other.level == level)&&(identical(other.species, species) || other.species == species)&&(identical(other.info, info) || other.info == info)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,partyId,playerClass,level,species,info,createdAt,updatedAt,rev);

@override
String toString() {
  return 'Player(id: $id, name: $name, partyId: $partyId, playerClass: $playerClass, level: $level, species: $species, info: $info, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class _$PlayerCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$PlayerCopyWith(_Player value, $Res Function(_Player) _then) = __$PlayerCopyWithImpl;
@override @useResult
$Res call({
@DocumentIdField() String id, String name, String? partyId, String? playerClass, int level, String? species, String? info, DateTime? createdAt, DateTime? updatedAt, int rev
});




}
/// @nodoc
class __$PlayerCopyWithImpl<$Res>
    implements _$PlayerCopyWith<$Res> {
  __$PlayerCopyWithImpl(this._self, this._then);

  final _Player _self;
  final $Res Function(_Player) _then;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? partyId = freezed,Object? playerClass = freezed,Object? level = null,Object? species = freezed,Object? info = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_Player(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,partyId: freezed == partyId ? _self.partyId : partyId // ignore: cast_nullable_to_non_nullable
as String?,playerClass: freezed == playerClass ? _self.playerClass : playerClass // ignore: cast_nullable_to_non_nullable
as String?,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,species: freezed == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as String?,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
