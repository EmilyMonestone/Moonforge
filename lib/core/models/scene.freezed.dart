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
mixin _$SceneDoc {

@DocumentIdField() String get id; String get title; RichTextDoc? get content; List<Mention> get mentions; List<MediaRef> get mediaRefs;@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get updatedAt; int get rev;
/// Create a copy of SceneDoc
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SceneDocCopyWith<SceneDoc> get copyWith => _$SceneDocCopyWithImpl<SceneDoc>(this as SceneDoc, _$identity);

  /// Serializes this SceneDoc to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SceneDoc&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.mentions, mentions)&&const DeepCollectionEquality().equals(other.mediaRefs, mediaRefs)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,const DeepCollectionEquality().hash(mentions),const DeepCollectionEquality().hash(mediaRefs),createdAt,updatedAt,rev);

@override
String toString() {
  return 'SceneDoc(id: $id, title: $title, content: $content, mentions: $mentions, mediaRefs: $mediaRefs, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class $SceneDocCopyWith<$Res>  {
  factory $SceneDocCopyWith(SceneDoc value, $Res Function(SceneDoc) _then) = _$SceneDocCopyWithImpl;
@useResult
$Res call({
@DocumentIdField() String id, String title, RichTextDoc? content, List<Mention> mentions, List<MediaRef> mediaRefs,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt, int rev
});


$RichTextDocCopyWith<$Res>? get content;

}
/// @nodoc
class _$SceneDocCopyWithImpl<$Res>
    implements $SceneDocCopyWith<$Res> {
  _$SceneDocCopyWithImpl(this._self, this._then);

  final SceneDoc _self;
  final $Res Function(SceneDoc) _then;

/// Create a copy of SceneDoc
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = freezed,Object? mentions = null,Object? mediaRefs = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as RichTextDoc?,mentions: null == mentions ? _self.mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<Mention>,mediaRefs: null == mediaRefs ? _self.mediaRefs : mediaRefs // ignore: cast_nullable_to_non_nullable
as List<MediaRef>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of SceneDoc
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RichTextDocCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $RichTextDocCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [SceneDoc].
extension SceneDocPatterns on SceneDoc {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SceneDoc value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SceneDoc() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SceneDoc value)  $default,){
final _that = this;
switch (_that) {
case _SceneDoc():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SceneDoc value)?  $default,){
final _that = this;
switch (_that) {
case _SceneDoc() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String title,  RichTextDoc? content,  List<Mention> mentions,  List<MediaRef> mediaRefs, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  int rev)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SceneDoc() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.mentions,_that.mediaRefs,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String title,  RichTextDoc? content,  List<Mention> mentions,  List<MediaRef> mediaRefs, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  int rev)  $default,) {final _that = this;
switch (_that) {
case _SceneDoc():
return $default(_that.id,_that.title,_that.content,_that.mentions,_that.mediaRefs,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DocumentIdField()  String id,  String title,  RichTextDoc? content,  List<Mention> mentions,  List<MediaRef> mediaRefs, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  int rev)?  $default,) {final _that = this;
switch (_that) {
case _SceneDoc() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.mentions,_that.mediaRefs,_that.createdAt,_that.updatedAt,_that.rev);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SceneDoc implements SceneDoc {
  const _SceneDoc({@DocumentIdField() required this.id, required this.title, this.content, final  List<Mention> mentions = const <Mention>[], final  List<MediaRef> mediaRefs = const <MediaRef>[], @TimestampConverter() this.createdAt, @TimestampConverter() this.updatedAt, this.rev = 0}): _mentions = mentions,_mediaRefs = mediaRefs;
  factory _SceneDoc.fromJson(Map<String, dynamic> json) => _$SceneDocFromJson(json);

@override@DocumentIdField() final  String id;
@override final  String title;
@override final  RichTextDoc? content;
 final  List<Mention> _mentions;
@override@JsonKey() List<Mention> get mentions {
  if (_mentions is EqualUnmodifiableListView) return _mentions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mentions);
}

 final  List<MediaRef> _mediaRefs;
@override@JsonKey() List<MediaRef> get mediaRefs {
  if (_mediaRefs is EqualUnmodifiableListView) return _mediaRefs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaRefs);
}

@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? updatedAt;
@override@JsonKey() final  int rev;

/// Create a copy of SceneDoc
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SceneDocCopyWith<_SceneDoc> get copyWith => __$SceneDocCopyWithImpl<_SceneDoc>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SceneDocToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SceneDoc&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._mentions, _mentions)&&const DeepCollectionEquality().equals(other._mediaRefs, _mediaRefs)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,const DeepCollectionEquality().hash(_mentions),const DeepCollectionEquality().hash(_mediaRefs),createdAt,updatedAt,rev);

@override
String toString() {
  return 'SceneDoc(id: $id, title: $title, content: $content, mentions: $mentions, mediaRefs: $mediaRefs, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class _$SceneDocCopyWith<$Res> implements $SceneDocCopyWith<$Res> {
  factory _$SceneDocCopyWith(_SceneDoc value, $Res Function(_SceneDoc) _then) = __$SceneDocCopyWithImpl;
@override @useResult
$Res call({
@DocumentIdField() String id, String title, RichTextDoc? content, List<Mention> mentions, List<MediaRef> mediaRefs,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt, int rev
});


@override $RichTextDocCopyWith<$Res>? get content;

}
/// @nodoc
class __$SceneDocCopyWithImpl<$Res>
    implements _$SceneDocCopyWith<$Res> {
  __$SceneDocCopyWithImpl(this._self, this._then);

  final _SceneDoc _self;
  final $Res Function(_SceneDoc) _then;

/// Create a copy of SceneDoc
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = freezed,Object? mentions = null,Object? mediaRefs = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_SceneDoc(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as RichTextDoc?,mentions: null == mentions ? _self._mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<Mention>,mediaRefs: null == mediaRefs ? _self._mediaRefs : mediaRefs // ignore: cast_nullable_to_non_nullable
as List<MediaRef>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of SceneDoc
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RichTextDocCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $RichTextDocCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}

// dart format on
