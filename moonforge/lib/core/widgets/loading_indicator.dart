import 'package:flutter/material.dart';

/// A reusable centered loading indicator that optionally shows a message.
///
/// ```dart
/// return const LoadingIndicator(message: 'Loading campaigns...');
/// ```
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final columnChildren = <Widget>[
      const CircularProgressIndicator(),
      if (message != null) ...[
        const SizedBox(height: 16),
        Text(
          message!,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: columnChildren),
      ),
    );
  }
}

/// A compact spinner for inline states such as buttons or list rows.
///
/// ```dart
/// child: isSaving
///     ? const InlineLoadingIndicator()
///     : Text(l10n.save);
/// ```
class InlineLoadingIndicator extends StatelessWidget {
  const InlineLoadingIndicator({super.key, this.size = 18});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
