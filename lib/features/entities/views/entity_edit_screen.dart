import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class EntityEditScreen extends StatelessWidget {
  const EntityEditScreen({
    super.key,
    @pathParam required this.campaignId,
    @pathParam required this.entityId,
  });

  final String campaignId;
  final String entityId;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
