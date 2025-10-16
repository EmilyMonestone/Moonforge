import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';

class PartyScreen extends StatelessWidget {
  const PartyScreen({super.key, required this.partyId});

  final String partyId;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Member A'),
          subtitle: Text('party $partyId'),
          onTap: () => MemberRoute(partyId: partyId, memberId: 'a').go(context),
        ),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Member B'),
          subtitle: Text('party $partyId'),
          onTap: () => MemberRoute(partyId: partyId, memberId: 'b').go(context),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.event_note_outlined),
          title: const Text('Session 1'),
          subtitle: Text('party $partyId'),
          onTap: () =>
              SessionRoute(partyId: partyId, sessionId: '1').go(context),
        ),
      ],
    );
  }
}
