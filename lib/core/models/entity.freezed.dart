// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EntityDoc {

@DocumentIdField() String get id; String get kind;// npc | monster | group | place | item | handout | journal
 String get name; String? get summary; List<String> get tags;// Optional union-specific fields
 Statblock? get statblock; String? get placeType;// for places
 String? get parentPlaceId; Coords? get coords;// Optional content/images
 RichTextDoc? get content; List<ImageRef> get images;// Optional group membership (for groups/parties)
 List<String> get members;// Optional item props
 Map<String, dynamic>? get props;// System
@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get updatedAt; int get rev; bool get deleted;
/// Create a copy of EntityDoc
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntityDocCopyWith<EntityDoc> get copyWith => _$EntityDocCopyWithImpl<EntityDoc>(this as EntityDoc, _$identity);

  /// Serializes this EntityDoc to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EntityDoc&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.statblock, statblock) || other.statblock == statblock)&&(identical(other.placeType, placeType) || other.placeType == placeType)&&(identical(other.parentPlaceId, parentPlaceId) || other.parentPlaceId == parentPlaceId)&&(identical(other.coords, coords) || other.coords == coords)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.images, images)&&const DeepCollectionEquality().equals(other.members, members)&&const DeepCollectionEquality().equals(other.props, props)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev)&&(identical(other.deleted, deleted) || other.deleted == deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,name,summary,const DeepCollectionEquality().hash(tags),statblock,placeType,parentPlaceId,coords,content,const DeepCollectionEquality().hash(images),const DeepCollectionEquality().hash(members),const DeepCollectionEquality().hash(props),createdAt,updatedAt,rev,deleted);

