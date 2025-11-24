import 'package:flutter/material.dart';
import 'package:moonforge/core/models/async_state.dart';
import 'package:moonforge/core/utils/error_handler.dart';
import 'package:moonforge/core/widgets/error_display.dart';
import 'package:moonforge/core/widgets/loading_indicator.dart';

class AsyncStateBuilder<T> extends StatelessWidget {
  const AsyncStateBuilder({
    super.key,
    required this.state,
    required this.builder,
    this.onLoading,
    this.onError,
    this.onIdle,
    this.onRetry,
  });

  final AsyncState<T> state;
  final Widget Function(BuildContext context, T data) builder;
  final WidgetBuilder? onLoading;
  final Widget Function(BuildContext context, Object error)? onError;
  final WidgetBuilder? onIdle;
  final Future<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return state.when(
      idle: () => onIdle?.call(context) ?? const SizedBox.shrink(),
      loading: () => onLoading?.call(context) ?? const LoadingIndicator(),
      data: (data) => builder(context, data),
      error: (error, stackTrace) {
        ErrorHandler.log(error, stackTrace);
        return onError?.call(context, error) ??
            ErrorDisplay(title: ErrorHandler.message(error), onRetry: onRetry);
      },
    );
  }
}
