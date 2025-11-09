import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/scene/widgets/scene_card.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Screen for browsing all scenes across all adventures in a campaign
class SceneListScreen extends StatefulWidget {
  const SceneListScreen({super.key});

  @override
  State<SceneListScreen> createState() => _SceneListScreenState();
}

class _SceneListScreenState extends State<SceneListScreen> {
  bool _isLoading = true;
  List<_SceneWithContext> _scenes = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAllScenes();
  }

  Future<void> _loadAllScenes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final campaign = context.read<CampaignProvider>().currentCampaign;
      if (campaign == null) {
        setState(() {
          _errorMessage = 'No campaign selected';
          _isLoading = false;
        });
        return;
      }

      final chapterRepo = context.read<ChapterRepository>();
      final adventureRepo = context.read<AdventureRepository>();
      final sceneRepo = context.read<SceneRepository>();

      // Load all chapters
      final chapters = await chapterRepo.getByCampaign(campaign.id);
      
      final allScenes = <_SceneWithContext>[];

      // For each chapter, load adventures and scenes
      for (final chapter in chapters) {
        final adventures = await adventureRepo.getByChapter(chapter.id);
        
        for (final adventure in adventures) {
          final scenes = await sceneRepo.getByAdventure(adventure.id);
          
          for (final scene in scenes) {
            allScenes.add(_SceneWithContext(
              scene: scene,
              chapterId: chapter.id,
              chapterName: chapter.name,
              adventureId: adventure.id,
              adventureName: adventure.name,
            ));
          }
        }
      }

      // Sort by chapter, adventure, then scene order
      allScenes.sort((a, b) {
        final chapterCompare = a.chapterName.compareTo(b.chapterName);
        if (chapterCompare != 0) return chapterCompare;
        
        final adventureCompare = a.adventureName.compareTo(b.adventureName);
        if (adventureCompare != 0) return adventureCompare;
        
        return a.scene.order.compareTo(b.scene.order);
      });

      setState(() {
        _scenes = allScenes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading scenes: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SurfaceContainer(
      title: Text(
        'All Scenes',
        style: theme.textTheme.displaySmall,
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _loadAllScenes,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _scenes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.movie_outlined,
                            size: 64,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No scenes found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _scenes.length,
                      itemBuilder: (context, index) {
                        final sceneWithContext = _scenes[index];
                        final scene = sceneWithContext.scene;

                        // Show chapter/adventure headers
                        bool showHeader = index == 0 ||
                            _scenes[index - 1].chapterName !=
                                sceneWithContext.chapterName ||
                            _scenes[index - 1].adventureName !=
                                sceneWithContext.adventureName;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (showHeader) ...[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sceneWithContext.chapterName,
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      sceneWithContext.adventureName,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            SceneCard(
                              scene: scene,
                              onTap: () {
                                SceneRoute(
                                  chapterId: sceneWithContext.chapterId,
                                  adventureId: sceneWithContext.adventureId,
                                  sceneId: scene.id,
                                ).go(context);
                              },
                            ),
                          ],
                        );
                      },
                    ),
    );
  }
}

class _SceneWithContext {
  final Scene scene;
  final String chapterId;
  final String chapterName;
  final String adventureId;
  final String adventureName;

  _SceneWithContext({
    required this.scene,
    required this.chapterId,
    required this.chapterName,
    required this.adventureId,
    required this.adventureName,
  });
}
