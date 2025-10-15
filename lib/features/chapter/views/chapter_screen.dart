import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ChapterScreen extends StatelessWidget {
  const ChapterScreen({super.key, @pathParam required this.chapterId});

  final String chapterId;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
