import 'package:flutter/material.dart';
import 'package:moonforge/core/database/odm.dart';
import 'package:moonforge/core/models/data/entity.dart';
import 'package:moonforge/core/models/data/player.dart';
import 'package:moonforge/core/providers/bestiary_provider.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/encounters/models/combatant.dart';
import 'package:moonforge/features/encounters/services/encounter_difficulty_service.dart';
import 'package:moonforge/features/encounters/views/initiative_tracker_screen.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class EncounterEditScreen extends StatefulWidget {
  const EncounterEditScreen({super.key, required this.encounterId});

  final String encounterId;

  @override
  State<EncounterEditScreen> createState() => _EncounterEditScreenState();
}

class _EncounterEditScreenState extends State<EncounterEditScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // Party selection state
  List<Player> _players = [];
  String? _selectedPartyId;
  bool _useCustomParty = true;
  final List<int> _customPlayerLevels = [1, 1, 1, 1]; // Default 4 level 1 players
  
  // Combatants state
  final List<Combatant> _combatants = [];
  
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
        : _players.map((p) => p.level).toList();
    
    _partyThresholds = EncounterDifficultyService.calculatePartyThresholds(playerLevels);
    
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
  
  void _addCombatant(Combatant combatant) {
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
  
  // Load party players from ODM
  Future<void> _loadPartyPlayers(String partyId) async {
    final campaign = Provider.of<CampaignProvider>(context, listen: false).currentCampaign;
    if (campaign == null) return;
    
    try {
      final odm = Odm.instance;
      final party = await odm.campaigns.doc(campaign.id).parties.doc(partyId).get();
      
      if (party != null && party.memberEntityIds != null) {
        // Load player entities for each member
        final playersList = <Player>[];
        for (final entityId in party.memberEntityIds!) {
          final player = await odm.campaigns.doc(campaign.id).players.doc(entityId).get();
          if (player != null) {
            playersList.add(player);
          }
        }
        
        setState(() {
          _players = playersList;
          _selectedPartyId = partyId;
          _calculateDifficulty();
        });
      }
    } catch (e) {
      // Handle error silently for now
    }
  }
  
  // Save encounter to database
  Future<void> _saveEncounter() async {
    if (!_formKey.currentState!.validate()) return;
    
    try {
      final campaign = Provider.of<CampaignProvider>(context, listen: false).currentCampaign;
      if (campaign == null) return;
      
      // Convert combatants to Map format for storage
      final combatantsJson = _combatants.map((c) => c.toJson()).toList();
      
      final encounter = Encounter(
        id: widget.encounterId,
        name: _nameController.text,
        combatants: combatantsJson,
        notes: 'Difficulty: $_difficulty, Adjusted XP: $_adjustedXp',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final odm = Odm.instance;
      await odm.campaigns.doc(campaign.id).encounters.doc(encounter.id).set(encounter);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.save)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e')),
        );
      }
    }
  }
  
  // Update combatant inline
  void _updateCombatant(int index, Combatant updated) {
    setState(() {
      _combatants[index] = updated;
      _calculateDifficulty();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.encounterBuilder),
      ),
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
                        if (value == null || value.isEmpty) {
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
                                  value: entry.value,
                                  decoration: InputDecoration(
                                    labelText: '${l10n.player} ${entry.key + 1}',
                                    border: const OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                  items: List.generate(20, (i) => i + 1)
                                      .map((level) => DropdownMenuItem(
                                            value: level,
                                            child: Text('${l10n.playerLevel} $level'),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      _updateCustomPlayerLevel(entry.key, value);
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
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
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
                                value: _selectedPartyId,
                                decoration: InputDecoration(
                                  labelText: l10n.selectParty,
                                  border: const OutlineInputBorder(),
                                ),
                                items: parties.map((party) => DropdownMenuItem(
                                  value: party['id'],
                                  child: Text(party['name'] ?? 'Party ${party['id']}'),
                                )).toList(),
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
                                      style: Theme.of(context).textTheme.bodySmall,
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
                        _buildThresholdChip(context, l10n.easy, _partyThresholds['easy'] ?? 0, Colors.green),
                        _buildThresholdChip(context, l10n.medium, _partyThresholds['medium'] ?? 0, Colors.yellow),
                        _buildThresholdChip(context, l10n.hard, _partyThresholds['hard'] ?? 0, Colors.orange),
                        _buildThresholdChip(context, l10n.deadly, _partyThresholds['deadly'] ?? 0, Colors.red),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Adjusted XP and Difficulty
                    Card(
                      color: _getDifficultyColor(_difficulty).withOpacity(0.1),
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
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                  backgroundColor: _getDifficultyColor(_difficulty),
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
                              color: combatant.isAlly ? Colors.blue : Colors.red,
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
                                  onPressed: () => _showEditCombatantDialog(context, entry.key, combatant),
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
  
  Widget _buildThresholdChip(BuildContext context, String label, int value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 4),
        Chip(
          label: Text(
            '$value',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: color.withOpacity(0.2),
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
    final campaign = Provider.of<CampaignProvider>(context, listen: false).currentCampaign;
    if (campaign == null) return [];
    
    try {
      final odm = Odm.instance;
      final parties = await odm.campaigns.doc(campaign.id).parties.get();
      return parties.map((p) => {'id': p.id, 'name': p.name}).toList();
    } catch (e) {
      return [];
    }
  }
  
  void _showAddCombatantDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _AddCombatantDialog(
        onAdd: _addCombatant,
      ),
    );
  }
  
  void _showEditCombatantDialog(BuildContext context, int index, Combatant combatant) {
    showDialog(
      context: context,
      builder: (context) => _EditCombatantDialog(
        combatant: combatant,
        onUpdate: (updated) => _updateCombatant(index, updated),
      ),
    );
  }
  
  void _startInitiativeTracker() {
    if (_combatants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add combatants before starting initiative tracker')),
      );
      return;
    }
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InitiativeTrackerScreen(
          initialCombatants: _combatants,
          encounterName: _nameController.text.isEmpty ? 'Encounter' : _nameController.text,
        ),
      ),
    );
  }
}

// Dialog for adding combatants
class _AddCombatantDialog extends StatefulWidget {
  final Function(Combatant) onAdd;
  
  const _AddCombatantDialog({required this.onAdd});
  
  @override
  State<_AddCombatantDialog> createState() => _AddCombatantDialogState();
}

class _AddCombatantDialogState extends State<_AddCombatantDialog> {
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
                  ? _BestiaryMonsterList(onAdd: widget.onAdd)
                  : _CampaignEntityList(onAdd: widget.onAdd),
            ),
          ],
        ),
      ),
    );
  }
}

