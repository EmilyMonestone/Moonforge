import 'package:flutter/material.dart' hide Alignment;
import 'package:moonforge/core/services/open5e/index.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/widgets/open5e/character_widgets.dart';
import 'package:moonforge/core/widgets/open5e/creature_widgets.dart';
import 'package:moonforge/core/widgets/open5e/equipment_widgets.dart';
import 'package:moonforge/core/widgets/open5e/spell_widgets.dart';

enum Open5eEndpointType {
  creatures,
  spells,
  backgrounds,
  species,
  classes,
  feats,
  conditions,
  items,
  magicItems,
  weapons,
  armor,
  abilities,
  skills,
  creatureTypes,
  creatureSets,
  spellSchools,
  damageTypes,
  languages,
  alignments,
  sizes,
  environments,
  itemSets,
  itemCategories,
  itemRarities,
  weaponProperties,
}

extension Open5eEndpointTypeExtension on Open5eEndpointType {
  String get displayName {
    switch (this) {
      case Open5eEndpointType.creatures:
        return 'Creatures';
      case Open5eEndpointType.spells:
        return 'Spells';
      case Open5eEndpointType.backgrounds:
        return 'Backgrounds';
      case Open5eEndpointType.species:
        return 'Species';
      case Open5eEndpointType.classes:
        return 'Classes';
      case Open5eEndpointType.feats:
        return 'Feats';
      case Open5eEndpointType.conditions:
        return 'Conditions';
      case Open5eEndpointType.items:
        return 'Items';
      case Open5eEndpointType.magicItems:
        return 'Magic Items';
      case Open5eEndpointType.weapons:
        return 'Weapons';
      case Open5eEndpointType.armor:
        return 'Armor';
      case Open5eEndpointType.abilities:
        return 'Abilities';
      case Open5eEndpointType.skills:
        return 'Skills';
      case Open5eEndpointType.creatureTypes:
        return 'Creature Types';
      case Open5eEndpointType.creatureSets:
        return 'Creature Sets';
      case Open5eEndpointType.spellSchools:
        return 'Spell Schools';
      case Open5eEndpointType.damageTypes:
        return 'Damage Types';
      case Open5eEndpointType.languages:
        return 'Languages';
      case Open5eEndpointType.alignments:
        return 'Alignments';
      case Open5eEndpointType.sizes:
        return 'Sizes';
      case Open5eEndpointType.environments:
        return 'Environments';
      case Open5eEndpointType.itemSets:
        return 'Item Sets';
      case Open5eEndpointType.itemCategories:
        return 'Item Categories';
      case Open5eEndpointType.itemRarities:
        return 'Item Rarities';
      case Open5eEndpointType.weaponProperties:
        return 'Weapon Properties';
    }
  }
}

class Open5eBrowserView extends StatefulWidget {
  const Open5eBrowserView({super.key});

  @override
  State<Open5eBrowserView> createState() => _Open5eBrowserViewState();
}

