import 'package:flutter/material.dart';
import 'package:moonforge/features/entities/views/entity_edit_screen_impl.dart';

class EntityEditScreen extends StatelessWidget {
  const EntityEditScreen({super.key, required this.entityId});

  final String entityId;

  @override
  Widget build(BuildContext context) {
    return EntityEditScreenImpl(entityId: entityId);
  }
}
