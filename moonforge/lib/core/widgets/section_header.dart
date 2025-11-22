import 'package:flutter/material.dart';

/// Reusable row combining an icon and text following the app's section styling.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.trailing,
  });

  final String title;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final children = <Widget>[
      if (icon != null) ...[
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
      ],
      Expanded(
        child: Text(
          title,
          style: theme.textTheme.titleLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...children,
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );
  }
}
