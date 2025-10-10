import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ChapterEditScreen extends StatelessWidget {
  const ChapterEditScreen({
    super.key,
    @pathParam required this.campaignId,
    @pathParam required this.chapterId,
  });

  final String campaignId;
  final String chapterId;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
