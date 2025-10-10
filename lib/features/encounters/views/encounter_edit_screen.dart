import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class EncounterEditScreen extends StatelessWidget {
  const EncounterEditScreen({
    super.key,
    @pathParam required this.campaignId,
    @pathParam required this.encoutnerId,
  });

  final String campaignId;
  final String encoutnerId;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
