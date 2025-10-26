import 'package:flutter/material.dart';
import 'package:moonforge/features/scene/views/scene_screen_impl.dart';

class SceneScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SceneScreenImpl(
      chapterId: chapterId,
      adventureId: adventureId,
      sceneId: sceneId,
    );
  }
}
