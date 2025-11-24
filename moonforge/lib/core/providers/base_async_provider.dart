import 'package:flutter/foundation.dart';
import 'package:moonforge/core/models/async_state.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Base class for providers that expose a single async `state`.
abstract class BaseAsyncProvider<T> extends ChangeNotifier {
  AsyncState<T> _state = const AsyncState.idle();

  AsyncState<T> get state => _state;

  @protected
  void updateState(AsyncState<T> newState) {
    _state = newState;
    notifyListeners();
  }

  @protected
  Future<void> executeAsync(Future<T> Function() operation) async {
    updateState(const AsyncState.loading());
    try {
      final result = await operation();
      updateState(AsyncState.data(result));
    } catch (error, stackTrace) {
      logger.e('Async operation failed', error: error, stackTrace: stackTrace);
      updateState(AsyncState.error(error, stackTrace));
    }
  }

  void reset() => updateState(const AsyncState.idle());
}
