// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Session {

@DocumentIdField() String get id; DateTime? get createdAt; String? get info;// quill delta json (DM-only)
 DateTime? get datetime; String? get log;// quill delta json (shared with players)
 String? get shareToken;// token for public read-only access
 bool get shareEnabled;// whether sharing is enabled
 DateTime? get shareExpiresAt;// optional expiration for share link
 DateTime? get updatedAt; int get rev;
/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCopyWith<Session> get copyWith => _$SessionCopyWithImpl<Session>(this as Session, _$identity);

  /// Serializes this Session to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Session&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.info, info) || other.info == info)&&(identical(other.datetime, datetime) || other.datetime == datetime)&&(identical(other.log, log) || other.log == log)&&(identical(other.shareToken, shareToken) || other.shareToken == shareToken)&&(identical(other.shareEnabled, shareEnabled) || other.shareEnabled == shareEnabled)&&(identical(other.shareExpiresAt, shareExpiresAt) || other.shareExpiresAt == shareExpiresAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,info,datetime,log,shareToken,shareEnabled,shareExpiresAt,updatedAt,rev);

@override
String toString() {
  return 'Session(id: $id, createdAt: $createdAt, info: $info, datetime: $datetime, log: $log, shareToken: $shareToken, shareEnabled: $shareEnabled, shareExpiresAt: $shareExpiresAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class $SessionCopyWith<$Res>  {
  factory $SessionCopyWith(Session value, $Res Function(Session) _then) = _$SessionCopyWithImpl;
@useResult
$Res call({
@DocumentIdField() String id, DateTime? createdAt, String? info, DateTime? datetime, String? log, String? shareToken, bool shareEnabled, DateTime? shareExpiresAt, DateTime? updatedAt, int rev
});




}
/// @nodoc
class _$SessionCopyWithImpl<$Res>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._self, this._then);

  final Session _self;
  final $Res Function(Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = freezed,Object? info = freezed,Object? datetime = freezed,Object? log = freezed,Object? shareToken = freezed,Object? shareEnabled = null,Object? shareExpiresAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as String?,datetime: freezed == datetime ? _self.datetime : datetime // ignore: cast_nullable_to_non_nullable
as DateTime?,log: freezed == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String?,shareToken: freezed == shareToken ? _self.shareToken : shareToken // ignore: cast_nullable_to_non_nullable
as String?,shareEnabled: null == shareEnabled ? _self.shareEnabled : shareEnabled // ignore: cast_nullable_to_non_nullable
as bool,shareExpiresAt: freezed == shareExpiresAt ? _self.shareExpiresAt : shareExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Session].
extension SessionPatterns on Session {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Session value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Session() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Session value)  $default,){
final _that = this;
switch (_that) {
case _Session():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Session value)?  $default,){
final _that = this;
switch (_that) {
case _Session() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  DateTime? createdAt,  String? info,  DateTime? datetime,  String? log,  String? shareToken,  bool shareEnabled,  DateTime? shareExpiresAt,  DateTime? updatedAt,  int rev)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.id,_that.createdAt,_that.info,_that.datetime,_that.log,_that.shareToken,_that.shareEnabled,_that.shareExpiresAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  DateTime? createdAt,  String? info,  DateTime? datetime,  String? log,  String? shareToken,  bool shareEnabled,  DateTime? shareExpiresAt,  DateTime? updatedAt,  int rev)  $default,) {final _that = this;
switch (_that) {
case _Session():
return $default(_that.id,_that.createdAt,_that.info,_that.datetime,_that.log,_that.shareToken,_that.shareEnabled,_that.shareExpiresAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DocumentIdField()  String id,  DateTime? createdAt,  String? info,  DateTime? datetime,  String? log,  String? shareToken,  bool shareEnabled,  DateTime? shareExpiresAt,  DateTime? updatedAt,  int rev)?  $default,) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.id,_that.createdAt,_that.info,_that.datetime,_that.log,_that.shareToken,_that.shareEnabled,_that.shareExpiresAt,_that.updatedAt,_that.rev);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Session implements Session {
  const _Session({@DocumentIdField() required this.id, this.createdAt, this.info, this.datetime, this.log, this.shareToken, this.shareEnabled = false, this.shareExpiresAt, this.updatedAt, this.rev = 0});
  factory _Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

@override@DocumentIdField() final  String id;
@override final  DateTime? createdAt;
@override final  String? info;
// quill delta json (DM-only)
@override final  DateTime? datetime;
@override final  String? log;
// quill delta json (shared with players)
@override final  String? shareToken;
// token for public read-only access
@override@JsonKey() final  bool shareEnabled;
// whether sharing is enabled
@override final  DateTime? shareExpiresAt;
// optional expiration for share link
@override final  DateTime? updatedAt;
@override@JsonKey() final  int rev;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionCopyWith<_Session> get copyWith => __$SessionCopyWithImpl<_Session>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Session&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.info, info) || other.info == info)&&(identical(other.datetime, datetime) || other.datetime == datetime)&&(identical(other.log, log) || other.log == log)&&(identical(other.shareToken, shareToken) || other.shareToken == shareToken)&&(identical(other.shareEnabled, shareEnabled) || other.shareEnabled == shareEnabled)&&(identical(other.shareExpiresAt, shareExpiresAt) || other.shareExpiresAt == shareExpiresAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,info,datetime,log,shareToken,shareEnabled,shareExpiresAt,updatedAt,rev);

@override
String toString() {
  return 'Session(id: $id, createdAt: $createdAt, info: $info, datetime: $datetime, log: $log, shareToken: $shareToken, shareEnabled: $shareEnabled, shareExpiresAt: $shareExpiresAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class _$SessionCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$SessionCopyWith(_Session value, $Res Function(_Session) _then) = __$SessionCopyWithImpl;
@override @useResult
$Res call({
@DocumentIdField() String id, DateTime? createdAt, String? info, DateTime? datetime, String? log, String? shareToken, bool shareEnabled, DateTime? shareExpiresAt, DateTime? updatedAt, int rev
});




}
/// @nodoc
class __$SessionCopyWithImpl<$Res>
    implements _$SessionCopyWith<$Res> {
  __$SessionCopyWithImpl(this._self, this._then);

  final _Session _self;
  final $Res Function(_Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = freezed,Object? info = freezed,Object? datetime = freezed,Object? log = freezed,Object? shareToken = freezed,Object? shareEnabled = null,Object? shareExpiresAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_Session(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as String?,datetime: freezed == datetime ? _self.datetime : datetime // ignore: cast_nullable_to_non_nullable
as DateTime?,log: freezed == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as String?,shareToken: freezed == shareToken ? _self.shareToken : shareToken // ignore: cast_nullable_to_non_nullable
as String?,shareEnabled: null == shareEnabled ? _self.shareEnabled : shareEnabled // ignore: cast_nullable_to_non_nullable
as bool,shareExpiresAt: freezed == shareExpiresAt ? _self.shareExpiresAt : shareExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
