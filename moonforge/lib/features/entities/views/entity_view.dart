import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show BuildContextM3EX, ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/design/domain_visuals.dart';
import 'package:moonforge/core/di/service_locator.dart';
import 'package:moonforge/core/models/domain_type.dart';
import 'package:moonforge/core/services/entity_gatherer.dart';
import 'package:moonforge/core/services/origin_resolver.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/entities/entity_badges.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/encounter_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class EntityView extends StatefulWidget {
  const EntityView({super.key, required this.entityId});

  final String entityId;

  @override
  State<EntityView> createState() => _EntityViewState();
}

class _EntityViewState extends State<EntityView> {
  final QuillController _controller = QuillController.basic();
  db.Entity? _entity;
  EntityOrigin? _resolvedOrigin;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEntity();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadEntity() async {
    setState(() => _isLoading = true);
    try {
      final campaign = context.read<CampaignProvider>().currentCampaign;
      if (campaign == null) {
        setState(() => _isLoading = false);
        return;
      }

      final entity = await getIt<EntityRepository>().getById(widget.entityId);

      if (entity != null && entity.content != null) {
        final ops = entity.content!['ops'] as List<dynamic>?;
        if (ops != null) {
          _controller.document = Document.fromJson(ops);
        }
      }
      _controller.readOnly = true;

      // Resolve true origin label with numbering using OriginResolver
      EntityOrigin? resolved;
      if (entity != null) {
        final resolver = OriginResolver(
          campaignRepo: getIt<CampaignRepository>(),
          chapterRepo: getIt<ChapterRepository>(),
          adventureRepo: getIt<AdventureRepository>(),
          sceneRepo: getIt<SceneRepository>(),
          encounterRepo: getIt<EncounterRepository>(),
        );
        resolved = await resolver.resolve(entity.originId);
        logger.d(
          '[EntityView] Resolved origin for entity=${entity.id} originId=${entity.originId}: ${resolved?.partType}:${resolved?.partId} label="${resolved?.label}"',
        );
      }

      setState(() {
        _entity = entity;
        _resolvedOrigin = resolved;
        _isLoading = false;
      });
    } catch (e) {
      logger.e('Error loading entity: $e');
      setState(() => _isLoading = false);
    }
  }

  Widget _buildStatblock(db.Entity entity, AppLocalizations l10n) {
    final theme = Theme.of(context);
    if (entity.statblock.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.statblock, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            children: entity.statblock.entries.map((entry) {
              return SizedBox(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entry.value.toString(),
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildKindSpecificFields(BuildContext context, db.Entity entity) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    switch (entity.kind) {
      case 'place':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: context.m3e.spacing.sm,
          children: [
            if (entity.placeType != null && entity.placeType!.isNotEmpty)
              _buildInfoRow(
                context,
                Icons.location_on_outlined,
                l10n.placeType,
                entity.placeType!,
              ),
            if (entity.parentPlaceId != null &&
                entity.parentPlaceId!.isNotEmpty)
              _buildInfoRow(
                context,
                DomainType.entityPlace.icon,
                l10n.parentPlace,
                entity.parentPlaceId!,
              ),
            if (entity.coords.isNotEmpty)
              _buildInfoRow(
                context,
                Icons.map_outlined,
                l10n.coordinates,
                'Lat: ${entity.coords['lat'] ?? '-'}, Lng: ${entity.coords['lng'] ?? '-'}',
              ),
          ],
        );
      case 'group':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: context.m3e.spacing.sm,
          children: [
            if (entity.members != null && entity.members!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.members, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...entity.members!.map(
                    (memberId) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(Icons.person_outline, size: 16),
                          const SizedBox(width: 8),
                          Text(memberId),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        );
      case 'npc':
      case 'monster':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: context.m3e.spacing.sm,
          children: [
            if (entity.statblock.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.statblock, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: entity.statblock.entries.map((entry) {
                        return SizedBox(
                          width: 160,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                entry.value.toString(),
                                style: theme.textTheme.bodySmall,
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
          ],
        );
      case 'item':
      case 'handout':
      case 'journal':
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_entity == null) {
      return Center(child: Text(l10n.error));
    }

    return Column(
      children: [
        SurfaceContainer(
          title: Row(
            children: [
              Icon(_getKindIcon(_entity!.kind), size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _entity!.name,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    KindChip(kind: _entity!.kind),
                    if (_resolvedOrigin != null)
                      OriginBadge(origin: _resolvedOrigin!),
                  ],
                ),
              ),
              const Spacer(),
              ButtonM3E(
                style: ButtonM3EStyle.tonal,
                shape: ButtonM3EShape.square,
                icon: const Icon(Icons.edit_outlined),
                label: Text(l10n.edit),
                onPressed: () {
                  EntityEditRouteData(entityId: widget.entityId).go(context);
                },
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: context.m3e.spacing.sm,
            children: [
              if (_entity!.summary != null && _entity!.summary!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.description,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(_entity!.summary!),
                  ],
                ),
              if (_entity!.tags != null && _entity!.tags!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.tags,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _entity!.tags!
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              if (_entity!.images != null && _entity!.images!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.images,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _entity!.images!.map((imageMap) {
                        final assetId = imageMap['assetId'] as String?;
                        final kind = imageMap['kind'] as String?;
                        return Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, size: 40),
                              const SizedBox(height: 4),
                              if (kind != null)
                                Text(
                                  kind,
                                  style: Theme.of(context).textTheme.labelSmall,
                                  textAlign: TextAlign.center,
                                ),
                              if (assetId != null)
                                Text(
                                  assetId.length > 10
                                      ? '${assetId.substring(0, 10)}...'
                                      : assetId,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              _buildKindSpecificFields(context, _entity!),
              if (_entity!.kind == 'npc' || _entity!.kind == 'monster')
                _buildStatblock(_entity!, l10n),
              if (_entity!.content != null && _entity!.content!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.content,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    CustomQuillViewer(
                      controller: _controller,
                      onMentionTap: (entityId, mentionType) async {
                        EntityRouteData(entityId: entityId).push(context);
                      },
                    ),
                  ],
                )
              else
                Text(l10n.noContentProvided),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getKindIcon(String kind) {
    switch (kind) {
      case 'npc':
        return Icons.person;
      case 'monster':
        return Icons.bug_report;
      case 'group':
        return Icons.groups;
      case 'place':
        return Icons.location_on;
      case 'item':
        return Icons.inventory_2;
      case 'handout':
        return Icons.description;
      case 'journal':
        return Icons.book;
      default:
        return Icons.help_outline;
    }
  }
}