@override
String toString() {
  return 'EntityDoc(id: $id, kind: $kind, name: $name, summary: $summary, tags: $tags, statblock: $statblock, placeType: $placeType, parentPlaceId: $parentPlaceId, coords: $coords, content: $content, images: $images, members: $members, props: $props, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class $EntityDocCopyWith<$Res>  {
  factory $EntityDocCopyWith(EntityDoc value, $Res Function(EntityDoc) _then) = _$EntityDocCopyWithImpl;
@useResult
$Res call({
@DocumentIdField() String id, String kind, String name, String? summary, List<String> tags, Statblock? statblock, String? placeType, String? parentPlaceId, Coords? coords, RichTextDoc? content, List<ImageRef> images, List<String> members, Map<String, dynamic>? props,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt, int rev, bool deleted
});


$StatblockCopyWith<$Res>? get statblock;$CoordsCopyWith<$Res>? get coords;$RichTextDocCopyWith<$Res>? get content;

}
/// @nodoc
class _$EntityDocCopyWithImpl<$Res>
    implements $EntityDocCopyWith<$Res> {
  _$EntityDocCopyWithImpl(this._self, this._then);

  final EntityDoc _self;
  final $Res Function(EntityDoc) _then;

/// Create a copy of EntityDoc
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? name = null,Object? summary = freezed,Object? tags = null,Object? statblock = freezed,Object? placeType = freezed,Object? parentPlaceId = freezed,Object? coords = freezed,Object? content = freezed,Object? images = null,Object? members = null,Object? props = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,Object? deleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,statblock: freezed == statblock ? _self.statblock : statblock // ignore: cast_nullable_to_non_nullable
as Statblock?,placeType: freezed == placeType ? _self.placeType : placeType // ignore: cast_nullable_to_non_nullable
as String?,parentPlaceId: freezed == parentPlaceId ? _self.parentPlaceId : parentPlaceId // ignore: cast_nullable_to_non_nullable
as String?,coords: freezed == coords ? _self.coords : coords // ignore: cast_nullable_to_non_nullable
as Coords?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as RichTextDoc?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<ImageRef>,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<String>,props: freezed == props ? _self.props : props // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of EntityDoc
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatblockCopyWith<$Res>? get statblock {
    if (_self.statblock == null) {
    return null;
  }

  return $StatblockCopyWith<$Res>(_self.statblock!, (value) {
    return _then(_self.copyWith(statblock: value));
  });
}/// Create a copy of EntityDoc
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoordsCopyWith<$Res>? get coords {
    if (_self.coords == null) {
    return null;
  }

  return $CoordsCopyWith<$Res>(_self.coords!, (value) {
    return _then(_self.copyWith(coords: value));
  });
}/// Create a copy of EntityDoc
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


/// Adds pattern-matching-related methods to [EntityDoc].
extension EntityDocPatterns on EntityDoc {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EntityDoc value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EntityDoc() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EntityDoc value)  $default,){
final _that = this;
switch (_that) {
case _EntityDoc():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EntityDoc value)?  $default,){
final _that = this;
switch (_that) {
case _EntityDoc() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String kind,  String name,  String? summary,  List<String> tags,  Statblock? statblock,  String? placeType,  String? parentPlaceId,  Coords? coords,  RichTextDoc? content,  List<ImageRef> images,  List<String> members,  Map<String, dynamic>? props, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  int rev,  bool deleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EntityDoc() when $default != null:
return $default(_that.id,_that.kind,_that.name,_that.summary,_that.tags,_that.statblock,_that.placeType,_that.parentPlaceId,_that.coords,_that.content,_that.images,_that.members,_that.props,_that.createdAt,_that.updatedAt,_that.rev,_that.deleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String kind,  String name,  String? summary,  List<String> tags,  Statblock? statblock,  String? placeType,  String? parentPlaceId,  Coords? coords,  RichTextDoc? content,  List<ImageRef> images,  List<String> members,  Map<String, dynamic>? props, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  int rev,  bool deleted)  $default,) {final _that = this;
switch (_that) {
case _EntityDoc():
return $default(_that.id,_that.kind,_that.name,_that.summary,_that.tags,_that.statblock,_that.placeType,_that.parentPlaceId,_that.coords,_that.content,_that.images,_that.members,_that.props,_that.createdAt,_that.updatedAt,_that.rev,_that.deleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DocumentIdField()  String id,  String kind,  String name,  String? summary,  List<String> tags,  Statblock? statblock,  String? placeType,  String? parentPlaceId,  Coords? coords,  RichTextDoc? content,  List<ImageRef> images,  List<String> members,  Map<String, dynamic>? props, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  int rev,  bool deleted)?  $default,) {final _that = this;
switch (_that) {
case _EntityDoc() when $default != null:
return $default(_that.id,_that.kind,_that.name,_that.summary,_that.tags,_that.statblock,_that.placeType,_that.parentPlaceId,_that.coords,_that.content,_that.images,_that.members,_that.props,_that.createdAt,_that.updatedAt,_that.rev,_that.deleted);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _EntityDoc implements EntityDoc {
  const _EntityDoc({@DocumentIdField() required this.id, required this.kind, required this.name, this.summary, final  List<String> tags = const <String>[], this.statblock, this.placeType, this.parentPlaceId, this.coords, this.content, final  List<ImageRef> images = const <ImageRef>[], final  List<String> members = const <String>[], final  Map<String, dynamic>? props, @TimestampConverter() this.createdAt, @TimestampConverter() this.updatedAt, this.rev = 0, this.deleted = false}): _tags = tags,_images = images,_members = members,_props = props;
  factory _EntityDoc.fromJson(Map<String, dynamic> json) => _$EntityDocFromJson(json);

@override@DocumentIdField() final  String id;
@override final  String kind;
// npc | monster | group | place | item | handout | journal
@override final  String name;
@override final  String? summary;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

// Optional union-specific fields
@override final  Statblock? statblock;
@override final  String? placeType;
// for places
@override final  String? parentPlaceId;
@override final  Coords? coords;
// Optional content/images
@override final  RichTextDoc? content;
 final  List<ImageRef> _images;
@override@JsonKey() List<ImageRef> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

// Optional group membership (for groups/parties)
 final  List<String> _members;
// Optional group membership (for groups/parties)
@override@JsonKey() List<String> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

// Optional item props
 final  Map<String, dynamic>? _props;
// Optional item props
@override Map<String, dynamic>? get props {
  final value = _props;
  if (value == null) return null;
  if (_props is EqualUnmodifiableMapView) return _props;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

// System
@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? updatedAt;
@override@JsonKey() final  int rev;
@override@JsonKey() final  bool deleted;

/// Create a copy of EntityDoc
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntityDocCopyWith<_EntityDoc> get copyWith => __$EntityDocCopyWithImpl<_EntityDoc>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntityDocToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EntityDoc&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.statblock, statblock) || other.statblock == statblock)&&(identical(other.placeType, placeType) || other.placeType == placeType)&&(identical(other.parentPlaceId, parentPlaceId) || other.parentPlaceId == parentPlaceId)&&(identical(other.coords, coords) || other.coords == coords)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._images, _images)&&const DeepCollectionEquality().equals(other._members, _members)&&const DeepCollectionEquality().equals(other._props, _props)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev)&&(identical(other.deleted, deleted) || other.deleted == deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,name,summary,const DeepCollectionEquality().hash(_tags),statblock,placeType,parentPlaceId,coords,content,const DeepCollectionEquality().hash(_images),const DeepCollectionEquality().hash(_members),const DeepCollectionEquality().hash(_props),createdAt,updatedAt,rev,deleted);

@override
String toString() {
  return 'EntityDoc(id: $id, kind: $kind, name: $name, summary: $summary, tags: $tags, statblock: $statblock, placeType: $placeType, parentPlaceId: $parentPlaceId, coords: $coords, content: $content, images: $images, members: $members, props: $props, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class _$EntityDocCopyWith<$Res> implements $EntityDocCopyWith<$Res> {
  factory _$EntityDocCopyWith(_EntityDoc value, $Res Function(_EntityDoc) _then) = __$EntityDocCopyWithImpl;
@override @useResult
$Res call({
@DocumentIdField() String id, String kind, String name, String? summary, List<String> tags, Statblock? statblock, String? placeType, String? parentPlaceId, Coords? coords, RichTextDoc? content, List<ImageRef> images, List<String> members, Map<String, dynamic>? props,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt, int rev, bool deleted
});


@override $StatblockCopyWith<$Res>? get statblock;@override $CoordsCopyWith<$Res>? get coords;@override $RichTextDocCopyWith<$Res>? get content;

}
/// @nodoc
class __$EntityDocCopyWithImpl<$Res>
    implements _$EntityDocCopyWith<$Res> {
  __$EntityDocCopyWithImpl(this._self, this._then);

  final _EntityDoc _self;
  final $Res Function(_EntityDoc) _then;

/// Create a copy of EntityDoc
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? name = null,Object? summary = freezed,Object? tags = null,Object? statblock = freezed,Object? placeType = freezed,Object? parentPlaceId = freezed,Object? coords = freezed,Object? content = freezed,Object? images = null,Object? members = null,Object? props = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,Object? deleted = null,}) {
  return _then(_EntityDoc(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,statblock: freezed == statblock ? _self.statblock : statblock // ignore: cast_nullable_to_non_nullable
as Statblock?,placeType: freezed == placeType ? _self.placeType : placeType // ignore: cast_nullable_to_non_nullable
as String?,parentPlaceId: freezed == parentPlaceId ? _self.parentPlaceId : parentPlaceId // ignore: cast_nullable_to_non_nullable
as String?,coords: freezed == coords ? _self.coords : coords // ignore: cast_nullable_to_non_nullable
as Coords?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as RichTextDoc?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<ImageRef>,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<String>,props: freezed == props ? _self._props : props // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of EntityDoc
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatblockCopyWith<$Res>? get statblock {
    if (_self.statblock == null) {
    return null;
  }

  return $StatblockCopyWith<$Res>(_self.statblock!, (value) {
    return _then(_self.copyWith(statblock: value));
  });
}/// Create a copy of EntityDoc
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoordsCopyWith<$Res>? get coords {
    if (_self.coords == null) {
    return null;
  }

  return $CoordsCopyWith<$Res>(_self.coords!, (value) {
    return _then(_self.copyWith(coords: value));
  });
}/// Create a copy of EntityDoc
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
