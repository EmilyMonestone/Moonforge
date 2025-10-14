// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaAsset {

@DocumentIdField() String get id; String get filename; int get size;// bytes
 String get mime; List<String>? get captions; String? get alt; List<Map<String, dynamic>>? get variants; DateTime? get createdAt; DateTime? get updatedAt; int get rev;
/// Create a copy of MediaAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaAssetCopyWith<MediaAsset> get copyWith => _$MediaAssetCopyWithImpl<MediaAsset>(this as MediaAsset, _$identity);

  /// Serializes this MediaAsset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaAsset&&(identical(other.id, id) || other.id == id)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.size, size) || other.size == size)&&(identical(other.mime, mime) || other.mime == mime)&&const DeepCollectionEquality().equals(other.captions, captions)&&(identical(other.alt, alt) || other.alt == alt)&&const DeepCollectionEquality().equals(other.variants, variants)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,filename,size,mime,const DeepCollectionEquality().hash(captions),alt,const DeepCollectionEquality().hash(variants),createdAt,updatedAt,rev);

@override
String toString() {
  return 'MediaAsset(id: $id, filename: $filename, size: $size, mime: $mime, captions: $captions, alt: $alt, variants: $variants, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class $MediaAssetCopyWith<$Res>  {
  factory $MediaAssetCopyWith(MediaAsset value, $Res Function(MediaAsset) _then) = _$MediaAssetCopyWithImpl;
@useResult
$Res call({
@DocumentIdField() String id, String filename, int size, String mime, List<String>? captions, String? alt, List<Map<String, dynamic>>? variants, DateTime? createdAt, DateTime? updatedAt, int rev
});




}
/// @nodoc
class _$MediaAssetCopyWithImpl<$Res>
    implements $MediaAssetCopyWith<$Res> {
  _$MediaAssetCopyWithImpl(this._self, this._then);

  final MediaAsset _self;
  final $Res Function(MediaAsset) _then;

/// Create a copy of MediaAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? filename = null,Object? size = null,Object? mime = null,Object? captions = freezed,Object? alt = freezed,Object? variants = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,mime: null == mime ? _self.mime : mime // ignore: cast_nullable_to_non_nullable
as String,captions: freezed == captions ? _self.captions : captions // ignore: cast_nullable_to_non_nullable
as List<String>?,alt: freezed == alt ? _self.alt : alt // ignore: cast_nullable_to_non_nullable
as String?,variants: freezed == variants ? _self.variants : variants // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaAsset].
extension MediaAssetPatterns on MediaAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaAsset value)  $default,){
final _that = this;
switch (_that) {
case _MediaAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaAsset value)?  $default,){
final _that = this;
switch (_that) {
case _MediaAsset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String filename,  int size,  String mime,  List<String>? captions,  String? alt,  List<Map<String, dynamic>>? variants,  DateTime? createdAt,  DateTime? updatedAt,  int rev)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaAsset() when $default != null:
return $default(_that.id,_that.filename,_that.size,_that.mime,_that.captions,_that.alt,_that.variants,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String filename,  int size,  String mime,  List<String>? captions,  String? alt,  List<Map<String, dynamic>>? variants,  DateTime? createdAt,  DateTime? updatedAt,  int rev)  $default,) {final _that = this;
switch (_that) {
case _MediaAsset():
return $default(_that.id,_that.filename,_that.size,_that.mime,_that.captions,_that.alt,_that.variants,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DocumentIdField()  String id,  String filename,  int size,  String mime,  List<String>? captions,  String? alt,  List<Map<String, dynamic>>? variants,  DateTime? createdAt,  DateTime? updatedAt,  int rev)?  $default,) {final _that = this;
switch (_that) {
case _MediaAsset() when $default != null:
return $default(_that.id,_that.filename,_that.size,_that.mime,_that.captions,_that.alt,_that.variants,_that.createdAt,_that.updatedAt,_that.rev);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaAsset implements MediaAsset {
  const _MediaAsset({@DocumentIdField() required this.id, required this.filename, required this.size, required this.mime, final  List<String>? captions, this.alt, final  List<Map<String, dynamic>>? variants, this.createdAt, this.updatedAt, this.rev = 0}): _captions = captions,_variants = variants;
  factory _MediaAsset.fromJson(Map<String, dynamic> json) => _$MediaAssetFromJson(json);

@override@DocumentIdField() final  String id;
@override final  String filename;
@override final  int size;
// bytes
@override final  String mime;
 final  List<String>? _captions;
@override List<String>? get captions {
  final value = _captions;
  if (value == null) return null;
  if (_captions is EqualUnmodifiableListView) return _captions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? alt;
 final  List<Map<String, dynamic>>? _variants;
@override List<Map<String, dynamic>>? get variants {
  final value = _variants;
  if (value == null) return null;
  if (_variants is EqualUnmodifiableListView) return _variants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  int rev;

/// Create a copy of MediaAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaAssetCopyWith<_MediaAsset> get copyWith => __$MediaAssetCopyWithImpl<_MediaAsset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaAssetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaAsset&&(identical(other.id, id) || other.id == id)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.size, size) || other.size == size)&&(identical(other.mime, mime) || other.mime == mime)&&const DeepCollectionEquality().equals(other._captions, _captions)&&(identical(other.alt, alt) || other.alt == alt)&&const DeepCollectionEquality().equals(other._variants, _variants)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,filename,size,mime,const DeepCollectionEquality().hash(_captions),alt,const DeepCollectionEquality().hash(_variants),createdAt,updatedAt,rev);

@override
String toString() {
  return 'MediaAsset(id: $id, filename: $filename, size: $size, mime: $mime, captions: $captions, alt: $alt, variants: $variants, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class _$MediaAssetCopyWith<$Res> implements $MediaAssetCopyWith<$Res> {
  factory _$MediaAssetCopyWith(_MediaAsset value, $Res Function(_MediaAsset) _then) = __$MediaAssetCopyWithImpl;
@override @useResult
$Res call({
@DocumentIdField() String id, String filename, int size, String mime, List<String>? captions, String? alt, List<Map<String, dynamic>>? variants, DateTime? createdAt, DateTime? updatedAt, int rev
});




}
/// @nodoc
class __$MediaAssetCopyWithImpl<$Res>
    implements _$MediaAssetCopyWith<$Res> {
  __$MediaAssetCopyWithImpl(this._self, this._then);

  final _MediaAsset _self;
  final $Res Function(_MediaAsset) _then;

/// Create a copy of MediaAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? filename = null,Object? size = null,Object? mime = null,Object? captions = freezed,Object? alt = freezed,Object? variants = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_MediaAsset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,mime: null == mime ? _self.mime : mime // ignore: cast_nullable_to_non_nullable
as String,captions: freezed == captions ? _self._captions : captions // ignore: cast_nullable_to_non_nullable
as List<String>?,alt: freezed == alt ? _self.alt : alt // ignore: cast_nullable_to_non_nullable
as String?,variants: freezed == variants ? _self._variants : variants // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
