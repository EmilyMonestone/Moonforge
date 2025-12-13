import 'package:flutter/material.dart';
import 'package:moonforge/core/providers/bestiary_provider.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/encounters/services/encounter_difficulty_service.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

/// Dialog that allows selecting a combatant from the Bestiary or from campaign entities.
class AddCombatantDialog extends StatefulWidget {
  final Function(db.Combatant) onAdd;

  const AddCombatantDialog({super.key, required this.onAdd});

  @override
  State<AddCombatantDialog> createState() => _AddCombatantDialogState();
}

class _AddCombatantDialogState extends State<AddCombatantDialog> {
  int _selectedTab = 0; // 0: Bestiary, 1: Campaign Entities

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      child: Container(
        width: 600,
        height: 600,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.selectMonster,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            // Tab selector
            SegmentedButton<int>(
              segments: [
                ButtonSegment(
                  value: 0,
                  label: Text(l10n.fromBestiary),
                  icon: const Icon(Icons.book),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text(l10n.fromCampaign),
                  icon: const Icon(Icons.campaign),
                ),
              ],
              selected: {_selectedTab},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _selectedTab = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 16),

            // Content based on selected tab
            Expanded(
              child: _selectedTab == 0
                  ? BestiaryMonsterList(onAdd: widget.onAdd)
                  : CampaignEntityList(onAdd: widget.onAdd),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stateless list rendering bestiary monsters and translating into Combatant objects.
class BestiaryMonsterList extends StatelessWidget {
  final Function(db.Combatant) onAdd;

  const BestiaryMonsterList({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bestiaryProvider = Provider.of<BestiaryProvider>(context);

    if (bestiaryProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (bestiaryProvider.hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.errorSomethingWentWrong),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => bestiaryProvider.loadCreatures(forceSync: true),
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    final creatures = bestiaryProvider.creatures;

    if (creatures.isEmpty) {
      return Center(child: Text(l10n.emptyStateNoItems));
    }

    return ListView.builder(
      itemCount: creatures.length,
      itemBuilder: (context, index) {
        final creature = creatures[index] as Map<String, dynamic>;
        final name = creature['name'] as String? ?? 'Unknown';
        final cr = creature['cr'] as String? ?? '0';
        final xp = EncounterDifficultyService.getXpForCr(cr);
        final hp = _parseHp(creature['hp']);
        final ac = _parseAc(creature['ac']);

        return ListTile(
          title: Text(name),
          subtitle: Text('CR $cr • $xp XP • HP $hp • AC $ac'),
          trailing: IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              final combatant = db.Combatant(
                id: 'monster_${const Uuid().v4()}',
                encounterId: 'local',
                name: name,
                type: 'monster',
                isAlly: false,
                currentHp: hp,
                maxHp: hp,
                armorClass: ac,
                initiative: null,
                initiativeModifier: 0,
                entityId: null,
                bestiaryName: name,
                cr: cr,
                xp: xp,
                conditions: const <String>[],
                notes: null,
                order: DateTime.now().microsecondsSinceEpoch % 1000000,
              );
              onAdd(combatant);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  int _parseHp(dynamic hp) {
    if (hp == null) return 10;
    if (hp is int) return hp;
    if (hp is Map) {
      final average = hp['average'];
      if (average is int) return average;
    }
    return 10;
  }

  int _parseAc(dynamic ac) {
    if (ac == null) return 10;
    if (ac is int) return ac;
    if (ac is List && ac.isNotEmpty) {
      final first = ac[0];
      if (first is int) return first;
      if (first is Map) {
        final acValue = first['ac'];
        if (acValue is int) return acValue;
      }
    }
    return 10;
  }
}

/// Stateless list rendering campaign entities (monsters/npcs with statblocks)
class CampaignEntityList extends StatelessWidget {
  final Function(db.Combatant) onAdd;

  const CampaignEntityList({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = Provider.of<CampaignProvider>(context).currentCampaign;

    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }

    // Expect a StreamProvider<List<db.Entity>> to be in scope where this widget is used.
    final allEntities = context.watch<List<db.Entity>>();

    final entities = allEntities.where((e) {
      return (e.kind == 'monster' || e.kind == 'npc') && e.statblock.isNotEmpty;
    }).toList();

    if (entities.isEmpty) {
      return const Center(
        child: Text('No monsters or NPCs with statblocks found in campaign'),
      );
    }

    return ListView.builder(
      itemCount: entities.length,
      itemBuilder: (context, index) {
        final entity = entities[index];
        final statblock = entity.statblock;
        final cr = statblock['cr'] as String? ?? '0';
        final xp = EncounterDifficultyService.getXpForCr(cr);
        final hp = (statblock['hp'] as int?) ?? 10;
        final ac = (statblock['ac'] as int?) ?? 10;

        return ListTile(
          title: Text(entity.name),
          subtitle: Text('CR $cr • $xp XP • HP $hp • AC $ac'),
          trailing: IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              final combatant = db.Combatant(
                id: 'entity_${const Uuid().v4()}',
                encounterId: 'local',
                name: entity.name,
                type: entity.kind == 'npc' ? 'npc' : 'monster',
                isAlly: false,
                currentHp: hp,
                maxHp: hp,
                armorClass: ac,
                initiative: null,
                initiativeModifier: 0,
                entityId: entity.id,
                bestiaryName: null,
                cr: cr,
                xp: xp,
                conditions: const <String>[],
                notes: null,
                order: DateTime.now().microsecondsSinceEpoch % 1000000,
              );
              onAdd(combatant);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
