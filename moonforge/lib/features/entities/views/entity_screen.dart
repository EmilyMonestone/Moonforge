import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show BuildContextM3EX, ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
class EntityScreen extends StatefulWidget {
  const EntityScreen({super.key, required this.entityId});
  final String entityId;
  @override
  State<EntityScreen> createState() => _EntityScreenState();
}
class _EntityScreenState extends State<EntityScreen> {
  final QuillController _controller = QuillController.basic();
  Entity? _entity;
  bool _isLoading = true;
  void initState() {
    super.initState();
    _loadEntity();
  }
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      _controller.readOnly = true;
      setState(() {
        _entity = entity;
        _isLoading = false;
      });
    } catch (e) {
      logger.e('Error loading entity: $e');
      setState(() => _isLoading = false);
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
            if (entity.parentPlaceId != null &&
                entity.parentPlaceId!.isNotEmpty)
                Icons.place_outlined,
                'Parent Place',
                entity.parentPlaceId!,
            if (entity.coords.isNotEmpty)
                Icons.map_outlined,
                'Coordinates',
                'Lat: ${entity.coords['lat'] ?? '-'}, Lng: ${entity.coords['lng'] ?? '-'}',
          ],
        );
      case 'group':
            if (entity.members != null && entity.members!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Members', style: theme.textTheme.titleMedium),
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
      case 'npc':
      case 'monster':
            if (entity.statblock.isNotEmpty)
                  Text('Stat Block', style: theme.textTheme.titleMedium),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
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
                                  entry.value.toString(),
                                  style: theme.textTheme.bodyMedium,
                            ],
                          ),
                        );
                      }).toList(),
      case 'item':
      case 'handout':
      case 'journal':
      default:
        return const SizedBox.shrink();
  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
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
              const SizedBox(height: 2),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    if (_entity == null) {
      return Center(child: Text(l10n.error));
    return Column(
        SurfaceContainer(
          title: Row(
              Icon(_getKindIcon(_entity!.kind), size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _entity!.name,
                      style: Theme.of(context).textTheme.displaySmall,
                      _entity!.kind.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                  ],
              const Spacer(),
              ButtonM3E(
                style: ButtonM3EStyle.tonal,
                shape: ButtonM3EShape.square,
                icon: const Icon(Icons.edit_outlined),
                label: Text(l10n.edit),
                onPressed: () {
                  EntityEditRoute(entityId: widget.entityId).go(context);
                },
            spacing: context.m3e.spacing.sm,
              if (_entity!.summary != null && _entity!.summary!.isNotEmpty)
                Column(
                      l10n.description,
                      style: Theme.of(context).textTheme.titleMedium,
                    const SizedBox(height: 8),
                    Text(_entity!.summary!),
              if (_entity!.tags != null && _entity!.tags!.isNotEmpty)
                      'Tags',
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
                          )
                          .toList(),
              if (_entity!.images != null && _entity!.images!.isNotEmpty)
                      'Images',
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                              Icon(Icons.image, size: 40),
                              const SizedBox(height: 4),
                              if (kind != null)
                                Text(
                                  kind,
                                  style: Theme.of(context).textTheme.labelSmall,
                                  textAlign: TextAlign.center,
                              if (assetId != null)
                                  assetId.length > 10
                                      ? '${assetId.substring(0, 10)}...'
                                      : assetId,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
              _buildKindSpecificFields(context, _entity!),
              if (_entity!.content != null && _entity!.content!.isNotEmpty)
                      l10n.content,
                    CustomQuillViewer(
                      controller: _controller,
                      onMentionTap: (entityId, mentionType) async {
                        EntityRoute(entityId: entityId).push(context);
                      },
                )
              else
                Text(l10n.noContentProvided),
  IconData _getKindIcon(String kind) {
    switch (kind) {
        return Icons.person;
        return Icons.bug_report;
        return Icons.groups;
        return Icons.location_on;
        return Icons.inventory_2;
        return Icons.description;
        return Icons.book;
        return Icons.help_outline;
