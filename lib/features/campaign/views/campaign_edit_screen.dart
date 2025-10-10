import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CampaignEditScreen extends StatelessWidget {
  const CampaignEditScreen({super.key, @pathParam required this.campaignId});

  final String campaignId;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
