// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scene.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Scene {

@DocumentIdField() String get id; String get title; int get order; String? get summary; String? get content;// quill delta json
 List<Map<String, dynamic>>? get mentions; List<Map<String, dynamic>>? get mediaRefs; DateTime? get updatedAt; DateTime? get createdAt; int get rev;
/// Create a copy of Scene
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SceneCopyWith<Scene> get copyWith => _$SceneCopyWithImpl<Scene>(this as Scene, _$identity);

  /// Serializes this Scene to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Scene&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.order, order) || other.order == order)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.mentions, mentions)&&const DeepCollectionEquality().equals(other.mediaRefs, mediaRefs)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,order,summary,content,const DeepCollectionEquality().hash(mentions),const DeepCollectionEquality().hash(mediaRefs),updatedAt,createdAt,rev);

@override
String toString() {
  return 'Scene(id: $id, title: $title, order: $order, summary: $summary, content: $content, mentions: $mentions, mediaRefs: $mediaRefs, updatedAt: $updatedAt, createdAt: $createdAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class $SceneCopyWith<$Res>  {
  factory $SceneCopyWith(Scene value, $Res Function(Scene) _then) = _$SceneCopyWithImpl;
@useResult
$Res call({
@DocumentIdField() String id, String title, int order, String? summary, String? content, List<Map<String, dynamic>>? mentions, List<Map<String, dynamic>>? mediaRefs, DateTime? updatedAt, DateTime? createdAt, int rev
});




}
/// @nodoc
class _$SceneCopyWithImpl<$Res>
    implements $SceneCopyWith<$Res> {
  _$SceneCopyWithImpl(this._self, this._then);

  final Scene _self;
  final $Res Function(Scene) _then;

/// Create a copy of Scene
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? order = null,Object? summary = freezed,Object? content = freezed,Object? mentions = freezed,Object? mediaRefs = freezed,Object? updatedAt = freezed,Object? createdAt = freezed,Object? rev = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,mentions: freezed == mentions ? _self.mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,mediaRefs: freezed == mediaRefs ? _self.mediaRefs : mediaRefs // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Scene].
extension ScenePatterns on Scene {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Scene value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Scene() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Scene value)  $default,){
final _that = this;
switch (_that) {
case _Scene():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Scene value)?  $default,){
final _that = this;
switch (_that) {
case _Scene() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String title,  int order,  String? summary,  String? content,  List<Map<String, dynamic>>? mentions,  List<Map<String, dynamic>>? mediaRefs,  DateTime? updatedAt,  DateTime? createdAt,  int rev)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Scene() when $default != null:
return $default(_that.id,_that.title,_that.order,_that.summary,_that.content,_that.mentions,_that.mediaRefs,_that.updatedAt,_that.createdAt,_that.rev);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String title,  int order,  String? summary,  String? content,  List<Map<String, dynamic>>? mentions,  List<Map<String, dynamic>>? mediaRefs,  DateTime? updatedAt,  DateTime? createdAt,  int rev)  $default,) {final _that = this;
switch (_that) {
case _Scene():
return $default(_that.id,_that.title,_that.order,_that.summary,_that.content,_that.mentions,_that.mediaRefs,_that.updatedAt,_that.createdAt,_that.rev);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DocumentIdField()  String id,  String title,  int order,  String? summary,  String? content,  List<Map<String, dynamic>>? mentions,  List<Map<String, dynamic>>? mediaRefs,  DateTime? updatedAt,  DateTime? createdAt,  int rev)?  $default,) {final _that = this;
switch (_that) {
case _Scene() when $default != null:
return $default(_that.id,_that.title,_that.order,_that.summary,_that.content,_that.mentions,_that.mediaRefs,_that.updatedAt,_that.createdAt,_that.rev);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Scene implements Scene {
  const _Scene({@DocumentIdField() required this.id, required this.title, this.order = 0, this.summary, this.content, final  List<Map<String, dynamic>>? mentions, final  List<Map<String, dynamic>>? mediaRefs, this.updatedAt, this.createdAt, this.rev = 0}): _mentions = mentions,_mediaRefs = mediaRefs;
  factory _Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);

@override@DocumentIdField() final  String id;
@override final  String title;
@override@JsonKey() final  int order;
@override final  String? summary;
@override final  String? content;
// quill delta json
 final  List<Map<String, dynamic>>? _mentions;
// quill delta json
@override List<Map<String, dynamic>>? get mentions {
  final value = _mentions;
  if (value == null) return null;
  if (_mentions is EqualUnmodifiableListView) return _mentions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Map<String, dynamic>>? _mediaRefs;
@override List<Map<String, dynamic>>? get mediaRefs {
  final value = _mediaRefs;
  if (value == null) return null;
  if (_mediaRefs is EqualUnmodifiableListView) return _mediaRefs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? updatedAt;
@override final  DateTime? createdAt;
@override@JsonKey() final  int rev;

/// Create a copy of Scene
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SceneCopyWith<_Scene> get copyWith => __$SceneCopyWithImpl<_Scene>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SceneToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Scene&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.order, order) || other.order == order)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._mentions, _mentions)&&const DeepCollectionEquality().equals(other._mediaRefs, _mediaRefs)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,order,summary,content,const DeepCollectionEquality().hash(_mentions),const DeepCollectionEquality().hash(_mediaRefs),updatedAt,createdAt,rev);

@override
String toString() {
  return 'Scene(id: $id, title: $title, order: $order, summary: $summary, content: $content, mentions: $mentions, mediaRefs: $mediaRefs, updatedAt: $updatedAt, createdAt: $createdAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class _$SceneCopyWith<$Res> implements $SceneCopyWith<$Res> {
  factory _$SceneCopyWith(_Scene value, $Res Function(_Scene) _then) = __$SceneCopyWithImpl;
@override @useResult
$Res call({
@DocumentIdField() String id, String title, int order, String? summary, String? content, List<Map<String, dynamic>>? mentions, List<Map<String, dynamic>>? mediaRefs, DateTime? updatedAt, DateTime? createdAt, int rev
});




}
/// @nodoc
class __$SceneCopyWithImpl<$Res>
    implements _$SceneCopyWith<$Res> {
  __$SceneCopyWithImpl(this._self, this._then);

  final _Scene _self;
  final $Res Function(_Scene) _then;

/// Create a copy of Scene
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? order = null,Object? summary = freezed,Object? content = freezed,Object? mentions = freezed,Object? mediaRefs = freezed,Object? updatedAt = freezed,Object? createdAt = freezed,Object? rev = null,}) {
  return _then(_Scene(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,mentions: freezed == mentions ? _self._mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,mediaRefs: freezed == mediaRefs ? _self._mediaRefs : mediaRefs // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
