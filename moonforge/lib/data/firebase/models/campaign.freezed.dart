// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'campaign.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Campaign {

@DocumentIdField() String get id; String get name; String get description; String? get content;// quill delta json
 String? get ownerUid; List<String>? get memberUids; List<String> get entityIds;// Related entities
 DateTime? get createdAt; DateTime? get updatedAt; int get rev;
/// Create a copy of Campaign
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampaignCopyWith<Campaign> get copyWith => _$CampaignCopyWithImpl<Campaign>(this as Campaign, _$identity);

  /// Serializes this Campaign to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Campaign&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.content, content) || other.content == content)&&(identical(other.ownerUid, ownerUid) || other.ownerUid == ownerUid)&&const DeepCollectionEquality().equals(other.memberUids, memberUids)&&const DeepCollectionEquality().equals(other.entityIds, entityIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,content,ownerUid,const DeepCollectionEquality().hash(memberUids),const DeepCollectionEquality().hash(entityIds),createdAt,updatedAt,rev);

@override
String toString() {
  return 'Campaign(id: $id, name: $name, description: $description, content: $content, ownerUid: $ownerUid, memberUids: $memberUids, entityIds: $entityIds, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class $CampaignCopyWith<$Res>  {
  factory $CampaignCopyWith(Campaign value, $Res Function(Campaign) _then) = _$CampaignCopyWithImpl;
@useResult
$Res call({
@DocumentIdField() String id, String name, String description, String? content, String? ownerUid, List<String>? memberUids, List<String> entityIds, DateTime? createdAt, DateTime? updatedAt, int rev
});




}
/// @nodoc
class _$CampaignCopyWithImpl<$Res>
    implements $CampaignCopyWith<$Res> {
  _$CampaignCopyWithImpl(this._self, this._then);

  final Campaign _self;
  final $Res Function(Campaign) _then;

/// Create a copy of Campaign
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? content = freezed,Object? ownerUid = freezed,Object? memberUids = freezed,Object? entityIds = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,ownerUid: freezed == ownerUid ? _self.ownerUid : ownerUid // ignore: cast_nullable_to_non_nullable
as String?,memberUids: freezed == memberUids ? _self.memberUids : memberUids // ignore: cast_nullable_to_non_nullable
as List<String>?,entityIds: null == entityIds ? _self.entityIds : entityIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Campaign].
extension CampaignPatterns on Campaign {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Campaign value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Campaign() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Campaign value)  $default,){
final _that = this;
switch (_that) {
case _Campaign():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Campaign value)?  $default,){
final _that = this;
switch (_that) {
case _Campaign() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String name,  String description,  String? content,  String? ownerUid,  List<String>? memberUids,  List<String> entityIds,  DateTime? createdAt,  DateTime? updatedAt,  int rev)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Campaign() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.content,_that.ownerUid,_that.memberUids,_that.entityIds,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String name,  String description,  String? content,  String? ownerUid,  List<String>? memberUids,  List<String> entityIds,  DateTime? createdAt,  DateTime? updatedAt,  int rev)  $default,) {final _that = this;
switch (_that) {
case _Campaign():
return $default(_that.id,_that.name,_that.description,_that.content,_that.ownerUid,_that.memberUids,_that.entityIds,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DocumentIdField()  String id,  String name,  String description,  String? content,  String? ownerUid,  List<String>? memberUids,  List<String> entityIds,  DateTime? createdAt,  DateTime? updatedAt,  int rev)?  $default,) {final _that = this;
switch (_that) {
case _Campaign() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.content,_that.ownerUid,_that.memberUids,_that.entityIds,_that.createdAt,_that.updatedAt,_that.rev);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Campaign implements Campaign {
  const _Campaign({@DocumentIdField() required this.id, required this.name, required this.description, this.content, this.ownerUid, final  List<String>? memberUids, final  List<String> entityIds = const [], this.createdAt, this.updatedAt, this.rev = 0}): _memberUids = memberUids,_entityIds = entityIds;
  factory _Campaign.fromJson(Map<String, dynamic> json) => _$CampaignFromJson(json);

@override@DocumentIdField() final  String id;
@override final  String name;
@override final  String description;
@override final  String? content;
// quill delta json
@override final  String? ownerUid;
 final  List<String>? _memberUids;
@override List<String>? get memberUids {
  final value = _memberUids;
  if (value == null) return null;
  if (_memberUids is EqualUnmodifiableListView) return _memberUids;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String> _entityIds;
@override@JsonKey() List<String> get entityIds {
  if (_entityIds is EqualUnmodifiableListView) return _entityIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entityIds);
}

// Related entities
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  int rev;

/// Create a copy of Campaign
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CampaignCopyWith<_Campaign> get copyWith => __$CampaignCopyWithImpl<_Campaign>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CampaignToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Campaign&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.content, content) || other.content == content)&&(identical(other.ownerUid, ownerUid) || other.ownerUid == ownerUid)&&const DeepCollectionEquality().equals(other._memberUids, _memberUids)&&const DeepCollectionEquality().equals(other._entityIds, _entityIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,content,ownerUid,const DeepCollectionEquality().hash(_memberUids),const DeepCollectionEquality().hash(_entityIds),createdAt,updatedAt,rev);

@override
String toString() {
  return 'Campaign(id: $id, name: $name, description: $description, content: $content, ownerUid: $ownerUid, memberUids: $memberUids, entityIds: $entityIds, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class _$CampaignCopyWith<$Res> implements $CampaignCopyWith<$Res> {
  factory _$CampaignCopyWith(_Campaign value, $Res Function(_Campaign) _then) = __$CampaignCopyWithImpl;
@override @useResult
$Res call({
@DocumentIdField() String id, String name, String description, String? content, String? ownerUid, List<String>? memberUids, List<String> entityIds, DateTime? createdAt, DateTime? updatedAt, int rev
});




}
/// @nodoc
class __$CampaignCopyWithImpl<$Res>
    implements _$CampaignCopyWith<$Res> {
  __$CampaignCopyWithImpl(this._self, this._then);

  final _Campaign _self;
  final $Res Function(_Campaign) _then;

/// Create a copy of Campaign
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? content = freezed,Object? ownerUid = freezed,Object? memberUids = freezed,Object? entityIds = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_Campaign(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,ownerUid: freezed == ownerUid ? _self.ownerUid : ownerUid // ignore: cast_nullable_to_non_nullable
as String?,memberUids: freezed == memberUids ? _self._memberUids : memberUids // ignore: cast_nullable_to_non_nullable
as List<String>?,entityIds: null == entityIds ? _self._entityIds : entityIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
