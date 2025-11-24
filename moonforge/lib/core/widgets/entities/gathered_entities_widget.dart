import 'package:flutter/material.dart';
import 'package:moonforge/core/services/entity_gatherer.dart';
import 'package:moonforge/core/widgets/entities_widget.dart';

/// Generic wrapper that shows loading/error state around an entities Future.
class GatheredEntitiesWidget extends StatelessWidget {
  final Future<List<EntityWithOrigin>> future;
  final String? logTag;

  const GatheredEntitiesWidget({super.key, required this.future, this.logTag});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EntityWithOrigin>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          // Keep simple error feedback here; callers can log as needed.
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final result = snapshot.data ?? const <EntityWithOrigin>[];
        return EntitiesWidget(entities: result);
      },
    );
  }
}
