import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SessionScreen extends StatelessWidget {
  const SessionScreen({
    super.key,
    @pathParam required this.partyId,
    @pathParam required this.sessionId,
  });

  final String partyId;
  final String sessionId;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
