import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class PartyEditScreen extends StatelessWidget {
  const PartyEditScreen({super.key, @pathParam required this.partyId});

  final String partyId;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
