import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key, @pathParam required this.campaignId});

  final String campaignId;

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
