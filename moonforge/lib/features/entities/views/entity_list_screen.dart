import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show BuildContextM3EX, ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/entities/controllers/entity_list_controller.dart';
import 'package:moonforge/features/entities/utils/create_entity.dart';
import 'package:moonforge/features/entities/widgets/entity_type_icon.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Screen for browsing all entities in the campaign
class EntityListScreen extends StatefulWidget {
  const EntityListScreen({super.key});

  @override
  State<EntityListScreen> createState() => _EntityListScreenState();
}

class _EntityListScreenState extends State<EntityListScreen> {
  late EntityListController _controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final repository = context.read<EntityRepository>();
    _controller = EntityListController(repository);
    _controller.loadEntities();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;

    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        if (_controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Header with search and create button
            SurfaceContainer(
              title: Row(
                children: [
                  Text(
                    l10n.entities,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  ButtonM3E(
                    style: ButtonM3EStyle.filled,
                    shape: ButtonM3EShape.square,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.createEntity),
                    onPressed: () async {
                      await createEntity(context, campaign);
                      _controller.loadEntities();
                    },
                  ),
                ],
              ),
              child: Column(
                spacing: context.m3e.spacing.md,
                children: [
                  // Search bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: l10n.search,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _controller.setSearchQuery('');
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) => _controller.setSearchQuery(value),
                  ),
                  // Filters
                  _buildFilters(context, l10n),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Entity list
            Expanded(
              child: _controller.entities.isEmpty
                  ? Center(
                      child: Text(
                        _controller.searchQuery.isNotEmpty ||
                                _controller.selectedKind != null ||
                                _controller.selectedTags.isNotEmpty
                            ? l10n.noEntitiesMatchingFilters
                            : l10n.noEntitiesYet,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _controller.entities.length,
                      itemBuilder: (context, index) {
                        final entity = _controller.entities[index];
                        return _EntityListItem(
                          entity: entity,
                          onTap: () {
                            EntityRoute(entityId: entity.id).push(context);
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilters(BuildContext context, AppLocalizations l10n) {
    final allKinds = _controller.getAllKinds().toList()..sort();
    final allTags = _controller.getAllTags().toList()..sort();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Kind filter dropdown
        if (allKinds.isNotEmpty)
          DropdownButton<String?>(
            value: _controller.selectedKind,
            hint: Text(l10n.filterByKind),
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(l10n.allKinds),
              ),
              ...allKinds.map((kind) {
                return DropdownMenuItem<String>(
                  value: kind,
                  child: Text(_getKindLabel(kind)),
                );
              }),
            ],
            onChanged: (value) => _controller.setKindFilter(value),
          ),
        // Tag filters
        if (allTags.isNotEmpty)
          ...allTags.map((tag) {
            final isSelected = _controller.selectedTags.contains(tag);
            return FilterChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (_) => _controller.toggleTagFilter(tag),
            );
          }),
        // Clear filters button
        if (_controller.searchQuery.isNotEmpty ||
            _controller.selectedKind != null ||
            _controller.selectedTags.isNotEmpty)
          TextButton.icon(
            icon: const Icon(Icons.clear_all),
            label: Text(l10n.clearFilters),
            onPressed: () {
              _searchController.clear();
              _controller.clearFilters();
            },
          ),
      ],
    );
  }

  String _getKindLabel(String kind) {
    switch (kind) {
      case 'npc':
        return 'NPC';
      case 'monster':
        return 'Monster';
      case 'group':
        return 'Group';
      case 'place':
        return 'Place';
      case 'item':
        return 'Item';
      case 'handout':
        return 'Handout';
      case 'journal':
        return 'Journal';
      default:
        return kind;
    }
  }
}

/// Widget for displaying an entity in the list
class _EntityListItem extends StatelessWidget {
  const _EntityListItem({
    required this.entity,
    required this.onTap,
  });

  final Entity entity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entity.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  _KindChip(kind: entity.kind),
                ],
              ),
              if (entity.summary != null && entity.summary!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  entity.summary!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (entity.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: entity.tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget to display entity kind as a chip
class _KindChip extends StatelessWidget {
  const _KindChip({required this.kind});

  final String kind;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getKindColor(context, kind),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getKindLabel(kind),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getKindColorText(context, kind),
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  String _getKindLabel(String kind) {
    switch (kind) {
      case 'npc':
        return 'NPC';
      case 'monster':
        return 'Monster';
      case 'group':
        return 'Group';
      case 'place':
        return 'Place';
      case 'item':
        return 'Item';
      case 'handout':
        return 'Handout';
      case 'journal':
        return 'Journal';
      default:
        return kind;
    }
  }

  Color _getKindColor(BuildContext context, String kind) {
    switch (kind) {
      case 'npc':
      case 'monster':
      case 'group':
        return Theme.of(context).colorScheme.primary;
      case 'place':
        return Theme.of(context).colorScheme.secondary;
      default:
        return Theme.of(context).colorScheme.tertiary;
    }
  }

  Color _getKindColorText(BuildContext context, String kind) {
    switch (kind) {
      case 'npc':
      case 'monster':
      case 'group':
        return Theme.of(context).colorScheme.onPrimary;
      case 'place':
        return Theme.of(context).colorScheme.onSecondary;
      default:
        return Theme.of(context).colorScheme.onTertiary;
    }
  }
}