// Bestiary monster list
class _BestiaryMonsterList extends StatelessWidget {
  final Function(Combatant) onAdd;
  
  const _BestiaryMonsterList({required this.onAdd});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bestiaryProvider = Provider.of<BestiaryProvider>(context);
    
    if (bestiaryProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (bestiaryProvider.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.error),
            const SizedBox(height: 8),
            Text(bestiaryProvider.errorMessage ?? ''),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => bestiaryProvider.loadMonsters(forceSync: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    final monsters = bestiaryProvider.monsters;
    
    if (monsters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No monsters loaded'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => bestiaryProvider.loadMonsters(forceSync: true),
              child: const Text('Load Bestiary'),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: monsters.length,
      itemBuilder: (context, index) {
        final monster = monsters[index] as Map<String, dynamic>;
        final name = monster['name'] as String? ?? 'Unknown';
        final cr = monster['cr'] as String? ?? '0';
        final xp = EncounterDifficultyService.getXpForCr(cr);
        final hp = _parseHp(monster['hp']);
        final ac = _parseAc(monster['ac']);
        
        return ListTile(
          title: Text(name),
          subtitle: Text('CR $cr • $xp XP • HP $hp • AC $ac'),
          trailing: IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              final combatant = Combatant(
                id: 'monster_${DateTime.now().millisecondsSinceEpoch}',
                name: name,
                type: CombatantType.monster,
                isAlly: false,
                cr: cr,
                xp: xp,
                maxHp: hp,
                currentHp: hp,
                armorClass: ac,
                bestiaryName: name,
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

// Campaign entity list (monsters/NPCs with statblocks)
class _CampaignEntityList extends StatelessWidget {
  final Function(Combatant) onAdd;
  
  const _CampaignEntityList({required this.onAdd});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = Provider.of<CampaignProvider>(context).currentCampaign;
    
    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }
    
    return FutureBuilder<List<Entity>>(
      future: _loadCampaignMonsters(campaign.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('${l10n.error}: ${snapshot.error}'));
        }
        
        final entities = snapshot.data ?? [];
        
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
                  final combatant = Combatant(
                    id: 'entity_${DateTime.now().millisecondsSinceEpoch}',
                    name: entity.name,
                    type: entity.kind == 'npc' ? CombatantType.npc : CombatantType.monster,
                    isAlly: false,
                    cr: cr,
                    xp: xp,
                    maxHp: hp,
                    currentHp: hp,
                    armorClass: ac,
                    entityId: entity.id,
                  );
                  onAdd(combatant);
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        );
      },
    );
  }
  
  Future<List<Entity>> _loadCampaignMonsters(String campaignId) async {
    try {
      final odm = Odm.instance;
      final entities = await odm.campaigns.doc(campaignId).entities.get();
      
      // Filter for monsters and NPCs with statblocks
      return entities.where((e) {
        return (e.kind == 'monster' || e.kind == 'npc') && 
               e.statblock.isNotEmpty;
      }).toList();
    } catch (e) {
      return [];
    }
  }
}

// Dialog for editing combatants inline
class _EditCombatantDialog extends StatefulWidget {
  final Combatant combatant;
  final Function(Combatant) onUpdate;
  
  const _EditCombatantDialog({
    required this.combatant,
    required this.onUpdate,
  });
  
  @override
  State<_EditCombatantDialog> createState() => _EditCombatantDialogState();
}

class _EditCombatantDialogState extends State<_EditCombatantDialog> {
  late TextEditingController _hpController;
  late TextEditingController _maxHpController;
  late TextEditingController _acController;
  late TextEditingController _initiativeController;
  late List<String> _conditions;
  
  @override
  void initState() {
    super.initState();
    _hpController = TextEditingController(text: widget.combatant.currentHp.toString());
    _maxHpController = TextEditingController(text: widget.combatant.maxHp.toString());
    _acController = TextEditingController(text: widget.combatant.armorClass.toString());
    _initiativeController = TextEditingController(text: widget.combatant.initiative?.toString() ?? '');
    _conditions = List.from(widget.combatant.conditions);
  }
  
  @override
  void dispose() {
    _hpController.dispose();
    _maxHpController.dispose();
    _acController.dispose();
    _initiativeController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return AlertDialog(
      title: Text('Edit ${widget.combatant.name}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HP
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _hpController,
                    decoration: InputDecoration(
                      labelText: l10n.hitPoints,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Text('/'),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _maxHpController,
                    decoration: InputDecoration(
                      labelText: 'Max HP',
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // AC
            TextField(
              controller: _acController,
              decoration: InputDecoration(
                labelText: l10n.armorClass,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            
            // Initiative
            TextField(
              controller: _initiativeController,
              decoration: InputDecoration(
                labelText: l10n.initiative,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            
            // Conditions
            Text(
              l10n.conditions,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ..._conditions.map((condition) => Chip(
                  label: Text(condition),
                  onDeleted: () {
                    setState(() {
                      _conditions.remove(condition);
                    });
                  },
                )),
                ActionChip(
                  label: Text(l10n.addCondition),
                  avatar: const Icon(Icons.add, size: 16),
                  onPressed: () => _showAddConditionDialog(),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            final updated = widget.combatant.copyWith(
              currentHp: int.tryParse(_hpController.text) ?? widget.combatant.currentHp,
              maxHp: int.tryParse(_maxHpController.text) ?? widget.combatant.maxHp,
              armorClass: int.tryParse(_acController.text) ?? widget.combatant.armorClass,
              initiative: int.tryParse(_initiativeController.text),
              conditions: _conditions,
            );
            widget.onUpdate(updated);
            Navigator.of(context).pop();
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
  
  void _showAddConditionDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.addCondition),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g., Poisoned, Stunned, Prone',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _conditions.add(controller.text);
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
