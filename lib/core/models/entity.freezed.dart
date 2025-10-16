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
mixin _$Entity {

@DocumentIdField() String get id; String get kind;// npc | monster | group | place | item | handout | journal
 String get name; String? get summary; List<String>? get tags;// Optional union-specific fields
 Map<String, dynamic> get statblock; String? get placeType;// world | continent | region | city | village | place | other
 String? get parentPlaceId; Map<String, dynamic> get coords;// { lat, lng }
// Optional rich content
 String? get content;// quill delta json
 List<Map<String, dynamic>>? get images;// [{ assetId, kind }]
// System fields
 DateTime? get createdAt; DateTime? get updatedAt; int get rev; bool get deleted;// Optional for groups/parties
 List<String>? get members;
/// Create a copy of Entity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntityCopyWith<Entity> get copyWith => _$EntityCopyWithImpl<Entity>(this as Entity, _$identity);

  /// Serializes this Entity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Entity&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.statblock, statblock)&&(identical(other.placeType, placeType) || other.placeType == placeType)&&(identical(other.parentPlaceId, parentPlaceId) || other.parentPlaceId == parentPlaceId)&&const DeepCollectionEquality().equals(other.coords, coords)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev)&&(identical(other.deleted, deleted) || other.deleted == deleted)&&const DeepCollectionEquality().equals(other.members, members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,name,summary,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(statblock),placeType,parentPlaceId,const DeepCollectionEquality().hash(coords),content,const DeepCollectionEquality().hash(images),createdAt,updatedAt,rev,deleted,const DeepCollectionEquality().hash(members));

@override
String toString() {
  return 'Entity(id: $id, kind: $kind, name: $name, summary: $summary, tags: $tags, statblock: $statblock, placeType: $placeType, parentPlaceId: $parentPlaceId, coords: $coords, content: $content, images: $images, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev, deleted: $deleted, members: $members)';
}


}

/// @nodoc
abstract mixin class $EntityCopyWith<$Res>  {
  factory $EntityCopyWith(Entity value, $Res Function(Entity) _then) = _$EntityCopyWithImpl;
@useResult
$Res call({
@DocumentIdField() String id, String kind, String name, String? summary, List<String>? tags, Map<String, dynamic> statblock, String? placeType, String? parentPlaceId, Map<String, dynamic> coords, String? content, List<Map<String, dynamic>>? images, DateTime? createdAt, DateTime? updatedAt, int rev, bool deleted, List<String>? members
});




}
/// @nodoc
class _$EntityCopyWithImpl<$Res>
    implements $EntityCopyWith<$Res> {
  _$EntityCopyWithImpl(this._self, this._then);

  final Entity _self;
  final $Res Function(Entity) _then;

/// Create a copy of Entity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? name = null,Object? summary = freezed,Object? tags = freezed,Object? statblock = null,Object? placeType = freezed,Object? parentPlaceId = freezed,Object? coords = null,Object? content = freezed,Object? images = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,Object? deleted = null,Object? members = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,statblock: null == statblock ? _self.statblock : statblock // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,placeType: freezed == placeType ? _self.placeType : placeType // ignore: cast_nullable_to_non_nullable
as String?,parentPlaceId: freezed == parentPlaceId ? _self.parentPlaceId : parentPlaceId // ignore: cast_nullable_to_non_nullable
as String?,coords: null == coords ? _self.coords : coords // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,members: freezed == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Entity].
extension EntityPatterns on Entity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Entity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Entity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Entity value)  $default,){
final _that = this;
switch (_that) {
case _Entity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Entity value)?  $default,){
final _that = this;
switch (_that) {
case _Entity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String kind,  String name,  String? summary,  List<String>? tags,  Map<String, dynamic> statblock,  String? placeType,  String? parentPlaceId,  Map<String, dynamic> coords,  String? content,  List<Map<String, dynamic>>? images,  DateTime? createdAt,  DateTime? updatedAt,  int rev,  bool deleted,  List<String>? members)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Entity() when $default != null:
return $default(_that.id,_that.kind,_that.name,_that.summary,_that.tags,_that.statblock,_that.placeType,_that.parentPlaceId,_that.coords,_that.content,_that.images,_that.createdAt,_that.updatedAt,_that.rev,_that.deleted,_that.members);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String kind,  String name,  String? summary,  List<String>? tags,  Map<String, dynamic> statblock,  String? placeType,  String? parentPlaceId,  Map<String, dynamic> coords,  String? content,  List<Map<String, dynamic>>? images,  DateTime? createdAt,  DateTime? updatedAt,  int rev,  bool deleted,  List<String>? members)  $default,) {final _that = this;
switch (_that) {
case _Entity():
return $default(_that.id,_that.kind,_that.name,_that.summary,_that.tags,_that.statblock,_that.placeType,_that.parentPlaceId,_that.coords,_that.content,_that.images,_that.createdAt,_that.updatedAt,_that.rev,_that.deleted,_that.members);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DocumentIdField()  String id,  String kind,  String name,  String? summary,  List<String>? tags,  Map<String, dynamic> statblock,  String? placeType,  String? parentPlaceId,  Map<String, dynamic> coords,  String? content,  List<Map<String, dynamic>>? images,  DateTime? createdAt,  DateTime? updatedAt,  int rev,  bool deleted,  List<String>? members)?  $default,) {final _that = this;
switch (_that) {
case _Entity() when $default != null:
return $default(_that.id,_that.kind,_that.name,_that.summary,_that.tags,_that.statblock,_that.placeType,_that.parentPlaceId,_that.coords,_that.content,_that.images,_that.createdAt,_that.updatedAt,_that.rev,_that.deleted,_that.members);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Entity implements Entity {
  const _Entity({@DocumentIdField() required this.id, required this.kind, required this.name, this.summary, final  List<String>? tags, final  Map<String, dynamic> statblock = const <String, dynamic>{}, this.placeType, this.parentPlaceId, final  Map<String, dynamic> coords = const <String, dynamic>{}, this.content, final  List<Map<String, dynamic>>? images, this.createdAt, this.updatedAt, this.rev = 0, this.deleted = false, final  List<String>? members}): _tags = tags,_statblock = statblock,_coords = coords,_images = images,_members = members;
  factory _Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);

@override@DocumentIdField() final  String id;
@override final  String kind;
// npc | monster | group | place | item | handout | journal
@override final  String name;
@override final  String? summary;
 final  List<String>? _tags;
@override List<String>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// Optional union-specific fields
 final  Map<String, dynamic> _statblock;
// Optional union-specific fields
@override@JsonKey() Map<String, dynamic> get statblock {
  if (_statblock is EqualUnmodifiableMapView) return _statblock;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_statblock);
}

@override final  String? placeType;
// world | continent | region | city | village | place | other
@override final  String? parentPlaceId;
 final  Map<String, dynamic> _coords;
@override@JsonKey() Map<String, dynamic> get coords {
  if (_coords is EqualUnmodifiableMapView) return _coords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_coords);
}

