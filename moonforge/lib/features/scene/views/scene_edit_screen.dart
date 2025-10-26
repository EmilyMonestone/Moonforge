import 'package:flutter/material.dart';
import 'package:moonforge/features/scene/views/scene_edit_screen_impl.dart';

class SceneEditScreen extends StatelessWidget {
  const SceneEditScreen({
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
    return SceneEditScreenImpl(
      chapterId: chapterId,
      adventureId: adventureId,
      sceneId: sceneId,
    );
  }
}
