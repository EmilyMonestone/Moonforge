import 'package:flutter/material.dart';
import 'package:moonforge/core/design/domain_visuals.dart';
import 'package:moonforge/core/di/service_locator.dart';
import 'package:moonforge/core/models/domain_type.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/party_repository.dart';
import 'package:moonforge/data/repo/player_repository.dart';
import 'package:moonforge/features/parties/widgets/party_card.dart';

/// Screen displaying a list of all parties
class PartyListView extends StatelessWidget {
  const PartyListView({super.key});

  @override
  Widget build(BuildContext context) {
    final partyRepo = getIt<PartyRepository>();
    final playerRepo = getIt<PlayerRepository>();

    return StreamBuilder<List<Party>>(
      stream: partyRepo.watchAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
              ],
            ),
          );
        }

        final parties = snapshot.data ?? [];

        if (parties.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  DomainType.party.icon,
                  size: 64,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No parties yet',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first party to get started',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: parties.length,
          itemBuilder: (context, index) {
            final party = parties[index];
            return FutureBuilder<int>(
              future: _getMemberCount(playerRepo, party),
              builder: (context, memberSnapshot) {
                final memberCount = memberSnapshot.data ?? 0;
                return PartyCard(party: party, memberCount: memberCount);
              },
            );
          },
        );
      },
    );
  }

  Future<int> _getMemberCount(PlayerRepository repo, Party party) async {
    if (party.memberPlayerIds == null || party.memberPlayerIds!.isEmpty) {
      return 0;
    }

    int count = 0;
    for (final playerId in party.memberPlayerIds!) {
      final player = await repo.getById(playerId);
      if (player != null && !player.deleted) {
        count++;
      }
    }
    return count;
  }
}
