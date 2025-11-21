import 'package:flutter/material.dart';
import 'package:moonforge/core/design/domain_visuals.dart';
import 'package:moonforge/core/models/domain_type.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/parties/services/player_character_service.dart';
import 'package:moonforge/features/parties/widgets/ability_scores_widget.dart';
import 'package:moonforge/features/parties/widgets/character_header_widget.dart';
import 'package:moonforge/features/parties/widgets/hp_tracker_widget.dart';
import 'package:moonforge/features/parties/widgets/saving_throws_widget.dart';
import 'package:moonforge/features/parties/widgets/skill_list_widget.dart';

/// Complete character sheet widget combining all character information
class CharacterSheetWidget extends StatelessWidget {
  final Player player;
  final PlayerCharacterService characterService;

  const CharacterSheetWidget({
    super.key,
    required this.player,
    required this.characterService,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Character Header (Name, Level, Class, Race)
          CharacterHeaderWidget(player: player),

          const SizedBox(height: 16),

          // Core Stats Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HP Tracker
              Expanded(child: HpTrackerWidget(player: player)),

              const SizedBox(width: 16),

              // Core Combat Stats
              Expanded(child: _buildCombatStatsCard(context)),
            ],
          ),

          const SizedBox(height: 16),

          // Ability Scores
          AbilityScoresWidget(player: player),

          const SizedBox(height: 16),

          // Saving Throws and Skills
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SavingThrowsWidget(
                  player: player,
                  characterService: characterService,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SkillListWidget(
                  player: player,
                  characterService: characterService,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Additional Info
          if (player.features != null && player.features!.isNotEmpty)
            _buildFeaturesCard(context),

          if (player.equipment != null && player.equipment!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildEquipmentCard(context),
          ],

          if (player.spells != null && player.spells!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSpellsCard(context),
          ],
        ],
      ),
    );
  }

  Widget _buildCombatStatsCard(BuildContext context) {
    final initiative = characterService.getInitiativeModifier(player);
    final passivePerception = characterService.getPassivePerception(player);
    final proficiencyBonus =
        player.proficiencyBonus ?? ((player.level - 1) ~/ 4) + 2;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Combat Stats',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              context,
              'Armor Class',
              player.ac?.toString() ?? '10',
            ),
            _buildStatRow(
              context,
              'Initiative',
              initiative >= 0 ? '+$initiative' : '$initiative',
            ),
            _buildStatRow(context, 'Speed', '${player.speed ?? 30} ft'),
            _buildStatRow(context, 'Proficiency Bonus', '+$proficiencyBonus'),
            _buildStatRow(
              context,
              'Passive Perception',
              passivePerception.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Features & Traits',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...player.features!.map(
              (feature) => ListTile(
                dense: true,
                title: Text(feature['name'] ?? 'Unknown Feature'),
                subtitle: feature['description'] != null
                    ? Text(feature['description'])
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Equipment', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...player.equipment!.map(
              (item) => ListTile(
                dense: true,
                leading: Icon(DomainType.entityItem.icon, size: 20),
                title: Text(item),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpellsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Spells', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...player.spells!.map(
              (spell) => ListTile(
                dense: true,
                leading: const Icon(Icons.auto_fix_high, size: 20),
                title: Text(spell),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
