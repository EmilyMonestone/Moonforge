// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adventure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Adventure {

@DocumentIdField() String get id; String get name; int get order; String? get summary; String? get content;// quill delta json
 List<String> get entityIds;// Related entities
 DateTime? get createdAt; DateTime? get updatedAt; int get rev;
/// Create a copy of Adventure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdventureCopyWith<Adventure> get copyWith => _$AdventureCopyWithImpl<Adventure>(this as Adventure, _$identity);

  /// Serializes this Adventure to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Adventure&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.order, order) || other.order == order)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.entityIds, entityIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,order,summary,content,const DeepCollectionEquality().hash(entityIds),createdAt,updatedAt,rev);

@override
String toString() {
  return 'Adventure(id: $id, name: $name, order: $order, summary: $summary, content: $content, entityIds: $entityIds, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class $AdventureCopyWith<$Res>  {
  factory $AdventureCopyWith(Adventure value, $Res Function(Adventure) _then) = _$AdventureCopyWithImpl;
@useResult
$Res call({
@DocumentIdField() String id, String name, int order, String? summary, String? content, List<String> entityIds, DateTime? createdAt, DateTime? updatedAt, int rev
});




}
/// @nodoc
class _$AdventureCopyWithImpl<$Res>
    implements $AdventureCopyWith<$Res> {
  _$AdventureCopyWithImpl(this._self, this._then);

  final Adventure _self;
  final $Res Function(Adventure) _then;

/// Create a copy of Adventure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? order = null,Object? summary = freezed,Object? content = freezed,Object? entityIds = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,entityIds: null == entityIds ? _self.entityIds : entityIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Adventure].
extension AdventurePatterns on Adventure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Adventure value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Adventure() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Adventure value)  $default,){
final _that = this;
switch (_that) {
case _Adventure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Adventure value)?  $default,){
final _that = this;
switch (_that) {
case _Adventure() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String name,  int order,  String? summary,  String? content,  List<String> entityIds,  DateTime? createdAt,  DateTime? updatedAt,  int rev)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Adventure() when $default != null:
return $default(_that.id,_that.name,_that.order,_that.summary,_that.content,_that.entityIds,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String name,  int order,  String? summary,  String? content,  List<String> entityIds,  DateTime? createdAt,  DateTime? updatedAt,  int rev)  $default,) {final _that = this;
switch (_that) {
case _Adventure():
return $default(_that.id,_that.name,_that.order,_that.summary,_that.content,_that.entityIds,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DocumentIdField()  String id,  String name,  int order,  String? summary,  String? content,  List<String> entityIds,  DateTime? createdAt,  DateTime? updatedAt,  int rev)?  $default,) {final _that = this;
switch (_that) {
case _Adventure() when $default != null:
return $default(_that.id,_that.name,_that.order,_that.summary,_that.content,_that.entityIds,_that.createdAt,_that.updatedAt,_that.rev);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Adventure implements Adventure {
  const _Adventure({@DocumentIdField() required this.id, required this.name, this.order = 0, this.summary, this.content, final  List<String> entityIds = const [], this.createdAt, this.updatedAt, this.rev = 0}): _entityIds = entityIds;
  factory _Adventure.fromJson(Map<String, dynamic> json) => _$AdventureFromJson(json);

@override@DocumentIdField() final  String id;
@override final  String name;
@override@JsonKey() final  int order;
@override final  String? summary;
@override final  String? content;
// quill delta json
 final  List<String> _entityIds;
// quill delta json
@override@JsonKey() List<String> get entityIds {
  if (_entityIds is EqualUnmodifiableListView) return _entityIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entityIds);
}

// Related entities
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  int rev;

/// Create a copy of Adventure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdventureCopyWith<_Adventure> get copyWith => __$AdventureCopyWithImpl<_Adventure>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdventureToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Adventure&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.order, order) || other.order == order)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._entityIds, _entityIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,order,summary,content,const DeepCollectionEquality().hash(_entityIds),createdAt,updatedAt,rev);

@override
String toString() {
  return 'Adventure(id: $id, name: $name, order: $order, summary: $summary, content: $content, entityIds: $entityIds, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class _$AdventureCopyWith<$Res> implements $AdventureCopyWith<$Res> {
  factory _$AdventureCopyWith(_Adventure value, $Res Function(_Adventure) _then) = __$AdventureCopyWithImpl;
@override @useResult
$Res call({
@DocumentIdField() String id, String name, int order, String? summary, String? content, List<String> entityIds, DateTime? createdAt, DateTime? updatedAt, int rev
});




}
/// @nodoc
class __$AdventureCopyWithImpl<$Res>
    implements _$AdventureCopyWith<$Res> {
  __$AdventureCopyWithImpl(this._self, this._then);

  final _Adventure _self;
  final $Res Function(_Adventure) _then;

/// Create a copy of Adventure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? order = null,Object? summary = freezed,Object? content = freezed,Object? entityIds = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_Adventure(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,entityIds: null == entityIds ? _self._entityIds : entityIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
