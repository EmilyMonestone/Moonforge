import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show BuildContextM3EX, ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/entity_widgets_wrappers.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/scene/controllers/scene_provider.dart';
import 'package:moonforge/features/scene/utils/scene_export.dart';
import 'package:moonforge/features/scene/widgets/scene_completion_indicator.dart';
import 'package:moonforge/features/scene/widgets/scene_navigation_widget.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SceneScreen extends StatefulWidget {
  const SceneScreen({
    super.key,
    required this.chapterId,
    required this.adventureId,
    required this.sceneId,
  });

  final String chapterId;
  final String adventureId;
  final String sceneId;

  @override
  State<SceneScreen> createState() => _SceneScreenState();
}

class _SceneScreenState extends State<SceneScreen> {
  final QuillController _controller = QuillController.basic();
  Scene? _scene;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScene();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadScene() async {
    setState(() => _isLoading = true);
    try {
      final sceneRepo = context.read<SceneRepository>();
      final scene = await sceneRepo.getById(widget.sceneId);

      if (scene != null && scene.content != null) {
        try {
          final ops = scene.content!['ops'] as List<dynamic>?;
          if (ops != null) {
            _controller.document = Document.fromJson(ops);
          } else {
            _controller.document = Document()..insert(0, scene.summary ?? '');
          }
        } catch (e) {
          _controller.document = Document()..insert(0, scene.summary ?? '');
        }
      }
      _controller.readOnly = true;

      setState(() {
        _scene = scene;
        _isLoading = false;
      });

      // Update scene provider
      if (scene != null && mounted) {
        final sceneProvider = context.read<SceneProvider>();
        await sceneProvider.setCurrentScene(scene);
      }
    } catch (e) {
      logger.e('Error loading scene: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_scene == null || campaign == null) {
      return Center(child: Text(l10n.error));
    }

    final sceneProvider = context.watch<SceneProvider>();
    final readAloudText = SceneExport.extractReadAloudText(_scene!);

    return Column(
      children: [
        // Scene navigation widget
        if (sceneProvider.scenesInAdventure.length > 1)
          SceneNavigationWidget(
            currentScene: _scene!,
            onNavigate: (scene) {
              SceneRouteData(
                chapterId: widget.chapterId,
                adventureId: widget.adventureId,
                sceneId: scene.id,
              ).go(context);
            },
          ),
        SurfaceContainer(
          title: Row(
            children: [
              Expanded(
                child: Text(
                  _scene!.name,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              // Completion indicator
              SceneCompletionIndicator(
                isCompleted: sceneProvider.isCompleted,
                onToggle: () {
                  sceneProvider.toggleCompletion();
                },
                showLabel: false,
              ),
              const SizedBox(width: 8),
              ButtonM3E(
                style: ButtonM3EStyle.tonal,
                shape: ButtonM3EShape.square,
                icon: const Icon(Icons.edit_outlined),
                label: Text(l10n.edit),
                onPressed: () {
                  SceneEditRouteData(
                    chapterId: widget.chapterId,
                    adventureId: widget.adventureId,
                    sceneId: widget.sceneId,
                  ).go(context);
                },
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: context.m3e.spacing.sm,
            children: [
              if (_scene!.summary != null && _scene!.summary!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.description,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(_scene!.summary!),
                  ],
                ),
              if (readAloudText != null && readAloudText.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Read Aloud',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        readAloudText,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              if (_scene!.content != null && _scene!.content!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
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
        SceneEntitiesWidget(
          campaignId: campaign.id,
          chapterId: widget.chapterId,
          adventureId: widget.adventureId,
          sceneId: widget.sceneId,
        ),
      ],
    );
  }
}
