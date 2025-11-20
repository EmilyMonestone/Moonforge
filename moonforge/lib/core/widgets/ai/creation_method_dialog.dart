import 'package:flutter/material.dart';
import 'package:moonforge/l10n/app_localizations.dart';

/// Enum for creation method choice
enum CreationMethod {
  manual,
  ai,
}

/// Shows a dialog asking user to choose between manual or AI-assisted creation
Future<CreationMethod?> showCreationMethodDialog(
  BuildContext context, {
  required String itemType,
}) async {
  final l10n = AppLocalizations.of(context);

  return showDialog<CreationMethod>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Create $itemType'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'How would you like to create this $itemType?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Manual Creation'),
            subtitle: const Text('Create and edit yourself'),
            onTap: () => Navigator.of(context).pop(CreationMethod.manual),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.auto_fix_high),
            title: const Text('AI-Assisted Creation'),
            subtitle: const Text('Generate with AI assistance'),
            onTap: () => Navigator.of(context).pop(CreationMethod.ai),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    ),
  );
}