class _Open5eBrowserViewState extends State<Open5eBrowserView> {
  late final Open5eService _service;
  Open5eEndpointType _selectedEndpoint = Open5eEndpointType.creatures;
  String _selectedGameSystem = GameSystemKey.edition2024;
  List<dynamic> _results = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _service = Open5eService(PersistenceService());
    // Use addPostFrameCallback to ensure widget is fully built before loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final options = Open5eQueryOptions(
        gameSystemKey: _selectedGameSystem,
        search: _searchQuery.isEmpty ? null : _searchQuery,
        limit: 50,
      );

      dynamic response;

      switch (_selectedEndpoint) {
        case Open5eEndpointType.creatures:
          response = await _service.getCreatures(options: options);
          break;
        case Open5eEndpointType.spells:
          response = await _service.getSpells(options: options);
          break;
        case Open5eEndpointType.backgrounds:
          response = await _service.getBackgrounds(options: options);
          break;
        case Open5eEndpointType.species:
          response = await _service.getSpecies(options: options);
          break;
        case Open5eEndpointType.classes:
          response = await _service.getClasses(options: options);
          break;
        case Open5eEndpointType.feats:
          response = await _service.getFeats(options: options);
          break;
        case Open5eEndpointType.conditions:
          response = await _service.getConditions(options: options);
          break;
        case Open5eEndpointType.items:
          response = await _service.getItems(options: options);
          break;
        case Open5eEndpointType.magicItems:
          response = await _service.getMagicItems(options: options);
          break;
        case Open5eEndpointType.weapons:
          response = await _service.getWeapons(options: options);
          break;
        case Open5eEndpointType.armor:
          response = await _service.getArmor(options: options);
          break;
        case Open5eEndpointType.abilities:
          response = await _service.getAbilities(options: options);
          break;
        case Open5eEndpointType.skills:
          response = await _service.getSkills(options: options);
          break;
        case Open5eEndpointType.creatureTypes:
          response = await _service.getCreatureTypes(options: options);
          break;
        case Open5eEndpointType.creatureSets:
          response = await _service.getCreatureSets(options: options);
          break;
        case Open5eEndpointType.spellSchools:
          response = await _service.getSpellSchools(options: options);
          break;
        case Open5eEndpointType.damageTypes:
          response = await _service.getDamageTypes(options: options);
          break;
        case Open5eEndpointType.languages:
          response = await _service.getLanguages(options: options);
          break;
        case Open5eEndpointType.alignments:
          response = await _service.getAlignments(options: options);
          break;
        case Open5eEndpointType.sizes:
          response = await _service.getSizes(options: options);
          break;
        case Open5eEndpointType.environments:
          response = await _service.getEnvironments(options: options);
          break;
        case Open5eEndpointType.itemSets:
          response = await _service.getItemSets(options: options);
          break;
        case Open5eEndpointType.itemCategories:
          response = await _service.getItemCategories(options: options);
          break;
        case Open5eEndpointType.itemRarities:
          response = await _service.getItemRarities(options: options);
          break;
        case Open5eEndpointType.weaponProperties:
          response = await _service.getWeaponProperties(options: options);
          break;
      }

      if (response != null) {
        setState(() {
          _results = response.results;
          _isLoading = false;
          _errorMessage = null;
        });
      } else {
        setState(() {
          _results = [];
          _isLoading = false;
          _errorMessage = 'Failed to load data from Open5e API. Please check your network connection.';
        });
      }
    } catch (e, stackTrace) {
      print('Error loading Open5e data: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _results = [];
        _isLoading = false;
        _errorMessage = 'Error loading data: $e';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _loadData,
            ),
          ),
        );
      }
    }
  }

  void _showDetailModal(dynamic item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildDetailWidget(item),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailWidget(dynamic item) {
    switch (_selectedEndpoint) {
      case Open5eEndpointType.creatures:
        return CreatureWidget(creature: item as Creature);
      case Open5eEndpointType.spells:
        return SpellWidget(spell: item as Open5eSpell);
      case Open5eEndpointType.backgrounds:
        return BackgroundWidget(background: item as Background);
      case Open5eEndpointType.species:
        return SpeciesWidget(species: item as Species);
      case Open5eEndpointType.classes:
        return CharacterClassWidget(characterClass: item as CharacterClass);
      case Open5eEndpointType.feats:
        return FeatWidget(feat: item as Feat);
      case Open5eEndpointType.conditions:
        return ConditionWidget(condition: item as Condition);
      case Open5eEndpointType.items:
        return ItemWidget(item: item as Item);
      case Open5eEndpointType.magicItems:
        return MagicItemWidget(magicItem: item as MagicItem);
      case Open5eEndpointType.weapons:
        return WeaponWidget(weapon: item as Weapon);
      case Open5eEndpointType.armor:
        return ArmorWidget(armor: item as Armor);
      case Open5eEndpointType.abilities:
        return AbilityWidget(ability: item as Ability);
      case Open5eEndpointType.skills:
        return SkillWidget(skill: item as Skill);
      default:
        // For simple types (CreatureType, SpellSchool, etc.), show basic info
        return _buildSimpleWidget(item);
    }
  }

  Widget _buildSimpleWidget(dynamic item) {
    String name = '';
    String? desc;

    if (item is CreatureType ||
        item is CreatureSet ||
        item is SpellSchool ||
        item is DamageType ||
        item is Language ||
        item is Alignment ||
        item is Size ||
        item is Environment ||
        item is ItemSet ||
        item is ItemCategory ||
        item is ItemRarity ||
        item is WeaponProperty) {
      name = item.name;
      desc = item.desc;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        if (desc != null && desc.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(desc),
        ],
      ],
    );
  }

  String _getItemName(dynamic item) {
    return item.name ?? 'Unknown';
  }

  String? _getItemDescription(dynamic item) {
    if (item is Creature) {
      return '${item.type ?? 'Unknown'} - CR ${item.challengeRatingText ?? item.challengeRatingDecimal?.toString() ?? '?'}';
    }
    if (item is Open5eSpell) {
      return 'Level ${item.level ?? '?'} ${item.school ?? 'Unknown'}';
    }
    if (item is Species) {
      return item.desc != null && item.desc!.length > 100
          ? '${item.desc!.substring(0, 100)}...'
          : item.desc;
    }
    if (item is Background || item is Feat || item is Condition) {
      final desc = item.desc;
      return desc != null && desc.length > 100
          ? '${desc.substring(0, 100)}...'
          : desc;
    }
    if (item is CharacterClass) return item.desc.length > 100 ? '${item.desc.substring(0, 100)}...' : item.desc;
    if (item is MagicItem || item is Item) return item.type;
    if (item is Weapon) return item.category;
    if (item is Armor) return item.category;
    if (item is Ability) return item.fullName;
    if (item is Skill) return item.ability;
    // For simple types, just return the first part of description
    final desc = item.desc;
    if (desc != null && desc.isNotEmpty) {
      return desc.length > 100 ? '${desc.substring(0, 100)}...' : desc;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Open5e Browser'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<Open5eEndpointType>(
                        value: _selectedEndpoint,
                        decoration: const InputDecoration(
                          labelText: 'Endpoint',
                          border: OutlineInputBorder(),
                        ),
                        items: Open5eEndpointType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type.displayName),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedEndpoint = value;
                              _results = [];
                            });
                            _loadData();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedGameSystem,
                        decoration: const InputDecoration(
                          labelText: 'Game System',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: GameSystemKey.edition2024,
                            child: Text('5e 2024'),
                          ),
                          DropdownMenuItem(
                            value: GameSystemKey.edition2014,
                            child: Text('5e 2014'),
                          ),
                          DropdownMenuItem(
                            value: GameSystemKey.advancedEdition,
                            child: Text('A5e'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedGameSystem = value;
                              _results = [];
                            });
                            _loadData();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() => _searchQuery = _searchController.text);
                        _loadData();
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    setState(() => _searchQuery = value);
                    _loadData();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _errorMessage!,
                                style: theme.textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _loadData,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _results.isEmpty
                        ? Center(
                            child: Text(
                              'No results found',
                              style: theme.textTheme.bodyLarge,
                            ),
                          )
                        : ListView.builder(
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final item = _results[index];
                          final name = _getItemName(item);
                          final description = _getItemDescription(item);

                          return ListTile(
                            title: Text(name),
                            subtitle:
                                description != null ? Text(description) : null,
                            onTap: () => _showDetailModal(item),
                            trailing: const Icon(Icons.chevron_right),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
