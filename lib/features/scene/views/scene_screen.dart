import 'package:flutter/material.dart';

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
    return const Placeholder();
  }
}
