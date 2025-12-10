import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/core/models/menu_bar_actions.dart';
import 'package:moonforge/core/repositories/menu_registry.dart';

/// Builds a menu sheet item widget that can be used in bottom sheets or modals.
///
/// Handles both expandable items (with children) and simple action items.
Widget buildMenuSheetItem(BuildContext context, MenuBarAction item) {
  if (item.children != null && item.children!.isNotEmpty) {
    return ExpansionTile(
      leading: item.icon != null ? Icon(item.icon) : null,
      title: Text(item.label),
      subtitle: item.helpText != null ? Text(item.helpText!) : null,
      children: [
        for (final child in item.children!)
          ListTile(
            leading: child.icon != null ? Icon(child.icon) : null,
            title: Text(child.label),
            subtitle: child.helpText != null ? Text(child.helpText!) : null,
            onTap: () {
              Navigator.of(context).pop();
              child.onPressed?.call(context);
            },
          ),
      ],
    );
  } else {
    return ListTile(
      leading: item.icon != null ? Icon(item.icon) : null,
      title: Text(item.label),
      subtitle: item.helpText != null ? Text(item.helpText!) : null,
      onTap: () {
        Navigator.of(context).pop();
        item.onPressed?.call(context);
      },
    );
  }
}

/// A FloatingActionButton that displays menu actions in a bottom sheet.
///
/// Resolves menu items from the MenuRegistry based on the current route
/// and displays them in a modal bottom sheet when tapped.
class MenuFloatingActionButton extends StatelessWidget {
  const MenuFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final items = MenuRegistry.resolve(context, GoRouterState.of(context).uri);
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          useSafeArea: true,
          showDragHandle: true,
          builder: (sheetCtx) {
            return SafeArea(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final item in items) buildMenuSheetItem(sheetCtx, item),
                ],
              ),
            );
          },
        );
      },
      child: const Icon(Icons.menu_rounded),
    );
  }
}
