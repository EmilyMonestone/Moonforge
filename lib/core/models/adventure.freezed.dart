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
mixin _$AdventureDoc {

@DocumentIdField() String get id; String get name; int get order; String? get summary; RichTextDoc? get content;@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get updatedAt; int get rev;
/// Create a copy of AdventureDoc
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdventureDocCopyWith<AdventureDoc> get copyWith => _$AdventureDocCopyWithImpl<AdventureDoc>(this as AdventureDoc, _$identity);

  /// Serializes this AdventureDoc to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdventureDoc&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.order, order) || other.order == order)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,order,summary,content,createdAt,updatedAt,rev);

@override
String toString() {
  return 'AdventureDoc(id: $id, name: $name, order: $order, summary: $summary, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class $AdventureDocCopyWith<$Res>  {
  factory $AdventureDocCopyWith(AdventureDoc value, $Res Function(AdventureDoc) _then) = _$AdventureDocCopyWithImpl;
@useResult
$Res call({
@DocumentIdField() String id, String name, int order, String? summary, RichTextDoc? content,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt, int rev
});


$RichTextDocCopyWith<$Res>? get content;

}
/// @nodoc
class _$AdventureDocCopyWithImpl<$Res>
    implements $AdventureDocCopyWith<$Res> {
  _$AdventureDocCopyWithImpl(this._self, this._then);

  final AdventureDoc _self;
  final $Res Function(AdventureDoc) _then;

/// Create a copy of AdventureDoc
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? order = null,Object? summary = freezed,Object? content = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as RichTextDoc?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of AdventureDoc
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


/// Adds pattern-matching-related methods to [AdventureDoc].
extension AdventureDocPatterns on AdventureDoc {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdventureDoc value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdventureDoc() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdventureDoc value)  $default,){
final _that = this;
switch (_that) {
case _AdventureDoc():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdventureDoc value)?  $default,){
final _that = this;
switch (_that) {
case _AdventureDoc() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String name,  int order,  String? summary,  RichTextDoc? content, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  int rev)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdventureDoc() when $default != null:
return $default(_that.id,_that.name,_that.order,_that.summary,_that.content,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String name,  int order,  String? summary,  RichTextDoc? content, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  int rev)  $default,) {final _that = this;
switch (_that) {
case _AdventureDoc():
return $default(_that.id,_that.name,_that.order,_that.summary,_that.content,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DocumentIdField()  String id,  String name,  int order,  String? summary,  RichTextDoc? content, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  int rev)?  $default,) {final _that = this;
switch (_that) {
case _AdventureDoc() when $default != null:
return $default(_that.id,_that.name,_that.order,_that.summary,_that.content,_that.createdAt,_that.updatedAt,_that.rev);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AdventureDoc implements AdventureDoc {
  const _AdventureDoc({@DocumentIdField() required this.id, required this.name, this.order = 0, this.summary, this.content, @TimestampConverter() this.createdAt, @TimestampConverter() this.updatedAt, this.rev = 0});
  factory _AdventureDoc.fromJson(Map<String, dynamic> json) => _$AdventureDocFromJson(json);

@override@DocumentIdField() final  String id;
@override final  String name;
@override@JsonKey() final  int order;
@override final  String? summary;
@override final  RichTextDoc? content;
@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? updatedAt;
@override@JsonKey() final  int rev;

/// Create a copy of AdventureDoc
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdventureDocCopyWith<_AdventureDoc> get copyWith => __$AdventureDocCopyWithImpl<_AdventureDoc>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdventureDocToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdventureDoc&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.order, order) || other.order == order)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,order,summary,content,createdAt,updatedAt,rev);

@override
String toString() {
  return 'AdventureDoc(id: $id, name: $name, order: $order, summary: $summary, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class _$AdventureDocCopyWith<$Res> implements $AdventureDocCopyWith<$Res> {
  factory _$AdventureDocCopyWith(_AdventureDoc value, $Res Function(_AdventureDoc) _then) = __$AdventureDocCopyWithImpl;
@override @useResult
$Res call({
@DocumentIdField() String id, String name, int order, String? summary, RichTextDoc? content,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt, int rev
});


@override $RichTextDocCopyWith<$Res>? get content;

}
/// @nodoc
class __$AdventureDocCopyWithImpl<$Res>
    implements _$AdventureDocCopyWith<$Res> {
  __$AdventureDocCopyWithImpl(this._self, this._then);

  final _AdventureDoc _self;
  final $Res Function(_AdventureDoc) _then;

/// Create a copy of AdventureDoc
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? order = null,Object? summary = freezed,Object? content = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_AdventureDoc(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as RichTextDoc?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of AdventureDoc
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
