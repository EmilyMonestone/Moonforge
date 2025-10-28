import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show BuildContextM3EX, ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/entity_widgets_wrappers.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/firebase/models/scene.dart';
import 'package:moonforge/data/firebase/models/schema.dart';
import 'package:moonforge/data/firebase/odm.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
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
      final campaign = context.read<CampaignProvider>().currentCampaign;
      if (campaign == null) {
        setState(() => _isLoading = false);
        return;
      }

      final odm = Odm.instance;
      final scene = await odm.campaigns
          .doc(campaign.id)
          .chapters
          .doc(widget.chapterId)
          .adventures
          .doc(widget.adventureId)
          .scenes
          .doc(widget.sceneId)
          .get();

      if (scene != null && scene.content != null) {
        _controller.document = Document.fromJson(jsonDecode(scene.content!));
      }
      _controller.readOnly = true;

      setState(() {
        _scene = scene;
        _isLoading = false;
      });
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

    return Column(
      children: [
        SurfaceContainer(
          title: Row(
            children: [
              Text(
                _scene!.title,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Spacer(),
              ButtonM3E(
                style: ButtonM3EStyle.tonal,
                shape: ButtonM3EShape.square,
                icon: Icon(Icons.edit_outlined),
                label: Text(l10n.edit),
                onPressed: () {
                  SceneEditRoute(
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
              if (_scene!.content != null && _scene!.content!.isNotEmpty)
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
