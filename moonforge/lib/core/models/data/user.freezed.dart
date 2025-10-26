// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

@DocumentIdField() String get id; Settings? get settings; DateTime? get createdAt; DateTime? get updatedAt; int get rev;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,settings,createdAt,updatedAt,rev);

@override
String toString() {
  return 'User(id: $id, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
@DocumentIdField() String id, Settings? settings, DateTime? createdAt, DateTime? updatedAt, int rev
});


$SettingsCopyWith<$Res>? get settings;

}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? settings = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Settings?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SettingsCopyWith<$Res>? get settings {
    if (_self.settings == null) {
    return null;
  }

  return $SettingsCopyWith<$Res>(_self.settings!, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  Settings? settings,  DateTime? createdAt,  DateTime? updatedAt,  int rev)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.settings,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  Settings? settings,  DateTime? createdAt,  DateTime? updatedAt,  int rev)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.settings,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DocumentIdField()  String id,  Settings? settings,  DateTime? createdAt,  DateTime? updatedAt,  int rev)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.settings,_that.createdAt,_that.updatedAt,_that.rev);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({@DocumentIdField() required this.id, this.settings, this.createdAt, this.updatedAt, this.rev = 0});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override@DocumentIdField() final  String id;
@override final  Settings? settings;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  int rev;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,settings,createdAt,updatedAt,rev);

@override
String toString() {
  return 'User(id: $id, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
@DocumentIdField() String id, Settings? settings, DateTime? createdAt, DateTime? updatedAt, int rev
});


@override $SettingsCopyWith<$Res>? get settings;

}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? settings = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Settings?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SettingsCopyWith<$Res>? get settings {
    if (_self.settings == null) {
    return null;
  }

  return $SettingsCopyWith<$Res>(_self.settings!, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// @nodoc
mixin _$Settings {

@DocumentIdField() String get id; ThemeMode? get themeMode; AppLocale? get locale; bool? get railNavExtended; DateTime? get createdAt; DateTime? get updatedAt; int get rev;
/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsCopyWith<Settings> get copyWith => _$SettingsCopyWithImpl<Settings>(this as Settings, _$identity);

  /// Serializes this Settings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Settings&&(identical(other.id, id) || other.id == id)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.railNavExtended, railNavExtended) || other.railNavExtended == railNavExtended)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,themeMode,locale,railNavExtended,createdAt,updatedAt,rev);

@override
String toString() {
  return 'Settings(id: $id, themeMode: $themeMode, locale: $locale, railNavExtended: $railNavExtended, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class $SettingsCopyWith<$Res>  {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) _then) = _$SettingsCopyWithImpl;
@useResult
$Res call({
@DocumentIdField() String id, ThemeMode? themeMode, AppLocale? locale, bool? railNavExtended, DateTime? createdAt, DateTime? updatedAt, int rev
});


$AppLocaleCopyWith<$Res>? get locale;

}
/// @nodoc
class _$SettingsCopyWithImpl<$Res>
    implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._self, this._then);

  final Settings _self;
  final $Res Function(Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? themeMode = freezed,Object? locale = freezed,Object? railNavExtended = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,themeMode: freezed == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as AppLocale?,railNavExtended: freezed == railNavExtended ? _self.railNavExtended : railNavExtended // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppLocaleCopyWith<$Res>? get locale {
    if (_self.locale == null) {
    return null;
  }

  return $AppLocaleCopyWith<$Res>(_self.locale!, (value) {
    return _then(_self.copyWith(locale: value));
  });
}
}


/// Adds pattern-matching-related methods to [Settings].
extension SettingsPatterns on Settings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Settings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Settings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Settings value)  $default,){
final _that = this;
switch (_that) {
case _Settings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Settings value)?  $default,){
final _that = this;
switch (_that) {
case _Settings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  ThemeMode? themeMode,  AppLocale? locale,  bool? railNavExtended,  DateTime? createdAt,  DateTime? updatedAt,  int rev)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Settings() when $default != null:
return $default(_that.id,_that.themeMode,_that.locale,_that.railNavExtended,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  ThemeMode? themeMode,  AppLocale? locale,  bool? railNavExtended,  DateTime? createdAt,  DateTime? updatedAt,  int rev)  $default,) {final _that = this;
switch (_that) {
case _Settings():
return $default(_that.id,_that.themeMode,_that.locale,_that.railNavExtended,_that.createdAt,_that.updatedAt,_that.rev);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DocumentIdField()  String id,  ThemeMode? themeMode,  AppLocale? locale,  bool? railNavExtended,  DateTime? createdAt,  DateTime? updatedAt,  int rev)?  $default,) {final _that = this;
switch (_that) {
case _Settings() when $default != null:
return $default(_that.id,_that.themeMode,_that.locale,_that.railNavExtended,_that.createdAt,_that.updatedAt,_that.rev);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Settings implements Settings {
  const _Settings({@DocumentIdField() required this.id, this.themeMode, this.locale, this.railNavExtended, this.createdAt, this.updatedAt, this.rev = 0});
  factory _Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);

@override@DocumentIdField() final  String id;
@override final  ThemeMode? themeMode;
@override final  AppLocale? locale;
@override final  bool? railNavExtended;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  int rev;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsCopyWith<_Settings> get copyWith => __$SettingsCopyWithImpl<_Settings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Settings&&(identical(other.id, id) || other.id == id)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.railNavExtended, railNavExtended) || other.railNavExtended == railNavExtended)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rev, rev) || other.rev == rev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,themeMode,locale,railNavExtended,createdAt,updatedAt,rev);

