import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/core/services/app_router.dart';

/// Card widget for displaying a party in a list
class PartyCard extends StatelessWidget {
  final Party party;
  final int memberCount;

  const PartyCard({
    super.key,
    required this.party,
    this.memberCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(party.name.substring(0, 1).toUpperCase()),
        ),
        title: Text(party.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (party.summary != null && party.summary!.isNotEmpty)
              Text(
                party.summary!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            Text('$memberCount members'),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          PartyRoute(partyId: party.id).go(context);
        },
      ),
    );
  }
}
