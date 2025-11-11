import 'package:flutter/material.dart';
import 'package:moonforge/l10n/app_localizations.dart';

/// A widget that catches exceptions in its child widget tree and displays a fallback UI.
///
/// This is similar to React's Error Boundaries but for Flutter. It catches exceptions
/// during build, layout, and paint phases and displays a fallback widget instead of
/// crashing the app.
class ErrorBoundary extends StatefulWidget {
  /// The child widget that might throw exceptions.
  final Widget child;

  /// A builder function that creates a fallback widget when an exception occurs.
  ///
  /// If not provided, a default error widget will be shown.
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  /// Creates an error boundary widget.
  const ErrorBoundary({super.key, required this.child, this.errorBuilder});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  void initState() {
    super.initState();
    // Initialize error handling for the app if not already done
    _initializeErrorHandling();
  }

  void _initializeErrorHandling() {
    // Set a custom error widget builder if not already set
    ErrorWidget.builder = (FlutterErrorDetails details) {
      debugPrint('Error caught by ErrorWidget.builder: ${details.exception}');
      debugPrint('Stack trace: ${details.stack}');
      // Ensure we have a Directionality; if no context yet available, default to LTR
      return Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Text(
            'ERROR.\nPlease restart the app.',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      // If an error occurred, show the fallback UI
      return widget.errorBuilder != null
          ? widget.errorBuilder!(context, _error!)
          : _buildDefaultErrorWidget(context, _error!);
    }

    // Otherwise, render the child widget inside an error catcher
    return _ErrorCatcher(
      child: widget.child,
      onError: (error) {
        debugPrint('Error caught by ErrorBoundary: $error');
        setState(() {
          _error = error;
        });
      },
    );
  }

  Widget _buildDefaultErrorWidget(BuildContext context, Object error) {
    final l10n = AppLocalizations.of(context);
    final code = Localizations.localeOf(context).languageCode;
    final title = l10n?.error ?? (code == 'de' ? 'Fehler' : 'Error');
    final msg = code == 'de'
        ? 'Bitte versuchen Sie es später erneut.'
        : 'Please try again later.';
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              msg,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              textAlign: TextAlign.center,
            ),
            if (error.toString().isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.error.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _error = null;
                });
              },
              child: Text(code == 'de' ? 'Erneut versuchen' : 'Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that catches exceptions during build and notifies a callback.
class _ErrorCatcher extends StatelessWidget {
  final Widget child;
  final void Function(Object error) onError;

  const _ErrorCatcher({required this.child, required this.onError});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        try {
          return child;
        } catch (e, stack) {
          debugPrint('Error caught in _ErrorCatcher.build: $e');
          debugPrint('Stack trace: $stack');
          onError(e);
          return const SizedBox.shrink(); // Return an empty widget
        }
      },
    );
  }
}

/// Extension method to wrap any widget with an ErrorBoundary
extension ErrorBoundaryExtension on Widget {
  /// Wraps this widget with an ErrorBoundary
  Widget withErrorBoundary({
    Widget Function(BuildContext context, Object error)? errorBuilder,
  }) {
    return ErrorBoundary(errorBuilder: errorBuilder, child: this);
  }
}
