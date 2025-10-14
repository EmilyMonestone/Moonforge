// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_code.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JoinCode {

@DocumentIdField() String get id;// code
 String get cid; String get sid;@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get ttl;
/// Create a copy of JoinCode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JoinCodeCopyWith<JoinCode> get copyWith => _$JoinCodeCopyWithImpl<JoinCode>(this as JoinCode, _$identity);

  /// Serializes this JoinCode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JoinCode&&(identical(other.id, id) || other.id == id)&&(identical(other.cid, cid) || other.cid == cid)&&(identical(other.sid, sid) || other.sid == sid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.ttl, ttl) || other.ttl == ttl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cid,sid,createdAt,ttl);

@override
String toString() {
  return 'JoinCode(id: $id, cid: $cid, sid: $sid, createdAt: $createdAt, ttl: $ttl)';
}


}

/// @nodoc
abstract mixin class $JoinCodeCopyWith<$Res>  {
  factory $JoinCodeCopyWith(JoinCode value, $Res Function(JoinCode) _then) = _$JoinCodeCopyWithImpl;
@useResult
$Res call({
@DocumentIdField() String id, String cid, String sid,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? ttl
});




}
/// @nodoc
class _$JoinCodeCopyWithImpl<$Res>
    implements $JoinCodeCopyWith<$Res> {
  _$JoinCodeCopyWithImpl(this._self, this._then);

  final JoinCode _self;
  final $Res Function(JoinCode) _then;

/// Create a copy of JoinCode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? cid = null,Object? sid = null,Object? createdAt = freezed,Object? ttl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cid: null == cid ? _self.cid : cid // ignore: cast_nullable_to_non_nullable
as String,sid: null == sid ? _self.sid : sid // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,ttl: freezed == ttl ? _self.ttl : ttl // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [JoinCode].
extension JoinCodePatterns on JoinCode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JoinCode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JoinCode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JoinCode value)  $default,){
final _that = this;
switch (_that) {
case _JoinCode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JoinCode value)?  $default,){
final _that = this;
switch (_that) {
case _JoinCode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String cid,  String sid, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? ttl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JoinCode() when $default != null:
return $default(_that.id,_that.cid,_that.sid,_that.createdAt,_that.ttl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String cid,  String sid, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? ttl)  $default,) {final _that = this;
switch (_that) {
case _JoinCode():
return $default(_that.id,_that.cid,_that.sid,_that.createdAt,_that.ttl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DocumentIdField()  String id,  String cid,  String sid, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? ttl)?  $default,) {final _that = this;
switch (_that) {
case _JoinCode() when $default != null:
return $default(_that.id,_that.cid,_that.sid,_that.createdAt,_that.ttl);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _JoinCode implements JoinCode {
  const _JoinCode({@DocumentIdField() required this.id, required this.cid, required this.sid, @TimestampConverter() this.createdAt, @TimestampConverter() this.ttl});
  factory _JoinCode.fromJson(Map<String, dynamic> json) => _$JoinCodeFromJson(json);

@override@DocumentIdField() final  String id;
// code
@override final  String cid;
@override final  String sid;
@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? ttl;

/// Create a copy of JoinCode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JoinCodeCopyWith<_JoinCode> get copyWith => __$JoinCodeCopyWithImpl<_JoinCode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JoinCodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinCode&&(identical(other.id, id) || other.id == id)&&(identical(other.cid, cid) || other.cid == cid)&&(identical(other.sid, sid) || other.sid == sid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.ttl, ttl) || other.ttl == ttl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cid,sid,createdAt,ttl);

@override
String toString() {
  return 'JoinCode(id: $id, cid: $cid, sid: $sid, createdAt: $createdAt, ttl: $ttl)';
}


}

/// @nodoc
abstract mixin class _$JoinCodeCopyWith<$Res> implements $JoinCodeCopyWith<$Res> {
  factory _$JoinCodeCopyWith(_JoinCode value, $Res Function(_JoinCode) _then) = __$JoinCodeCopyWithImpl;
@override @useResult
$Res call({
@DocumentIdField() String id, String cid, String sid,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? ttl
});




}
/// @nodoc
class __$JoinCodeCopyWithImpl<$Res>
    implements _$JoinCodeCopyWith<$Res> {
  __$JoinCodeCopyWithImpl(this._self, this._then);

  final _JoinCode _self;
  final $Res Function(_JoinCode) _then;

/// Create a copy of JoinCode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? cid = null,Object? sid = null,Object? createdAt = freezed,Object? ttl = freezed,}) {
  return _then(_JoinCode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cid: null == cid ? _self.cid : cid // ignore: cast_nullable_to_non_nullable
as String,sid: null == sid ? _self.sid : sid // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,ttl: freezed == ttl ? _self.ttl : ttl // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
