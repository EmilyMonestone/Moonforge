import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/player_repository.dart';
import 'package:moonforge/features/parties/services/player_character_service.dart';
import 'package:moonforge/features/parties/widgets/character_sheet_widget.dart';
import 'package:provider/provider.dart';

class MemberScreen extends StatelessWidget {
  const MemberScreen({
    super.key,
    required this.partyId,
    required this.memberId,
  });

  final String partyId;
  final String memberId;

  @override
  Widget build(BuildContext context) {
    final playerRepo = Provider.of<PlayerRepository>(context, listen: false);
    final characterService = PlayerCharacterService(playerRepo);

    return FutureBuilder<Player?>(
      future: playerRepo.getById(memberId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 16),
                const Text('Character not found'),
              ],
            ),
          );
        }

        final player = snapshot.data!;

        return CharacterSheetWidget(
          player: player,
          characterService: characterService,
        );
      },
    );
  }
}
