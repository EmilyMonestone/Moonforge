import 'package:freezed_annotation/freezed_annotation.dart';

part 'async_state.freezed.dart';

/// Represents the state of an asynchronous operation.
@freezed
class AsyncState<T> with _$AsyncState<T> {
  const AsyncState._();

  const factory AsyncState.idle() = _AsyncStateIdle<T>;

  const factory AsyncState.loading() = _AsyncStateLoading<T>;

  const factory AsyncState.data(T data) = _AsyncStateData<T>;

  const factory AsyncState.error(Object error, [StackTrace? stackTrace]) =
      _AsyncStateError<T>;

  bool get isIdle => this is _AsyncStateIdle<T>;

  bool get isLoading => this is _AsyncStateLoading<T>;

  bool get hasData => this is _AsyncStateData<T>;

  bool get hasError => this is _AsyncStateError<T>;

  T? get dataOrNull =>
      maybeMap(data: (state) => state.data, orElse: () => null);

  Object? get errorOrNull =>
      maybeMap(error: (state) => state.error, orElse: () => null);

  StackTrace? get stackTraceOrNull =>
      maybeMap(error: (state) => state.stackTrace, orElse: () => null);
}
