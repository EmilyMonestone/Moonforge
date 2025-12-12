import 'package:flutter/material.dart';
import 'package:moonforge/core/services/open5e/index.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/widgets/open5e/character_widgets.dart';
import 'package:moonforge/core/widgets/open5e/equipment_widgets.dart';
import 'package:moonforge/core/widgets/open5e/monster_widgets.dart';
import 'package:moonforge/core/widgets/open5e/spell_widgets.dart';
import 'package:moonforge/data/models/monster.dart';

enum Open5eEndpointType {
  monsters,
  spells,
  backgrounds,
  races,
  classes,
  feats,
  conditions,
  magicItems,
  weapons,
  armor,
}

extension Open5eEndpointTypeExtension on Open5eEndpointType {
  String get displayName {
    switch (this) {
      case Open5eEndpointType.monsters:
        return 'Monsters';
      case Open5eEndpointType.spells:
        return 'Spells';
      case Open5eEndpointType.backgrounds:
        return 'Backgrounds';
      case Open5eEndpointType.races:
        return 'Races';
      case Open5eEndpointType.classes:
        return 'Classes';
      case Open5eEndpointType.feats:
        return 'Feats';
      case Open5eEndpointType.conditions:
        return 'Conditions';
      case Open5eEndpointType.magicItems:
        return 'Magic Items';
      case Open5eEndpointType.weapons:
        return 'Weapons';
      case Open5eEndpointType.armor:
        return 'Armor';
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
  Open5eEndpointType _selectedEndpoint = Open5eEndpointType.monsters;
  List<dynamic> _results = [];
  bool _isLoading = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _service = Open5eService(PersistenceService());
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final options = Open5eQueryOptions(
        search: _searchQuery.isEmpty ? null : _searchQuery,
        limit: 50,
      );

      dynamic response;

      switch (_selectedEndpoint) {
        case Open5eEndpointType.monsters:
          response = await _service.getMonsters(options: options);
          break;
        case Open5eEndpointType.spells:
          response = await _service.getSpells(options: options);
          break;
        case Open5eEndpointType.backgrounds:
          response = await _service.getBackgrounds(options: options);
          break;
        case Open5eEndpointType.races:
          response = await _service.getRaces(options: options);
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
        case Open5eEndpointType.magicItems:
          response = await _service.getMagicItems(options: options);
          break;
        case Open5eEndpointType.weapons:
          response = await _service.getWeapons(options: options);
          break;
        case Open5eEndpointType.armor:
          response = await _service.getArmor(options: options);
          break;
      }

      if (response != null) {
        setState(() {
          _results = response.results;
          _isLoading = false;
        });
      } else {
        setState(() {
          _results = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _results = [];
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
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
      case Open5eEndpointType.monsters:
        return MonsterWidget(monster: item as Monster);
      case Open5eEndpointType.spells:
        return SpellWidget(spell: item as Open5eSpell);
      case Open5eEndpointType.backgrounds:
        return BackgroundWidget(background: item as Background);
      case Open5eEndpointType.races:
        return RaceWidget(race: item as Race);
      case Open5eEndpointType.classes:
        return CharacterClassWidget(characterClass: item as CharacterClass);
      case Open5eEndpointType.feats:
        return FeatWidget(feat: item as Feat);
      case Open5eEndpointType.conditions:
        return ConditionWidget(condition: item as Condition);
      case Open5eEndpointType.magicItems:
        return MagicItemWidget(item: item as MagicItem);
      case Open5eEndpointType.weapons:
        return WeaponWidget(weapon: item as Weapon);
      case Open5eEndpointType.armor:
        return ArmorWidget(armor: item as Armor);
    }
  }

  String _getItemName(dynamic item) {
    if (item is Monster) return item.name;
    if (item is Open5eSpell) return item.name;
    if (item is Background) return item.name;
    if (item is Race) return item.name;
    if (item is CharacterClass) return item.name;
    if (item is Feat) return item.name;
    if (item is Condition) return item.name;
    if (item is MagicItem) return item.name;
    if (item is Weapon) return item.name;
    if (item is Armor) return item.name;
    return 'Unknown';
  }

  String? _getItemDescription(dynamic item) {
    if (item is Monster) return item.type;
    if (item is Open5eSpell) {
      return 'Level ${item.level} ${item.school}';
    }
    if (item is Background) return item.desc.length > 100
        ? '${item.desc.substring(0, 100)}...'
        : item.desc;
    if (item is Race) return item.desc.length > 100
        ? '${item.desc.substring(0, 100)}...'
        : item.desc;
    if (item is CharacterClass) return item.hitDice;
    if (item is Feat) return item.prerequisite;
    if (item is Condition) return item.desc.length > 100
        ? '${item.desc.substring(0, 100)}...'
        : item.desc;
    if (item is MagicItem) return item.type;
    if (item is Weapon) return item.category;
    if (item is Armor) return item.category;
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
                DropdownButtonFormField<Open5eEndpointType>(
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
