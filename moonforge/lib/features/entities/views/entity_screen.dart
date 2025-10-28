import 'package:flutter/material.dart';
import 'package:moonforge/features/entities/views/entity_screen_impl.dart';

class EntityScreen extends StatelessWidget {
  const EntityScreen({super.key, required this.entityId});

  final String entityId;

  @override
  Widget build(BuildContext context) {
    return EntityScreenImpl(entityId: entityId);
  }
}
