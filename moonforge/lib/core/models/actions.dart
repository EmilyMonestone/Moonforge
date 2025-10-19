import 'package:flutter/material.dart';

abstract class MenuItem {}

class MenuBarAction extends MenuItem {
  final String label;
  final String? helpText;
  final IconData? icon;
  final void Function(BuildContext)? onPressed;
  final List<MenuBarAction>? children;

  MenuBarAction({
    required this.label,
    this.helpText,
    this.icon,
    this.onPressed,
    this.children,
  }) : assert(
         (onPressed != null && children == null) ||
             (onPressed == null && children != null),
         'Either onPressed or children must be provided.',
       );
}

class MenuBarCustomWidget extends MenuItem {
  final Widget Function(BuildContext context, bool showLabels) builder;

  MenuBarCustomWidget(this.builder);
}
