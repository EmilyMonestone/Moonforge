import 'package:flutter/material.dart';
import 'package:moonforge/core/di/service_locator.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/party_repository.dart';
import 'package:moonforge/features/parties/services/party_service.dart';
import 'package:moonforge/features/parties/widgets/character_card.dart';
import 'package:moonforge/features/parties/widgets/party_composition_widget.dart';
import 'package:moonforge/features/parties/widgets/party_stats_widget.dart';

class PartyView extends StatelessWidget {
  const PartyView({super.key, required this.partyId});

  final String partyId;

  @override
  Widget build(BuildContext context) {
    final partyService = getIt<PartyService>();
    final partyRepo = getIt<PartyRepository>();

    return FutureBuilder<Party?>(
      future: partyRepo.getById(partyId),
      builder: (context, partySnapshot) {
        if (partySnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (partySnapshot.hasError || partySnapshot.data == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 16),
                Text('Party not found'),
              ],
            ),
          );
        }

        final party = partySnapshot.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Party Header
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        party.name,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (party.summary != null &&
                          party.summary!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(party.summary!),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Party Statistics and Composition
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PartyStatsWidget(
                      partyId: partyId,
                      partyService: partyService,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PartyCompositionWidget(
                      partyId: partyId,
                      partyService: partyService,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Party Members
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Members',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder<List<Player>>(
                        future: partyService.getPartyMembers(partyId),
                        builder: (context, membersSnapshot) {
                          if (membersSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final members = membersSnapshot.data ?? [];

                          if (members.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: Text('No members in this party'),
                              ),
                            );
                          }

                          return Column(
                            children: members.map((member) {
                              return CharacterCard(
                                player: member,
                                partyId: partyId,
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
