import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AdventureEditScreen extends StatelessWidget {
  const AdventureEditScreen({
    super.key,
    @pathParam required this.chapterId,
    @pathParam required this.adventureId,
  });

  final String chapterId;
  final String adventureId;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
