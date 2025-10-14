// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model_support.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RichTextDoc {

 String get type; List<dynamic> get nodes;
/// Create a copy of RichTextDoc
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RichTextDocCopyWith<RichTextDoc> get copyWith => _$RichTextDocCopyWithImpl<RichTextDoc>(this as RichTextDoc, _$identity);

  /// Serializes this RichTextDoc to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RichTextDoc&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.nodes, nodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(nodes));

@override
String toString() {
  return 'RichTextDoc(type: $type, nodes: $nodes)';
}


}

/// @nodoc
abstract mixin class $RichTextDocCopyWith<$Res>  {
  factory $RichTextDocCopyWith(RichTextDoc value, $Res Function(RichTextDoc) _then) = _$RichTextDocCopyWithImpl;
@useResult
$Res call({
 String type, List<dynamic> nodes
});




}
/// @nodoc
class _$RichTextDocCopyWithImpl<$Res>
    implements $RichTextDocCopyWith<$Res> {
  _$RichTextDocCopyWithImpl(this._self, this._then);

  final RichTextDoc _self;
  final $Res Function(RichTextDoc) _then;

/// Create a copy of RichTextDoc
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? nodes = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,nodes: null == nodes ? _self.nodes : nodes // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [RichTextDoc].
extension RichTextDocPatterns on RichTextDoc {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RichTextDoc value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RichTextDoc() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RichTextDoc value)  $default,){
final _that = this;
switch (_that) {
case _RichTextDoc():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RichTextDoc value)?  $default,){
final _that = this;
switch (_that) {
case _RichTextDoc() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  List<dynamic> nodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RichTextDoc() when $default != null:
return $default(_that.type,_that.nodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  List<dynamic> nodes)  $default,) {final _that = this;
switch (_that) {
case _RichTextDoc():
return $default(_that.type,_that.nodes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  List<dynamic> nodes)?  $default,) {final _that = this;
switch (_that) {
case _RichTextDoc() when $default != null:
return $default(_that.type,_that.nodes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RichTextDoc implements RichTextDoc {
  const _RichTextDoc({this.type = 'doc', final  List<dynamic> nodes = const <dynamic>[]}): _nodes = nodes;
  factory _RichTextDoc.fromJson(Map<String, dynamic> json) => _$RichTextDocFromJson(json);

@override@JsonKey() final  String type;
 final  List<dynamic> _nodes;
@override@JsonKey() List<dynamic> get nodes {
  if (_nodes is EqualUnmodifiableListView) return _nodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nodes);
}


/// Create a copy of RichTextDoc
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RichTextDocCopyWith<_RichTextDoc> get copyWith => __$RichTextDocCopyWithImpl<_RichTextDoc>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RichTextDocToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RichTextDoc&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._nodes, _nodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_nodes));

@override
String toString() {
  return 'RichTextDoc(type: $type, nodes: $nodes)';
}


}

/// @nodoc
abstract mixin class _$RichTextDocCopyWith<$Res> implements $RichTextDocCopyWith<$Res> {
  factory _$RichTextDocCopyWith(_RichTextDoc value, $Res Function(_RichTextDoc) _then) = __$RichTextDocCopyWithImpl;
@override @useResult
$Res call({
 String type, List<dynamic> nodes
});




}
/// @nodoc
class __$RichTextDocCopyWithImpl<$Res>
    implements _$RichTextDocCopyWith<$Res> {
  __$RichTextDocCopyWithImpl(this._self, this._then);

  final _RichTextDoc _self;
  final $Res Function(_RichTextDoc) _then;

/// Create a copy of RichTextDoc
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? nodes = null,}) {
  return _then(_RichTextDoc(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,nodes: null == nodes ? _self._nodes : nodes // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}


}


/// @nodoc
mixin _$Mention {

 String get kind; String get id;
/// Create a copy of Mention
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MentionCopyWith<Mention> get copyWith => _$MentionCopyWithImpl<Mention>(this as Mention, _$identity);

  /// Serializes this Mention to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Mention&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,id);

@override
String toString() {
  return 'Mention(kind: $kind, id: $id)';
}


}

/// @nodoc
abstract mixin class $MentionCopyWith<$Res>  {
  factory $MentionCopyWith(Mention value, $Res Function(Mention) _then) = _$MentionCopyWithImpl;
@useResult
$Res call({
 String kind, String id
});




}
/// @nodoc
class _$MentionCopyWithImpl<$Res>
    implements $MentionCopyWith<$Res> {
  _$MentionCopyWithImpl(this._self, this._then);

  final Mention _self;
  final $Res Function(Mention) _then;

/// Create a copy of Mention
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? id = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Mention].
extension MentionPatterns on Mention {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Mention value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Mention() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Mention value)  $default,){
final _that = this;
switch (_that) {
case _Mention():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Mention value)?  $default,){
final _that = this;
switch (_that) {
case _Mention() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String kind,  String id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Mention() when $default != null:
return $default(_that.kind,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String kind,  String id)  $default,) {final _that = this;
switch (_that) {
case _Mention():
return $default(_that.kind,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String kind,  String id)?  $default,) {final _that = this;
switch (_that) {
case _Mention() when $default != null:
return $default(_that.kind,_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Mention implements Mention {
  const _Mention({required this.kind, required this.id});
  factory _Mention.fromJson(Map<String, dynamic> json) => _$MentionFromJson(json);

@override final  String kind;
@override final  String id;

/// Create a copy of Mention
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MentionCopyWith<_Mention> get copyWith => __$MentionCopyWithImpl<_Mention>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MentionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Mention&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,id);

@override
String toString() {
  return 'Mention(kind: $kind, id: $id)';
}


}

/// @nodoc
abstract mixin class _$MentionCopyWith<$Res> implements $MentionCopyWith<$Res> {
  factory _$MentionCopyWith(_Mention value, $Res Function(_Mention) _then) = __$MentionCopyWithImpl;
@override @useResult
$Res call({
 String kind, String id
});




}
/// @nodoc
class __$MentionCopyWithImpl<$Res>
    implements _$MentionCopyWith<$Res> {
  __$MentionCopyWithImpl(this._self, this._then);

  final _Mention _self;
  final $Res Function(_Mention) _then;

/// Create a copy of Mention
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,}) {
  return _then(_Mention(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MediaRef {

 String get assetId; String? get variant;
/// Create a copy of MediaRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaRefCopyWith<MediaRef> get copyWith => _$MediaRefCopyWithImpl<MediaRef>(this as MediaRef, _$identity);

  /// Serializes this MediaRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaRef&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.variant, variant) || other.variant == variant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,variant);

@override
String toString() {
  return 'MediaRef(assetId: $assetId, variant: $variant)';
}


}

/// @nodoc
abstract mixin class $MediaRefCopyWith<$Res>  {
  factory $MediaRefCopyWith(MediaRef value, $Res Function(MediaRef) _then) = _$MediaRefCopyWithImpl;
@useResult
$Res call({
 String assetId, String? variant
});




}
/// @nodoc
class _$MediaRefCopyWithImpl<$Res>
    implements $MediaRefCopyWith<$Res> {
  _$MediaRefCopyWithImpl(this._self, this._then);

  final MediaRef _self;
  final $Res Function(MediaRef) _then;

/// Create a copy of MediaRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assetId = null,Object? variant = freezed,}) {
  return _then(_self.copyWith(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,variant: freezed == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaRef].
extension MediaRefPatterns on MediaRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaRef value)  $default,){
final _that = this;
switch (_that) {
case _MediaRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaRef value)?  $default,){
final _that = this;
switch (_that) {
case _MediaRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String assetId,  String? variant)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaRef() when $default != null:
return $default(_that.assetId,_that.variant);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String assetId,  String? variant)  $default,) {final _that = this;
switch (_that) {
case _MediaRef():
return $default(_that.assetId,_that.variant);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String assetId,  String? variant)?  $default,) {final _that = this;
switch (_that) {
case _MediaRef() when $default != null:
return $default(_that.assetId,_that.variant);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaRef implements MediaRef {
  const _MediaRef({required this.assetId, this.variant});
  factory _MediaRef.fromJson(Map<String, dynamic> json) => _$MediaRefFromJson(json);

@override final  String assetId;
@override final  String? variant;

/// Create a copy of MediaRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaRefCopyWith<_MediaRef> get copyWith => __$MediaRefCopyWithImpl<_MediaRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaRef&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.variant, variant) || other.variant == variant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,variant);

@override
String toString() {
  return 'MediaRef(assetId: $assetId, variant: $variant)';
}


}

/// @nodoc
abstract mixin class _$MediaRefCopyWith<$Res> implements $MediaRefCopyWith<$Res> {
  factory _$MediaRefCopyWith(_MediaRef value, $Res Function(_MediaRef) _then) = __$MediaRefCopyWithImpl;
@override @useResult
$Res call({
 String assetId, String? variant
});




}
/// @nodoc
class __$MediaRefCopyWithImpl<$Res>
    implements _$MediaRefCopyWith<$Res> {
  __$MediaRefCopyWithImpl(this._self, this._then);

  final _MediaRef _self;
  final $Res Function(_MediaRef) _then;

/// Create a copy of MediaRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetId = null,Object? variant = freezed,}) {
  return _then(_MediaRef(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,variant: freezed == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ImageRef {

 String get assetId; String? get kind;
/// Create a copy of ImageRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageRefCopyWith<ImageRef> get copyWith => _$ImageRefCopyWithImpl<ImageRef>(this as ImageRef, _$identity);

  /// Serializes this ImageRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageRef&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,kind);

@override
String toString() {
  return 'ImageRef(assetId: $assetId, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $ImageRefCopyWith<$Res>  {
  factory $ImageRefCopyWith(ImageRef value, $Res Function(ImageRef) _then) = _$ImageRefCopyWithImpl;
@useResult
$Res call({
 String assetId, String? kind
});




}
/// @nodoc
class _$ImageRefCopyWithImpl<$Res>
    implements $ImageRefCopyWith<$Res> {
  _$ImageRefCopyWithImpl(this._self, this._then);

  final ImageRef _self;
  final $Res Function(ImageRef) _then;

/// Create a copy of ImageRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assetId = null,Object? kind = freezed,}) {
  return _then(_self.copyWith(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ImageRef].
extension ImageRefPatterns on ImageRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImageRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImageRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImageRef value)  $default,){
final _that = this;
switch (_that) {
case _ImageRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImageRef value)?  $default,){
final _that = this;
switch (_that) {
case _ImageRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String assetId,  String? kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImageRef() when $default != null:
return $default(_that.assetId,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String assetId,  String? kind)  $default,) {final _that = this;
switch (_that) {
case _ImageRef():
return $default(_that.assetId,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String assetId,  String? kind)?  $default,) {final _that = this;
switch (_that) {
case _ImageRef() when $default != null:
return $default(_that.assetId,_that.kind);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImageRef implements ImageRef {
  const _ImageRef({required this.assetId, this.kind});
  factory _ImageRef.fromJson(Map<String, dynamic> json) => _$ImageRefFromJson(json);

@override final  String assetId;
@override final  String? kind;

/// Create a copy of ImageRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageRefCopyWith<_ImageRef> get copyWith => __$ImageRefCopyWithImpl<_ImageRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImageRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageRef&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,kind);

@override
String toString() {
  return 'ImageRef(assetId: $assetId, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$ImageRefCopyWith<$Res> implements $ImageRefCopyWith<$Res> {
  factory _$ImageRefCopyWith(_ImageRef value, $Res Function(_ImageRef) _then) = __$ImageRefCopyWithImpl;
@override @useResult
$Res call({
 String assetId, String? kind
});




}
/// @nodoc
class __$ImageRefCopyWithImpl<$Res>
    implements _$ImageRefCopyWith<$Res> {
  __$ImageRefCopyWithImpl(this._self, this._then);

  final _ImageRef _self;
  final $Res Function(_ImageRef) _then;

/// Create a copy of ImageRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetId = null,Object? kind = freezed,}) {
  return _then(_ImageRef(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Coords {

 double get lat; double get lng;
/// Create a copy of Coords
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoordsCopyWith<Coords> get copyWith => _$CoordsCopyWithImpl<Coords>(this as Coords, _$identity);

  /// Serializes this Coords to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Coords&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng);

@override
String toString() {
  return 'Coords(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class $CoordsCopyWith<$Res>  {
  factory $CoordsCopyWith(Coords value, $Res Function(Coords) _then) = _$CoordsCopyWithImpl;
@useResult
$Res call({
 double lat, double lng
});




}
/// @nodoc
class _$CoordsCopyWithImpl<$Res>
    implements $CoordsCopyWith<$Res> {
  _$CoordsCopyWithImpl(this._self, this._then);

  final Coords _self;
  final $Res Function(Coords) _then;

/// Create a copy of Coords
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Coords].
extension CoordsPatterns on Coords {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Coords value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Coords() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Coords value)  $default,){
final _that = this;
switch (_that) {
case _Coords():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Coords value)?  $default,){
final _that = this;
switch (_that) {
case _Coords() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Coords() when $default != null:
return $default(_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng)  $default,) {final _that = this;
switch (_that) {
case _Coords():
return $default(_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng)?  $default,) {final _that = this;
switch (_that) {
case _Coords() when $default != null:
return $default(_that.lat,_that.lng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Coords implements Coords {
  const _Coords({required this.lat, required this.lng});
  factory _Coords.fromJson(Map<String, dynamic> json) => _$CoordsFromJson(json);

@override final  double lat;
@override final  double lng;

/// Create a copy of Coords
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoordsCopyWith<_Coords> get copyWith => __$CoordsCopyWithImpl<_Coords>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoordsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Coords&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng);

@override
String toString() {
  return 'Coords(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class _$CoordsCopyWith<$Res> implements $CoordsCopyWith<$Res> {
  factory _$CoordsCopyWith(_Coords value, $Res Function(_Coords) _then) = __$CoordsCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng
});




}
/// @nodoc
class __$CoordsCopyWithImpl<$Res>
    implements _$CoordsCopyWith<$Res> {
  __$CoordsCopyWithImpl(this._self, this._then);

  final _Coords _self;
  final $Res Function(_Coords) _then;

/// Create a copy of Coords
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,}) {
  return _then(_Coords(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$Statblock {

 String? get source;// srd|custom
 String? get srdRef; Map<String, dynamic>? get data;
/// Create a copy of Statblock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatblockCopyWith<Statblock> get copyWith => _$StatblockCopyWithImpl<Statblock>(this as Statblock, _$identity);

  /// Serializes this Statblock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Statblock&&(identical(other.source, source) || other.source == source)&&(identical(other.srdRef, srdRef) || other.srdRef == srdRef)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,srdRef,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'Statblock(source: $source, srdRef: $srdRef, data: $data)';
}


}

/// @nodoc
abstract mixin class $StatblockCopyWith<$Res>  {
  factory $StatblockCopyWith(Statblock value, $Res Function(Statblock) _then) = _$StatblockCopyWithImpl;
@useResult
$Res call({
 String? source, String? srdRef, Map<String, dynamic>? data
});




}
/// @nodoc
class _$StatblockCopyWithImpl<$Res>
    implements $StatblockCopyWith<$Res> {
  _$StatblockCopyWithImpl(this._self, this._then);

  final Statblock _self;
  final $Res Function(Statblock) _then;

/// Create a copy of Statblock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = freezed,Object? srdRef = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,srdRef: freezed == srdRef ? _self.srdRef : srdRef // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Statblock].
extension StatblockPatterns on Statblock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Statblock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Statblock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Statblock value)  $default,){
final _that = this;
switch (_that) {
case _Statblock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Statblock value)?  $default,){
final _that = this;
switch (_that) {
case _Statblock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? source,  String? srdRef,  Map<String, dynamic>? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Statblock() when $default != null:
return $default(_that.source,_that.srdRef,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? source,  String? srdRef,  Map<String, dynamic>? data)  $default,) {final _that = this;
switch (_that) {
case _Statblock():
return $default(_that.source,_that.srdRef,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? source,  String? srdRef,  Map<String, dynamic>? data)?  $default,) {final _that = this;
switch (_that) {
case _Statblock() when $default != null:
return $default(_that.source,_that.srdRef,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Statblock implements Statblock {
  const _Statblock({this.source, this.srdRef, final  Map<String, dynamic>? data}): _data = data;
  factory _Statblock.fromJson(Map<String, dynamic> json) => _$StatblockFromJson(json);

@override final  String? source;
// srd|custom
@override final  String? srdRef;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Statblock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatblockCopyWith<_Statblock> get copyWith => __$StatblockCopyWithImpl<_Statblock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatblockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Statblock&&(identical(other.source, source) || other.source == source)&&(identical(other.srdRef, srdRef) || other.srdRef == srdRef)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,srdRef,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'Statblock(source: $source, srdRef: $srdRef, data: $data)';
}


}

/// @nodoc
abstract mixin class _$StatblockCopyWith<$Res> implements $StatblockCopyWith<$Res> {
  factory _$StatblockCopyWith(_Statblock value, $Res Function(_Statblock) _then) = __$StatblockCopyWithImpl;
@override @useResult
$Res call({
 String? source, String? srdRef, Map<String, dynamic>? data
});




}
/// @nodoc
class __$StatblockCopyWithImpl<$Res>
    implements _$StatblockCopyWith<$Res> {
  __$StatblockCopyWithImpl(this._self, this._then);

  final _Statblock _self;
  final $Res Function(_Statblock) _then;

/// Create a copy of Statblock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = freezed,Object? srdRef = freezed,Object? data = freezed,}) {
  return _then(_Statblock(
source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,srdRef: freezed == srdRef ? _self.srdRef : srdRef // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$Hp {

 int get current; int get max;
/// Create a copy of Hp
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HpCopyWith<Hp> get copyWith => _$HpCopyWithImpl<Hp>(this as Hp, _$identity);

  /// Serializes this Hp to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hp&&(identical(other.current, current) || other.current == current)&&(identical(other.max, max) || other.max == max));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,current,max);

@override
String toString() {
  return 'Hp(current: $current, max: $max)';
}


}

/// @nodoc
abstract mixin class $HpCopyWith<$Res>  {
  factory $HpCopyWith(Hp value, $Res Function(Hp) _then) = _$HpCopyWithImpl;
@useResult
$Res call({
 int current, int max
});




}
/// @nodoc
class _$HpCopyWithImpl<$Res>
    implements $HpCopyWith<$Res> {
  _$HpCopyWithImpl(this._self, this._then);

  final Hp _self;
  final $Res Function(Hp) _then;

/// Create a copy of Hp
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? current = null,Object? max = null,}) {
  return _then(_self.copyWith(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Hp].
extension HpPatterns on Hp {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hp value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hp() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hp value)  $default,){
final _that = this;
switch (_that) {
case _Hp():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hp value)?  $default,){
final _that = this;
switch (_that) {
case _Hp() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int current,  int max)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hp() when $default != null:
return $default(_that.current,_that.max);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int current,  int max)  $default,) {final _that = this;
switch (_that) {
case _Hp():
return $default(_that.current,_that.max);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int current,  int max)?  $default,) {final _that = this;
switch (_that) {
case _Hp() when $default != null:
return $default(_that.current,_that.max);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Hp implements Hp {
  const _Hp({required this.current, required this.max});
  factory _Hp.fromJson(Map<String, dynamic> json) => _$HpFromJson(json);

@override final  int current;
@override final  int max;

/// Create a copy of Hp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HpCopyWith<_Hp> get copyWith => __$HpCopyWithImpl<_Hp>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HpToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hp&&(identical(other.current, current) || other.current == current)&&(identical(other.max, max) || other.max == max));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,current,max);

@override
String toString() {
  return 'Hp(current: $current, max: $max)';
}


}

/// @nodoc
abstract mixin class _$HpCopyWith<$Res> implements $HpCopyWith<$Res> {
  factory _$HpCopyWith(_Hp value, $Res Function(_Hp) _then) = __$HpCopyWithImpl;
@override @useResult
$Res call({
 int current, int max
});




}
/// @nodoc
class __$HpCopyWithImpl<$Res>
    implements _$HpCopyWith<$Res> {
  __$HpCopyWithImpl(this._self, this._then);

  final _Hp _self;
  final $Res Function(_Hp) _then;

/// Create a copy of Hp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? current = null,Object? max = null,}) {
  return _then(_Hp(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CombatantSource {

 String get type;// entity | statblock | adHoc
 String? get entityId; Map<String, dynamic>? get snapshot;
/// Create a copy of CombatantSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CombatantSourceCopyWith<CombatantSource> get copyWith => _$CombatantSourceCopyWithImpl<CombatantSource>(this as CombatantSource, _$identity);

  /// Serializes this CombatantSource to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CombatantSource&&(identical(other.type, type) || other.type == type)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&const DeepCollectionEquality().equals(other.snapshot, snapshot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,entityId,const DeepCollectionEquality().hash(snapshot));

@override
String toString() {
  return 'CombatantSource(type: $type, entityId: $entityId, snapshot: $snapshot)';
}


}

/// @nodoc
abstract mixin class $CombatantSourceCopyWith<$Res>  {
  factory $CombatantSourceCopyWith(CombatantSource value, $Res Function(CombatantSource) _then) = _$CombatantSourceCopyWithImpl;
@useResult
$Res call({
 String type, String? entityId, Map<String, dynamic>? snapshot
});




}
/// @nodoc
class _$CombatantSourceCopyWithImpl<$Res>
    implements $CombatantSourceCopyWith<$Res> {
  _$CombatantSourceCopyWithImpl(this._self, this._then);

  final CombatantSource _self;
  final $Res Function(CombatantSource) _then;

/// Create a copy of CombatantSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? entityId = freezed,Object? snapshot = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CombatantSource].
extension CombatantSourcePatterns on CombatantSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CombatantSource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CombatantSource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CombatantSource value)  $default,){
final _that = this;
switch (_that) {
case _CombatantSource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CombatantSource value)?  $default,){
final _that = this;
switch (_that) {
case _CombatantSource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String? entityId,  Map<String, dynamic>? snapshot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CombatantSource() when $default != null:
return $default(_that.type,_that.entityId,_that.snapshot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String? entityId,  Map<String, dynamic>? snapshot)  $default,) {final _that = this;
switch (_that) {
case _CombatantSource():
return $default(_that.type,_that.entityId,_that.snapshot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String? entityId,  Map<String, dynamic>? snapshot)?  $default,) {final _that = this;
switch (_that) {
case _CombatantSource() when $default != null:
return $default(_that.type,_that.entityId,_that.snapshot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CombatantSource implements CombatantSource {
  const _CombatantSource({required this.type, this.entityId, final  Map<String, dynamic>? snapshot}): _snapshot = snapshot;
  factory _CombatantSource.fromJson(Map<String, dynamic> json) => _$CombatantSourceFromJson(json);

@override final  String type;
// entity | statblock | adHoc
@override final  String? entityId;
 final  Map<String, dynamic>? _snapshot;
@override Map<String, dynamic>? get snapshot {
  final value = _snapshot;
  if (value == null) return null;
  if (_snapshot is EqualUnmodifiableMapView) return _snapshot;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of CombatantSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CombatantSourceCopyWith<_CombatantSource> get copyWith => __$CombatantSourceCopyWithImpl<_CombatantSource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CombatantSourceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CombatantSource&&(identical(other.type, type) || other.type == type)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&const DeepCollectionEquality().equals(other._snapshot, _snapshot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,entityId,const DeepCollectionEquality().hash(_snapshot));

@override
String toString() {
  return 'CombatantSource(type: $type, entityId: $entityId, snapshot: $snapshot)';
}


}

/// @nodoc
abstract mixin class _$CombatantSourceCopyWith<$Res> implements $CombatantSourceCopyWith<$Res> {
  factory _$CombatantSourceCopyWith(_CombatantSource value, $Res Function(_CombatantSource) _then) = __$CombatantSourceCopyWithImpl;
@override @useResult
$Res call({
 String type, String? entityId, Map<String, dynamic>? snapshot
});




}
/// @nodoc
class __$CombatantSourceCopyWithImpl<$Res>
    implements _$CombatantSourceCopyWith<$Res> {
  __$CombatantSourceCopyWithImpl(this._self, this._then);

  final _CombatantSource _self;
  final $Res Function(_CombatantSource) _then;

/// Create a copy of CombatantSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? entityId = freezed,Object? snapshot = freezed,}) {
  return _then(_CombatantSource(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,snapshot: freezed == snapshot ? _self._snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$Combatant {

 String get id; CombatantSource get source; Hp get hp; int? get ac; List<String> get conditions; String? get note; int? get initiative;
/// Create a copy of Combatant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CombatantCopyWith<Combatant> get copyWith => _$CombatantCopyWithImpl<Combatant>(this as Combatant, _$identity);

  /// Serializes this Combatant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Combatant&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.hp, hp) || other.hp == hp)&&(identical(other.ac, ac) || other.ac == ac)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&(identical(other.note, note) || other.note == note)&&(identical(other.initiative, initiative) || other.initiative == initiative));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,source,hp,ac,const DeepCollectionEquality().hash(conditions),note,initiative);

@override
String toString() {
  return 'Combatant(id: $id, source: $source, hp: $hp, ac: $ac, conditions: $conditions, note: $note, initiative: $initiative)';
}


}

/// @nodoc
abstract mixin class $CombatantCopyWith<$Res>  {
  factory $CombatantCopyWith(Combatant value, $Res Function(Combatant) _then) = _$CombatantCopyWithImpl;
@useResult
$Res call({
 String id, CombatantSource source, Hp hp, int? ac, List<String> conditions, String? note, int? initiative
});


$CombatantSourceCopyWith<$Res> get source;$HpCopyWith<$Res> get hp;

}
/// @nodoc
class _$CombatantCopyWithImpl<$Res>
    implements $CombatantCopyWith<$Res> {
  _$CombatantCopyWithImpl(this._self, this._then);

  final Combatant _self;
  final $Res Function(Combatant) _then;

/// Create a copy of Combatant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? source = null,Object? hp = null,Object? ac = freezed,Object? conditions = null,Object? note = freezed,Object? initiative = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as CombatantSource,hp: null == hp ? _self.hp : hp // ignore: cast_nullable_to_non_nullable
as Hp,ac: freezed == ac ? _self.ac : ac // ignore: cast_nullable_to_non_nullable
as int?,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<String>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,initiative: freezed == initiative ? _self.initiative : initiative // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of Combatant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CombatantSourceCopyWith<$Res> get source {
  
  return $CombatantSourceCopyWith<$Res>(_self.source, (value) {
    return _then(_self.copyWith(source: value));
  });
}/// Create a copy of Combatant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HpCopyWith<$Res> get hp {
  
  return $HpCopyWith<$Res>(_self.hp, (value) {
    return _then(_self.copyWith(hp: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  CombatantSource source,  Hp hp,  int? ac,  List<String> conditions,  String? note,  int? initiative)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Combatant() when $default != null:
return $default(_that.id,_that.source,_that.hp,_that.ac,_that.conditions,_that.note,_that.initiative);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  CombatantSource source,  Hp hp,  int? ac,  List<String> conditions,  String? note,  int? initiative)  $default,) {final _that = this;
switch (_that) {
case _Combatant():
return $default(_that.id,_that.source,_that.hp,_that.ac,_that.conditions,_that.note,_that.initiative);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  CombatantSource source,  Hp hp,  int? ac,  List<String> conditions,  String? note,  int? initiative)?  $default,) {final _that = this;
switch (_that) {
case _Combatant() when $default != null:
return $default(_that.id,_that.source,_that.hp,_that.ac,_that.conditions,_that.note,_that.initiative);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Combatant implements Combatant {
  const _Combatant({required this.id, required this.source, required this.hp, this.ac, final  List<String> conditions = const <String>[], this.note, this.initiative}): _conditions = conditions;
  factory _Combatant.fromJson(Map<String, dynamic> json) => _$CombatantFromJson(json);

@override final  String id;
@override final  CombatantSource source;
@override final  Hp hp;
@override final  int? ac;
 final  List<String> _conditions;
@override@JsonKey() List<String> get conditions {
  if (_conditions is EqualUnmodifiableListView) return _conditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conditions);
}

@override final  String? note;
@override final  int? initiative;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Combatant&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.hp, hp) || other.hp == hp)&&(identical(other.ac, ac) || other.ac == ac)&&const DeepCollectionEquality().equals(other._conditions, _conditions)&&(identical(other.note, note) || other.note == note)&&(identical(other.initiative, initiative) || other.initiative == initiative));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,source,hp,ac,const DeepCollectionEquality().hash(_conditions),note,initiative);

@override
String toString() {
  return 'Combatant(id: $id, source: $source, hp: $hp, ac: $ac, conditions: $conditions, note: $note, initiative: $initiative)';
}


}

/// @nodoc
abstract mixin class _$CombatantCopyWith<$Res> implements $CombatantCopyWith<$Res> {
  factory _$CombatantCopyWith(_Combatant value, $Res Function(_Combatant) _then) = __$CombatantCopyWithImpl;
@override @useResult
$Res call({
 String id, CombatantSource source, Hp hp, int? ac, List<String> conditions, String? note, int? initiative
});


@override $CombatantSourceCopyWith<$Res> get source;@override $HpCopyWith<$Res> get hp;

}
/// @nodoc
class __$CombatantCopyWithImpl<$Res>
    implements _$CombatantCopyWith<$Res> {
  __$CombatantCopyWithImpl(this._self, this._then);

  final _Combatant _self;
  final $Res Function(_Combatant) _then;

/// Create a copy of Combatant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? source = null,Object? hp = null,Object? ac = freezed,Object? conditions = null,Object? note = freezed,Object? initiative = freezed,}) {
  return _then(_Combatant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as CombatantSource,hp: null == hp ? _self.hp : hp // ignore: cast_nullable_to_non_nullable
as Hp,ac: freezed == ac ? _self.ac : ac // ignore: cast_nullable_to_non_nullable
as int?,conditions: null == conditions ? _self._conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<String>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,initiative: freezed == initiative ? _self.initiative : initiative // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of Combatant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CombatantSourceCopyWith<$Res> get source {
  
  return $CombatantSourceCopyWith<$Res>(_self.source, (value) {
    return _then(_self.copyWith(source: value));
  });
}/// Create a copy of Combatant
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HpCopyWith<$Res> get hp {
  
  return $HpCopyWith<$Res>(_self.hp, (value) {
    return _then(_self.copyWith(hp: value));
  });
}
}


/// @nodoc
mixin _$MediaVariant {

 String get kind; String get path; int? get width; int? get height; int? get bytes;
/// Create a copy of MediaVariant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaVariantCopyWith<MediaVariant> get copyWith => _$MediaVariantCopyWithImpl<MediaVariant>(this as MediaVariant, _$identity);

  /// Serializes this MediaVariant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaVariant&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.path, path) || other.path == path)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.bytes, bytes) || other.bytes == bytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,path,width,height,bytes);

@override
String toString() {
  return 'MediaVariant(kind: $kind, path: $path, width: $width, height: $height, bytes: $bytes)';
}


}

/// @nodoc
abstract mixin class $MediaVariantCopyWith<$Res>  {
  factory $MediaVariantCopyWith(MediaVariant value, $Res Function(MediaVariant) _then) = _$MediaVariantCopyWithImpl;
@useResult
$Res call({
 String kind, String path, int? width, int? height, int? bytes
});




}
/// @nodoc
class _$MediaVariantCopyWithImpl<$Res>
    implements $MediaVariantCopyWith<$Res> {
  _$MediaVariantCopyWithImpl(this._self, this._then);

  final MediaVariant _self;
  final $Res Function(MediaVariant) _then;

/// Create a copy of MediaVariant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? path = null,Object? width = freezed,Object? height = freezed,Object? bytes = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,bytes: freezed == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaVariant].
extension MediaVariantPatterns on MediaVariant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaVariant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaVariant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaVariant value)  $default,){
final _that = this;
switch (_that) {
case _MediaVariant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaVariant value)?  $default,){
final _that = this;
switch (_that) {
case _MediaVariant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String kind,  String path,  int? width,  int? height,  int? bytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaVariant() when $default != null:
return $default(_that.kind,_that.path,_that.width,_that.height,_that.bytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String kind,  String path,  int? width,  int? height,  int? bytes)  $default,) {final _that = this;
switch (_that) {
case _MediaVariant():
return $default(_that.kind,_that.path,_that.width,_that.height,_that.bytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String kind,  String path,  int? width,  int? height,  int? bytes)?  $default,) {final _that = this;
switch (_that) {
case _MediaVariant() when $default != null:
return $default(_that.kind,_that.path,_that.width,_that.height,_that.bytes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaVariant implements MediaVariant {
  const _MediaVariant({required this.kind, required this.path, this.width, this.height, this.bytes});
  factory _MediaVariant.fromJson(Map<String, dynamic> json) => _$MediaVariantFromJson(json);

@override final  String kind;
@override final  String path;
@override final  int? width;
@override final  int? height;
@override final  int? bytes;

/// Create a copy of MediaVariant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaVariantCopyWith<_MediaVariant> get copyWith => __$MediaVariantCopyWithImpl<_MediaVariant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaVariantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaVariant&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.path, path) || other.path == path)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.bytes, bytes) || other.bytes == bytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,path,width,height,bytes);

@override
String toString() {
  return 'MediaVariant(kind: $kind, path: $path, width: $width, height: $height, bytes: $bytes)';
}


}

/// @nodoc
abstract mixin class _$MediaVariantCopyWith<$Res> implements $MediaVariantCopyWith<$Res> {
  factory _$MediaVariantCopyWith(_MediaVariant value, $Res Function(_MediaVariant) _then) = __$MediaVariantCopyWithImpl;
@override @useResult
$Res call({
 String kind, String path, int? width, int? height, int? bytes
});




}
/// @nodoc
class __$MediaVariantCopyWithImpl<$Res>
    implements _$MediaVariantCopyWith<$Res> {
  __$MediaVariantCopyWithImpl(this._self, this._then);

  final _MediaVariant _self;
  final $Res Function(_MediaVariant) _then;

/// Create a copy of MediaVariant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? path = null,Object? width = freezed,Object? height = freezed,Object? bytes = freezed,}) {
  return _then(_MediaVariant(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,bytes: freezed == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
