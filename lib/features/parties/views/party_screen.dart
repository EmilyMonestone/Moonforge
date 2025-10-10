import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class PartyScreen extends StatelessWidget {
  const PartyScreen({super.key, @pathParam required this.partyId});

  final String partyId;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
