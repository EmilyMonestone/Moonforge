import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          onTap: () => context.go('/party/$partyId/member/a'),
        ),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Member B'),
          subtitle: Text('party $partyId'),
          onTap: () => context.go('/party/$partyId/member/b'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.event_note_outlined),
          title: const Text('Session 1'),
          subtitle: Text('party $partyId'),
          onTap: () => context.go('/party/$partyId/session/1'),
        ),
      ],
    );
  }
}
