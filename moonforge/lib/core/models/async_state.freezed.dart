// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'async_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AsyncState<T> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AsyncState<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AsyncState<$T>()';
}


}

/// @nodoc
class $AsyncStateCopyWith<T,$Res>  {
$AsyncStateCopyWith(AsyncState<T> _, $Res Function(AsyncState<T>) __);
}


/// Adds pattern-matching-related methods to [AsyncState].
extension AsyncStatePatterns<T> on AsyncState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AsyncStateIdle<T> value)?  idle,TResult Function( _AsyncStateLoading<T> value)?  loading,TResult Function( _AsyncStateData<T> value)?  data,TResult Function( _AsyncStateError<T> value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AsyncStateIdle() when idle != null:
return idle(_that);case _AsyncStateLoading() when loading != null:
return loading(_that);case _AsyncStateData() when data != null:
return data(_that);case _AsyncStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AsyncStateIdle<T> value)  idle,required TResult Function( _AsyncStateLoading<T> value)  loading,required TResult Function( _AsyncStateData<T> value)  data,required TResult Function( _AsyncStateError<T> value)  error,}){
final _that = this;
switch (_that) {
case _AsyncStateIdle():
return idle(_that);case _AsyncStateLoading():
return loading(_that);case _AsyncStateData():
return data(_that);case _AsyncStateError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AsyncStateIdle<T> value)?  idle,TResult? Function( _AsyncStateLoading<T> value)?  loading,TResult? Function( _AsyncStateData<T> value)?  data,TResult? Function( _AsyncStateError<T> value)?  error,}){
final _that = this;
switch (_that) {
case _AsyncStateIdle() when idle != null:
return idle(_that);case _AsyncStateLoading() when loading != null:
return loading(_that);case _AsyncStateData() when data != null:
return data(_that);case _AsyncStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  loading,TResult Function( T data)?  data,TResult Function( Object error,  StackTrace? stackTrace)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AsyncStateIdle() when idle != null:
return idle();case _AsyncStateLoading() when loading != null:
return loading();case _AsyncStateData() when data != null:
return data(_that.data);case _AsyncStateError() when error != null:
return error(_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  loading,required TResult Function( T data)  data,required TResult Function( Object error,  StackTrace? stackTrace)  error,}) {final _that = this;
switch (_that) {
case _AsyncStateIdle():
return idle();case _AsyncStateLoading():
return loading();case _AsyncStateData():
return data(_that.data);case _AsyncStateError():
return error(_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  loading,TResult? Function( T data)?  data,TResult? Function( Object error,  StackTrace? stackTrace)?  error,}) {final _that = this;
switch (_that) {
case _AsyncStateIdle() when idle != null:
return idle();case _AsyncStateLoading() when loading != null:
return loading();case _AsyncStateData() when data != null:
return data(_that.data);case _AsyncStateError() when error != null:
return error(_that.error,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _AsyncStateIdle<T> extends AsyncState<T> {
  const _AsyncStateIdle(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AsyncStateIdle<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AsyncState<$T>.idle()';
}


}




/// @nodoc


class _AsyncStateLoading<T> extends AsyncState<T> {
  const _AsyncStateLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AsyncStateLoading<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AsyncState<$T>.loading()';
}


}




/// @nodoc


class _AsyncStateData<T> extends AsyncState<T> {
  const _AsyncStateData(this.data): super._();
  

 final  T data;

/// Create a copy of AsyncState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AsyncStateDataCopyWith<T, _AsyncStateData<T>> get copyWith => __$AsyncStateDataCopyWithImpl<T, _AsyncStateData<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AsyncStateData<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'AsyncState<$T>.data(data: $data)';
}


}

/// @nodoc
abstract mixin class _$AsyncStateDataCopyWith<T,$Res> implements $AsyncStateCopyWith<T, $Res> {
  factory _$AsyncStateDataCopyWith(_AsyncStateData<T> value, $Res Function(_AsyncStateData<T>) _then) = __$AsyncStateDataCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class __$AsyncStateDataCopyWithImpl<T,$Res>
    implements _$AsyncStateDataCopyWith<T, $Res> {
  __$AsyncStateDataCopyWithImpl(this._self, this._then);

  final _AsyncStateData<T> _self;
  final $Res Function(_AsyncStateData<T>) _then;

/// Create a copy of AsyncState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(_AsyncStateData<T>(
freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class _AsyncStateError<T> extends AsyncState<T> {
  const _AsyncStateError(this.error, [this.stackTrace]): super._();
  

 final  Object error;
 final  StackTrace? stackTrace;

/// Create a copy of AsyncState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AsyncStateErrorCopyWith<T, _AsyncStateError<T>> get copyWith => __$AsyncStateErrorCopyWithImpl<T, _AsyncStateError<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AsyncStateError<T>&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'AsyncState<$T>.error(error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$AsyncStateErrorCopyWith<T,$Res> implements $AsyncStateCopyWith<T, $Res> {
  factory _$AsyncStateErrorCopyWith(_AsyncStateError<T> value, $Res Function(_AsyncStateError<T>) _then) = __$AsyncStateErrorCopyWithImpl;
@useResult
$Res call({
 Object error, StackTrace? stackTrace
});




}
/// @nodoc
class __$AsyncStateErrorCopyWithImpl<T,$Res>
    implements _$AsyncStateErrorCopyWith<T, $Res> {
  __$AsyncStateErrorCopyWithImpl(this._self, this._then);

  final _AsyncStateError<T> _self;
  final $Res Function(_AsyncStateError<T>) _then;

/// Create a copy of AsyncState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,Object? stackTrace = freezed,}) {
  return _then(_AsyncStateError<T>(
null == error ? _self.error : error ,freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

// dart format on
