import 'package:flutter/material.dart';

/// A simple section header with an icon and title, used in the Home feature.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