// { lat, lng }
// Optional rich content
@override final  String? content;
// quill delta json
 final  List<Map<String, dynamic>>? _images;
// quill delta json
@override List<Map<String, dynamic>>? get images {
  final value = _images;
  if (value == null) return null;
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// [{ assetId, kind }]
// System fields
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  int rev;
@override@JsonKey() final  bool deleted;
// Optional for groups/parties
 final  List<String>? _members;
// Optional for groups/parties
@override List<String>? get members {
  final value = _members;
  if (value == null) return null;
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Entity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntityCopyWith<_Entity> get copyWith => __$EntityCopyWithImpl<_Entity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Entity&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._statblock, _statblock)&&(identical(other.placeType, placeType) || other.placeType == placeType)&&(identical(other.parentPlaceId, parentPlaceId) || other.parentPlaceId == parentPlaceId)&&const DeepCollectionEquality().equals(other._coords, _coords)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev)&&(identical(other.deleted, deleted) || other.deleted == deleted)&&const DeepCollectionEquality().equals(other._members, _members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,name,summary,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_statblock),placeType,parentPlaceId,const DeepCollectionEquality().hash(_coords),content,const DeepCollectionEquality().hash(_images),createdAt,updatedAt,rev,deleted,const DeepCollectionEquality().hash(_members));

@override
String toString() {
  return 'Entity(id: $id, kind: $kind, name: $name, summary: $summary, tags: $tags, statblock: $statblock, placeType: $placeType, parentPlaceId: $parentPlaceId, coords: $coords, content: $content, images: $images, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev, deleted: $deleted, members: $members)';
}


}

/// @nodoc
abstract mixin class _$EntityCopyWith<$Res> implements $EntityCopyWith<$Res> {
  factory _$EntityCopyWith(_Entity value, $Res Function(_Entity) _then) = __$EntityCopyWithImpl;
@override @useResult
$Res call({
@DocumentIdField() String id, String kind, String name, String? summary, List<String>? tags, Map<String, dynamic> statblock, String? placeType, String? parentPlaceId, Map<String, dynamic> coords, String? content, List<Map<String, dynamic>>? images, DateTime? createdAt, DateTime? updatedAt, int rev, bool deleted, List<String>? members
});




}
/// @nodoc
class __$EntityCopyWithImpl<$Res>
    implements _$EntityCopyWith<$Res> {
  __$EntityCopyWithImpl(this._self, this._then);

  final _Entity _self;
  final $Res Function(_Entity) _then;

/// Create a copy of Entity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? name = null,Object? summary = freezed,Object? tags = freezed,Object? statblock = null,Object? placeType = freezed,Object? parentPlaceId = freezed,Object? coords = null,Object? content = freezed,Object? images = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,Object? deleted = null,Object? members = freezed,}) {
  return _then(_Entity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,statblock: null == statblock ? _self._statblock : statblock // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,placeType: freezed == placeType ? _self.placeType : placeType // ignore: cast_nullable_to_non_nullable
as String?,parentPlaceId: freezed == parentPlaceId ? _self.parentPlaceId : parentPlaceId // ignore: cast_nullable_to_non_nullable
as String?,coords: null == coords ? _self._coords : coords // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,members: freezed == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
