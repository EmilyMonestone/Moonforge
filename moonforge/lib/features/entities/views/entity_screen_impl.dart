import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show BuildContextM3EX, ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/database/odm.dart';
import 'package:moonforge/core/models/data/entity.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class EntityScreenImpl extends StatefulWidget {
  const EntityScreenImpl({
    super.key,
    required this.entityId,
  });

  final String entityId;

  @override
  State<EntityScreenImpl> createState() => _EntityScreenImplState();
}

class _EntityScreenImplState extends State<EntityScreenImpl> {
  final QuillController _controller = QuillController.basic();
  Entity? _entity;
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

      final odm = Odm.instance;
      final entity = await odm.campaigns
          .doc(campaign.id)
          .entities
          .doc(widget.entityId)
          .get();

      if (entity != null && entity.content != null) {
        _controller.document = Document.fromJson(jsonDecode(entity.content!));
      }
      _controller.readOnly = true;

      setState(() {
        _entity = entity;
        _isLoading = false;
      });
    } catch (e) {
      logger.e('Error loading entity: $e');
      setState(() => _isLoading = false);
    }
  }

  Widget _buildKindSpecificFields(BuildContext context, Entity entity) {
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
                'Place Type',
                entity.placeType!,
              ),
            if (entity.parentPlaceId != null && entity.parentPlaceId!.isNotEmpty)
              _buildInfoRow(
                context,
                Icons.place_outlined,
                'Parent Place',
                entity.parentPlaceId!,
              ),
            if (entity.coords.isNotEmpty)
              _buildInfoRow(
                context,
                Icons.map_outlined,
                'Coordinates',
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
                  Text(
                    'Members',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...entity.members!.map((memberId) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(Icons.person_outline, size: 16),
                            const SizedBox(width: 8),
                            Text(memberId),
                          ],
                        ),
                      )),
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
                  Text(
                    'Stat Block',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: entity.statblock.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  '${entry.key}:',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.value.toString(),
                                  style: theme.textTheme.bodyMedium,
                                ),
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
      BuildContext context, IconData icon, String label, String value) {
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
              Text(
                value,
                style: theme.textTheme.bodyMedium,
              ),
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
              Icon(
                _getKindIcon(_entity!.kind),
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _entity!.name,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Text(
                      _entity!.kind.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
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
                  EntityEditRoute(entityId: widget.entityId).go(context);
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
                      'Tags',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _entity!.tags!
                          .map((tag) => Chip(
                                label: Text(tag),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              if (_entity!.images != null && _entity!.images!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Images',
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
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                        EntityRoute(entityId: entityId).push(context);
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
