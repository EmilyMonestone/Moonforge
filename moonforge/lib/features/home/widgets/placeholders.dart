import 'package:flutter/material.dart';

/// Small placeholder shown while content is loading.
class LoadingPlaceholder extends StatelessWidget {
  const LoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

/// Placeholder when there is simply no content to show.
class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

/// Placeholder displayed when an error occurs.
class ErrorPlaceholder extends StatelessWidget {
  const ErrorPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Center(child: Icon(Icons.error_outline)),
    );
  }
}
