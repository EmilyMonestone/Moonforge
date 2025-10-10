import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SceneEditScreen extends StatelessWidget {
  const SceneEditScreen({
    super.key,
    @pathParam required this.campaignId,
    @pathParam required this.chapterId,
    @pathParam required this.adventureId,
    @pathParam required this.sceneId,
  });

  final String campaignId;
  final String chapterId;
  final String adventureId;
  final String sceneId;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
