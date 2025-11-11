import 'package:flutter/material.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/data/db/app_db.dart';

/// Card widget for displaying a character in a list
class CharacterCard extends StatelessWidget {
  final Player player;
  final String? partyId;

  const CharacterCard({super.key, required this.player, this.partyId});

  @override
  Widget build(BuildContext context) {
    final hpPercentage = (player.hpMax != null && player.hpMax! > 0)
        ? (player.hpCurrent ?? 0) / player.hpMax!
        : 1.0;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(player.name.substring(0, 1).toUpperCase()),
        ),
        title: Text(player.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Level ${player.level} ${player.className}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: hpPercentage,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getHpColor(hpPercentage),
                    ),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${player.hpCurrent ?? 0}/${player.hpMax ?? 0}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (partyId != null) {
            MemberRouteData(partyId: partyId!, memberId: player.id).go(context);
          }
        },
      ),
    );
  }

  Color _getHpColor(double percentage) {
    if (percentage > 0.5) {
      return Colors.green;
    } else if (percentage > 0.25) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
