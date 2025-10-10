import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MemberScreen extends StatelessWidget {
  const MemberScreen({
    super.key,
    @pathParam required this.partyId,
    @pathParam required this.memberId,
  });

  final String partyId;
  final String memberId;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