@override
String toString() {
  return 'Settings(id: $id, themeMode: $themeMode, locale: $locale, railNavExtended: $railNavExtended, createdAt: $createdAt, updatedAt: $updatedAt, rev: $rev)';
}


}

/// @nodoc
abstract mixin class _$SettingsCopyWith<$Res> implements $SettingsCopyWith<$Res> {
  factory _$SettingsCopyWith(_Settings value, $Res Function(_Settings) _then) = __$SettingsCopyWithImpl;
@override @useResult
$Res call({
@DocumentIdField() String id, ThemeMode? themeMode, AppLocale? locale, bool? railNavExtended, DateTime? createdAt, DateTime? updatedAt, int rev
});


@override $AppLocaleCopyWith<$Res>? get locale;

}
/// @nodoc
class __$SettingsCopyWithImpl<$Res>
    implements _$SettingsCopyWith<$Res> {
  __$SettingsCopyWithImpl(this._self, this._then);

  final _Settings _self;
  final $Res Function(_Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? themeMode = freezed,Object? locale = freezed,Object? railNavExtended = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rev = null,}) {
  return _then(_Settings(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,themeMode: freezed == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as AppLocale?,railNavExtended: freezed == railNavExtended ? _self.railNavExtended : railNavExtended // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rev: null == rev ? _self.rev : rev // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppLocaleCopyWith<$Res>? get locale {
    if (_self.locale == null) {
    return null;
  }

  return $AppLocaleCopyWith<$Res>(_self.locale!, (value) {
    return _then(_self.copyWith(locale: value));
  });
}
}


/// @nodoc
mixin _$AppLocale {

@DocumentIdField() String get id; String get languageCode; String? get countryCode;
/// Create a copy of AppLocale
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppLocaleCopyWith<AppLocale> get copyWith => _$AppLocaleCopyWithImpl<AppLocale>(this as AppLocale, _$identity);

  /// Serializes this AppLocale to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppLocale&&(identical(other.id, id) || other.id == id)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,languageCode,countryCode);

@override
String toString() {
  return 'AppLocale(id: $id, languageCode: $languageCode, countryCode: $countryCode)';
}


}

/// @nodoc
abstract mixin class $AppLocaleCopyWith<$Res>  {
  factory $AppLocaleCopyWith(AppLocale value, $Res Function(AppLocale) _then) = _$AppLocaleCopyWithImpl;
@useResult
$Res call({
@DocumentIdField() String id, String languageCode, String? countryCode
});




}
/// @nodoc
class _$AppLocaleCopyWithImpl<$Res>
    implements $AppLocaleCopyWith<$Res> {
  _$AppLocaleCopyWithImpl(this._self, this._then);

  final AppLocale _self;
  final $Res Function(AppLocale) _then;

/// Create a copy of AppLocale
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? languageCode = null,Object? countryCode = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppLocale].
extension AppLocalePatterns on AppLocale {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppLocale value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppLocale() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppLocale value)  $default,){
final _that = this;
switch (_that) {
case _AppLocale():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppLocale value)?  $default,){
final _that = this;
switch (_that) {
case _AppLocale() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String languageCode,  String? countryCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppLocale() when $default != null:
return $default(_that.id,_that.languageCode,_that.countryCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DocumentIdField()  String id,  String languageCode,  String? countryCode)  $default,) {final _that = this;
switch (_that) {
case _AppLocale():
return $default(_that.id,_that.languageCode,_that.countryCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DocumentIdField()  String id,  String languageCode,  String? countryCode)?  $default,) {final _that = this;
switch (_that) {
case _AppLocale() when $default != null:
return $default(_that.id,_that.languageCode,_that.countryCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppLocale implements AppLocale {
  const _AppLocale({@DocumentIdField() required this.id, required this.languageCode, this.countryCode});
  factory _AppLocale.fromJson(Map<String, dynamic> json) => _$AppLocaleFromJson(json);

@override@DocumentIdField() final  String id;
@override final  String languageCode;
@override final  String? countryCode;

/// Create a copy of AppLocale
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppLocaleCopyWith<_AppLocale> get copyWith => __$AppLocaleCopyWithImpl<_AppLocale>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppLocaleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppLocale&&(identical(other.id, id) || other.id == id)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,languageCode,countryCode);

@override
String toString() {
  return 'AppLocale(id: $id, languageCode: $languageCode, countryCode: $countryCode)';
}


}

/// @nodoc
abstract mixin class _$AppLocaleCopyWith<$Res> implements $AppLocaleCopyWith<$Res> {
  factory _$AppLocaleCopyWith(_AppLocale value, $Res Function(_AppLocale) _then) = __$AppLocaleCopyWithImpl;
@override @useResult
$Res call({
@DocumentIdField() String id, String languageCode, String? countryCode
});




}
/// @nodoc
class __$AppLocaleCopyWithImpl<$Res>
    implements _$AppLocaleCopyWith<$Res> {
  __$AppLocaleCopyWithImpl(this._self, this._then);

  final _AppLocale _self;
  final $Res Function(_AppLocale) _then;

/// Create a copy of AppLocale
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? languageCode = null,Object? countryCode = freezed,}) {
  return _then(_AppLocale(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
