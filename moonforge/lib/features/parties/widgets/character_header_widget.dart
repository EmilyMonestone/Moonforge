import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';

/// Header widget showing character name, level, class, and race
class CharacterHeaderWidget extends StatelessWidget {
  final Player player;

  const CharacterHeaderWidget({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              player.name,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildInfoChip(
                  context,
                  'Level ${player.level}',
                  Icons.trending_up,
                ),
                _buildInfoChip(context, player.className, Icons.shield),
                if (player.subclass != null && player.subclass!.isNotEmpty)
                  _buildInfoChip(context, player.subclass!, Icons.auto_awesome),
                if (player.race != null && player.race!.isNotEmpty)
                  _buildInfoChip(context, player.race!, Icons.person),
                if (player.background != null && player.background!.isNotEmpty)
                  _buildInfoChip(
                    context,
                    player.background!,
                    Icons.history_edu,
                  ),
              ],
            ),
            if (player.alignment != null && player.alignment!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Alignment: ${player.alignment}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}
