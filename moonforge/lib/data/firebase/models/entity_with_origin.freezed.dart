// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entity_with_origin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EntityWithOrigin {

 Entity get entity; EntityOrigin? get origin;
/// Create a copy of EntityWithOrigin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntityWithOriginCopyWith<EntityWithOrigin> get copyWith => _$EntityWithOriginCopyWithImpl<EntityWithOrigin>(this as EntityWithOrigin, _$identity);

  /// Serializes this EntityWithOrigin to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EntityWithOrigin&&(identical(other.entity, entity) || other.entity == entity)&&(identical(other.origin, origin) || other.origin == origin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entity,origin);

@override
String toString() {
  return 'EntityWithOrigin(entity: $entity, origin: $origin)';
}


}

/// @nodoc
abstract mixin class $EntityWithOriginCopyWith<$Res>  {
  factory $EntityWithOriginCopyWith(EntityWithOrigin value, $Res Function(EntityWithOrigin) _then) = _$EntityWithOriginCopyWithImpl;
@useResult
$Res call({
 Entity entity, EntityOrigin? origin
});


$EntityCopyWith<$Res> get entity;$EntityOriginCopyWith<$Res>? get origin;

}
/// @nodoc
class _$EntityWithOriginCopyWithImpl<$Res>
    implements $EntityWithOriginCopyWith<$Res> {
  _$EntityWithOriginCopyWithImpl(this._self, this._then);

  final EntityWithOrigin _self;
  final $Res Function(EntityWithOrigin) _then;

/// Create a copy of EntityWithOrigin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entity = null,Object? origin = freezed,}) {
  return _then(_self.copyWith(
entity: null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as Entity,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as EntityOrigin?,
  ));
}
/// Create a copy of EntityWithOrigin
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EntityCopyWith<$Res> get entity {
  
  return $EntityCopyWith<$Res>(_self.entity, (value) {
    return _then(_self.copyWith(entity: value));
  });
}/// Create a copy of EntityWithOrigin
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EntityOriginCopyWith<$Res>? get origin {
    if (_self.origin == null) {
    return null;
  }

  return $EntityOriginCopyWith<$Res>(_self.origin!, (value) {
    return _then(_self.copyWith(origin: value));
  });
}
}


