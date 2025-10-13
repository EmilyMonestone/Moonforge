import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.gr.dart';
import 'package:moonforge/layout/two_pane_layout.dart';

@RoutePage()
class PartyScreen extends StatelessWidget {
  const PartyScreen({super.key, @pathParam required this.partyId});

  final String partyId;

  @override
  Widget build(BuildContext context) {
    final childRouter = AutoRouter.of(context);
    final hasDetail = childRouter.currentChild != null;

    Widget master = ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Member A'),
          subtitle: Text('party $partyId'),
          onTap: () =>
              context.router.push(MemberRoute(partyId: partyId, memberId: 'a')),
        ),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Member B'),
          subtitle: Text('party $partyId'),
          onTap: () =>
              context.router.push(MemberRoute(partyId: partyId, memberId: 'b')),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.event_note_outlined),
          title: const Text('Session 1'),
          subtitle: Text('party $partyId'),
          onTap: () => context.router.push(
            SessionRoute(partyId: partyId, sessionId: '1'),
          ),
        ),
      ],
    );

    return TwoPaneLayout(
      master: master,
      detail: const AutoRouter(),
      showDetail: hasDetail,
      onCloseDetail: () {
        // If user dismisses bottom sheet, navigate back to master-only.
        context.router.maybePop();
      },
    );
  }
}
