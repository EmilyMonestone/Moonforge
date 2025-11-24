import 'package:flutter/material.dart';
import 'package:moonforge/core/di/service_locator.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/data/repo/encounter_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/encounters/services/encounter_difficulty_service.dart';
import 'package:moonforge/features/encounters/views/initiative_tracker_view.dart';
import 'package:moonforge/features/encounters/widgets/add_combatant_dialog.dart';
import 'package:moonforge/features/encounters/widgets/edit_combatant_dialog.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class EncounterEditView extends StatefulWidget {
  const EncounterEditView({super.key, required this.encounterId});

  final String encounterId;

  @override
  State<EncounterEditView> createState() => _EncounterEditViewState();
}

class _EncounterEditViewState extends State<EncounterEditView> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Party selection state
  List /*<Player>*/ _players = [];
  String? _selectedPartyId;
  bool _useCustomParty = true;
  final List<int> _customPlayerLevels = [
    1,
    1,
    1,
    1,
  ]; // Default 4 level 1 players

  // Combatants state
  final List<db.Combatant> _combatants = [];

  // Calculated values
  Map<String, int> _partyThresholds = {};
  int _adjustedXp = 0;
  String _difficulty = 'trivial';

  @override
  void initState() {
    super.initState();
    _calculateDifficulty();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _calculateDifficulty() {
    // Calculate party thresholds
    final playerLevels = _useCustomParty
        ? _customPlayerLevels
        : _players.map((p) => p.level as int).toList();

    _partyThresholds = EncounterDifficultyService.calculatePartyThresholds(
      playerLevels,
    );

    // Calculate adjusted XP from combatants
    final monsterXp = _combatants
        .where((c) => !c.isAlly)
        .map((c) => c.xp)
        .toList();

    _adjustedXp = EncounterDifficultyService.calculateAdjustedXp(
      monsterXp,
      playerLevels.length,
    );

    // Classify difficulty
    _difficulty = EncounterDifficultyService.classifyDifficulty(
      _adjustedXp,
      _partyThresholds,
    );

    setState(() {});
  }

  void _addCombatant(db.Combatant combatant) {
    setState(() {
      _combatants.add(combatant);
      _calculateDifficulty();
    });
  }

  void _removeCombatant(int index) {
    setState(() {
      _combatants.removeAt(index);
      _calculateDifficulty();
    });
  }

  void _updateCustomPlayerLevel(int index, int level) {
    setState(() {
      _customPlayerLevels[index] = level.clamp(1, 20);
      _calculateDifficulty();
    });
  }

  void _addCustomPlayer() {
    setState(() {
      _customPlayerLevels.add(1);
      _calculateDifficulty();
    });
  }

  void _removeCustomPlayer(int index) {
    if (_customPlayerLevels.length > 1) {
      setState(() {
        _customPlayerLevels.removeAt(index);
        _calculateDifficulty();
      });
    }
  }

  // Load party players from Drift
  Future<void> _loadPartyPlayers(String partyId) async {
    try {
      // TODO: Implement players when Player model/repo exists in Drift.
      setState(() {
        _players = [];
        _selectedPartyId = partyId;
        _calculateDifficulty();
      });
    } catch (e) {
      // Handle error silently for now
    }
  }

  // Save encounter to database
  Future<void> _saveEncounter() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final campaign = Provider.of<CampaignProvider>(
        context,
        listen: false,
      ).currentCampaign;
      if (campaign == null) return;

      // Convert combatants to Map format for storage
      final combatantsJson = _combatants.map((c) => c.toJson()).toList();

      final encounter = db.Encounter(
        id: widget.encounterId,
        name: _nameController.text,
        originId: campaign.id,
        preset: false,
        notes: 'Difficulty: $_difficulty, Adjusted XP: $_adjustedXp',
        loot: null,
        combatants: combatantsJson,
        entityIds: const <String>[],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 0,
      );

      final encounterRepo = getIt<EncounterRepository>();
      await encounterRepo.upsertLocal(encounter);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.save)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving: $e')));
      }
    }
  }

  // Update combatant inline
  void _updateCombatant(int index, db.Combatant updated) {
    setState(() {
      _combatants[index] = updated;
      _calculateDifficulty();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.encounterBuilder)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name
              SurfaceContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: l10n.name,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.nameRequired;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Party Selection
              SurfaceContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.partySelection,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),

                    // Toggle between custom and existing party
                    SegmentedButton<bool>(
                      segments: [
                        ButtonSegment(
                          value: true,
                          label: Text(l10n.customPlayerGroup),
                          icon: const Icon(Icons.people_outline),
                        ),
                        ButtonSegment(
                          value: false,
                          label: Text(l10n.selectParty),
                          icon: const Icon(Icons.group),
                        ),
                      ],
                      selected: {_useCustomParty},
                      onSelectionChanged: (Set<bool> newSelection) {
                        setState(() {
                          _useCustomParty = newSelection.first;
                          _calculateDifficulty();
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Custom player group
                    if (_useCustomParty) ...[
                      Text(
                        '${l10n.partySize}: ${_customPlayerLevels.length}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      ..._customPlayerLevels.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  initialValue: entry.value,
                                  decoration: InputDecoration(
                                    labelText:
                                        '${l10n.player} ${entry.key + 1}',
                                    border: const OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                  items: List.generate(20, (i) => i + 1)
                                      .map(
                                        (level) => DropdownMenuItem(
                                          value: level,
                                          child: Text(
                                            '${l10n.playerLevel} $level',
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      _updateCustomPlayerLevel(
                                        entry.key,
                                        value,
                                      );
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: _customPlayerLevels.length > 1
                                    ? () => _removeCustomPlayer(entry.key)
                                    : null,
                              ),
                            ],
                          ),
                        );
                      }),
                      ElevatedButton.icon(
                        onPressed: _addCustomPlayer,
                        icon: const Icon(Icons.add),
                        label: Text(l10n.addPlayer),
                      ),
                    ]
                    // Existing party selection (placeholder for future implementation)
                    else ...[
                      FutureBuilder<List<Map<String, String>>>(
                        future: _loadParties(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final parties = snapshot.data ?? [];
                          if (parties.isEmpty) {
                            return Text(
                              l10n.noPartySelected,
                              style: Theme.of(context).textTheme.bodyMedium,
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownButtonFormField<String>(
                                initialValue: _selectedPartyId,
                                decoration: InputDecoration(
                                  labelText: l10n.selectParty,
                                  border: const OutlineInputBorder(),
                                ),
                                items: parties
                                    .map(
                                      (party) => DropdownMenuItem(
                                        value: party['id'],
                                        child: Text(
                                          party['name'] ??
                                              'Party ${party['id']}',
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    _loadPartyPlayers(value);
                                  }
                                },
                              ),
                              if (_players.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  '${l10n.partySize}: ${_players.length} players',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                ...List.generate(_players.length, (i) {
                                  final player = _players[i];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      '• ${player.name} (Level ${player.level})',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  );
                                }),
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Encounter Difficulty Display
              SurfaceContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.encounterDifficulty,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),

                    // XP Thresholds
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildThresholdChip(
                          context,
                          l10n.easy,
                          _partyThresholds['easy'] ?? 0,
                          Colors.green,
                        ),
                        _buildThresholdChip(
                          context,
                          l10n.medium,
                          _partyThresholds['medium'] ?? 0,
                          Colors.yellow,
                        ),
                        _buildThresholdChip(
                          context,
                          l10n.hard,
                          _partyThresholds['hard'] ?? 0,
                          Colors.orange,
                        ),
                        _buildThresholdChip(
                          context,
                          l10n.deadly,
                          _partyThresholds['deadly'] ?? 0,
                          Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Adjusted XP and Difficulty
                    Card(
                      color: _getDifficultyColor(
                        _difficulty,
                      ).withValues(alpha: 0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${l10n.adjustedXp}:',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  '$_adjustedXp XP',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${l10n.encounterDifficulty}:',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Chip(
                                  label: Text(
                                    _getDifficultyLabel(l10n, _difficulty),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  backgroundColor: _getDifficultyColor(
                                    _difficulty,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Combatants List
              SurfaceContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.addCombatant,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IconButton(
                          onPressed: () => _showAddCombatantDialog(context),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (_combatants.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('No combatants added yet'),
                        ),
                      )
                    else
                      ..._combatants.asMap().entries.map((entry) {
                        final combatant = entry.value;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(
                              combatant.isAlly ? Icons.shield : Icons.dangerous,
                              color: combatant.isAlly
                                  ? Colors.blue
                                  : Colors.red,
                            ),
                            title: Text(combatant.name),
                            subtitle: Text(
                              'CR ${combatant.cr ?? '?'} • ${combatant.xp} XP • HP ${combatant.currentHp}/${combatant.maxHp} • AC ${combatant.armorClass}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () => _showEditCombatantDialog(
                                    context,
                                    entry.key,
                                    combatant,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _removeCombatant(entry.key),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Start Initiative Tracker Button
              if (_combatants.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _startInitiativeTracker,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(l10n.startEncounter),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveEncounter,
        icon: const Icon(Icons.save),
        label: Text(l10n.save),
      ),
    );
  }

  Widget _buildThresholdChip(
    BuildContext context,
    String label,
    int value,
    Color color,
  ) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        Chip(
          label: Text(
            '$value',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: color.withValues(alpha: 0.2),
          side: BorderSide(color: color),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'trivial':
        return Colors.grey;
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.yellow.shade700;
      case 'hard':
        return Colors.orange;
      case 'deadly':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getDifficultyLabel(AppLocalizations l10n, String difficulty) {
    switch (difficulty) {
      case 'trivial':
        return l10n.trivial;
      case 'easy':
        return l10n.easy;
      case 'medium':
        return l10n.medium;
      case 'hard':
        return l10n.hard;
      case 'deadly':
        return l10n.deadly;
      default:
        return difficulty;
    }
  }

  Future<List<Map<String, String>>> _loadParties() async {
    try {
      // Parties stream not wired here; returning empty list for now.
      return [];
    } catch (e) {
      return [];
    }
  }

  void _showAddCombatantDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddCombatantDialog(onAdd: _addCombatant),
    );
  }

  void _showEditCombatantDialog(
    BuildContext context,
    int index,
    db.Combatant combatant,
  ) {
    showDialog(
      context: context,
      builder: (context) => EditCombatantDialog(
        combatant: combatant,
        onUpdate: (updated) => _updateCombatant(index, updated),
      ),
    );
  }

  void _startInitiativeTracker() {
    if (_combatants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add combatants before starting initiative tracker'),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InitiativeTrackerView(
          initialCombatants: _combatants,
          encounterName: _nameController.text.isEmpty
              ? 'Encounter'
              : _nameController.text,
        ),
      ),
    );
  }
}