/// Adds pattern-matching-related methods to [EntityWithOrigin].
extension EntityWithOriginPatterns on EntityWithOrigin {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EntityWithOrigin value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EntityWithOrigin() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EntityWithOrigin value)  $default,){
final _that = this;
switch (_that) {
case _EntityWithOrigin():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EntityWithOrigin value)?  $default,){
final _that = this;
switch (_that) {
case _EntityWithOrigin() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Entity entity,  EntityOrigin? origin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EntityWithOrigin() when $default != null:
return $default(_that.entity,_that.origin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Entity entity,  EntityOrigin? origin)  $default,) {final _that = this;
switch (_that) {
case _EntityWithOrigin():
return $default(_that.entity,_that.origin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Entity entity,  EntityOrigin? origin)?  $default,) {final _that = this;
switch (_that) {
case _EntityWithOrigin() when $default != null:
return $default(_that.entity,_that.origin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EntityWithOrigin implements EntityWithOrigin {
  const _EntityWithOrigin({required this.entity, this.origin});
  factory _EntityWithOrigin.fromJson(Map<String, dynamic> json) => _$EntityWithOriginFromJson(json);

@override final  Entity entity;
@override final  EntityOrigin? origin;

/// Create a copy of EntityWithOrigin
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntityWithOriginCopyWith<_EntityWithOrigin> get copyWith => __$EntityWithOriginCopyWithImpl<_EntityWithOrigin>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntityWithOriginToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EntityWithOrigin&&(identical(other.entity, entity) || other.entity == entity)&&(identical(other.origin, origin) || other.origin == origin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entity,origin);

@override
String toString() {
  return 'EntityWithOrigin(entity: $entity, origin: $origin)';
}


}

/// @nodoc
abstract mixin class _$EntityWithOriginCopyWith<$Res> implements $EntityWithOriginCopyWith<$Res> {
  factory _$EntityWithOriginCopyWith(_EntityWithOrigin value, $Res Function(_EntityWithOrigin) _then) = __$EntityWithOriginCopyWithImpl;
@override @useResult
$Res call({
 Entity entity, EntityOrigin? origin
});


@override $EntityCopyWith<$Res> get entity;@override $EntityOriginCopyWith<$Res>? get origin;

}
/// @nodoc
class __$EntityWithOriginCopyWithImpl<$Res>
    implements _$EntityWithOriginCopyWith<$Res> {
  __$EntityWithOriginCopyWithImpl(this._self, this._then);

  final _EntityWithOrigin _self;
  final $Res Function(_EntityWithOrigin) _then;

/// Create a copy of EntityWithOrigin
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entity = null,Object? origin = freezed,}) {
  return _then(_EntityWithOrigin(
entity: null == entity ? _self.entity : entity // ignore: cast_nullable_to_non_nullable
as Entity,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as EntityOrigin?,
  ));
}

/// Create a copy of EntityWithOrigin
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EntityCopyWith<$Res> get entity {
  
  return $EntityCopyWith<$Res>(_self.entity, (value) {
    return _then(_self.copyWith(entity: value));
  });
}/// Create a copy of EntityWithOrigin
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EntityOriginCopyWith<$Res>? get origin {
    if (_self.origin == null) {
    return null;
  }

  return $EntityOriginCopyWith<$Res>(_self.origin!, (value) {
    return _then(_self.copyWith(origin: value));
  });
}
}


/// @nodoc
mixin _$EntityOrigin {

 String get partType;// campaign, chapter, adventure, scene, encounter
 String get partId; String get label;// e.g., "Scene 1.3.2" or "Adventure 2.1"
 String get path;
/// Create a copy of EntityOrigin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntityOriginCopyWith<EntityOrigin> get copyWith => _$EntityOriginCopyWithImpl<EntityOrigin>(this as EntityOrigin, _$identity);

  /// Serializes this EntityOrigin to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EntityOrigin&&(identical(other.partType, partType) || other.partType == partType)&&(identical(other.partId, partId) || other.partId == partId)&&(identical(other.label, label) || other.label == label)&&(identical(other.path, path) || other.path == path));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,partType,partId,label,path);

@override
String toString() {
  return 'EntityOrigin(partType: $partType, partId: $partId, label: $label, path: $path)';
}


}

/// @nodoc
abstract mixin class $EntityOriginCopyWith<$Res>  {
  factory $EntityOriginCopyWith(EntityOrigin value, $Res Function(EntityOrigin) _then) = _$EntityOriginCopyWithImpl;
@useResult
$Res call({
 String partType, String partId, String label, String path
});




}
/// @nodoc
class _$EntityOriginCopyWithImpl<$Res>
    implements $EntityOriginCopyWith<$Res> {
  _$EntityOriginCopyWithImpl(this._self, this._then);

  final EntityOrigin _self;
  final $Res Function(EntityOrigin) _then;

/// Create a copy of EntityOrigin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? partType = null,Object? partId = null,Object? label = null,Object? path = null,}) {
  return _then(_self.copyWith(
partType: null == partType ? _self.partType : partType // ignore: cast_nullable_to_non_nullable
as String,partId: null == partId ? _self.partId : partId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EntityOrigin].
extension EntityOriginPatterns on EntityOrigin {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EntityOrigin value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EntityOrigin() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EntityOrigin value)  $default,){
final _that = this;
switch (_that) {
case _EntityOrigin():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EntityOrigin value)?  $default,){
final _that = this;
switch (_that) {
case _EntityOrigin() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String partType,  String partId,  String label,  String path)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EntityOrigin() when $default != null:
return $default(_that.partType,_that.partId,_that.label,_that.path);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String partType,  String partId,  String label,  String path)  $default,) {final _that = this;
switch (_that) {
case _EntityOrigin():
return $default(_that.partType,_that.partId,_that.label,_that.path);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String partType,  String partId,  String label,  String path)?  $default,) {final _that = this;
switch (_that) {
case _EntityOrigin() when $default != null:
return $default(_that.partType,_that.partId,_that.label,_that.path);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EntityOrigin implements EntityOrigin {
  const _EntityOrigin({required this.partType, required this.partId, required this.label, required this.path});
  factory _EntityOrigin.fromJson(Map<String, dynamic> json) => _$EntityOriginFromJson(json);

@override final  String partType;
// campaign, chapter, adventure, scene, encounter
@override final  String partId;
@override final  String label;
// e.g., "Scene 1.3.2" or "Adventure 2.1"
@override final  String path;

/// Create a copy of EntityOrigin
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntityOriginCopyWith<_EntityOrigin> get copyWith => __$EntityOriginCopyWithImpl<_EntityOrigin>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntityOriginToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EntityOrigin&&(identical(other.partType, partType) || other.partType == partType)&&(identical(other.partId, partId) || other.partId == partId)&&(identical(other.label, label) || other.label == label)&&(identical(other.path, path) || other.path == path));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,partType,partId,label,path);

@override
String toString() {
  return 'EntityOrigin(partType: $partType, partId: $partId, label: $label, path: $path)';
}


}

/// @nodoc
abstract mixin class _$EntityOriginCopyWith<$Res> implements $EntityOriginCopyWith<$Res> {
  factory _$EntityOriginCopyWith(_EntityOrigin value, $Res Function(_EntityOrigin) _then) = __$EntityOriginCopyWithImpl;
@override @useResult
$Res call({
 String partType, String partId, String label, String path
});




}
/// @nodoc
class __$EntityOriginCopyWithImpl<$Res>
    implements _$EntityOriginCopyWith<$Res> {
  __$EntityOriginCopyWithImpl(this._self, this._then);

  final _EntityOrigin _self;
  final $Res Function(_EntityOrigin) _then;

/// Create a copy of EntityOrigin
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? partType = null,Object? partId = null,Object? label = null,Object? path = null,}) {
  return _then(_EntityOrigin(
partType: null == partType ? _self.partType : partType // ignore: cast_nullable_to_non_nullable
as String,partId: null == partId ? _self.partId : partId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
